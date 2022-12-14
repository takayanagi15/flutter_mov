import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'login_new.dart';
import 'searchMill.dart';

class SubSystemMenuWidget extends StatefulWidget {
  final String token;
  final UserInfo userInfoObj;

  const SubSystemMenuWidget(
      {super.key, required this.token, required this.userInfoObj});

  @override
  State<SubSystemMenuWidget> createState() => _SubSystemMenuWidgetState();
}

class _SubSystemMenuWidgetState extends State<SubSystemMenuWidget> {
  final String hostName = 'https://userpageuat.azurewebsites.net';
  final String uri = '/api/GetSystemMenu';
  final String code =
      'iTAx69vL/UuhBflxh82uUiwSd1XaFAneFbFWs/OhpJT5jKgzK85vbg==';
  final String env = 'uat';
  // 全画面より渡されたtokenを取得　build以前に参照したい場合は　late final で取得する。
  late final String token = widget.token;
  late final UserInfo userInfoObj = widget.userInfoObj;

  BaseResponsObj? resMenuObj;

  Future<void> getSystemMenuResponseObj() async {
    final String url = hostName + uri;
    final Response response = await Dio().get(
      url,
      queryParameters: {
        'code': code,
        'env': env,
        'token': token,
      },
    );

    Map<String, dynamic> jsonResponse = jsonDecode(response.data);

    // レスポンス生成
    resMenuObj = BaseResponsObj.fromMap(jsonResponse);

    setState(() {}); // 画面を更新したいので setState も呼んでおきます
  }

  // この関数の中の処理は初回に一度だけ実行されます。
  @override
  void initState() {
    super.initState();
    getSystemMenuResponseObj();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "ホームメニュー",
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
                  resMenuObj?.userInfo.companyName ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Text(
                  resMenuObj?.userInfo.name ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )
              ],
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: resMenuObj?.menuList.length ?? 0,
        itemBuilder: (context, index) {
          final menu = resMenuObj!.menuList[index];
          return Card(
            child: ListTile(
              onTap: () {
                print(index.toString() + "行をクリック");
                if (menu.srcId == 'MillSearchInput') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchMillWidget(
                            token: token, userInfoObj: userInfoObj)),
                  );
                }
              },
              title: Text(menu.title),
              subtitle: Text(menu.subTitle),
              isThreeLine: true,
              // dense: true,
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(menu.icon),
                      );
                    },
                  );
                },
              ),
              tileColor: Color.fromARGB(255, 201, 221, 240),
            ),
          );
        },
      ),
    );
  }
}

class BaseResponsObj {
  final int errorCode;
  final String errorMessage;
  final String token;
  final UserInfo userInfo;
  final List<Menu> menuList;

  BaseResponsObj(
      {required this.errorCode,
      required this.errorMessage,
      required this.token,
      required this.userInfo,
      required this.menuList});

  factory BaseResponsObj.fromMap(Map<String, dynamic> map) {
    int errorCode = map['ErrorCode'];
    String errorMessage = map['RetMessage'];
    String token = map['token'];
    UserInfo userInfo;
    List<Menu> menuList = [];

    // errorCode !=0 は失敗の為空オブジェクトを作成
    if (errorCode == 0) {
      userInfo = UserInfo.fromMap(map['UserInfo']);
      final menuListMap = map['menuList'] as List;
      var tmpList = menuListMap.map((e) => Menu.fromMap(e)).toList();
      menuList = tmpList;
    } else {
      userInfo = UserInfo(
          userId: '',
          name: '',
          companyId: '',
          companyName: '',
          companyAuth: -1,
          userAuth: -1);
    }
    return BaseResponsObj(
      errorCode: errorCode,
      errorMessage: errorMessage,
      token: token,
      userInfo: userInfo,
      menuList: menuList,
    );
  }
}

class Menu {
  final int rowId;
  final String srcId;
  final String title;
  final String subTitle;
  final int menuAuth;
  final String icon;

  Menu(
      {required this.rowId,
      required this.srcId,
      required this.title,
      required this.subTitle,
      required this.menuAuth,
      required this.icon});

  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
        rowId: map['rowId'],
        srcId: map['srcId'],
        title: map['title'],
        subTitle: map['subTitle'],
        menuAuth: map['menuAuth'],
        icon: map['icon']);
  }
}
