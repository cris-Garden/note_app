import 'dart:io';
import 'package:flutter/material.dart';

import '../full_screen_view.dart';

class CardView extends StatelessWidget {
  CardView({
    this.type = CardViewType.TopImage,
    this.isEditing = false,
    this.enable = false,
    this.imagePath,
    this.text = '',
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.imageClick,
    this.item = 0,
  });

  final int item;

  final CardViewType type;

  final bool isEditing;

  final bool enable;

  final String imagePath;

  final String text;

  final VoidCallback imageClick;

  final VoidCallback onTap;

  final ValueChanged<String> onChanged;

  final ValueChanged<String> onSubmitted;

  bool hasImage() {
    return !(imagePath == null || imagePath.length == 0);
  }

  @override
  Widget build(BuildContext context) {
    final imageV = enable
        ? GestureDetector(
            onTap:hasImage() ?null:this.imageClick,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200, minHeight: 200),
              child: Container(
                width: double.infinity,
                child: hasImage()
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        child: Image.file(
                          File(imagePath ?? ''),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
          )
        : FullScreenView(
            tag: 'image$item',
            child: ConstrainedBox(
              constraints:  BoxConstraints(maxHeight: 200, minHeight: 200),
              child:Container(
                width: double.infinity,
                child: hasImage()
                    ? ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                  child: Image.file(
                    File(imagePath ?? ''),
                    fit: BoxFit.cover,
                  ),
                )
                    : Container(
                  child: Icon(
                    Icons.add_photo_alternate,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            fullChild: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          );

    final text = Container(
      alignment: AlignmentDirectional.topStart,
      padding: EdgeInsets.all(16),
      child: TextField(
        style: Theme.of(context).textTheme.bodyText1,
        autofocus: isEditing,
        enabled: enable,
        controller: TextEditingController(text: this.text ?? ''),
        decoration:
            enable ? InputDecoration(hintText: "输入你想要记录的内容...") : null,
        maxLines: null,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        onTap: onTap,
      ),
    );

    return Column(
      children: <Widget>[
        Card(
          elevation: 8,
          child: getView(text, imageV),
        ),
      ],
    );
  }

  Widget getView(Widget text, Widget image) {
    switch (this.type) {
      case CardViewType.LeftImage:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Card(
                child: image,
              ),
            ),
            Expanded(
              flex: 2,
              child: text,
            ),
          ],
        );
      case CardViewType.RightImage:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: text,
            ),
            Expanded(
              flex: 1,
              child: Card(
                child: image,
              ),
            ),
          ],
        );
      case CardViewType.TopImage:
        return Column(
          children: <Widget>[
            image,
            Divider(
              height: 2,
            ),
            text,
          ],
        );
      case CardViewType.BottomImage:
        return Column(
          children: <Widget>[
            text,
            Divider(
              height: 2,
            ),
            image,
          ],
        );
    }
    return Container();
  }
}

enum CardViewType {
  LeftImage,
  RightImage,
  TopImage,
  BottomImage,
}