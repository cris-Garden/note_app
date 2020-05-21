import 'package:flutter/material.dart';
import 'package:flutter_app/page/home_page.dart';
import 'package:flutter_app/util/file_util.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FileUtil().appDocsDir = await getApplicationDocumentsDirectory();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}


