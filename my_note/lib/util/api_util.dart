

import 'dart:convert';
import 'dart:io';

import 'app_util.dart';

class ApiUtil {
  static final ApiUtil _util = ApiUtil._internal();

  ApiUtil._internal();

  factory ApiUtil() {
    return _util;
  }

  static String developBaseUrl = "https://cris-garden.github.io/jekyll_demo/";
  static String releaseBaseUrl = "http://47.101.160.248/jekyll_demo/";
  static String baseUrl = AppUtil.isReleaseContext()==true?releaseBaseUrl:developBaseUrl;

  static String versionPath = "appdata/myNoteUpdate.json";

  //获取新闻接口
  static Future<Map> getDataFromPath(String path) async {
    print('baseUrl:$baseUrl');
    var url = '$baseUrl$path';
    print(url);
    var httpClient = HttpClient();
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        return data;
      } else {
        result =
        '$url 获取失败:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = '$url json解析失败';
    }
    print(result);
   return null;
  }

  //获取最新版本接口
  static Future<Map> getVersion() async {
    print('baseUrl:$baseUrl');
    var url = '$baseUrl$versionPath';
    print(url);
    var httpClient = HttpClient();
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        return data;
      } else {
        result =
        '$url 获取失败:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = '$url json解析失败';
    }
    print(result);
    return null;
  }

}