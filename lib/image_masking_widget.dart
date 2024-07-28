import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:image_masking_flutter/image_masking_painter.dart';
import 'package:image_masking_flutter/single_gesture.dart';

class ImageMaskingWidget extends StatefulWidget {
  final String unColoredImage;
  final String coloredImage;
  final double? height;
  final double? width;
  final EdgeInsets? margin;
  final BoxDecoration? decoration;
  final VoidCallback? onReset;

  const ImageMaskingWidget(
      {super.key, required this.unColoredImage, required this.coloredImage, this.onReset, this.height, this.width, this.margin,this.decoration});

  @override
  State<ImageMaskingWidget> createState() => ImageMaskingWidgetState();
}

class ImageMaskingWidgetState extends State<ImageMaskingWidget> {

  ui.Image? unColoredImage;
  ui.Image? coloredImage;
  final List<List<Offset>> _paths = [];
  var currentPoint = Offset.zero;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    initImages();
    super.initState();
  }

  //load both images
  void initImages() {
    loadImage(widget.unColoredImage).then((image) {
      setState(() {
        unColoredImage = image;
      });
      loadImage(widget.coloredImage).then((image) {
        setState(() {
          coloredImage = image;
        });
      });
    });
  }

  //convert asset path into ui image
  Future<ui.Image> loadImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mainImageView(context),
    );
  }

  //clear the imageview
  void resetView() {
    setState(() {
      _paths.clear();
    });
    widget.onReset?.call();
  }

  //render the main imageview and also managed single finger gesture
  RawGestureDetector mainImageView(BuildContext context) {
    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: <Type, GestureRecognizerFactory>{
        SingleGestureRecognizer:
        GestureRecognizerFactoryWithHandlers<SingleGestureRecognizer>(
                () => SingleGestureRecognizer(debugOwner: this),
                (instance) {
              instance.onStart = (pointerEvent) {
                _startNewPath(pointerEvent.localPosition);
              };
              instance.onUpdate = (pointerEvent) {
                _addPointToPath(pointerEvent.localPosition);
              };
              instance.onEnd = (pointerEvent) {
                if (_paths.isNotEmpty && _paths.last.isNotEmpty) {
                  // Duplicate the last point in the current path
                  _paths.last.add(_paths.last.last);
                }
              };
            }),
      },
      child: Container(
        height:widget.height ?? MediaQuery.of(context).size.height/2,
        width: widget.width ?? MediaQuery.of(context).size.width,
        margin: widget.margin ?? EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/4,horizontal: 15),
        decoration: widget.decoration ?? BoxDecoration(
      border: Border.all(color: Colors.black, width: 2)),
        child: RepaintBoundary(
          key: _globalKey,
          child: CustomPaint(
            size: Size(
              MediaQuery
                  .of(context)
                  .size
                  .width,
              MediaQuery
                  .of(context)
                  .size
                  .height,
            ),
            painter: unColoredImage != null && coloredImage != null
                ? ImageMaskingPainter(
                paths: _paths,
                coloredImage: coloredImage!,
                unColoredImage: unColoredImage!)
                : null,
          ),
        ),
      ),
    );
  }

  void _startNewPath(Offset startPoint) {
    setState(() {
      currentPoint = startPoint;
      _paths.add([]);
    });
  }

  void _addPointToPath(Offset point) {
    setState(() {
      RenderBox? renderBox =
      _globalKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        // Convert touch point from global coordinate to local coordinate of CustomPaint
        Offset localPoint = renderBox.globalToLocal(point);
        if (_paths.isNotEmpty) {
          _paths.last.add(localPoint);
          currentPoint = localPoint;
        }
      }
    });
  }

}
