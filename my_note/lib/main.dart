import 'package:flutter/material.dart';
import 'package:my_note/page/home_page.dart';
import 'package:my_note/provider/home_page_provider.dart';
import 'package:my_note/util/file_util.dart';
import 'package:my_note/util/guide_util.dart';
import 'package:my_note/util/theme_util.dart';
import 'package:my_note/util/tool_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  FileUtil().appDocsDir = await getApplicationDocumentsDirectory();

  await GuideUtil().init();

  runApp(
    MyApp(),
  );

}

class MyApp extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomePageProvider>(
      create: (_) => HomePageProvider(),
      builder: (context, _) {
        return MaterialApp(
          theme: getBlackTheme(),
          darkTheme:getBlackTheme(),
          home: HomePage(),
        );
      },
    );
  }
}
