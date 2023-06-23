import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  double _height = 100;
  double _width = 150;
  double _square = 200;

  double _oldAngle = 0.0;
  double _angleDelta = 0.0;
  Offset initialOffset = Offset(0, 0);

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
            child: Stack(
              children: [
                Container(
                  height: _square,
                  width: _square,
                  color: Colors.green,
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: _square / 2 - _height / 2,
                      left: _square / 2 - _width / 2),
                  child: Transform.rotate(
                    angle: _angle,
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.red,
                          height: _height,
                          width: _width,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: _height - 30,
                          ),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green,
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
                              Offset centerOfSquare =
                                  Offset(_x + _square / 2, _y + _square / 2);

                              Offset centerOfCenterDetection = Offset(
                                  _x + _square / 2 + _height, _y + _square / 2);

                              return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onPanStart: (details) {
                                  // final touchPositionFromCenter =
                                  //     details.localPosition -
                                  //         centerOfGestureDetector;
                                  //
                                  // _angleDelta = _oldAngle -
                                  //     touchPositionFromCenter.direction;
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
                                      details.localPosition - centerOfSquare;

                                  setState(
                                    () {
                                      // _angle =
                                      //     touchPositionFromCenter.direction +
                                      //         _angleDelta;
                                      //
                                      //
                                      //
                                      // var x1 = details.globalPosition.dx;
                                      // var y1 = details.globalPosition.dy;
                                      //
                                      // var x2 = centerOfSquare.dx;
                                      // var y2 = centerOfSquare.dy;
                                      //
                                      //  _angle = math.atan2(y2 - y1, x2 - x1);
                                      //
                                      //  if (_angle < 0) {
                                      //    _angle += math.pi;
                                      //  }
                                      //  _angle = _angle * (180 / math.pi);

                                      var p1 = centerOfSquare;
                                      var p2 = centerOfCenterDetection;
                                      var p3 = details.globalPosition;

                                      // _angle = math.acos(
                                      //     (math.pow(getSegment(p1, p2), 2) +
                                      //         math.pow(getSegment(p1, p3), 2) -
                                      //         math.pow(getSegment(p2, p3), 2) /
                                      //             (2 *
                                      //                 getSegment(p1, p3) *
                                      //                 getSegment(p1, p2))));

                                      // // _angle = calculateAngleWithOffset(p1,p2,p3,_angle);
                                      // _angle =  calculateAngle(p1,p2,p3);

                                      _angle = calculateAngle2(p3, p1, p2);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          // top: _y - 7.5 + 2 * handleSize - 2 * ((180 / math.pi) * _angle),
          // left: _x - 7.5 + 2 * ((180 / math.pi) * _angle),

          top: _y - 7.5,
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
        Positioned(
          top: _y + _square / 2 - 7.5,
          left: _x + _square / 2 - 7.5,
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

// Function to calculate distance between two points
  double calculateDistance(Offset p1, Offset p2) {
    double distance = sqrt(pow(p2.dx - p1.dx, 2) + pow(p2.dy - p1.dy, 2));
    return distance;
  }

// Function to calculate the angle at vertex P1
  double calculateAngle(double P12, double P13, double P23) {
    double angle =
        acos((pow(P12, 2) + pow(P13, 2) - pow(P23, 2)) / (2 * P12 * P13));
    return angle * (180 / pi); // convert the angle from radians to degrees
  }

  double getSegment(Offset p1, Offset p2) {
    return math.sqrt(math.pow(p2.dx - p1.dx, 2) + math.pow(p2.dy - p1.dy, 2));
  }

  double calculateAngleWithOffset(
      Offset p1, Offset p2, Offset p3, double offset) {
    double angle1 = math.atan2(p1.dy - p2.dy, p1.dx - p2.dx);
    double angle2 = math.atan2(p3.dy - p2.dy, p3.dx - p2.dx);

    double angle = (angle1 - angle2) * 180 / math.pi;
    angle += offset;

    while (angle < 0) {
      angle += 360;
    }
    while (angle > 360) {
      angle -= 360;
    }

    return angle;
  }

  double calculateAngle2(Offset a, Offset b, Offset c) {
    // Create vectors
    var ab = Point(b.dx - a.dx, b.dy - a.dy);
    var ac = Point(c.dx - a.dx, c.dy - a.dy);

    // Calculate the dot product
    var dotProduct = ab.x * ac.x + ab.y * ac.y;

    // Calculate the magnitudes of the vectors
    var magAB = sqrt(pow(ab.x, 2) + pow(ab.y, 2));
    var magAC = sqrt(pow(ac.x, 2) + pow(ac.y, 2));

    // Use the dot product formula to find the cosine of the angle
    var cosine = dotProduct / (magAB * magAC);

    // Use the arccos function to find the angle in radians
    var angle = acos(cosine);

    // // Convert the angle to degrees
    // var angleInDegrees = angle * 180 / pi;

    return angle;
  }
}
