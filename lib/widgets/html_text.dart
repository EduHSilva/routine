import 'package:flutter/cupertino.dart';

class HtmlText extends StatelessWidget {
  final String html;

  const HtmlText({super.key, required this.html});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: _parseHtmlToTextSpans(html),
        style: DefaultTextStyle.of(context).style,
      ),
    );
  }

  List<TextSpan> _parseHtmlToTextSpans(String html) {
    List<TextSpan> spans = [];

    List<String> paragraphs = html.split(RegExp(r'</?p>'));

    for (var i = 0; i < paragraphs.length; i++) {
      String paragraph = paragraphs[i].trim();
      if (paragraph.isEmpty) continue;

      if (paragraph.contains('<b>')) {
        spans.add(TextSpan(
          text: paragraph.replaceAll('<b>', '').replaceAll('</b>', ''),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (paragraph.contains('<i>')) {
        spans.add(TextSpan(
          text: paragraph.replaceAll('<i>', '').replaceAll('</i>', ''),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ));
      } else {
        spans.add(TextSpan(text: paragraph));
      }

      if (i != paragraphs.length - 1) {
        spans.add(const TextSpan(text: '\n\n'));
      }
    }

    return spans;
  }
}

