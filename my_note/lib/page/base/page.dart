import 'package:flutter/material.dart';

//  RouteObserver能够联动使用采用继承StatefulWidget。
final RouteObserver<PageRoute> routeObserver = new RouteObserver<PageRoute>();

/// 所有页面的底部视图
class Page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageState();
  }
  
}

class PageState<T extends Page> extends State<T> with RouteAware {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // 上の画面がpopされて、この画面に戻ったときに呼ばれます
  void didPopNext() {
    debugPrint("didPopNext ${runtimeType}");
  }

  // この画面がpushされたときに呼ばれます
  void didPush() {
    debugPrint("didPush ${runtimeType}");
  }

  // この画面がpopされたときに呼ばれます
  void didPop() {
    debugPrint("didPop ${runtimeType}");
  }

  // この画面から新しい画面をpushしたときに呼ばれます
  void didPushNext() {
    debugPrint("didPushNext ${runtimeType}");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
