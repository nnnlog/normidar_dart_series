// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:ios_native_sensors/src/interface/sensor_vector.dart';

class AttitudeEvent {
  final double pitch;
  final double roll;
  final double yaw;

  AttitudeEvent({
    required this.pitch,
    required this.roll,
    required this.yaw,
  });

  /// SensorVector(pitch, yaw, roll)
  SensorVector get vector => SensorVector(pitch, yaw, roll);

  Map<String, dynamic> toJson() {
    return {
      'pitch': pitch,
      'roll': roll,
      'yaw': yaw,
    };
  }

  @override
  String toString() => '[UserAccelerometerEvent ($vector)]';
}
