import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

void main() {
  debugPaintSizeEnabled = false;
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: ImageRotate(),
        ),
      ),
    );
  }
}

class ImageRotate extends StatefulWidget {
  @override
  _ImageRotateState createState() => _ImageRotateState();
}

class _ImageRotateState extends State<ImageRotate> {
  double _x = 0;
  double _angle = (math.pi / 180) * 0;
  double _y = 0;
  double handleSize = 30;
  double _height = 200;
  double _width = 300;
  double _oldAngle = 0.0;
  double _angleDelta = 0.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: _y,
          left: _x,
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                _x += details.delta.dx;
                _y += details.delta.dy;
              });
            },
            child: Transform.rotate(
              angle: _angle,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: handleSize,
                      height: handleSize,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(handleSize),
                        border: Border.all(
                          width: 5,
                          color: Colors.white,
                        ),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          //   Offset centerOfGestureDetector = Offset(
                          // constraints.maxWidth / 2, constraints.maxHeight / 2);
                          /**
                           * using center of positioned element instead to better fit the
                           * mental map of the user rotating object.
                           * (height = container height (30) + container height (30) + container height (200)) / 2
                           */
                          Offset centerOfGestureDetector =
                              Offset(constraints.maxWidth / 2, _x + handleSize);
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onPanStart: (details) {
                              final touchPositionFromCenter =
                                  details.localPosition - centerOfGestureDetector;
                              _angleDelta =
                                  _oldAngle - touchPositionFromCenter.direction;
                            },
                            onPanEnd: (details) {
                              setState(
                                () {
                                  _oldAngle = _angle;
                                },
                              );
                            },
                            onPanUpdate: (details) {
                              final touchPositionFromCenter =
                                  details.localPosition - centerOfGestureDetector;

                              setState(
                                () {
                                  _angle = touchPositionFromCenter.direction +
                                      _angleDelta;
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: handleSize,
                    width: 5,
                    color: Colors.white,
                  ),
                  Image.network(
                    "https://via.placeholder.com/300x200",
                    height: _height,
                    width: _width,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          // top: _y - 7.5 + 2 * handleSize - 2 * ((180 / math.pi) * _angle),
          // left: _x - 7.5 + 2 * ((180 / math.pi) * _angle),

          top: _y - 7.5 + 2 * handleSize,
          left: _x - 7.5,
          child: Container(
            height: 2 * 7.5,
            width: 2 * 7.5,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(7.5),
              border: Border.all(
                width: 3,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],

      // top left
    );
  }
}
