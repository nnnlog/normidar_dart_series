import 'package:ios_native_sensors/src/interface/sensors_plus_platform_interface.dart';

import 'src/sensors.dart';

export 'src/interface/sensor_vector.dart';
export 'src/interface/sensors_plus_platform_interface.dart';

final _sensors = Sensors();

/// A broadcast stream of events from the device accelerometer.
@Deprecated('Use accelerometerEventStream() instead.')
Stream<GravityEvent> get accelerometerEvents {
  return _sensors.accelerometerEvents;
}

/// A broadcast stream of events from the device gyroscope.
@Deprecated('Use gyroscopeEventStream() instead.')
Stream<RotationRateEvent> get gyroscopeEvents {
  return _sensors.gyroscopeEvents;
}

/// A broadcast stream of events from the device magnetometer.
@Deprecated('Use magnetometerEventStream() instead.')
Stream<MagnetometerEvent> get magnetometerEvents {
  return _sensors.magnetometerEvents;
}

/// Events from the device accelerometer with gravity removed.
@Deprecated('Use userAccelerometerEventStream() instead.')
Stream<MotionEvent> get motionEvents {
  return _sensors.motionEvents;
}

/// Returns a broadcast stream of events from the device accelerometer at the
/// given sampling frequency.
@override
Stream<GravityEvent> accelerometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.accelerometerEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a broadcast stream of events from the device gyroscope at the
/// given sampling frequency.
@override
Stream<RotationRateEvent> gyroscopeEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.gyroscopeEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a broadcast stream of events from the device magnetometer at the
/// given sampling frequency.
@override
Stream<MagnetometerEvent> magnetometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.magnetometerEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a broadcast stream of events from the device accelerometer with
/// gravity removed at the given sampling frequency.
@override
Stream<MotionEvent> motionEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.motionEventStream(samplingPeriod: samplingPeriod);
}
