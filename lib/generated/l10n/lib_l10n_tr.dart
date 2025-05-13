// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'lib_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class LibLocalizationsTr extends LibLocalizations {
  LibLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get about => 'Hakkında';

  @override
  String get add => 'ekle';

  @override
  String get all => 'tümü';

  @override
  String get anonLoseDataTip => 'Şu anda anonim olarak giriş yapılmış, işlemlere devam edilmesi veri kaybına neden olacaktır.';

  @override
  String get app => 'Uygulama';

  @override
  String askContinue(Object msg) {
    return '$msg. Devam edilsin mi?';
  }

  @override
  String get attention => 'Dikkat';

  @override
  String get authRequired => 'kimlik doğrulaması gerekiyor';

  @override
  String get auto => 'Otomatik';

  @override
  String get backup => 'Yedekleme';

  @override
  String get bioAuth => 'biyometrik doğrulama';

  @override
  String get bright => 'Açık';

  @override
  String get cancel => 'iptal';

  @override
  String get checkUpdate => 'Güncellemeleri kontrol et';

  @override
  String get clear => 'temizle';

  @override
  String get clipboard => 'Pano';

  @override
  String get close => 'Kapat';

  @override
  String get content => 'İçerik';

  @override
  String get copy => 'kopyala';

  @override
  String get dark => 'Koyu';

  @override
  String get day => 'gün';

  @override
  String delFmt(Object id, Object type) {
    return '$type ($id) silinsin mi?';
  }

  @override
  String get delete => 'Sil';

  @override
  String get device => 'Cihaz';

  @override
  String get disabled => 'Devre dışı';

  @override
  String get doc => 'Dokümantasyon';

  @override
  String get dontShowAgain => 'Bir daha gösterme';

  @override
  String get download => 'İndir';

  @override
  String get edit => 'düzenle';

  @override
  String get empty => 'boş';

  @override
  String get error => 'Hata';

  @override
  String get example => 'Örnek';

  @override
  String get execute => 'Yürüt';

  @override
  String get exit => 'çıkış';

  @override
  String get exitConfirmTip => 'çıkmak için tekrar geri dön';

  @override
  String get export => 'Dışa aktar';

  @override
  String get fail => 'başarısız';

  @override
  String get feedback => 'Geri bildirim';

  @override
  String get file => 'dosya';

  @override
  String get fold => 'Katmak';

  @override
  String get folder => 'Klasör';

  @override
  String get hideTitleBar => 'Başlık çubuğunu gizle';

  @override
  String get hour => 'saat';

  @override
  String get image => 'Resim';

  @override
  String get import => 'İçe Aktar';

  @override
  String get key => 'anahtar';

  @override
  String get language => 'Dil';

  @override
  String get log => 'Kayıt';

  @override
  String get login => 'Giriş yap';

  @override
  String get loginTip => 'Kayıt gerekmez, ücretsiz kullanım.';

  @override
  String get logout => 'Çıkış yap';

  @override
  String get migrateCfg => 'Yapılandırma geçişi';

  @override
  String get migrateCfgTip => 'Gerekli yeni yapılandırmaya uyum sağlamak için';

  @override
  String get minute => 'dakika';

  @override
  String get name => 'ad';

  @override
  String get network => 'Ağ';

  @override
  String get next => 'Sonraki';

  @override
  String notExistFmt(Object file) {
    return '$file mevcut değil';
  }

  @override
  String get note => 'Not';

  @override
  String get ok => 'tamam';

  @override
  String get open => 'Aç';

  @override
  String get paste => 'Yapıştır';

  @override
  String get path => 'Yol';

  @override
  String get previous => 'Önceki';

  @override
  String get primaryColorSeed => 'Birincil renk tohumu';

  @override
  String get pwd => 'şifre';

  @override
  String get pwdTip => 'Uzunluk 6-32, İngilizce harfler, rakamlar ve noktalama işaretleri olabilir';

  @override
  String get register => 'Kaydol';

  @override
  String get rename => 'yeniden adlandır';

  @override
  String get replace => 'Değiştir';

  @override
  String get replaceAll => 'Tümünü değiştir';

  @override
  String get restore => 'Geri Yükleme';

  @override
  String get save => 'Kaydet';

  @override
  String get search => 'Ara';

  @override
  String get second => 'saniye';

  @override
  String get select => 'seç';

  @override
  String get setting => 'Ayarlar';

  @override
  String get share => 'Paylaş';

  @override
  String sizeTooLargeOnlyPrefix(Object bytes) {
    return 'İçerik çok büyük, yalnızca ilk $bytes gösteriliyor';
  }

  @override
  String get success => 'başarılı';

  @override
  String get sync => 'Senkronize etmek';

  @override
  String get tag => 'etiket';

  @override
  String get tapToAuth => 'doğrulamak için dokunun';

  @override
  String get themeMode => 'Tema modu';

  @override
  String get thinking => 'Düşünüyor';

  @override
  String get unsupported => 'Desteklenmiyor';

  @override
  String get update => 'güncelle';

  @override
  String get user => 'Kullanıcı';

  @override
  String get value => 'değer';

  @override
  String versionHasUpdate(Object build) {
    return 'Bulundu: v1.0.$build, güncellemek için tıklayın';
  }

  @override
  String versionUnknownUpdate(Object build) {
    return 'Mevcut: v1.0.$build, güncellemeleri kontrol etmek için tıklayın';
  }

  @override
  String versionUpdated(Object build) {
    return 'Mevcut: v1.0.$build, güncel';
  }

  @override
  String get yesterday => 'dün';
}
