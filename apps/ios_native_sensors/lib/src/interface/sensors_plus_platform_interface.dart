// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ios_native_sensors/src/interface/motion/motion_event.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gravity_event.dart';
import 'magnetometer_event.dart';
import 'method_channel_sensors.dart';
import 'rotation_rate_event.dart';
import 'sensor_interval.dart';

export 'gravity_event.dart';
export 'magnetometer_event.dart';
export 'motion/attitude_event.dart';
export 'motion/magnetic_event.dart';
export 'motion/motion_event.dart';
export 'motion/user_acceleration_event.dart';
export 'rotation_rate_event.dart';
export 'sensor_interval.dart';

/// The common platform interface for sensors.
abstract class SensorsPlatform extends PlatformInterface {
  static final Object _token = Object();

  static SensorsPlatform _instance = MethodChannelSensors();

  /// The default instance of [SensorsPlatform] to use.
  ///
  /// Defaults to [MethodChannelSensors].
  static SensorsPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [SensorsPlatform] when they register themselves.
  static set instance(SensorsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Constructs a SensorsPlatform.
  SensorsPlatform() : super(token: _token);

  /// A broadcast stream of events from the device accelerometer.
  @nonVirtual
  @Deprecated('Use accelerometerEventStream() instead.')
  Stream<GravityEvent> get accelerometerEvents {
    return accelerometerEventStream();
  }

  /// A broadcast stream of events from the device gyroscope.
  @nonVirtual
  @Deprecated('Use gyroscopeEventStream() instead.')
  Stream<RotationRateEvent> get gyroscopeEvents {
    return gyroscopeEventStream();
  }

  /// A broadcast stream of events from the device magnetometer.
  @nonVirtual
  @Deprecated('Use magnetometerEventStream() instead.')
  Stream<MagnetometerEvent> get magnetometerEvents {
    return magnetometerEventStream();
  }

  /// Events from the device accelerometer with gravity removed.
  @nonVirtual
  @Deprecated('Use userAccelerometerEventStream() instead.')
  Stream<MotionEvent> get motionEvents {
    return motionEventStream();
  }

  /// Returns a broadcast stream of events from the device accelerometer at the
  /// given sampling frequency.
  Stream<GravityEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError(
        'listenToAccelerometerEvents has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device gyroscope at the
  /// given sampling frequency.
  Stream<RotationRateEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('gyroscopeEvents has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device magnetometer at the
  /// given sampling frequency.
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('magnetometerEvents has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device accelerometer with
  /// gravity removed at the given sampling frequency.
  Stream<MotionEvent> motionEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError(
        'userAccelerometerEvents has not been implemented.');
  }
}
