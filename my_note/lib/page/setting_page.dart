import 'package:flutter/material.dart';
import 'package:my_note/model/diary.dart';
import 'package:my_note/page/base/base_page.dart';
import 'package:my_note/util/guide_util.dart';
import 'diary_detail_page.dart';
import 'dart:io';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> titles;
    List<Diary> diarys;
    if(Platform.isIOS){
      titles = [
        '使用说明',
        '如何备份日志',
      ];
      diarys = [GuideUtil().useDiary, GuideUtil().backUpDiary];
    }else{
      titles = [
        '使用说明',
      ];
      diarys = [GuideUtil().useDiary];
    }

    return BasePage(
      appBar: AppBar(
        title: Text(
          '设置',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return DiaryDetailPage(
                  diarys[index],
                  showBarButton: false,
                );
              }));
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: Text(
                titles[index],
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          );
        },
        itemCount: diarys.length,
      ),
    );
  }
}
