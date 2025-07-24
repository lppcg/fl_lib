import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

/// Secure backup encryption utility class
/// Uses AES-GCM authenticated encryption and PBKDF2 key derivation
abstract final class Cryptor {
  static const _saltLength = 32;
  static const _nonceLength = 12;
  static const _tagLength = 16;
  static const _iterations = 100000;
  static const _magicHeader = 'LKFL_ENC_V01';

  /// Derives a key from password and salt using PBKDF2
  static Uint8List _deriveKey(String password, List<int> salt) {
    final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64));
    pbkdf2.init(Pbkdf2Parameters(Uint8List.fromList(salt), _iterations, 32));
    return pbkdf2.process(Uint8List.fromList(utf8.encode(password)));
  }

  /// Encrypts data using AES-GCM
  /// [data] Plaintext data to encrypt
  /// [password] Encryption password
  /// Returns Base64 encoded encrypted result
  static String encrypt(String data, String password) {
    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }
    if (data.isEmpty) {
      throw ArgumentError('Data cannot be empty');
    }

    final random = Random.secure();
    
    // Generate random salt and nonce
    final salt = List.generate(_saltLength, (_) => random.nextInt(256));
    final nonce = List.generate(_nonceLength, (_) => random.nextInt(256));
    
    // Derive key from password and salt
    final key = _deriveKey(password, salt);
    
    // Initialize AES-GCM cipher
    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(true, AEADParameters(
      KeyParameter(key), 
      _tagLength * 8, 
      Uint8List.fromList(nonce),
      Uint8List(0)
    ));
    
    // Encrypt data (includes authentication tag)
    final dataBytes = utf8.encode(data);
    final encrypted = cipher.process(Uint8List.fromList(dataBytes));
    
    // Combine result: magic_header + salt + nonce + encrypted_data_with_tag
    final header = utf8.encode(_magicHeader);
    final result = <int>[...header, ...salt, ...nonce, ...encrypted];
    
    return base64.encode(result);
  }

  /// Decrypts data using AES-GCM 
  /// [encryptedData] Base64 encoded encrypted data
  /// [password] Decryption password
  static String decrypt(String encryptedData, String password) {
    if (password.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }
    if (encryptedData.isEmpty) {
      throw ArgumentError('Encrypted data cannot be empty');
    }

    try {
      final data = base64.decode(encryptedData);
      final headerBytes = utf8.encode(_magicHeader);
      
      // Check data length
      if (data.length < headerBytes.length + _saltLength + _nonceLength + _tagLength) {
        throw Exception('Invalid encrypted data format');
      }
      
      // Check magic header
      final header = data.sublist(0, headerBytes.length);
      if (!_listEquals(header, headerBytes)) {
        throw Exception('Invalid encrypted data format');
      }
      
      // Extract components
      int offset = headerBytes.length;
      final salt = data.sublist(offset, offset + _saltLength);
      offset += _saltLength;
      final nonce = data.sublist(offset, offset + _nonceLength);
      offset += _nonceLength;
      final encrypted = data.sublist(offset);
      
      // Derive key from password and salt
      final key = _deriveKey(password, salt);
      
      // Initialize AES-GCM cipher for decryption
      final cipher = GCMBlockCipher(AESEngine());
      cipher.init(false, AEADParameters(
        KeyParameter(key), 
        _tagLength * 8, 
        Uint8List.fromList(nonce),
        Uint8List(0)
      ));
      
      // Decrypt data (automatically verifies authentication tag)
      final decryptedBytes = cipher.process(Uint8List.fromList(encrypted));
      return utf8.decode(decryptedBytes);
    } on InvalidCipherTextException {
      throw Exception('Failed to decrypt: incorrect password or corrupted data');
    } on FormatException {
      throw Exception('Failed to decrypt: invalid Base64 format');
    } catch (e) {
      throw Exception('Failed to decrypt: $e');
    }
  }

  /// Checks if the data is encrypted
  /// [data] Data string to check
  /// Returns true if the data is encrypted by this class
  static bool isEncrypted(String data) {
    if (data.isEmpty) return false;
    
    try {
      final decoded = base64.decode(data);
      final headerBytes = utf8.encode(_magicHeader);
      
      if (decoded.length < headerBytes.length + _saltLength + _nonceLength + _tagLength) {
        return false;
      }
      
      final header = decoded.sublist(0, headerBytes.length);
      return _listEquals(header, headerBytes);
    } catch (e) {
      return false;
    }
  }

  /// Checks if two lists are equal (constant time comparison to prevent timing attacks)
  static bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    int result = 0;
    for (int i = 0; i < a.length; i++) {
      result |= a[i] ^ b[i];
    }
    return result == 0;
  }

  /// Generates a random password for testing
  /// [length] Password length, default is 32
  /// Returns a random alphanumeric password
  static String generatePassword([int length = 32]) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }
}