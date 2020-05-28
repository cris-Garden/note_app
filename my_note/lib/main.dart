import 'package:flutter/material.dart';
import 'package:my_note/page/home_page.dart';
import 'package:my_note/provider/home_page_provider.dart';
import 'package:my_note/util/file_util.dart';
import 'package:my_note/util/guide_util.dart';
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
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ).copyWith(
            textTheme: TextTheme(
              headline1: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.black
              ),
              headline2: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: Colors.black
              ),
              bodyText1: TextStyle(
                height: 1.4,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black
              ),
              button: TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          darkTheme:ThemeData.dark().copyWith(
            textTheme: TextTheme(
              headline1: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
              headline2: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
              bodyText1: TextStyle(
                height: 1.4,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              button: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          home: HomePage(),
        );
      },
    );
  }
}
