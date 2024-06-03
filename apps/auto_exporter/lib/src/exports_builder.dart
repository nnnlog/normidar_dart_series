import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:build/build.dart';
import 'package:glob/glob.dart';

/// the ExportsBuilder will create the file to
/// export all dart files
class ExportsBuilder implements Builder {
  BuilderOptions options;

  ExportsBuilder({required this.options});

  @override
  Map<String, List<String>> get buildExtensions {
    return {
      r'$lib$': ['$packageName.dart']
    };
  }

  bool get isDefaultExportAll => options.config['default_export_all'] ?? true;

  String get packageName => options.config['project_name'] ?? 'exports';

  @override
  Future<void> build(BuildStep buildStep) async {
    final exports = buildStep.findAssets(Glob('lib/**/*.dart'));

    final expList = <String>[];
    final content = [
      "// run this to reset your file:  dart run build_runner build",
      "// or use flutter:               flutter packages pub run build_runner build",
      "// remenber to format this file, you can use: dart format",
      "// publish your package hint: dart pub publish --dry-run",
      "// if you want to update your packages on power: dart pub upgrade --major-versions",
    ];
    await for (var exportLibrary in exports) {
      // each file

      final con = await buildStep.readAsString(exportLibrary);
      // to check has `part of`
      // check the runtime type to develop auto_exporter.
      final ast = parseString(content: con).unit.childEntities;

      final exportUri = exportLibrary.uri.path;
      if (exportUri.toString() != 'package:$packageName/$packageName.dart') {
        // not the file for exports

        if (ast.whereType<PartOfDirective>().isEmpty) {
          // no `part of`

          final expString = getExpString(ast, exportUri);
          if (expString != null) {
            expList.add(expString);
          }
        }
      }
    }
    expList.add('');

    content.addAll(expList);
    if (content.isNotEmpty) {
      await buildStep.writeAsString(
          AssetId(buildStep.inputId.package, 'lib/$packageName.dart'),
          content.join('\n'));
    }
  }

  /// get export string:
  /// If default export all:
  ///   only ignore the `@IgnoreExport()`
  /// If default not export all:
  ///   only export the `@AutoExport()`
  String? getExpString(Iterable<SyntacticEntity> ast, String exportUri) {
    var ignoreCount = 0;
    var exportCount = 0;

    List<String> ignoreList = [];
    List<String> exportList = [];
    List<String> normalList = [];

    // class
    ast.whereType<NamedCompilationUnitMember>().forEach((e) {
      final meta = e.metadata.map((e) => e.toString());
      if (meta.contains('@IgnoreExport()')) {
        ignoreCount++;
        ignoreList.add(e.name.toString());
      } else if (meta.contains('@AutoExport()')) {
        exportCount++;
        exportList.add(e.name.toString());
      } else {
        normalList.add(e.name.toString());
      }
    });

    // variable
    ast.whereType<TopLevelVariableDeclaration>().forEach((e) {
      final meta = e.metadata.map((e) => e.toString());
      if (meta.contains('@IgnoreExport()')) {
        ignoreCount++;
        ignoreList.add(e.variables.variables.first.name.toString());
      } else if (meta.contains('@AutoExport()')) {
        exportCount++;
        exportList.add(e.variables.variables.first.name.toString());
      } else {
        normalList.add(e.variables.variables.first.name.toString());
      }
    });

    if (isDefaultExportAll) {
      if (ignoreCount == 0) {
        return "export 'package:$exportUri';";
      }

      // only take not ignore class
      final toExpLst = [...normalList, ...exportList].join(', ');
      return "export 'package:$exportUri' show $toExpLst;";
    } else {
      // default unexport all
      if (exportCount == 0) {
        return null;
      }

      // only take export classes
      final toExpLst = exportList.join(',');
      return "export 'package:$exportUri' show $toExpLst;";
    }
  }
}
