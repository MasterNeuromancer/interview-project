import 'package:flutter/material.dart';

Color getTempColor(double temp) {
  if (temp < 32) return Colors.blue.shade300;
  if (temp < 60) return Colors.green.shade300;
  if (temp < 85) return Colors.orange.shade300;
  return Colors.red.shade300;
}
