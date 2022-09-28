import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_mov/pages/login_new.dart';
import 'package:flutter_mov/pages/searchMill.dart';

class MillSheetListWidget extends StatefulWidget {
  final String token;
  final UserInfo userInfoObj;
  final SearchObj searchObj;

  const MillSheetListWidget(
      {super.key,
      required this.token,
      required this.userInfoObj,
      required this.searchObj});

  @override
  State<MillSheetListWidget> createState() => _MillSheetListWidgetState();
}

class _MillSheetListWidgetState extends State<MillSheetListWidget> {
  // 全画面より渡されたtokenを取得　build以前に参照したい場合は　late final で取得する。
  late final String token = widget.token;
  late final UserInfo userInfoObj = widget.userInfoObj;
  late final SearchObj searchObj = widget.searchObj;

  final String hostName = 'https://momillsheetuat.azurewebsites.net';
  final String uri = '/api/MillSearchList';
  final String code =
      'iTAx69vL/UuhBflxh82uUiwSd1XaFAneFbFWs/OhpJT5jKgzK85vbg==';
  final String env = 'uat';
  // final String token = '404b8d63-eac1-4cc6-9a81-d7c74a09e01e';

  var CircularProgressIndicatorFlg = true;

  MillSheetResponsObj? resMillSheetObj;

  Future<void> getSearchMillList() async {
    final String url = hostName + uri;
    final Response response = await Dio().get(
      url,
      queryParameters: {
        'code': code,
        'env': env,
        'token': token,
        'serialNo': searchObj.serialNo,
      },
    );

    Map<String, dynamic> jsonResponse = jsonDecode(response.data);

    // レスポンス生成
    resMillSheetObj = MillSheetResponsObj.fromMap(jsonResponse);

    CircularProgressIndicatorFlg = false;
    setState(() {}); // 画面を更新したいので setState も呼んでおきます
  }

  // この関数の中の処理は初回に一度だけ実行されます。
  @override
  void initState() {
    super.initState();
    getSearchMillList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "ホーム > ミルシート > 検索結果",
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
      body: Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            children: [_createDataTable()],
          ),
          if (CircularProgressIndicatorFlg) CircularProgressIndicator(),
        ],
      ),
    );
  }

  DataTable _createDataTable() {
    return DataTable(
      columnSpacing: 70,
      dataRowHeight: 60,
      columns: _createColumns(),
      rows: _createRows(),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: SelectableText('鉄鋼メーカー')),
      DataColumn(label: Text('日付')),
      DataColumn(label: Text('規格')),
      DataColumn(label: Text('寸法')),
      DataColumn(label: Text('個体管理番号')),
      DataColumn(label: Text('プレビュー')),
      DataColumn(label: Text('ダウンロード')),
    ];
  }

  List<DataRow> _createRows() {
    List<DataRow> rows = [];
    List<MillSheet> millSheetList = resMillSheetObj?.millSheetList ?? [];

    int i = 0;
    for (MillSheet element in millSheetList) {
      DataRow row = DataRow(cells: [
        DataCell(Text(maxLines: 1, element.buyerName ?? "")),
        DataCell(Text(element.orderDate ?? "")),
        DataCell(Text(element.specification ?? "")),
        DataCell(Text(element.size ?? "")),
        DataCell(Text(element.serialNo ?? "")),
        DataCell(Text(element.pdf_name ?? "")),
        DataCell(Text(element.preView ?? "")),
        // DataCell(SelectableText(maxLines: 1, element.buyerName ?? "")),
        // DataCell(SelectableText(element.orderDate ?? "")),
        // DataCell(SelectableText(element.specification ?? "")),
        // DataCell(SelectableText(element.size ?? "")),
        // DataCell(SelectableText(element.serialNo ?? "")),
        // DataCell(SelectableText(element.pdf_name ?? "")),
        // DataCell(SelectableText(element.preView ?? "")),
      ]);
      rows.add(row);

      if (i == 50) {
        break;
      }
      i++;
    }

    return rows;
  }
}

class MillSheetResponsObj {
  final int errorCode;
  final String errorMessage;
  final String token;
  final UserInfo userInfo;
  final List<MillSheet> millSheetList;

  MillSheetResponsObj(
      {required this.errorCode,
      required this.errorMessage,
      required this.token,
      required this.userInfo,
      required this.millSheetList});

  factory MillSheetResponsObj.fromMap(Map<String, dynamic> map) {
    int errorCode = map['ErrorCode'];
    String errorMessage = map['RetMessage'];
    String token = map['token'];
    UserInfo userInfo;
    List<MillSheet> millSheetList = [];

    // errorCode !=0 は失敗の為空オブジェクトを作成
    if (errorCode == 0) {
      userInfo = UserInfo.fromMap(map['UserInfo']);
      final millSheetListMap = map['DataLines'] as List;
      var tmpList = millSheetListMap.map((e) => MillSheet.fromMap(e)).toList();
      millSheetList = tmpList;
    } else {
      userInfo = UserInfo(
          userId: '',
          name: '',
          companyId: '',
          companyName: '',
          companyAuth: -1,
          userAuth: -1);
    }
    return MillSheetResponsObj(
      errorCode: errorCode,
      errorMessage: errorMessage,
      token: token,
      userInfo: userInfo,
      millSheetList: millSheetList,
    );
  }
}

class MillSheet {
  final String? buyerName;
  final String? orderDate;
  final String? specification;
  final String? size;
  final String? serialNo;
  final String? pdf_name;
  final String? preView;

  MillSheet(
      {this.buyerName,
      this.orderDate,
      this.specification,
      this.size,
      this.serialNo,
      this.pdf_name,
      this.preView});

  factory MillSheet.fromMap(Map<String, dynamic> map) {
    return MillSheet(
      buyerName: map['buyer_name'],
      orderDate: map['order_date'],
      specification: map['specification'],
      size: map['size'],
      serialNo: map['serial_no'],
      pdf_name: map['pdf_name'],
      preView: map['pdf_container_path'],
    );
  }
}
