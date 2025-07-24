// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'lib_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class LibLocalizationsRu extends LibLocalizations {
  LibLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get about => 'о';

  @override
  String actionAndAction(Object action1, Object action2) {
    return '$action1, а потом $action2?';
  }

  @override
  String get add => 'Добавить';

  @override
  String get all => 'Все';

  @override
  String get anonLoseDataTip =>
      'В настоящее время выполнен анонимный вход, продолжение операций приведет к потере данных.';

  @override
  String get app => 'Приложение';

  @override
  String askContinue(Object msg) {
    return '$msg, продолжить?';
  }

  @override
  String get attention => 'Внимание';

  @override
  String get authRequired => 'Требуется аутентификация';

  @override
  String get auto => 'авто';

  @override
  String get background => 'Фон';

  @override
  String get backup => 'Резервное копирование';

  @override
  String get bioAuth => 'Биометрическая аутентификация';

  @override
  String get blurRadius => 'Радиус размытия';

  @override
  String get bright => 'Светлый';

  @override
  String get cancel => 'Отмена';

  @override
  String get checkUpdate => 'Проверить обновления';

  @override
  String get clear => 'Очистить';

  @override
  String get clipboard => 'Буфер обмена';

  @override
  String get close => 'закрыть';

  @override
  String get content => 'Содержимое';

  @override
  String get copy => 'Копировать';

  @override
  String get custom => 'Настроить';

  @override
  String get cut => 'Вырезать';

  @override
  String get dark => 'Темный';

  @override
  String get day => 'Дни';

  @override
  String delFmt(Object id, Object type) {
    return 'Удалить $type ($id)?';
  }

  @override
  String get delete => 'Удалить';

  @override
  String get device => 'Устройство';

  @override
  String get disabled => 'отключено';

  @override
  String get doc => 'Документация';

  @override
  String get dontShowAgain => 'Больше не показывать';

  @override
  String get download => 'скачать';

  @override
  String get edit => 'Редактировать';

  @override
  String get editor => 'Редактор';

  @override
  String get empty => 'Пусто';

  @override
  String get error => 'Ошибка';

  @override
  String get example => 'Пример';

  @override
  String get execute => 'Выполнить';

  @override
  String get exit => 'Выйти';

  @override
  String get exitConfirmTip => 'Нажмите назад еще раз, чтобы выйти';

  @override
  String get exitDirectly => 'Выйти сразу';

  @override
  String get export => 'экспорт';

  @override
  String get fail => 'Неудача';

  @override
  String get feedback => 'обратная связь';

  @override
  String get file => 'Файл';

  @override
  String get fold => 'Складывать';

  @override
  String get folder => 'Папка';

  @override
  String get hideTitleBar => 'Скрыть строку заголовка';

  @override
  String get hour => 'Часы';

  @override
  String get image => 'Изображение';

  @override
  String get import => 'Импортировать';

  @override
  String get key => 'Ключ';

  @override
  String get language => 'язык';

  @override
  String get log => 'лог';

  @override
  String get login => 'Войти';

  @override
  String get loginTip => 'Регистрация не требуется, бесплатное использование.';

  @override
  String get logout => 'Выйти';

  @override
  String get migrateCfg => 'Миграция конфигурации';

  @override
  String get migrateCfgTip => 'Для адаптации к требуемой новой конфигурации';

  @override
  String get minute => 'Минуты';

  @override
  String get moveDown => 'Отменить';

  @override
  String get moveUp => 'Вверх';

  @override
  String get name => 'Имя';

  @override
  String get network => 'Сеть';

  @override
  String get next => 'Далее';

  @override
  String notExistFmt(Object file) {
    return '$file не существует';
  }

  @override
  String get note => 'заметка';

  @override
  String get ok => 'Хорошо';

  @override
  String get opacity => 'Прозрачность';

  @override
  String get open => 'Открыть';

  @override
  String get paste => 'Вставить';

  @override
  String get path => 'путь';

  @override
  String get previous => 'Назад';

  @override
  String get primaryColorSeed => 'основной цветовой тон';

  @override
  String get pwd => 'Пароль';

  @override
  String get pwdTip =>
      'Длина от 6 до 32 символов, может содержать английские буквы, цифры и знаки препинания';

  @override
  String get redo => 'Повторить';

  @override
  String get refresh => 'Обновить';

  @override
  String get register => 'Зарегистрироваться';

  @override
  String get rename => 'Переименовать';

  @override
  String get replace => 'Заменить';

  @override
  String get replaceAll => 'Заменить всё';

  @override
  String get restore => 'Восстановление';

  @override
  String get retry => 'Повторить';

  @override
  String get save => 'Сохранить';

  @override
  String get search => 'Поиск';

  @override
  String get second => 'Секунды';

  @override
  String get select => 'Выбрать';

  @override
  String get setting => 'настройки';

  @override
  String get share => 'Поделиться';

  @override
  String sizeTooLargeOnlyPrefix(Object bytes) {
    return 'Содержимое слишком большое, отображаются только первые $bytes';
  }

  @override
  String get success => 'Успех';

  @override
  String get sync => 'Синхронизировать';

  @override
  String get tag => 'Тег';

  @override
  String get tapToAuth => 'Нажмите для подтверждения';

  @override
  String get themeMode => 'режим темы';

  @override
  String get thinking => 'Думаю';

  @override
  String get undo => 'Отменить';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get unsupported => 'Не поддерживается';

  @override
  String get update => 'Обновить';

  @override
  String get user => 'пользователь';

  @override
  String get value => 'значение';

  @override
  String versionHasUpdate(Object build) {
    return 'Найдена новая версия: v1.0.$build, нажмите для обновления';
  }

  @override
  String versionUnknownUpdate(Object build) {
    return 'Текущая: v1.0.$build, нажмите для проверки обновлений';
  }

  @override
  String versionUpdated(Object build) {
    return 'Текущая: v1.0.$build, последняя версия';
  }

  @override
  String get yesterday => 'Вчера';
}
