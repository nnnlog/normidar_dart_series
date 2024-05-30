import 'dart:isolate';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:image_gen/image_gen.dart';
import 'package:source_gen/source_gen.dart';

class ImageBuildGenerator extends GeneratorForAnnotation<ImageGen> {
  @override
  Future generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final code = (await buildStep.resolver.astNodeFor(element));

    final boostCode = '''
import 'package:image_gen/image_gen.dart';
import 'package:image/image.dart';


void main(_, Map<String, dynamic> data) {
  final image = ${element.displayName}().generate();
  data['port']?.send(image.toJson());
}
''';

    final runCode = boostCode + code.toString();

    final uri = Uri.dataFromString(runCode, mimeType: 'application/dart');
    ReceivePort? recievePort = ReceivePort();
    recievePort.listen((data) async {
      final imgData = data as Map<String, dynamic>;

      GenImage.fromJson(imgData).saveAsPng(
          'assets/image_gen/${buildStep.inputId.changeExtension('.png').path.split('/').last}');

      // final image = Image.fromBytes(
      //   width: imgData['width'],
      //   height: imgData['height'],
      //   bytes: Uint8List.fromList(imgData['buffer']).buffer,
      // );
      // final file = File(
      //     'assets/image_gen/${buildStep.inputId.changeExtension('.png').path.split('/').last}');
      // await file.create(recursive: true);
      // await file.writeAsBytes(encodePng(image));

      try {
        recievePort?.close();
      } catch (e) {
        recievePort = null;
      }
    });
    await Isolate.spawnUri(uri, [], {
      // 'canvas': canvas,
      'port': recievePort?.sendPort,
    });
  }
}
