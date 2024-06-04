import 'package:ios_native_sensors/src/interface/sensor_vector.dart';

/// A sensor sample from a magnetometer.
///
/// Magnetometers measure the ambient magnetic field surrounding the sensor,
/// returning values in microteslas ***μT*** for each three-dimensional axis.
///
/// Consider that these samples may bear effects of Earth's magnetic field as
/// well as local factors such as the metal of the device itself or nearby
/// magnets, though most devices compensate for these factors.
///
/// A compass is an example of a general utility for magnetometer data.
class MagnetometerEvent {
  /// The ambient magnetic field in this axis surrounding the sensor in
  /// microteslas ***μT***.
  final SensorVector vector;

  /// Constructs a new instance with the given [x], [y], and [z] values.
  ///
  /// See [MagnetometerEvent] for more information.
  MagnetometerEvent({required this.vector});

  Map toJson() {
    return {
      'x': vector.x,
      'y': vector.y,
      'z': vector.z,
    };
  }

  @override
  String toString() => '[MagnetometerEvent ($vector)]';
}
