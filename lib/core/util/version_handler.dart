import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

abstract class VersionHandler {
  static String getVersionKey(PackageInfo info) {
    print(info.buildNumber);
    String versionKey = Platform.isAndroid ? info.buildNumber : info.version.replaceAll(".", "") + "${info.buildNumber}";
    return versionKey;
  }

  static String getVersionBuild(PackageInfo info) {
    String buildNumber = (!Platform.isAndroid) ? info.buildNumber : info.buildNumber.replaceFirst(info.version.replaceAll(".", ""), "");


    return buildNumber;
  }
}
