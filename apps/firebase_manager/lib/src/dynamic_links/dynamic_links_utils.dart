import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DynamicLinksUtils {
  static Future<String> createDynamicLink() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("http://normidar.com/"),
      uriPrefix: "https://appexm.page.link/email_create",
      androidParameters:
          AndroidParameters(packageName: packageInfo.packageName),
      iosParameters: IOSParameters(bundleId: packageInfo.packageName),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    return dynamicLink.toString();
  }
}
