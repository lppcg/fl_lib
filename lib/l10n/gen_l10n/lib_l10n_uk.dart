import 'lib_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Ukraine (`uk`).
class LibLocalizationsUk extends LibLocalizations {
  LibLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get about => 'Про застосунок';

  @override
  String get add => 'Додати';

  @override
  String get all => 'Все';

  @override
  String get anonLoseDataTip => 'Наразі ви увійшли в систему анонімно, продовження роботи призведе до втрати даних.';

  @override
  String get app => 'Застосунок';

  @override
  String askContinue(Object msg) {
    return '$msg. Продовжити?';
  }

  @override
  String get attention => 'Увага!';

  @override
  String get authRequired => 'Потрібна автентифікація';

  @override
  String get auto => 'Авто';

  @override
  String get autoCheckUpdate => 'Автоматична перевірка оновлень';

  @override
  String get backup => 'Резервне копіювання';

  @override
  String get bioAuth => 'Біометрична автентифікація';

  @override
  String get bright => 'Світлий';

  @override
  String get cancel => 'Скасувати';

  @override
  String get clear => 'Очистити';

  @override
  String get clipboard => 'Буфер обміну';

  @override
  String get close => 'Закрити';

  @override
  String get content => 'Контент';

  @override
  String get copy => 'Скопіювати';

  @override
  String get dark => 'Темний';

  @override
  String get day => 'Дні';

  @override
  String delFmt(Object id, Object type) {
    return 'Видалити $type($id)?';
  }

  @override
  String get delete => 'Видалити';

  @override
  String get device => 'Пристрій';

  @override
  String get disabled => 'Вимкнений';

  @override
  String get doc => 'Документація';

  @override
  String get dontShowAgain => 'Більше не показувати';

  @override
  String get download => 'Завантажити';

  @override
  String get edit => 'Редагувати';

  @override
  String get empty => 'Пустий';

  @override
  String get error => 'Помилка';

  @override
  String get example => 'Приклад';

  @override
  String get execute => 'Виконати';

  @override
  String get exit => 'Вихід';

  @override
  String get exitConfirmTip => 'Натисніть ще раз, щоб вийти';

  @override
  String get export => 'Експорт';

  @override
  String get fail => 'Невдача';

  @override
  String get feedback => 'Зворотній зв\'язок';

  @override
  String get file => 'Файл';

  @override
  String get fold => 'Складений';

  @override
  String get folder => 'Директорія';

  @override
  String get hideTitleBar => 'Приховати рядок заголовка';

  @override
  String get hour => 'Години';

  @override
  String get image => 'Зображення';

  @override
  String get import => 'Імпорт';

  @override
  String get key => 'Ключ';

  @override
  String get language => 'Мова';

  @override
  String get log => 'Лог';

  @override
  String get login => 'Вхід';

  @override
  String get loginTip => 'Реєстрація не потрібна, користування безкоштовне.';

  @override
  String get logout => 'Вихід';

  @override
  String get minute => 'Хвилини';

  @override
  String get name => 'Назва';

  @override
  String get network => 'Мережа';

  @override
  String notExistFmt(Object file) {
    return '$file не існує';
  }

  @override
  String get note => 'Нотатка';

  @override
  String get ok => 'Гаразд';

  @override
  String get open => 'Відкрити';

  @override
  String get paste => 'Вставити';

  @override
  String get path => 'Шлях';

  @override
  String get primaryColorSeed => 'Основний колір';

  @override
  String get pwd => 'Пароль';

  @override
  String get register => 'Зареєструватися';

  @override
  String get rename => 'Перейменувати';

  @override
  String get restore => 'Відновити';

  @override
  String get save => 'Зберегти';

  @override
  String get second => 'Секунди';

  @override
  String get select => 'Вибрати';

  @override
  String get setting => 'Налаштування';

  @override
  String get share => 'Поділіться';

  @override
  String get success => 'Успішно';

  @override
  String get sync => 'Синхронізувати';

  @override
  String get tag => 'Теґ';

  @override
  String get tapToAuth => 'Натисніть, щоб підтвердити';

  @override
  String get themeMode => 'Тема';

  @override
  String get update => 'Оновити';

  @override
  String get user => 'Користувач';

  @override
  String get value => 'Значення';

  @override
  String versionHasUpdate(Object build) {
    return 'Є оновлення: v1.0.$build, натисніть, щоб оновити';
  }

  @override
  String versionUnknownUpdate(Object build) {
    return 'Поточна: v1.0.$build, натисніть, щоб перевірити оновлення';
  }

  @override
  String versionUpdated(Object build) {
    return 'Поточна: v1.0.$build, є актуальною';
  }

  @override
  String get yesterday => 'Вчора';
}
