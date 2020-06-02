
import 'package:flutter/material.dart';
import 'package:my_note/model/diary.dart';
import 'package:my_note/util/guide_util.dart';
import 'diary_detail_page.dart';

class SettingPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    List<String> titles = ['如何备份日志','使用说明',];
    List<Diary> diarys = [GuideUtil().useDiary,GuideUtil().backUpDiary];
    return Scaffold(
      appBar: AppBar(title: Text('设置'),),
      body: ListView.builder(itemBuilder: (context,index){
        return GestureDetector(
          onTap: (){
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) {
              return DiaryDetailPage(diarys[index],showBarButton: false,);
            }));

          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Text(titles[index]),
          ),
        );
      },itemCount: 2,),
    );
  }

}