import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:my_note/page/diary_detail_page.dart';
import 'package:my_note/provider/home_page_provider.dart';
import 'package:my_note/util/tool_util.dart';
import 'package:my_note/widget/title_cell.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  //截取长屏
  GlobalKey rootWidgetKey = GlobalKey();

  Future<void> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          rootWidgetKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String dataImagePath = await ImagePickers.saveByteDataImageToGallery(
        pngBytes,
      );
    } catch (e) {
      print(e);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<HomePageProvider, HomePageProvider>(
      shouldRebuild: (pre, next) {
        return pre.changeFlag;
      },
      builder: (context, provider, _) {
        return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                title: Text(
                  '日記',
                  style: Theme.of(context).textTheme.headline1,
                ),
                actions: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(left: 5, top: 15, bottom: 15, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        //截取长屏
                        _capturePng();
                      },
                      child: Icon(Icons.file_download),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return DiaryDetailPage(provider.newDiary());
                  })).then((value) {
                    provider.didChange();
                  });
                },
                child: Icon(Icons.add),
              ),
              body: Container(
                child: Selector<HomePageProvider, bool>(
                    builder: (context, didChange, child) {
                  final keys = provider.diaryTimeMap.keys.toList()
                    ..sort((a, b) {
                      return timeCompare(a, b) ? 0 : 1;
                    });
                  final widgets = <Widget>[];
                  for (final key in keys) {
                    final diarys = provider.diaryTimeMap[key];
                    widgets.add(
                      Container(
                        margin: EdgeInsets.only(top: 16, left: 16),
                        width: double.infinity,
                        child: Text(
                          key,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    );
                    widgets.addAll(List.generate(
                      diarys.length,
                      (index) {
                        return TitleCell(
                          diarys[index],
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return DiaryDetailPage(diarys[index]);
                            }));
                          },
                        );
                      },
                    ));
                  }

                  return SingleChildScrollView(
                    child: RepaintBoundary(
                        key: rootWidgetKey,
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Column(children: widgets),
                        )),
                  );
                }, selector: (context, provider) {
                  return provider.changeFlag;
                }),
              )),
        );
      },
      selector: (context, provider) => provider,
    );
  }
}
