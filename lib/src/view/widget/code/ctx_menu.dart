import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';

class _ContextMenuItemWidget extends PopupMenuItem<void> implements PreferredSizeWidget {
  _ContextMenuItemWidget({
    required String text,
    required VoidCallback super.onTap,
  }) : super(child: Text(text));

  @override
  Size get preferredSize => const Size(150, 25);
}

class CodeContextMenuController implements SelectionToolbarController {
  const CodeContextMenuController();

  @override
  void hide(BuildContext context) {}

  @override
  void show({
    required BuildContext context,
    required CodeLineEditingController controller,
    required TextSelectionToolbarAnchors anchors,
    Rect? renderRect,
    required LayerLink layerLink,
    required ValueNotifier<bool> visibility,
  }) {
    showMenu(
        context: context,
        position: RelativeRect.fromSize(anchors.primaryAnchor & const Size(150, double.infinity), MediaQuery.of(context).size),
        items: [
          _ContextMenuItemWidget(
            text: libL10n.cut,
            onTap: () {
              controller.cut();
            },
          ),
          _ContextMenuItemWidget(
            text: libL10n.copy,
            onTap: () {
              controller.copy();
            },
          ),
          _ContextMenuItemWidget(
            text: libL10n.paste,
            onTap: () {
              controller.paste();
            },
          ),
        ]);
  }
}
