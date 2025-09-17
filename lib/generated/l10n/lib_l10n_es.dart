// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'lib_l10n.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LibLocalizationsEs extends LibLocalizations {
  LibLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'Acerca de';

  @override
  String actionAndAction(Object action1, Object action2) {
    return '¿$action1 y luego $action2?';
  }

  @override
  String get add => 'Añadir';

  @override
  String get all => 'Todos';

  @override
  String get anonLoseDataTip =>
      'Actualmente has iniciado sesión de forma anónima. Si continuas, podrías perder tus datos.';

  @override
  String get app => 'Aplicación';

  @override
  String askContinue(Object msg) {
    return '$msg, ¿deseas continuar?';
  }

  @override
  String get attention => 'Atención';

  @override
  String get authRequired => 'Autenticación requerida';

  @override
  String get auto => 'Auto';

  @override
  String get background => 'Fondo';

  @override
  String get backup => 'Copia de seguridad';

  @override
  String get bioAuth => 'Autenticación biométrica';

  @override
  String get blurRadius => 'Radio de desenfoque';

  @override
  String get bright => 'Brillante';

  @override
  String get cancel => 'Cancelar';

  @override
  String get checkUpdate => 'Buscar actualizaciones';

  @override
  String get clear => 'Limpiar';

  @override
  String get click => 'Clic';

  @override
  String get clipboard => 'Portapapeles';

  @override
  String get close => 'Cerrar';

  @override
  String get content => 'Contenido';

  @override
  String get copy => 'Copiar';

  @override
  String get custom => 'Personalizado';

  @override
  String get cut => 'Cortar';

  @override
  String get dark => 'Oscuro';

  @override
  String get day => 'Días';

  @override
  String delFmt(Object id, Object type) {
    return '¿Eliminar $type ($id)?';
  }

  @override
  String get delay => 'Retraso';

  @override
  String get delete => 'Eliminar';

  @override
  String get device => 'Dispositivo';

  @override
  String get disabled => 'Deshabilitado';

  @override
  String get doc => 'Documentación';

  @override
  String get dontShowAgain => 'No mostrar más';

  @override
  String get download => 'Descargar';

  @override
  String get duration => 'Duración';

  @override
  String get edit => 'Editar';

  @override
  String get editor => 'Editor';

  @override
  String get empty => 'Vacío';

  @override
  String get error => 'Error';

  @override
  String get example => 'Ejemplo';

  @override
  String get execute => 'Ejecutar';

  @override
  String get exit => 'Salir';

  @override
  String get exitConfirmTip => 'Presiona Atrás nuevamente para salir';

  @override
  String get exitDirectly => 'Salir directamente';

  @override
  String get export => 'Exportar';

  @override
  String get fail => 'Error';

  @override
  String get feedback => 'Comentarios';

  @override
  String get file => 'Archivo';

  @override
  String get fold => 'Contraer';

  @override
  String get folder => 'Carpeta';

  @override
  String get font => 'Fuente';

  @override
  String get found => 'Encontrado';

  @override
  String get hideTitleBar => 'Ocultar barra de título';

  @override
  String get hour => 'Horas';

  @override
  String get image => 'Imagen';

  @override
  String get import => 'Importar';

  @override
  String get init => 'Inicializar';

  @override
  String get key => 'Clave';

  @override
  String get language => 'Idioma';

  @override
  String get license => 'Licencia';

  @override
  String get log => 'Registro';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get loginTip => 'No es necesario registrarse, es gratuito.';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get mannual => 'Manual';

  @override
  String get migrateCfg => 'Migración de configuración';

  @override
  String get migrateCfgTip =>
      'Para adaptarse a la nueva configuración necesaria';

  @override
  String get minute => 'Minutos';

  @override
  String get moveDown => 'Bajar';

  @override
  String get moveUp => 'Subir';

  @override
  String get name => 'Nombre';

  @override
  String get network => 'Red';

  @override
  String get next => 'Siguiente';

  @override
  String notExistFmt(Object file) {
    return '$file no existe';
  }

  @override
  String get note => 'Nota';

  @override
  String get ok => 'OK';

  @override
  String get opacity => 'Opacidad';

  @override
  String get open => 'Abrir';

  @override
  String get paste => 'Pegar';

  @override
  String get path => 'Ruta';

  @override
  String get preview => 'Vista previa';

  @override
  String get previous => 'Anterior';

  @override
  String get primaryColorSeed => 'Color principal base';

  @override
  String get pwd => 'Contraseña';

  @override
  String get pwdTip =>
      'Longitud de 6 a 32 caracteres, puede contener letras, números y signos de puntuación';

  @override
  String get redo => 'Rehacer';

  @override
  String get refresh => 'Actualizar';

  @override
  String get register => 'Registrarse';

  @override
  String get rename => 'Renombrar';

  @override
  String get replace => 'Reemplazar';

  @override
  String get replaceAll => 'Reemplazar todo';

  @override
  String get reset => 'Restablecer';

  @override
  String get restore => 'Restaurar';

  @override
  String get result => 'Resultado';

  @override
  String get retry => 'Reintentar';

  @override
  String get save => 'Guardar';

  @override
  String get search => 'Buscar';

  @override
  String get second => 'Segundos';

  @override
  String get select => 'Seleccionar';

  @override
  String get setting => 'Configuración';

  @override
  String get share => 'Compartir';

  @override
  String get size => 'Tamaño';

  @override
  String sizeTooLargeOnlyPrefix(Object bytes) {
    return 'Contenido demasiado grande, mostrando solo los primeros $bytes';
  }

  @override
  String get start => 'Iniciar';

  @override
  String get stop => 'Detener';

  @override
  String get success => 'Éxito';

  @override
  String get switch_ => 'Interruptor';

  @override
  String get switcher => 'Conmutador';

  @override
  String get sync => 'Sincronizar';

  @override
  String get system => 'Sistema';

  @override
  String get tag => 'Etiqueta';

  @override
  String get tapToAuth => 'Toca para autenticarte';

  @override
  String get themeMode => 'Modo de tema';

  @override
  String get thinking => 'Pensando';

  @override
  String get timeout => 'Tiempo de espera';

  @override
  String get undo => 'Deshacer';

  @override
  String get unknown => 'Desconocido';

  @override
  String get unsupported => 'No compatible';

  @override
  String get update => 'Actualizar';

  @override
  String get upload => 'Subir';

  @override
  String get user => 'Usuario';

  @override
  String get value => 'Valor';

  @override
  String versionHasUpdate(Object build) {
    return 'Nueva versión disponible: v1.0.$build, toca para actualizar';
  }

  @override
  String versionUnknownUpdate(Object build) {
    return 'Versión actual: v1.0.$build, toca para buscar actualizaciones';
  }

  @override
  String versionUpdated(Object build) {
    return 'Versión actual: v1.0.$build, ya tienes la última versión';
  }

  @override
  String get yesterday => 'Ayer';
}
