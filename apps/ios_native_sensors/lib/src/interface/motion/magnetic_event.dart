// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:ios_native_sensors/src/interface/sensor_vector.dart';

class MagneticEvent {
  final SensorVector vector;
  final int accuracy;

  MagneticEvent({
    required this.vector,
    required this.accuracy,
  });

  Map<String, dynamic> toJson() {
    return {
      'x': vector.x,
      'y': vector.y,
      'z': vector.z,
      'accuracy': accuracy,
    };
  }

  @override
  String toString() => '[UserAccelerometerEvent ($vector)]';
}
