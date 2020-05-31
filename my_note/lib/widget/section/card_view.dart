import 'dart:io';
import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  CardView(
      {this.type = CardViewType.TopImage,
        this.isEditing = false,
        this.imagePath,
        this.text = '',
        this.onTap,
        this.onChanged,
        this.onSubmitted});

  final CardViewType type;

  final bool isEditing;

  final String imagePath;

  final String text;

  final VoidCallback onTap;

  final ValueChanged<String> onChanged;

  final ValueChanged<String> onSubmitted;

  bool hasImage() {
    return !(imagePath == null || imagePath.length == 0);
  }

  @override
  Widget build(BuildContext context) {
    final imageV = GestureDetector(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 240, minHeight: 160),
        child: Container(
          width: double.infinity,
          child: hasImage()
              ? Image.file(
            File(imagePath),
            fit: BoxFit.cover,
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
    );

    final text = Container(
      alignment: AlignmentDirectional.topStart,
      padding: EdgeInsets.all(16),
      child: TextField(
        style: Theme.of(context).textTheme.bodyText1,
        autofocus: isEditing,
        enabled: isEditing,
        controller: TextEditingController(text: this.text),
        decoration:
        isEditing ? InputDecoration(hintText: "输入你想要记录的内容...") : null,
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
              child: Card(child: image,),
            ),
            Expanded(
              flex: 2,
              child: text,
            ),
          ],
        );
      case CardViewType.RightImage:
        return  Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: text,
            ),
            Expanded(
              flex: 1,
              child: Card(child: image,),
            ),
          ],
        );
      case CardViewType.TopImage:
        return Column(
          children: <Widget>[
            image,
            Divider(),
            text,
          ],
        );
      case CardViewType.BottomImage:
        return Column(
          children: <Widget>[
            text,
            Divider(),
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