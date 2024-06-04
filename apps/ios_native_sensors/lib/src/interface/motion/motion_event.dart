import 'package:ios_native_sensors/ios_native_sensors.dart';

class MotionEvent {
  final double timestamp;
  final RotationRateEvent rotationRate;
  final AttitudeEvent attitude;
  final MagneticEvent magnetic;
  final UserAccelerationEvent userAcceleration;
  final GravityEvent gravity;

  MotionEvent({
    required this.timestamp,
    required this.rotationRate,
    required this.attitude,
    required this.magnetic,
    required this.userAcceleration,
    required this.gravity,
  });

  Map<String, dynamic> toJson() {
    return {
      'rotationRate': rotationRate.toJson(),
      'attitude': attitude.toJson(),
      'magnetic': magnetic.toJson(),
      'userAcceleration': userAcceleration.toJson(),
      'gravity': gravity.toJson(),
    };
  }
}
