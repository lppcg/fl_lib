import 'dart:async';
import 'dart:io';

import 'package:computer/computer.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:re_editor/re_editor.dart';

const _kSoftWrap = false;
const _kEnableHighlight = true;
const _kCloseAfterSave = false;

/// The return value type
enum EditorPageRetType { path, text }

/// The return value of the editor page
final class EditorPageRet {
  final EditorPageRetType typ;
  final String val;

  const EditorPageRet(this.typ, this.val);
}

final class EditorPageArgs {
  /// If path is not null, then it's a file editor
  /// If path is null, then it's a text editor
  final String? path;

  /// Only used when path is null
  final String? text;

  /// Code of language, eg: dart, go, etc.
  /// Higher priority than [path]
  final ProgLang? lang;

  /// The title of the editor
  final String? title;

  /// The theme of the editor in light mode
  final HighlightTheme? lightTheme;

  /// The theme of the editor in dark mode
  final HighlightTheme? darkTheme;

  /// The callback when the editor is saved
  final void Function(BuildContext, EditorPageRet) onSave;

  /// Whether to soft wrap the text
  final bool softWrap;

  /// Whether to enable highlight
  final bool enableHighlight;

  /// Whether to close the editor after saving
  final bool closeAfterSave;

  const EditorPageArgs({
    this.path,
    this.text,
    this.lang,
    this.title,
    required this.onSave,
    this.lightTheme,
    this.darkTheme,
    this.softWrap = _kSoftWrap,
    this.enableHighlight = _kEnableHighlight,
    this.closeAfterSave = _kCloseAfterSave,
  });
}

/// The code editor page which has code highlighting and syntax highlighting
class EditorPage extends StatefulWidget {
  final EditorPageArgs? args;

  const EditorPage({super.key, this.args});

  static const route = AppRoute<void, EditorPageArgs>(
    page: EditorPage.new,
    path: '/editor',
  );

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final _focusNode = FocusNode();

  final _controller = CodeLineEditingController();
  late final _findController = CodeFindController(_controller);
  late Map<String, TextStyle> _codeTheme;
  late final _modesMap = _parseModesMap;

  var _saved = false;

  @override
  void dispose() {
    _controller.dispose();
    _findController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setupCtrl();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (context.isDark) {
      _codeTheme = widget.args?.darkTheme?.theme ?? monokaiTheme;
    } else {
      _codeTheme = widget.args?.lightTheme?.theme ?? a11yLightTheme;
    }
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        _pop();
      },
      child: Scaffold(
        backgroundColor: _codeTheme['root']?.backgroundColor,
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBar(
      centerTitle: true,
      title: TwoLineText(
        up: widget.args?.title ?? widget.args?.path?.getFileName() ?? libL10n.unknown,
        down: libL10n.editor,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: libL10n.search,
          onPressed: () => _findController.findMode(),
        ),
        // PopupMenuButton<String>(
        //   icon: const Icon(Icons.language),
        //   tooltip: libL10n.language,
        //   onSelected: (value) {
        //     _langCode = value;
        //   },
        //   initialValue: _langCode,
        //   itemBuilder: (BuildContext context) {
        //     return Highlights.all.keys.map((e) {
        //       return PopupMenuItem(
        //         value: e,
        //         child: Text(e),
        //       );
        //     }).toList();
        //   },
        // ),
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: libL10n.save,
          onPressed: _onSave,
        )
      ],
    );
  }

  Widget _buildBody() {
    return CodeEditor(
      style: CodeEditorStyle(
        codeTheme: CodeHighlightTheme(
          languages: _modesMap,
          theme: _codeTheme,
        ),
      ),
      controller: _controller,
      findController: _findController,
      wordWrap: widget.args?.softWrap ?? false,
      focusNode: _focusNode,
      indicatorBuilder: (context, editingController, chunkController, notifier) {
        return Row(
          children: [
            DefaultCodeLineNumber(
              controller: editingController,
              notifier: notifier,
            ),
            UIs.width7,
          ],
        );
      },
      findBuilder: (context, controller, readOnly) => CodeFindPanelView(controller: controller, readOnly: readOnly),
      toolbarController: const CodeContextMenuController(),
    );
  }
}

extension on _EditorPageState {
  Future<void> _setupCtrl() async {
    final path = widget.args?.path;
    final text = widget.args?.text;
    if (path != null) {
      final code = await Computer.shared.startNoParam(
        () => File(path).readAsString(),
      );
      _controller.text = code;
    } else if (text != null) {
      _controller.text = text;
    }
  }

  Map<String, CodeHighlightThemeMode> get _parseModesMap {
    final lang = widget.args?.lang ?? ProgLang.parseFileName(widget.args?.path);
    return lang?.editorLangs ?? ProgLang.defaultLangModeMap;
  }

  void _onSave() async {
    // If path is not null, then it's a file editor
    final path = widget.args?.path;
    if (path != null) {
      final (res, _) = await context.showLoadingDialog(
        fn: () => File(path).writeAsString(_controller.text),
      );
      if (res == null) {
        context.showSnackBar(libL10n.fail);
        return;
      }
      final ret = EditorPageRet(EditorPageRetType.path, path);
      widget.args?.onSave(context, ret);
      _saved = true;

      final pop_ = widget.args?.closeAfterSave ?? _kCloseAfterSave;
      if (pop_) _pop();
      return;
    }

    // it's a text editor
    final ret = EditorPageRet(EditorPageRetType.text, _controller.text);
    widget.args?.onSave(context, ret);
    _saved = true;

    final pop_ = widget.args?.closeAfterSave ?? _kCloseAfterSave;
    if (pop_) _pop();
  }

  void _pop() async {
    if (!_saved) {
      final ret = await context.showRoundDialog(
        title: libL10n.attention,
        child: Text(libL10n.askContinue(libL10n.exit)),
        actions: Btnx.cancelOk,
      );
      if (ret != true) return;
    }
    contextSafe?.pop();
  }
}
