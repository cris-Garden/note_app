import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasePage extends StatelessWidget {
  BasePage({this.body, this.appBar, this.floatingActionButton});

  final Widget body;
  final PreferredSizeWidget appBar;
  final Widget floatingActionButton;
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    bool isDarkMode = themeData.brightness == Brightness.dark;
    SystemUiOverlayStyle darkMode = SystemUiOverlayStyle.dark;
    SystemUiOverlayStyle lightMode = SystemUiOverlayStyle.light;
//    return AnnotatedRegion<SystemUiOverlayStyle>(
//      //修改状态栏的颜色,苹果顶部状态栏是透明的，如果设置safearea需要把顶部部分去掉
//      value: !isDarkMode ? darkMode : lightMode,
//      child:
      return Scaffold(
          appBar: appBar,
          body: body,
          floatingActionButton: floatingActionButton,
        );
  }
}
