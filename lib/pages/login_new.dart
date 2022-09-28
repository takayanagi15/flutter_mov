import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'dart:convert';
import 'subsystem_menu.dart';

class loginValidate extends StatefulWidget {
  const loginValidate({Key? key}) : super(key: key);

  @override
  State<loginValidate> createState() => _loginValidateState();
}

class _loginValidateState extends State<loginValidate> {
  bool _isObscure = true;

  final _formkey = GlobalKey<FormState>();

  // final String serverName = Config.
  final String hostName = 'https://userpageuat.azurewebsites.net/api/Login';
  final String code =
      'iTAx69vL/UuhBflxh82uUiwSd1XaFAneFbFWs/OhpJT5jKgzK85vbg==';
  final String env = 'uat';

  final userIdContor = TextEditingController();
  final passWordContor = TextEditingController();

  var circularProgressIndicatorFlg = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザページログイン'),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: userIdContor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ユーザー名が入力されていません!';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'ユーザー名を入力してください',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: passWordContor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'パスワードが入力されていません!';
                          }
                          return null;
                        },
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                })),
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Processing Data')),
                              );
                            }

                            circularProgressIndicatorFlg = true;
                            setState(() {}); // 画面を更新したいので setState も呼んでおきます

                            final BaseResponsObj resObj =
                                await getLoginResponseObj(
                                    userIdContor.text, passWordContor.text);
                            // ログイン成功
                            if (resObj.errorCode == 0) {
                              print("ログイン成功");
                              circularProgressIndicatorFlg = true;
                              setState(() {}); // 画面を更新したいので setState も呼んでおきます
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SubSystemMenuWidget(
                                        token: resObj.token,
                                        userInfoObj: resObj.userInfo)),
                              );
                              circularProgressIndicatorFlg = false;
                              setState(() {}); // 画面を更新したいので setState も呼んでおきます
                            } else {
                              circularProgressIndicatorFlg = false;
                              setState(() {}); // 画面を更新したいので setState も呼んでおきます
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
                          child: Text('ログイン')),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (circularProgressIndicatorFlg) CircularProgressIndicator(),
        ],
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
