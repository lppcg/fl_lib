import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

final class SimpleMarkdown extends StatelessWidget {
  final String data;
  final MarkdownStyleSheet? styleSheet;
  final void Function()? onOpenFail;
  final bool selectable;

  const SimpleMarkdown({
    super.key,
    required this.data,
    this.styleSheet,
    this.onOpenFail,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      onTapLink: (text, href, title) async {
        if (href != null && href.isNotEmpty) {
          final suc = await href.launchUrl();
          if (suc) return;
        }
        onOpenFail?.call();
      },
      selectable: selectable,
      styleSheet: styleSheet?.copyWith(a: TextStyle(color: UIs.colorSeed)) ??
          MarkdownStyleSheet(a: TextStyle(color: UIs.colorSeed)),
    );
  }
}
