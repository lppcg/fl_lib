// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'lib_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class LibLocalizationsZh extends LibLocalizations {
  LibLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get about => '关于';

  @override
  String actionAndAction(Object action1, Object action2) {
    return '$action1 然后 $action2？';
  }

  @override
  String get add => '添加';

  @override
  String get all => '所有';

  @override
  String get anonLoseDataTip => '当前以匿名登录，继续操作会导致数据丢失';

  @override
  String get app => '应用';

  @override
  String askContinue(Object msg) {
    return '$msg，继续吗？';
  }

  @override
  String get attention => '注意';

  @override
  String get authRequired => '需要认证';

  @override
  String get auto => '自动';

  @override
  String get background => '背景';

  @override
  String get backup => '备份';

  @override
  String get bioAuth => '生物认证';

  @override
  String get blurRadius => '模糊半径';

  @override
  String get bright => '亮';

  @override
  String get cancel => '取消';

  @override
  String get checkUpdate => '检查更新';

  @override
  String get clear => '清除';

  @override
  String get clipboard => '剪切板';

  @override
  String get close => '关闭';

  @override
  String get content => '内容';

  @override
  String get copy => '复制';

  @override
  String get custom => '自定义';

  @override
  String get cut => '剪切';

  @override
  String get dark => '暗';

  @override
  String get day => '天';

  @override
  String delFmt(Object id, Object type) {
    return '删除 $type（$id）？';
  }

  @override
  String get delete => '删除';

  @override
  String get device => '设备';

  @override
  String get disabled => '已禁用';

  @override
  String get doc => '文档';

  @override
  String get dontShowAgain => '不再提示';

  @override
  String get download => '下载';

  @override
  String get edit => '编辑';

  @override
  String get editor => '编辑器';

  @override
  String get empty => '空';

  @override
  String get error => '错误';

  @override
  String get example => '示例';

  @override
  String get execute => '执行';

  @override
  String get exit => '退出';

  @override
  String get exitConfirmTip => '再次返回以退出';

  @override
  String get exitDirectly => '直接退出';

  @override
  String get export => '导出';

  @override
  String get fail => '失败';

  @override
  String get feedback => '反馈';

  @override
  String get file => '文件';

  @override
  String get fold => '折叠';

  @override
  String get folder => '文件夹';

  @override
  String get hideTitleBar => '隐藏标题栏';

  @override
  String get hour => '时';

  @override
  String get image => '图片';

  @override
  String get import => '导入';

  @override
  String get key => '键';

  @override
  String get language => '语言';

  @override
  String get log => '日志';

  @override
  String get login => '登录';

  @override
  String get loginTip => '无需注册，免费使用';

  @override
  String get logout => '登出';

  @override
  String get migrateCfg => '配置迁移';

  @override
  String get migrateCfgTip => '为了适应所需的新配置';

  @override
  String get minute => '分';

  @override
  String get moveDown => '下移';

  @override
  String get moveUp => '上移';

  @override
  String get name => '名称';

  @override
  String get network => '网络';

  @override
  String get next => '下一个';

  @override
  String notExistFmt(Object file) {
    return '$file 不存在';
  }

  @override
  String get note => '备注';

  @override
  String get ok => '好';

  @override
  String get opacity => '透明度';

  @override
  String get open => '打开';

  @override
  String get paste => '粘贴';

  @override
  String get path => '路径';

  @override
  String get previous => '上一个';

  @override
  String get primaryColorSeed => '主题色种子';

  @override
  String get pwd => '密码';

  @override
  String get pwdTip => '长度6-32，可以是英文的字母、数字、标点';

  @override
  String get redo => '重做';

  @override
  String get refresh => '刷新';

  @override
  String get register => '注册';

  @override
  String get rename => '重命名';

  @override
  String get replace => '替换';

  @override
  String get replaceAll => '替换全部';

  @override
  String get restore => '恢复';

  @override
  String get retry => '重试';

  @override
  String get save => '保存';

  @override
  String get search => '搜索';

  @override
  String get second => '秒';

  @override
  String get select => '选择';

  @override
  String get setting => '设置';

  @override
  String get share => '分享';

  @override
  String sizeTooLargeOnlyPrefix(Object bytes) {
    return '内容过大，仅显示前 $bytes';
  }

  @override
  String get success => '成功';

  @override
  String get sync => '同步';

  @override
  String get tag => '标签';

  @override
  String get tapToAuth => '点击以认证';

  @override
  String get themeMode => '主题模式';

  @override
  String get thinking => '思考中';

  @override
  String get undo => '撤销';

  @override
  String get unknown => '未知';

  @override
  String get unsupported => '不支持';

  @override
  String get update => '更新';

  @override
  String get user => '用户';

  @override
  String get value => '值';

  @override
  String versionHasUpdate(Object build) {
    return '找到新版本：v1.0.$build, 点击更新';
  }

  @override
  String versionUnknownUpdate(Object build) {
    return '当前：v1.0.$build，点击检查更新';
  }

  @override
  String versionUpdated(Object build) {
    return '当前：v1.0.$build, 已是最新版本';
  }

  @override
  String get yesterday => '昨天';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class LibLocalizationsZhTw extends LibLocalizationsZh {
  LibLocalizationsZhTw() : super('zh_TW');

  @override
  String get about => '關於';

  @override
  String actionAndAction(Object action1, Object action2) {
    return '$action1 然後 $action2？';
  }

  @override
  String get add => '添加';

  @override
  String get all => '所有';

  @override
  String get anonLoseDataTip => '目前以匿名方式登入，繼續操作將導致資料遺失。';

  @override
  String get app => '應用';

  @override
  String askContinue(Object msg) {
    return '$msg，繼續嗎？';
  }

  @override
  String get attention => '注意';

  @override
  String get authRequired => '需要認證';

  @override
  String get auto => '自動';

  @override
  String get background => '背景';

  @override
  String get backup => '備份';

  @override
  String get bioAuth => '生物認證';

  @override
  String get blurRadius => '模糊半徑';

  @override
  String get bright => '亮';

  @override
  String get cancel => '取消';

  @override
  String get checkUpdate => '檢查更新';

  @override
  String get clear => '清除';

  @override
  String get clipboard => '剪貼簿';

  @override
  String get close => '關閉';

  @override
  String get content => '內容';

  @override
  String get copy => '複製';

  @override
  String get custom => '自訂';

  @override
  String get cut => '剪下';

  @override
  String get dark => '暗';

  @override
  String get day => '天';

  @override
  String delFmt(Object id, Object type) {
    return '刪除 $type（$id）？';
  }

  @override
  String get delete => '刪除';

  @override
  String get device => 'Cihaz';

  @override
  String get disabled => '已禁用';

  @override
  String get doc => '文檔';

  @override
  String get dontShowAgain => '不再顯示';

  @override
  String get download => '下載';

  @override
  String get edit => '編輯';

  @override
  String get editor => '編輯器';

  @override
  String get empty => '空';

  @override
  String get error => '錯誤';

  @override
  String get example => '範例';

  @override
  String get execute => '執行';

  @override
  String get exit => '退出';

  @override
  String get exitConfirmTip => '再次返回以退出';

  @override
  String get exitDirectly => '直接退出';

  @override
  String get export => '匯出';

  @override
  String get fail => '失敗';

  @override
  String get feedback => '反饋';

  @override
  String get file => '文件';

  @override
  String get fold => '摺疊';

  @override
  String get folder => '資料夾';

  @override
  String get hideTitleBar => '隱藏標題欄';

  @override
  String get hour => '時';

  @override
  String get image => '圖片';

  @override
  String get import => '導入';

  @override
  String get key => '鍵';

  @override
  String get language => '語言';

  @override
  String get log => '日誌';

  @override
  String get login => '登入';

  @override
  String get loginTip => '無需註冊，免費使用。';

  @override
  String get logout => '登出';

  @override
  String get migrateCfg => '配置遷移';

  @override
  String get migrateCfgTip => '为了適應所需的新配置';

  @override
  String get minute => '分';

  @override
  String get moveDown => '下移';

  @override
  String get moveUp => '上移';

  @override
  String get name => '名稱';

  @override
  String get network => '網絡';

  @override
  String get next => '下一個';

  @override
  String notExistFmt(Object file) {
    return '$file 不存在';
  }

  @override
  String get note => '備註';

  @override
  String get ok => '好';

  @override
  String get opacity => '透明度';

  @override
  String get open => '打開';

  @override
  String get paste => '貼上';

  @override
  String get path => '路徑';

  @override
  String get previous => '上一個';

  @override
  String get primaryColorSeed => '主要色調種子';

  @override
  String get pwd => '密碼';

  @override
  String get pwdTip => '長度6-32，可以是英文字母、數字、標點符號';

  @override
  String get redo => '重做';

  @override
  String get refresh => '刷新';

  @override
  String get register => '註冊';

  @override
  String get rename => '重命名';

  @override
  String get replace => '替換';

  @override
  String get replaceAll => '全部替換';

  @override
  String get restore => '恢復';

  @override
  String get retry => '重試';

  @override
  String get save => '儲存';

  @override
  String get search => '搜尋';

  @override
  String get second => '秒';

  @override
  String get select => '選擇';

  @override
  String get setting => '設置';

  @override
  String get share => '分享';

  @override
  String sizeTooLargeOnlyPrefix(Object bytes) {
    return '內容過大，僅顯示前 $bytes';
  }

  @override
  String get success => '成功';

  @override
  String get sync => '同步';

  @override
  String get tag => '標籤';

  @override
  String get tapToAuth => '點擊以認證';

  @override
  String get themeMode => '主題模式';

  @override
  String get thinking => '思考中';

  @override
  String get undo => '復原';

  @override
  String get unknown => '未知';

  @override
  String get unsupported => '不支援';

  @override
  String get update => '更新';

  @override
  String get user => '使用者';

  @override
  String get value => '值';

  @override
  String versionHasUpdate(Object build) {
    return '找到新版本：v1.0.$build, 點擊更新';
  }

  @override
  String versionUnknownUpdate(Object build) {
    return '當前：v1.0.$build，點擊檢查更新';
  }

  @override
  String versionUpdated(Object build) {
    return '當前：v1.0.$build, 已是最新版本';
  }

  @override
  String get yesterday => '昨天';
}
