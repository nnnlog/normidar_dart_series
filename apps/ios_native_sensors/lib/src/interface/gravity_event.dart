// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:ios_native_sensors/src/interface/sensor_vector.dart';

/// Discrete reading from an accelerometer. Accelerometers measure the velocity
/// of the device. Note that these readings include the effects of gravity. Put
/// simply, you can use accelerometer readings to tell if the device is moving in
/// a particular direction.
class GravityEvent {
  final SensorVector vector;

  /// Constructs an instance with the given [x], [y], and [z] values.
  const GravityEvent({required this.vector});

  Map<String, dynamic> toJson() {
    return {
      'x': vector.x,
      'y': vector.y,
      'z': vector.z,
    };
  }

  @override
  String toString() => '[AccelerometerEvent ($vector)]';
}
