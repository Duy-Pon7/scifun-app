import 'package:flutter/material.dart';

class BasicAppBarScreen extends StatelessWidget {
  const BasicAppBarScreen({Key? key}) : super(key: key);
  @override
  // Source - https://stackoverflow.com/a/60005471
// Posted by Murat Aktasli
// Retrieved 2026-03-18, License - CC BY-SA 4.0

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AppBar(
                elevation: 0.0,
                automaticallyImplyLeading: false,
                flexibleSpace: Container(),
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    PopupMenuButton<String>(
                        icon: Icon(Icons.menu),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: "1",
                                child: Text('Hello'),
                              ),
                              PopupMenuItem<String>(
                                value: "2",
                                child: Text('World'),
                              ),
                            ]),
                    Text("data"),
                    PopupMenuButton<String>(
                        icon: Icon(Icons.menu),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: "1",
                                child: Text('Hello'),
                              ),
                              PopupMenuItem<String>(
                                value: "2",
                                child: Text('World'),
                              ),
                            ])
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Container());
  }
}
