import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_note/page/diary_detail_page.dart';
import 'package:my_note/page/setting_page.dart';
import 'package:my_note/provider/home_page_provider.dart';
import 'package:my_note/util/alert_util.dart';
import 'package:my_note/util/tool_util.dart';
import 'package:my_note/widget/title_cell.dart';
import 'package:provider/provider.dart';
import 'package:my_note/util/file_util.dart';

import 'base/base_page.dart';

class HomePage extends StatelessWidget {
  //截取长屏
  GlobalKey rootWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Selector<HomePageProvider, HomePageProvider>(
      shouldRebuild: (pre, next) {
        return pre.changeFlag;
      },
      builder: (context, provider, _) {
        return SafeArea(
          top: false,
          child: BasePage(
              appBar: AppBar(
                title: Text(
                  '日記',
                  style: Theme.of(context).textTheme.headline1,
                ),
                centerTitle: true,
                actions: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(left: 5, top: 15, bottom: 15, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        showTextAlert('是否将日记列表截长屏到相册？', context, okClick: () {
                          Navigator.of(context).pop();
                          showLoading(context);
                          FileUtil().capturePng(rootWidgetKey).then((value) {
                            hideLoading(context);
                          });
                        }, cancelClick: () {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Icon(
                        Icons.file_download,
                        size: 25,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 5, top: 15, bottom: 15, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return SettingPage();
                        }));
                      },
                      child: Icon(
                        Icons.settings,
                        size: 25,
                      ),
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
                color: Theme.of(context).scaffoldBackgroundColor,
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
                          onDelete: () {
                            final diary = diarys[index];
                            provider.diarys.remove(diary);
                            diary.delete();
                            provider.didChange();
                          },
                        );
                      },
                    ));
                  }

                  return SingleChildScrollView(
                    child: RepaintBoundary(
                        key: rootWidgetKey,
                        child:widgets.length == 0?Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: double.infinity,
                          height: 500,
                        ):Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
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
