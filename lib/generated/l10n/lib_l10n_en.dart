import 'lib_l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LibLocalizationsEn extends LibLocalizations {
  LibLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get add => 'Add';

  @override
  String get all => 'All';

  @override
  String get anonLoseDataTip =>
      'Currently logged in anonymously, continuing operations will result in data loss.';

  @override
  String get app => 'Application';

  @override
  String askContinue(Object msg) {
    return '$msg. Continue?';
  }

  @override
  String get attention => 'Attention';

  @override
  String get authRequired => 'Authentication required';

  @override
  String get auto => 'Auto';

  @override
  String get autoCheckUpdate => 'Automatic update check';

  @override
  String get backup => 'Backup';

  @override
  String get bioAuth => 'Biometric authentication';

  @override
  String get bright => 'Bright';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get clipboard => 'Clipboard';

  @override
  String get close => 'Close';

  @override
  String get content => 'Content';

  @override
  String get copy => 'Copy';

  @override
  String get dark => 'Dark';

  @override
  String get day => 'Days';

  @override
  String delFmt(Object id, Object type) {
    return 'Delete $type($id)?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get device => 'Device';

  @override
  String get disabled => 'Disabled';

  @override
  String get doc => 'Documentation';

  @override
  String get dontShowAgain => 'Don\'t show again';

  @override
  String get download => 'Download';

  @override
  String get edit => 'Edit';

  @override
  String get empty => 'Empty';

  @override
  String get error => 'Error';

  @override
  String get example => 'Example';

  @override
  String get execute => 'Execute';

  @override
  String get exit => 'Exit';

  @override
  String get exitConfirmTip => 'Press back again to exit';

  @override
  String get export => 'Export';

  @override
  String get fail => 'Failure';

  @override
  String get feedback => 'Feedback';

  @override
  String get file => 'File';

  @override
  String get fold => 'Fold';

  @override
  String get folder => 'Folder';

  @override
  String get hideTitleBar => 'Hide title bar';

  @override
  String get hour => 'Hours';

  @override
  String get image => 'Image';

  @override
  String get import => 'Import';

  @override
  String get key => 'Key';

  @override
  String get language => 'Language';

  @override
  String get log => 'Log';

  @override
  String get login => 'Log in';

  @override
  String get loginTip => 'No registration required, free to use.';

  @override
  String get logout => 'Logout';

  @override
  String get migrateCfg => 'Configuration migration';

  @override
  String get migrateCfgTip => 'To adapt to the required new configuration';

  @override
  String get minute => 'Minutes';

  @override
  String get name => 'Name';

  @override
  String get network => 'Network';

  @override
  String notExistFmt(Object file) {
    return '$file not exist';
  }

  @override
  String get note => 'Note';

  @override
  String get ok => 'Okay';

  @override
  String get open => 'Open';

  @override
  String get paste => 'Paste';

  @override
  String get path => 'Path';

  @override
  String get primaryColorSeed => 'Primary color seed';

  @override
  String get pwd => 'Password';

  @override
  String get pwdTip =>
      'Length 6-32, can be English letters, numbers, and punctuation';

  @override
  String get register => 'Sign up';

  @override
  String get rename => 'Rename';

  @override
  String get restore => 'Restore';

  @override
  String get save => 'Save';

  @override
  String get second => 'Seconds';

  @override
  String get select => 'Select';

  @override
  String get setting => 'Settings';

  @override
  String get share => 'Share';

  @override
  String get success => 'Success';

  @override
  String get sync => 'Synchronize';

  @override
  String get tag => 'Tag';

  @override
  String get tapToAuth => 'Click to verify';

  @override
  String get themeMode => 'Theme mode';

  @override
  String get update => 'Update';

  @override
  String get user => 'User';

  @override
  String get value => 'Value';

  @override
  String versionHasUpdate(Object build) {
    return 'Found: v1.0.$build, click to update';
  }

  @override
  String versionUnknownUpdate(Object build) {
    return 'Current: v1.0.$build, click to check updates';
  }

  @override
  String versionUpdated(Object build) {
    return 'Current: v1.0.$build, is up to date';
  }

  @override
  String get yesterday => 'Yesterday';
}
