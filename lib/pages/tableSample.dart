import 'package:flutter/material.dart';

class TableSampleWidget extends StatefulWidget {
  const TableSampleWidget({super.key});

  @override
  State<TableSampleWidget> createState() => _TableSampleWidgetState();
}

class _TableSampleWidgetState extends State<TableSampleWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const CrossScrollWidget(),
    );
  }
}

class CrossScrollWidget extends StatefulWidget {
  const CrossScrollWidget({super.key});

  @override
  State<CrossScrollWidget> createState() => _CrossScrollWidgetState();
}

class _CrossScrollWidgetState extends State<CrossScrollWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // SingleChildScrollView を二回使う
        // ひとつめは水平方向へのスクロール
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // ふたつめは縦方向へのスクロール
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                for (var index = 0; index < 30; index++)
                  Row(children: [
                    for (var number = 0; number < 30; number++)
                      Container(
                        height: 80,
                        width: 80,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(child: Text('$number')),
                      ),
                  ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
