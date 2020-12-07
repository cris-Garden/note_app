import 'dart:io';
import 'dart:ui';

import 'package:package_info/package_info.dart';

class AppUtil {
  static final AppUtil _util = AppUtil._internal();

  AppUtil._internal();

  factory AppUtil(){
    return _util;
  }

  // version information
  String appName;
  String packageName;
  String version;
  String buildNumber;

  void init() async{
    if(!AppUtil.isReleaseContext()){
      print("系统：${AppUtil.isiOS()?'iOS':'Android'}");
      print("系统版本：${AppUtil.getSystemVersion()}");
      print("环境：${AppUtil.isReleaseContext()?'生产环境':'开发环境'}");
    }

    // get version information
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
  }
  static bool isiOS(){
    return Platform.isIOS;
  }

  static final windowWidth = window.physicalSize.width;
  static final windowHeight = window.physicalSize.height;

  static String getSystemVersion(){
    return Platform.operatingSystemVersion;
  }

  static bool isReleaseContext(){
    return bool.fromEnvironment("dart.vm.product");
  }

}