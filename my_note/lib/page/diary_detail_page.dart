import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:my_note/model/diary.dart';
import 'package:my_note/model/section.dart';
import 'package:my_note/provider/diary_provider.dart';
import 'package:my_note/provider/home_page_provider.dart';
import 'package:my_note/util/alert_util.dart';
import 'package:my_note/util/file_util.dart';
import 'package:my_note/widget/diary_detail.dart';
import 'package:provider/provider.dart';

class DiaryDetailPage extends StatelessWidget with RouteAware {

  DiaryDetailPage(this.diary,{this.showBarButton = true});

  final Diary diary;

  final bool showBarButton;

  //截取长屏
  GlobalKey rootWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => DiaryProvider(diary),
      child: Selector<DiaryProvider, DiaryProvider>(
        shouldRebuild: (pre, next) {
          return next.didChange;
        },
        builder: (context, provider, _) {
          return GestureDetector(
            onTap: () {
              diary.save();
              homePageProvider.doChange();
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: TextField(
                  enabled: showBarButton,
                  style: Theme.of(context).textTheme.headline1,
                  controller: TextEditingController(
                    text: provider.diary.title,
                  ),
                  decoration: null,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  onChanged: (value) {
                    diary.setTitle(value);
                    diary.save();
                  },
                  onSubmitted: (value) {
                    homePageProvider.didChange();
                    print('aa');
                  },
                ),
                actions:showBarButton? <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(left: 5, top: 15, bottom: 15, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        showTextAlert('是否将日志内容截长屏到相册？', context,okClick: (){
                          Navigator.of(context).pop();
                          //截取长屏
                          showLoading(context);
                          FileUtil().capturePng(rootWidgetKey).then((value){
                            hideLoading(context);
                          });
                        },cancelClick: (){
                          Navigator.of(context).pop();
                        });
                      },
                      child: Icon(Icons.file_download),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 5, top: 15, bottom: 15, right: 5),
                    child: GestureDetector(
                        onTap: () {
                          if (provider.isEditing == true) {
                            provider.index = 1000;
                          }
                          provider.changeEditing();
                          homePageProvider.didChange();
                        },
                        child: Text(
                          provider.isEditing ? '浏览' : '编辑',
                          style: Theme.of(context).textTheme.button,
                        )),
                  ),
                ]:<Widget>[
                ],
              ),
              body: Container(
                child: Column(children: <Widget>[
                  provider.isEditing
                      ? Container(
                          width: double.infinity,
                          color: Colors.grey,
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                child: Icon(
                                  Icons.add,
                                  size: 40.0,
                                ),
                                onTap: () {
                                  showSheet(context, ['文本', '图片','图片靠上卡片','图片靠下卡片'], onClick: (index) {
                                    print(index);
                                    if(index == 1){
                                      FileUtil().getImage().then((image) {
                                        provider.addImage(image, didSave: () {
                                          homePageProvider.didChange();
                                        });
                                      });
                                      return;
                                    }
                                    final addSection = Section(type: SectionType.values[index+2]);
                                    provider.addSection(addSection);
                                  });
//                                  provider.addText();
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.arrow_upward,
                                  size: 40.0,
                                ),
                                onTap: () {
                                  provider.up();
                                  homePageProvider.didChange();
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.arrow_downward,
                                  size: 40.0,
                                ),
                                onTap: () {
                                  provider.down();
                                  homePageProvider.didChange();
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.delete,
                                  size: 40.0,
                                ),
                                onTap: () {
                                  showTextAlert('是否删除选中的图片或文本？', context,
                                      okClick: () {
                                    provider.delete();
                                    homePageProvider.didChange();
                                    Navigator.pop(context);
                                  }, cancelClick: () {
                                    Navigator.pop(context);
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: RepaintBoundary(
                        key: rootWidgetKey,
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: DiaryDetailWidget(),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
        selector: (_, provider) => provider,
      ),
    );
  }
}
