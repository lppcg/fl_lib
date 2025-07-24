// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'lib_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class LibLocalizationsJa extends LibLocalizations {
  LibLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get about => '約';

  @override
  String actionAndAction(Object action1, Object action2) {
    return '$action1してから$action2？';
  }

  @override
  String get add => '追加';

  @override
  String get all => '全て';

  @override
  String get anonLoseDataTip => '現在匿名でログインしています。操作を続行するとデータが失われます。';

  @override
  String get app => 'アプリケーション';

  @override
  String askContinue(Object msg) {
    return '$msg、続行しますか？';
  }

  @override
  String get attention => '注意';

  @override
  String get authRequired => '認証が必要';

  @override
  String get auto => '自動';

  @override
  String get background => '背景';

  @override
  String get backup => 'バックアップ';

  @override
  String get bioAuth => '生体認証';

  @override
  String get blurRadius => 'ぼかし半径';

  @override
  String get bright => '明るい';

  @override
  String get cancel => 'キャンセル';

  @override
  String get checkUpdate => 'アップデートを確認する';

  @override
  String get clear => 'クリア';

  @override
  String get clipboard => 'クリップボード';

  @override
  String get close => '閉じる';

  @override
  String get content => 'コンテンツ';

  @override
  String get copy => 'コピーする';

  @override
  String get custom => 'カスタム';

  @override
  String get cut => '切り取り';

  @override
  String get dark => '暗い';

  @override
  String get day => '日';

  @override
  String delFmt(Object id, Object type) {
    return '$type（$id）を削除しますか？';
  }

  @override
  String get delete => '削除';

  @override
  String get device => '装置';

  @override
  String get disabled => '無効';

  @override
  String get doc => 'ドキュメント';

  @override
  String get dontShowAgain => '今後表示しない';

  @override
  String get download => 'ダウンロード';

  @override
  String get edit => '編集';

  @override
  String get editor => 'エディター';

  @override
  String get empty => '空';

  @override
  String get error => 'エラー';

  @override
  String get example => '例';

  @override
  String get execute => '実行';

  @override
  String get exit => '終了';

  @override
  String get exitConfirmTip => 'もう一度戻ると終了します';

  @override
  String get exitDirectly => '直接終了する';

  @override
  String get export => 'エクスポート';

  @override
  String get fail => '失敗';

  @override
  String get feedback => 'フィードバック';

  @override
  String get file => 'ファイル';

  @override
  String get fold => '折る';

  @override
  String get folder => 'フォルダ';

  @override
  String get hideTitleBar => 'タイトルバーを非表示にする';

  @override
  String get hour => '時間';

  @override
  String get image => '画像';

  @override
  String get import => 'インポート';

  @override
  String get key => 'キー';

  @override
  String get language => '言語';

  @override
  String get log => 'ログ';

  @override
  String get login => 'ログイン';

  @override
  String get loginTip => '登録不要、無料で利用可能。';

  @override
  String get logout => 'ログアウト';

  @override
  String get migrateCfg => '設定の移行';

  @override
  String get migrateCfgTip => '必要な新しい設定に適応するため';

  @override
  String get minute => '分';

  @override
  String get moveDown => '下へ移動';

  @override
  String get moveUp => '上へ移動';

  @override
  String get name => '名前';

  @override
  String get network => 'ネットワーク';

  @override
  String get next => '次へ';

  @override
  String notExistFmt(Object file) {
    return '$fileは存在しません';
  }

  @override
  String get note => 'メモ';

  @override
  String get ok => 'いいです';

  @override
  String get opacity => '不透明度';

  @override
  String get open => '開く';

  @override
  String get paste => '貼り付け';

  @override
  String get path => 'パス';

  @override
  String get previous => '前へ';

  @override
  String get primaryColorSeed => 'プライマリーカラーシード';

  @override
  String get pwd => 'パスワード';

  @override
  String get pwdTip => '長さ6〜32文字、英語の文字、数字、句読点が使用可能';

  @override
  String get redo => 'やり直す';

  @override
  String get refresh => '更新';

  @override
  String get register => '登録';

  @override
  String get rename => '名前変更';

  @override
  String get replace => '置換';

  @override
  String get replaceAll => 'すべて置換';

  @override
  String get restore => 'リストア';

  @override
  String get retry => '再試行';

  @override
  String get save => '保存';

  @override
  String get search => '検索';

  @override
  String get second => '秒';

  @override
  String get select => '選択';

  @override
  String get setting => '設定';

  @override
  String get share => '共有';

  @override
  String sizeTooLargeOnlyPrefix(Object bytes) {
    return 'コンテンツが大きすぎるため、最初の $bytes のみを表示しています';
  }

  @override
  String get success => '成功';

  @override
  String get sync => '同期';

  @override
  String get tag => 'タグ';

  @override
  String get tapToAuth => '認証するにはクリックしてください';

  @override
  String get themeMode => 'テーマモード';

  @override
  String get thinking => '考え中';

  @override
  String get undo => '元に戻す';

  @override
  String get unknown => '不明';

  @override
  String get unsupported => 'サポートされていません';

  @override
  String get update => '更新';

  @override
  String get user => 'ユーザー';

  @override
  String get value => '値';

  @override
  String versionHasUpdate(Object build) {
    return '新しいバージョンが見つかりました：v1.0.$build、クリックして更新';
  }

  @override
  String versionUnknownUpdate(Object build) {
    return 'Huidig: v1.0.$build, klik om te kijken naar een nieuwere versie';
  }

  @override
  String versionUpdated(Object build) {
    return '現在：v1.0.$build、最新バージョンです';
  }

  @override
  String get yesterday => '昨日';
}
