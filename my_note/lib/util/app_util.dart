import 'dart:io';
import 'dart:ui';

class AppUtil {
  static final AppUtil _util = AppUtil._internal();

  AppUtil._internal();

  factory AppUtil(){
    return _util;
  }

  void init(){
    if(!AppUtil.isReleaseContext()){
      print("系统：${AppUtil.isiOS()?'iOS':'Android'}");
      print("系统版本：${AppUtil.getSystemVersion()}");
      print("环境：${AppUtil.isReleaseContext()?'生产环境':'开发环境'}");
    }
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