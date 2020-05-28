import 'package:flutter/material.dart';
import 'package:my_note/page/diary_detail_page.dart';
import 'package:my_note/provider/home_page_provider.dart';
import 'package:my_note/widget/title_cell.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
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
                    builder: (_, didChange, child) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final kes = provider.diaryTimeMap.keys.toList();
                      final title = kes[index];
                      final diarys = provider.diaryTimeMap[title];
                      return Column(
                        children: List.generate(
                          diarys.length,
                          (index_d) {
                            return TitleCell(
                              diarys[index_d],
                              showTopLine: false,
                              showBottomLine: false,
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return DiaryDetailPage(diarys[index_d]);
                                }));
                              },
                            );
                          },
                        )..insert(
                            0,
                             Container(
                               margin: EdgeInsets.only(top: 16,left: 16),
                               width: double.infinity,
                                child: Text(title),
                              ),
                          ),
                      );
                    },
                    itemCount: provider.diaryTimeMap.keys.length,
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
