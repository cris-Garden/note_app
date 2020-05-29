import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_note/model/diary.dart';
import 'package:my_note/model/section.dart';
import 'package:my_note/provider/diary_provider.dart';
import 'package:my_note/provider/home_page_provider.dart';
import 'package:my_note/widget/full_screen_view.dart';
import 'package:provider/provider.dart';

class DiaryDetailPage extends StatelessWidget with RouteAware {
  DiaryDetailPage(this.diary);

  final Diary diary;

  //截取长屏
//  GlobalKey rootWidgetKey = GlobalKey();
//
//  Future<Uint8List> _capturePng() async {
//    try {
//      RenderRepaintBoundary boundary =
//      rootWidgetKey.currentContext.findRenderObject();
//      var image = await boundary.toImage(pixelRatio: 3.0);
//      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
//      Uint8List pngBytes = byteData.buffer.asUint8List();
//      return pngBytes;//这个对象就是图片数据
//    } catch (e) {
//      print(e);
//    }
//    return null;
//  }

//  RepaintBoundary(
//  key: rootWidgetKey,
//  child:
//  ),

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

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
                  onEditingComplete: () {

                    homePageProvider.didChange();
                  },
                ),
                actions: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5,top: 15,bottom: 15,right: 5),
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
                ],
              ),
              body: Column(
                children: <Widget>[
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
                                  Icons.text_fields,
                                  size: 40.0,
                                ),
                                onTap: () {
                                  provider.addText();
                                },
                              ),
                              GestureDetector(
                                child: Icon(
                                  Icons.image,
                                  size: 40.0,
                                ),
                                onTap: () {
                                  getImage().then((image) {
                                    provider.addImage(image, didSave: () {
                                      homePageProvider.didChange();
                                    });
                                  });
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
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        title: Text("提示"),
                                        content: Text("是否删除选中的图片或文本？"),
                                        actions: <Widget>[
                                          // ボタン領域
                                          FlatButton(
                                            child: Text("Cancel"),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          FlatButton(
                                            child: Text("OK"),
                                            onPressed: () {
                                              provider.delete();
                                              homePageProvider.didChange();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Selector<DiaryProvider, int>(
                    selector: (_, provider) => provider.diary.sections.length,
                    builder: (context, count, child) {
                      return Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, item) {
                            if (provider.diary.sections[item]
                                .type == SectionType.image) {
                              return provider.isEditing
                                  ? GestureDetector(
                                      child:ConstrainedBox(
//                                        constraints: const BoxConstraints.expand(),
                                        constraints: BoxConstraints(maxHeight:240),
                                        // constraints: BoxConstraints(minWidth: 100),
//                                         constraints: BoxConstraints.lerp(BoxConstraints(minHeight: 0), BoxConstraints(minHeight: 150), 0.5),
                                        // constraints: BoxConstraints.loose(Size(30,120)),
                                        // constraints: BoxConstraints.tight(Size(30,120)),
                                        // constraints: BoxConstraints.lerp(a, b, t),
                                        // constraints: BoxConstraints.expand(width: 150,height: 150),
                                        // constraints: BoxConstraints.tightForFinite(),
                                        child: Container(
                                        decoration: item == provider.index
                                            ? BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.blue,
                                                    width: 1.5), // 边色与边宽度
                                              )
                                            : null,
                                        padding: EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 8,
                                            bottom: 8),
                                        width: double.infinity,
                                        child: Image.file(
                                          File(provider.imagePath(provider.diary.sections[item].imagePath)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),),
                                      onTap: () {
                                        if (!provider.isEditing) {
                                          return;
                                        }
                                        provider.setIndex(item);
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                      },
                                    )
                                  : FullScreenView(
                                      tag: 'image$item',
                                      child: ConstrainedBox(
//                                        constraints: const BoxConstraints.expand(),
                                         constraints: BoxConstraints(maxHeight:240),
                                        // constraints: BoxConstraints(minWidth: 100),
//                                         constraints: BoxConstraints.lerp(BoxConstraints(minHeight: 0), BoxConstraints(minHeight: 150), 0.5),
                                        // constraints: BoxConstraints.loose(Size(30,120)),
                                        // constraints: BoxConstraints.tight(Size(30,120)),
                                        // constraints: BoxConstraints.lerp(a, b, t),
                                        // constraints: BoxConstraints.expand(width: 150,height: 150),
                                        // constraints: BoxConstraints.tightForFinite(),
                                        child:  Container(
                                          decoration: item == provider.index
                                              ? BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blue,
                                                width: 1.5), // 边色与边宽度
                                          )
                                              : null,
                                          padding: EdgeInsets.only(
                                              left: 16,
                                              right: 16,
                                              top: 8,
                                              bottom: 8),
                                          width: double.infinity,
                                          child: Image.file(
                                            File(provider.imagePath(provider.diary.sections[item].imagePath)),
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),

                                      ),

                                      fullChild: Image.file(
                                        File(provider.imagePath(provider.diary.sections[item].imagePath)),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                            }
                            if (provider.diary.sections[item].type == SectionType.firstTitle){
                              return Container();
                            }
                            return Container(
                              decoration: item == provider.index
                                  ? BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blue,
                                          width: 1.5), // 边色与边宽度
                                    )
                                  : null,
                              padding: EdgeInsets.only(
                                  left: 16, top: 8, right: 16, bottom: 8),
                              child: TextField(
                                style: Theme.of(context).textTheme.bodyText1,
                                autofocus: item == provider.index,
                                enabled: provider.isEditing,
                                controller: TextEditingController(
                                    text: provider.diary.sections[item].text),
                                decoration: provider.isEditing
                                    ? InputDecoration(hintText: "输入你想要记录的内容...")
                                    : null,
                                maxLines: null,
                                onChanged: (value) {
                                  provider.saveText(value, item);

                                },
                                onSubmitted: (value) {
                                  provider.setIndex(1000);
                                  homePageProvider.doChange();
                                },
                                onTap: () {
                                  print(item);
                                  provider.setIndex(item);
                                },
                              ),
                            );
                          },
                          itemCount: count,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
        selector: (_, provider) => provider,
      ),
    );
  }
}
