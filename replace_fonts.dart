import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    var content = file.readAsStringSync();
    if (content.contains('.poppins(')) {
      content = content.replaceAll('.poppins(', '.inter(');
      file.writeAsStringSync(content);
      print('Updated \${file.path}');
    }
  }
}
