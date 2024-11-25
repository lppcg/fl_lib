import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'lib_l10n_de.dart';
import 'lib_l10n_en.dart';
import 'lib_l10n_es.dart';
import 'lib_l10n_fr.dart';
import 'lib_l10n_id.dart';
import 'lib_l10n_ja.dart';
import 'lib_l10n_nl.dart';
import 'lib_l10n_pt.dart';
import 'lib_l10n_ru.dart';
import 'lib_l10n_tr.dart';
import 'lib_l10n_uk.dart';
import 'lib_l10n_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of LibLocalizations
/// returned by `LibLocalizations.of(context)`.
///
/// Applications need to include `LibLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/lib_l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: LibLocalizations.localizationsDelegates,
///   supportedLocales: LibLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the LibLocalizations.supportedLocales
/// property.
abstract class LibLocalizations {
  LibLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static LibLocalizations? of(BuildContext context) {
    return Localizations.of<LibLocalizations>(context, LibLocalizations);
  }

  static const LocalizationsDelegate<LibLocalizations> delegate =
      _LibLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('id'),
    Locale('ja'),
    Locale('nl'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('uk'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @anonLoseDataTip.
  ///
  /// In en, this message translates to:
  /// **'Currently logged in anonymously, continuing operations will result in data loss.'**
  String get anonLoseDataTip;

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get app;

  /// No description provided for @askContinue.
  ///
  /// In en, this message translates to:
  /// **'{msg}. Continue?'**
  String askContinue(Object msg);

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get attention;

  /// No description provided for @authRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get authRequired;

  /// No description provided for @auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get auto;

  /// No description provided for @autoCheckUpdate.
  ///
  /// In en, this message translates to:
  /// **'Automatic update check'**
  String get autoCheckUpdate;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @bioAuth.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication'**
  String get bioAuth;

  /// No description provided for @bright.
  ///
  /// In en, this message translates to:
  /// **'Bright'**
  String get bright;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @clipboard.
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get clipboard;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get day;

  /// No description provided for @delFmt.
  ///
  /// In en, this message translates to:
  /// **'Delete {type}({id})?'**
  String delFmt(Object id, Object type);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @device.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @doc.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get doc;

  /// No description provided for @dontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get dontShowAgain;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get empty;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @example.
  ///
  /// In en, this message translates to:
  /// **'Example'**
  String get example;

  /// No description provided for @execute.
  ///
  /// In en, this message translates to:
  /// **'Execute'**
  String get execute;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @exitConfirmTip.
  ///
  /// In en, this message translates to:
  /// **'Press back again to exit'**
  String get exitConfirmTip;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @fail.
  ///
  /// In en, this message translates to:
  /// **'Failure'**
  String get fail;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @fold.
  ///
  /// In en, this message translates to:
  /// **'Fold'**
  String get fold;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// No description provided for @hideTitleBar.
  ///
  /// In en, this message translates to:
  /// **'Hide title bar'**
  String get hideTitleBar;

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hour;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @key.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get key;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @log.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get log;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @loginTip.
  ///
  /// In en, this message translates to:
  /// **'No registration required, free to use.'**
  String get loginTip;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @migrateCfg.
  ///
  /// In en, this message translates to:
  /// **'Configuration migration'**
  String get migrateCfg;

  /// No description provided for @migrateCfgTip.
  ///
  /// In en, this message translates to:
  /// **'To adapt to the required new configuration'**
  String get migrateCfgTip;

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minute;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @notExistFmt.
  ///
  /// In en, this message translates to:
  /// **'{file} not exist'**
  String notExistFmt(Object file);

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get ok;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @path.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get path;

  /// No description provided for @primaryColorSeed.
  ///
  /// In en, this message translates to:
  /// **'Primary color seed'**
  String get primaryColorSeed;

  /// No description provided for @pwd.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get pwd;

  /// No description provided for @pwdTip.
  ///
  /// In en, this message translates to:
  /// **'Length 6-32, can be English letters, numbers, and punctuation'**
  String get pwdTip;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get register;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get second;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Synchronize'**
  String get sync;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @tapToAuth.
  ///
  /// In en, this message translates to:
  /// **'Click to verify'**
  String get tapToAuth;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get themeMode;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @versionHasUpdate.
  ///
  /// In en, this message translates to:
  /// **'Found: v1.0.{build}, click to update'**
  String versionHasUpdate(Object build);

  /// No description provided for @versionUnknownUpdate.
  ///
  /// In en, this message translates to:
  /// **'Current: v1.0.{build}, click to check updates'**
  String versionUnknownUpdate(Object build);

  /// No description provided for @versionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Current: v1.0.{build}, is up to date'**
  String versionUpdated(Object build);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;
}

class _LibLocalizationsDelegate
    extends LocalizationsDelegate<LibLocalizations> {
  const _LibLocalizationsDelegate();

  @override
  Future<LibLocalizations> load(Locale locale) {
    return SynchronousFuture<LibLocalizations>(lookupLibLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'id',
        'ja',
        'nl',
        'pt',
        'ru',
        'tr',
        'uk',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_LibLocalizationsDelegate old) => false;
}

LibLocalizations lookupLibLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return LibLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return LibLocalizationsDe();
    case 'en':
      return LibLocalizationsEn();
    case 'es':
      return LibLocalizationsEs();
    case 'fr':
      return LibLocalizationsFr();
    case 'id':
      return LibLocalizationsId();
    case 'ja':
      return LibLocalizationsJa();
    case 'nl':
      return LibLocalizationsNl();
    case 'pt':
      return LibLocalizationsPt();
    case 'ru':
      return LibLocalizationsRu();
    case 'tr':
      return LibLocalizationsTr();
    case 'uk':
      return LibLocalizationsUk();
    case 'zh':
      return LibLocalizationsZh();
  }

  throw FlutterError(
      'LibLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
