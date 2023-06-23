import 'dart:math';
import 'dart:ui';

// Function to calculate the dot product of two vectors
double dotProduct(Offset v1, Offset v2) {
  return v1.dx * v2.dx + v1.dy * v2.dy;
}

// Function to calculate the magnitude of a vector
double magnitude(Offset v) {
  return sqrt(pow(v.dx, 2) + pow(v.dy, 2));
}

// Function to calculate the angle between two vectors
double calculateAngle(Offset v1, Offset v2) {
  double dotProductValue = dotProduct(v1, v2);
  double magnitudeProduct = magnitude(v1) * magnitude(v2);

  double angle = acos(dotProductValue / magnitudeProduct);
  return angle * (180 / pi); // convert the angle from radians to degrees
}

double calculateAngle2(Offset P1,Offset P2,Offset P3) {


  // Define the vectors from P1 to P2 and from P1 to P3
  Offset a = Offset(P1.dx - P2.dx, P1.dy - P2.dy);
  Offset b = Offset(P1.dx - P3.dx, P1.dy - P3.dy);

  // Calculate the angle between vectors a and b
  double angle = calculateAngle(a, b);

  print("The angle at vertex P1 in degrees is: $angle");
  return angle;
}
