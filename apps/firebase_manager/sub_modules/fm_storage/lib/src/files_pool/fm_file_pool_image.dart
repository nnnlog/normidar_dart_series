// import 'package:flutter/material.dart';

// import 'pool_file.dart';


// TODO: remake pool feature
// class FmFilePoolImage extends StatelessWidget {
//   final String md5;

//   final double scale;
//   final ImageFrameBuilder? frameBuilder;
//   final ImageErrorWidgetBuilder? errorBuilder;
//   final String? semanticLabel;
//   final bool excludeFromSemantics;
//   final double? width;
//   final double? height;
//   final Color? color;
//   final Animation<double>? opacity;
//   final BlendMode? colorBlendMode;
//   final BoxFit? fit;
//   final AlignmentGeometry alignment;
//   final ImageRepeat repeat;
//   final Rect? centerSlice;
//   final bool matchTextDirection;
//   final bool gaplessPlayback;
//   final bool isAntiAlias;
//   final FilterQuality filterQuality;
//   final int? cacheWidth;
//   final int? cacheHeight;
//   const FmFilePoolImage(
//     this.md5, {
//     super.key,
//     this.scale = 1.0,
//     this.frameBuilder,
//     this.errorBuilder,
//     this.semanticLabel,
//     this.excludeFromSemantics = false,
//     this.width,
//     this.height,
//     this.color,
//     this.opacity,
//     this.colorBlendMode,
//     this.fit,
//     this.alignment = Alignment.center,
//     this.repeat = ImageRepeat.noRepeat,
//     this.centerSlice,
//     this.matchTextDirection = false,
//     this.gaplessPlayback = false,
//     this.isAntiAlias = false,
//     this.filterQuality = FilterQuality.low,
//     this.cacheWidth,
//     this.cacheHeight,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<PoolFile?>(
//         future: fs.db.storage.getPoolFile(md5),
//         builder: (_, snapshot) {
//           final data = snapshot.data;
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return SizedBox(
//                 width: width,
//                 height: height,
//                 child: const Center(
//                   child: CircularProgressIndicator(),
//                 ));
//           }
//           if (snapshot.connectionState == ConnectionState.done) {
//             if (data == null) {
//               return SizedBox(
//                 width: width,
//                 height: height,
//                 child: const Text('image un exists'),
//               );
//             } else {
//               return Image.file(data.file,
//                   scale: scale,
//                   frameBuilder: frameBuilder,
//                   errorBuilder: errorBuilder,
//                   semanticLabel: semanticLabel,
//                   excludeFromSemantics: excludeFromSemantics,
//                   width: width,
//                   height: height,
//                   color: color,
//                   opacity: opacity,
//                   colorBlendMode: colorBlendMode,
//                   fit: fit,
//                   alignment: alignment,
//                   repeat: repeat,
//                   centerSlice: centerSlice,
//                   matchTextDirection: matchTextDirection,
//                   gaplessPlayback: gaplessPlayback,
//                   isAntiAlias: isAntiAlias,
//                   filterQuality: filterQuality,
//                   cacheWidth: cacheWidth,
//                   cacheHeight: cacheHeight);
//             }
//           }
//           throw 'FmFilePoolImage un handle state: ${snapshot.connectionState.name}, has error: ${snapshot.error}, data: $data';
//         });
//   }
// }
