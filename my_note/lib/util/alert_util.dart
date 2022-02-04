import 'package:flutter/material.dart';
// import 'package:loading_dialog/loading_dialog.dart';

// LoadingDialog _loading;

void showTextAlert(
  String text,
  BuildContext context, {
  String title,
  String ok,
  String cancel,
  VoidCallback okClick,
  VoidCallback cancelClick,
}) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(title ?? '提示'),
        content: Text(text),
        actions: <Widget>[
          // ボタン領域
          TextButton(
            child: Text(cancel ?? 'CANCEL'),
            onPressed: () {
              if (cancelClick != null) {
                cancelClick();
              }
            },
          ),
          TextButton(
            child: Text(ok ?? 'OK'),
            onPressed: () {
              if (okClick != null) {
                okClick();
              }
            },
          ),
        ],
      );
    },
  );
}

void showLoading(BuildContext context) {
  // _loading = _loading == null ? LoadingDialog(buildContext: context) : _loading;
  // _loading.show();
}

void hideLoading(BuildContext context) {
  // _loading = _loading == null ? LoadingDialog(buildContext: context) : _loading;
  // _loading.hide();
}

void showSheet(
  BuildContext context,
  List<String> titles, {
  Function(int index) onClick,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      child: Column(
          children: List.generate(
        titles.length,
        (index) => GestureDetector(
            child: Container(
              alignment: Alignment.center,
              height: 45.0,
              child: Text(
                titles[index],
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            onTap: () {
              if (onClick != null) {
                onClick(index);
              }
              Navigator.pop(context);
            }),
      )),
      height: 45 * titles.length.toDouble(),
    ),
  );
}
