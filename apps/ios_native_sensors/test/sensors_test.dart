// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart'
    show TestDefaultBinaryMessengerBinding, TestWidgetsFlutterBinding;
import 'package:ios_native_sensors/ios_native_sensors.dart';
import 'package:test/test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('accelerometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/accelerometer';
    const sensorData = <double>[1.0, 2.0, 3.0];
    _initializeFakeMethodChannel('setAccelerationSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await accelerometerEventStream().first;

    expect(event.vector.x, sensorData[0]);
    expect(event.vector.y, sensorData[1]);
    expect(event.vector.z, sensorData[2]);
  });

  test('gyroscopeEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/gyroscope';
    const sensorData = <double>[3.0, 4.0, 5.0];
    _initializeFakeMethodChannel('setGyroscopeSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await gyroscopeEventStream().first;

    expect(event.vector.x, sensorData[0]);
    expect(event.vector.y, sensorData[1]);
    expect(event.vector.z, sensorData[2]);
  });

  test('motionEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/motion';
    //     let motionData = [
    //     "rotationRate": [
    //         "x": data!.rotationRate.x,
    //         "y": data!.rotationRate.y,
    //         "z": data!.rotationRate.z,
    //     ],
    //     "attitude": [
    //         "roll": data!.attitude.roll,
    //         "pitch": data!.attitude.pitch,
    //         "yaw": data!.attitude.yaw,
    //     ],
    //     "gravity": [
    //         "x": data!.gravity.x,
    //         "y": data!.gravity.y,
    //         "z": data!.gravity.z,
    //     ],
    //     "magnetic": [
    //         "x": data!.magneticField.field.x,
    //         "y": data!.magneticField.field.y,
    //         "z": data!.magneticField.field.z,
    //         "accuracy": data!.magneticField.accuracy.rawValue,
    //     ],
    //     "userAcceleration": [
    //         "x": data!.userAcceleration.x,
    //         "y": data!.userAcceleration.y,
    //         "z": data!.userAcceleration.z,
    //     ],
    // ]
    const Map<String, dynamic> sensorData = {
      "timestamp": 1.0,
      "rotationRate": {
        "x": 3.0,
        "y": 4.0,
        "z": 5.0,
      },
      "attitude": {
        "roll": 6.0,
        "pitch": 7.0,
        "yaw": 8.0,
      },
      "gravity": {
        "x": 9.0,
        "y": 10.0,
        "z": 11.0,
      },
      "magnetic": {
        "x": 12.0,
        "y": 13.0,
        "z": 14.0,
        "accuracy": 15,
      },
      "userAcceleration": {
        "x": 16.0,
        "y": 17.0,
        "z": 18.0,
      },
    };
    _initializeFakeMethodChannel('setUserAccelerometerSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await motionEventStream().first;

    // timestamp
    expect(event.timestamp, sensorData["timestamp"]);
    // rotationRate
    expect(event.rotationRate.vector.x, sensorData["rotationRate"]!["x"]);
    // attitude
    expect(event.attitude.roll, sensorData["attitude"]!["roll"]);
    // gravity
    expect(event.gravity.vector.x, sensorData["gravity"]!["x"]);
    // magnetic
    expect(event.magnetic.vector.x, sensorData["magnetic"]!["x"]);
    expect(event.magnetic.accuracy, sensorData["magnetic"]!["accuracy"]);
    // userAcceleration
    expect(
        event.userAcceleration.vector.x, sensorData["userAcceleration"]!["x"]);
  });

  test('magnetometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/magnetometer';
    const sensorData = <double>[8.0, 9.0, 10.0];
    _initializeFakeMethodChannel('setMagnetometerSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await magnetometerEventStream().first;

    expect(event.vector.x, sensorData[0]);
    expect(event.vector.y, sensorData[1]);
    expect(event.vector.z, sensorData[2]);
  });
}

void _initializeFakeMethodChannel(String methodName) {
  const standardMethod = StandardMethodCodec();

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('dev.fluttercommunity.plus/sensors/method',
          (ByteData? message) async {
    final methodCall = standardMethod.decodeMethodCall(message);
    if (methodCall.method == methodName) {
      return standardMethod.encodeSuccessEnvelope(null);
    } else {
      fail('Expected $methodName');
    }
  });
}

void _initializeFakeSensorChannel(String channelName, Object? sensorData) {
  const standardMethod = StandardMethodCodec();

  void emitEvent(ByteData? event) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(
      channelName,
      event,
      (ByteData? reply) {},
    );
  }

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler(channelName, (ByteData? message) async {
    final methodCall = standardMethod.decodeMethodCall(message);
    if (methodCall.method == 'listen') {
      emitEvent(standardMethod.encodeSuccessEnvelope(sensorData));
      emitEvent(null);
      return standardMethod.encodeSuccessEnvelope(null);
    } else if (methodCall.method == 'cancel') {
      return standardMethod.encodeSuccessEnvelope(null);
    } else {
      fail('Expected listen or cancel');
    }
  });
}
