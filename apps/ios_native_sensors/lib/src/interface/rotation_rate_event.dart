// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:ios_native_sensors/src/interface/sensor_vector.dart';

/// Discrete reading from a gyroscope. Gyroscopes measure the rate or rotation of
/// the device in 3D space.
class RotationRateEvent {
  final SensorVector vector;

  /// Constructs an instance with the given [x], [y], and [z] values.
  RotationRateEvent({required this.vector});

  Map<String, dynamic> toJson() {
    return {
      'x': vector.x,
      'y': vector.y,
      'z': vector.z,
    };
  }

  @override
  String toString() => '[GyroscopeEvent ($vector)]';
}
