import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_note/page/home_page.dart';
import 'package:my_note/provider/home_page_provider.dart';
import 'package:my_note/util/admod_util.dart';
import 'package:my_note/util/app_util.dart';
import 'package:my_note/util/file_util.dart';
import 'package:my_note/util/guide_util.dart';
import 'package:my_note/util/location_util.dart';
import 'package:my_note/util/theme_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'local/Strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  FileUtil().appDocsDir = await getApplicationDocumentsDirectory();

  GuideUtil().useDiary = await GuideUtil().getUserDiary();
  GuideUtil().backUpDiary = await GuideUtil().getBackUpUseDiary();

  //初始化广告
  AppUtil().init();
  AdmodUtil().init();

  //生产环境不显示红色错误界面
  if (bool.fromEnvironment("dart.vm.product")) {
    ErrorWidget.builder = (errorDetails) {
      print(errorDetails.toString());
      return Container();
    };
  }


  //只支持竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MyApp(),
    );
    FileUtil().delete();
  });


//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
}

class _MyLocalizationsDelegate extends LocalizationsDelegate<Strings> {
  const _MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    String code = locale.languageCode;
    String scriptCode = locale.scriptCode;

    if (code.contains('zh')) {
      if (scriptCode != null) {
        if (scriptCode.contains('Hant')) {
          code = 'zh_Hant';
        }

        if (scriptCode.contains('Hans')) {
          code = 'zh_Hans';
        }
      } else {
        code = 'zh_Hans';
      }
    }

    return ['en', 'ja', 'ko', 'zh_Hant', 'zh_Hans'].contains(code);
  }

  @override
  Future<Strings> load(Locale locale) => Strings.load(locale);

  @override
  bool shouldReload(_MyLocalizationsDelegate old) => false;
}

class MyApp extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();
  @override
  Widget build(BuildContext context) {
    final lightTheme = getNormalTheme();
    return ChangeNotifierProvider<HomePageProvider>(
      create: (_) => HomePageProvider(),
      builder: (context, _) {
        return Material(
            child: MaterialApp(
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                print('deviceLocale: $deviceLocale');
                LocationUtil().deviceLocal = deviceLocale;
                return deviceLocale;
              },
              localizationsDelegates: [
                const _MyLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                ChineseCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', ''),
                const Locale('ja', ''),
                const Locale('zh', 'Hans'), // China
                const Locale('zh', ''), //China
              ],
              theme: lightTheme,
              darkTheme: getBlackTheme(),
              home: HomePage(),
            ),
          );
      },
    );
  }
}
