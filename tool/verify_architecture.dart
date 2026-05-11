// Usage: dart run tool/verify_architecture.dart
import 'dart:io';

void main() {
  final violations = <String>[];
  final presentation = Directory('lib/presentation');
  if (presentation.existsSync()) {
    for (final entity in presentation.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final text = entity.readAsStringSync();
      if (text.contains("package:malomati/data/")) {
        violations.add('${entity.path}: must not import package:malomati/data/...');
      }
    }
  }
  final data = Directory('lib/data');
  if (data.existsSync()) {
    for (final entity in data.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final text = entity.readAsStringSync();
      if (text.contains('package:malomati/presentation/')) {
        violations.add('${entity.path}: must not import presentation layer');
      }
    }
  }
  if (violations.isNotEmpty) {
    stderr.writeln('Architecture violations:\n${violations.join('\n')}');
    exit(1);
  }
  stdout.writeln('Architecture import checks passed.');
}
