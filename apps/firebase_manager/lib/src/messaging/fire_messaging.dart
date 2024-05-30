import 'package:firebase_messaging/firebase_messaging.dart';

export 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart'
    show
        NotificationSettings,
        AppleNotificationSetting,
        AuthorizationStatus,
        AppleShowPreviewSetting,
        RemoteMessage;

class FireMessaging {
  FireMessaging shared = FireMessaging._();
  FireMessaging._();

  /// Returns a Stream that is called when an incoming FCM payload is received whilst
  /// the Flutter instance is in the foreground.
  ///
  /// The Stream contains the [RemoteMessage].
  ///
  /// To handle messages whilst the app is in the background or terminated,
  /// see [onBackgroundMessage].
  Stream<RemoteMessage> onMessage() {
    return FirebaseMessaging.onMessage;
  }

  /// Returns a [Stream] that is called when a user presses a notification message displayed
  /// via FCM.
  ///
  /// A Stream event will be sent if the app has opened from a background state
  /// (not terminated).
  ///
  /// If your app is opened via a notification whilst the app is terminated,
  /// see [getInitialMessage].
  Stream<RemoteMessage> onMessageOpenedApp() {
    return FirebaseMessaging.onMessageOpenedApp;
  }

  /// Prompts the user for notification permissions.
  ///
  ///  - On iOS, a dialog is shown requesting the users permission.
  ///  - On macOS, a notification will appear asking to grant permission.
  ///  - On Android, a [NotificationSettings] class will be returned with the
  ///    value of [NotificationSettings.authorizationStatus] indicating whether
  ///    the app has notifications enabled or blocked in the system settings.
  ///  - On Web, a popup requesting the users permission is shown using the native browser API.
  ///
  /// Note that on iOS, if [provisional] is set to `true`, silent notification permissions will be
  /// automatically granted. When notifications are delivered to the device, the
  /// user will be presented with an option to disable notifications, keep receiving
  /// them silently or enable prominent notifications.
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool sound = true,
  }) {
    return FirebaseMessaging.instance.requestPermission(
      alert: alert,
      announcement: announcement,
      badge: badge,
      carPlay: carPlay,
      criticalAlert: criticalAlert,
      provisional: provisional,
      sound: sound,
    );
  }
}
