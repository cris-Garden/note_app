import 'package:flutter/material.dart';
import 'package:flutter_app/page/diary_detail_page.dart';
import 'package:flutter_app/provider/home_page_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomePage'),
        ),
        body: ChangeNotifierProvider(
          create: (_) => HomePageProvider(),
          builder: (context, _) {
            return Selector<HomePageProvider, HomePageProvider>(
              builder: (context, provider, _) {
                return Container(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(provider.diarys[index].name),
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context ){
                             return DiaryDetailPage(provider.diarys[index]);
                          }));
                        },
                      );
                    },
                    itemCount: provider.diarys.length,
                  ),
                );
              },
              selector: (context,provider) => provider,
            );
          },
        ));
  }
}
