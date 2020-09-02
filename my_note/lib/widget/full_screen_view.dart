import 'package:flutter/material.dart';

class FullScreenView extends StatelessWidget {

  FullScreenView({this.tag,this.child,this.fullChild});
  final String tag;
  final Widget child;
  final Widget fullChild;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        child: Hero(
          tag: tag,
          transitionOnUserGestures:true,
          child: child,
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return _DetailScreen(tag: tag,child:fullChild ?? child,);
          }));
        },
      );
  }
}


class _DetailScreen extends StatelessWidget {

  _DetailScreen({this.tag,this.child});

  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          color: Colors.black,
          child: Center(
            child: Hero(
              tag: tag,
              child: child,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
