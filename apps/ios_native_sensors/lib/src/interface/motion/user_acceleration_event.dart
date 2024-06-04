// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:ios_native_sensors/src/interface/sensor_vector.dart';

/// Like [AccelerometerEvent], this is a discrete reading from an accelerometer
/// and measures the velocity of the device. However, unlike
/// [AccelerometerEvent], this event does not include the effects of gravity.
class UserAccelerationEvent {
  /// measured in m/s^2.
  ///
  /// When the device is held upright facing the user, positive values mean the
  /// device is moving to the right and negative mean it is moving to the left.
  final SensorVector vector;

  /// Constructs an instance with the given [x], [y], and [z] values.
  UserAccelerationEvent({required this.vector});

  Map<String, dynamic> toJson() {
    return {
      'x': vector.x,
      'y': vector.y,
      'z': vector.z,
    };
  }

  @override
  String toString() => '[UserAccelerometerEvent ($vector)]';
}
