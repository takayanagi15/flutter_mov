import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_mov/pages/login.dart';

import 'millSheetList.dart';

class SearchMillWidget extends StatefulWidget {
  final String token;
  final UserInfo userInfoObj;

  const SearchMillWidget(
      {super.key, required this.token, required this.userInfoObj});

  @override
  State<SearchMillWidget> createState() => _SearchMillWidgetState();
}

class _SearchMillWidgetState extends State<SearchMillWidget> {
  // 全画面より渡されたtokenを取得　build以前に参照したい場合は　late final で取得する。
  late final String token = widget.token;
  late final UserInfo userInfoObj = widget.userInfoObj;

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
                  userInfoObj.companyName,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Text(
                  userInfoObj.name,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
              onPressed: () {
                SearchObj searchObj = SearchObj(
                    buyerId: "",
                    serialNo: serialNoController.text,
                    size: "",
                    specification: "");
                print(searchObj.serialNo);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MillSheetListWidget(
                            token: token,
                            userInfoObj: userInfoObj,
                            searchObj: searchObj,
                          )),
                );
              },
              child: const Text('検索'),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchObj {
  final String? buyerId;
  final String? specification;
  final String? size;
  final String? serialNo;

  SearchObj({this.buyerId, this.specification, this.size, this.serialNo});
}
