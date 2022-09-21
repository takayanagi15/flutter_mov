import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class SearchMillWidget extends StatefulWidget {
  const SearchMillWidget({super.key});

  @override
  State<SearchMillWidget> createState() => _SearchMillWidgetState();
}

class _SearchMillWidgetState extends State<SearchMillWidget> {
  final serialNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "ホーム > ミルシート > 検索条件入力",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                print("クリック");
                setState(() {}); // 画面を更新したいので setState も呼んでおきます
              },
              child: Text("更新"),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 300,
                ),
                Text(
                  "会社名",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Text(
                  "ログイン名",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )
              ],
            ),
          ],
        ),
      ),
      body: Column(
        // children プロパティに Text のリストを与えます。
        children: [
          Text("鉄鋼メーカー/Steel Mill"),
          TextFormField(
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          Text("寸法/Size"),
          TextFormField(
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          Text("規格/Specification"),
          TextFormField(
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          Text("個体管理番号/Roll No."),
          TextFormField(
            controller: serialNoController,
            decoration: const InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20)),
            onPressed: () async {},
            child: const Text('検索'),
          ),
        ],
      ),
    );
  }
}
