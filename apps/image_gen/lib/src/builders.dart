import 'package:build/build.dart';
import 'package:image_gen/src/image_build_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder codeIconBuilder(BuilderOptions options) {
  return LibraryBuilder(ImageBuildGenerator());
}
