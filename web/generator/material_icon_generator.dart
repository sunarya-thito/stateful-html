import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const url =
    'https://raw.githubusercontent.com/Templarian/MaterialDesign/master/meta.json';
const outputFile = 'web/src/material/icons.dart';

class IconGlyph {
  final String name;
  final bool deprecated;
  final String author;

  IconGlyph.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        deprecated = json['deprecated'] ?? false,
        author = json['author'];
}

String dartSafeName(String name) {
  // - to _
  // starts with number to _number

  name = name.replaceAll('-', '_');
  // check if name starts with number
  if (RegExp(r'^[0-9]').hasMatch(name)) {
    name = '_' + name;
  }
  return name;
}

void main() async {
  var response = await http.get(Uri.parse(url));
  List<dynamic> json = jsonDecode(response.body);
  List<IconGlyph> glyphs = json.map((e) => IconGlyph.fromJson(e)).toList();
  glyphs = glyphs.where((element) => !element.deprecated).toList();
  // only by Google or Contributors
  glyphs = glyphs
      .where((element) =>
          element.author == 'Google' || element.author == 'Contributors')
      .toList();
  List<String> names = glyphs.map((e) => e.name).toList();
  File file = File(outputFile);
  String builder = 'import \'icon.dart\';\nclass Icons {\n  const Icons._();';
  // trim names to 100
  // names = names.sublist(0, 100);
  for (String n in names) {
    builder +=
        '\n  static const IconData ${dartSafeName(n)} = NamedIconData(\'${dartSafeName(n)}\');';
  }
  builder += '\n}';
  file.writeAsString(builder);
}
