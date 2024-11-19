import 'dart:ui';

String getPlaceholder(String text, { Color? color, int? width = 80, int? height = 80 }) {
  String url = 'https://placeholderjs.com/${width}x$height&text=${text.replaceAll(' ', '+')}';
  if (color != null) {
    final r = color.red.toRadixString(16);
    final g = color.green.toRadixString(16);
    final b = color.blue.toRadixString(16);
    url += '&color=_$r$g$b';
  }
  return url;
}
