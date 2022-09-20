import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String hostName = 'https://userpageuat.azurewebsites.net/api/Login';
  final String code =
      'iTAx69vL/UuhBflxh82uUiwSd1XaFAneFbFWs/OhpJT5jKgzK85vbg==';
  final String env = 'uat';

  final userIdContor = TextEditingController();
  final passWordContor = TextEditingController();

  Future<BaseResponsObj> getLoginResponseObj(
      String userIdStr, String passWordStr) async {
    final Response response = await Dio().get(
      hostName,
      queryParameters: {
        'code': code,
        'env': env,
        'userId': userIdStr,
        'passWord': passWordStr,
      },
    );

    Map<String, dynamic> jsonResponse = jsonDecode(response.data);

    // レスポンス生成
    BaseResponsObj resObj = BaseResponsObj.fromMap(jsonResponse);

    return resObj;
  }

  // この関数の中の処理は初回に一度だけ実行されます。
  @override
  void initState() {
    super.initState();
    // setState(() {}); // 画面を更新したいので setState も呼んでおきます
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // body プロパティに Row を与えます。
        body: Column(
          // children プロパティに Text のリストを与えます。
          children: [
            Text("ユーザID"),
            TextFormField(
              controller: userIdContor,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            Text("パスワード"),
            TextFormField(
              controller: passWordContor,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: () async {
                final BaseResponsObj resObj = await getLoginResponseObj(
                    userIdContor.text, passWordContor.text);
                // ログイン成功
                if (resObj.errorCode == 0) {
                  print("ログイン成功");
                } else {
                  // ログイン失敗時はダイアログ表示
                  showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text('ログイン失敗'),
                        scrollable: true,
                        content: const Text('ログインIDまたはパスワードが違います。'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}

class BaseResponsObj {
  final int errorCode;
  final String retMessage;
  final String token;
  final UserInfo userInfo;

  BaseResponsObj(
      {required this.errorCode,
      required this.retMessage,
      required this.token,
      required this.userInfo});

  factory BaseResponsObj.fromMap(Map<String, dynamic> map) {
    int errorCode = map['ErrorCode'];
    String retMessage = map['RetMessage'];
    String token = map['token'];
    UserInfo userInfo;
    // errorCode !=0 は失敗の為空オブジェクトを作成
    if (errorCode == 0) {
      userInfo = UserInfo.fromMap(map['UserInfo']);
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
      retMessage: retMessage,
      token: token,
      userInfo: userInfo,
    );
  }
}

class UserInfo {
  final String userId;
  final String name;
  final String companyId;
  final String companyName;
  final int userAuth;
  final int companyAuth;

  UserInfo(
      {required this.userId,
      required this.name,
      required this.companyId,
      required this.companyName,
      required this.userAuth,
      required this.companyAuth});

  factory UserInfo.fromMap(Map<String, dynamic> map) {
    return UserInfo(
      userId: map['userId'],
      name: map['name'],
      companyId: map['companyId'],
      companyName: map['companyName'],
      userAuth: map['userAuth'],
      companyAuth: map['companyAuth'],
    );
  }
}
