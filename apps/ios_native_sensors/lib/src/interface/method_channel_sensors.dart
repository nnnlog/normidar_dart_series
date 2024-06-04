// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:ios_native_sensors/src/interface/sensor_vector.dart';
import 'package:logging/logging.dart';

import 'sensors_plus_platform_interface.dart';

/// A method channel -based implementation of the SensorsPlatform interface.
class MethodChannelSensors extends SensorsPlatform {
  static const MethodChannel _methodChannel =
      MethodChannel('dev.fluttercommunity.plus/sensors/method');

  static const EventChannel _accelerometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/accelerometer');

  static const EventChannel _userAccelerometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/motion');

  static const EventChannel _gyroscopeEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/gyroscope');

  static const EventChannel _magnetometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/magnetometer');

  final logger = Logger('MethodChannelSensors');
  Stream<GravityEvent>? _accelerometerEvents;
  Stream<RotationRateEvent>? _gyroscopeEvents;
  Stream<MotionEvent>? _userAccelerometerEvents;
  Stream<MagnetometerEvent>? _magnetometerEvents;

  /// Returns a broadcast stream of events from the device accelerometer at the
  /// given sampling frequency.
  @override
  Stream<GravityEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setAccelerationSamplingPeriod', microseconds);
    _accelerometerEvents ??= _accelerometerEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
      final list = event.cast<double>();
      return GravityEvent(vector: SensorVector(list[0]!, list[1]!, list[2]!));
    });
    return _accelerometerEvents!;
  }

  /// Returns a broadcast stream of events from the device gyroscope at the
  /// given sampling frequency.
  @override
  Stream<RotationRateEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setGyroscopeSamplingPeriod', microseconds);
    _gyroscopeEvents ??=
        _gyroscopeEventChannel.receiveBroadcastStream().map((dynamic event) {
      final list = event.cast<double>();
      return RotationRateEvent(
          vector: SensorVector(list[0]!, list[1]!, list[2]!));
    });
    return _gyroscopeEvents!;
  }

  /// Returns a broadcast stream of events from the device magnetometer at the
  /// given sampling frequency.
  @override
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setMagnetometerSamplingPeriod', microseconds);
    _magnetometerEvents ??=
        _magnetometerEventChannel.receiveBroadcastStream().map((dynamic event) {
      final data = event.cast<double>();
      return MagnetometerEvent(
        vector: SensorVector(data[0]!, data[1]!, data[2]!),
      );
    });
    return _magnetometerEvents!;
  }

  /// Returns a broadcast stream of events from the device accelerometer with
  /// gravity removed at the given sampling frequency.
  @override
  Stream<MotionEvent> motionEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod(
        'setUserAccelerometerSamplingPeriod', microseconds);
    _userAccelerometerEvents ??= _userAccelerometerEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
      final data = event as Map<dynamic, dynamic>;
      data.cast<String, dynamic>();
      return MotionEvent(
        timestamp: data['timestamp']!,
        rotationRate: RotationRateEvent(
          vector: SensorVector(data['rotationRate']['x']!,
              data['rotationRate']['y']!, data['rotationRate']['z']!),
        ),
        attitude: AttitudeEvent(
          pitch: data['attitude']['pitch']!,
          roll: data['attitude']['roll']!,
          yaw: data['attitude']['yaw']!,
        ),
        magnetic: MagneticEvent(
          vector: SensorVector(data['magnetic']['x']!, data['magnetic']['y']!,
              data['magnetic']['z']!),
          accuracy: data['magnetic']['accuracy']!,
        ),
        userAcceleration: UserAccelerationEvent(
          vector: SensorVector(data['userAcceleration']['x']!,
              data['userAcceleration']['y']!, data['userAcceleration']['z']!),
        ),
        gravity: GravityEvent(
          vector: SensorVector(data['gravity']['x']!, data['gravity']['y']!,
              data['gravity']['z']!),
        ),
      );
    });
    return _userAccelerometerEvents!;
  }
}
