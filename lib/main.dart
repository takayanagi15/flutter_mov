import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List items = [];
  bool isError = false;
  String errorString = '';

  Future<void> getLoginResponse2() async {
    // final Response response = await Dio().get(
    //   'https://userpageuat.azurewebsites.net/api/Login',
    //   queryParameters: {
    //     'code': 'iTAx69vL/UuhBflxh82uUiwSd1XaFAneFbFWs/OhpJT5jKgzK85vbg==',
    //     'env': 'uat',
    //     'userId': 'kazumi.takayanagi@mtlo.co.jp',
    //     'passWord': 'Mamezou@001',
    //   },
    // );

    final Response response = await Dio().get(
        'https://userpageuat.azurewebsites.net/api/Login?code=iTAx69vL/UuhBflxh82uUiwSd1XaFAneFbFWs/OhpJT5jKgzK85vbg==&env=uat&userId=kazumi.takayanagi@mtlo.co.jp&passWord=Mamezou@001');

    print('ErrorCode:');
    print(response.data['ErrorCode']);
    print('RetMessage:');
    print(response.data['RetMessage']);
    print('token:');
    print(response.data['token']);

    setState(() {}); // 画面を更新したいので setState も呼んでおきます
  }

  Future<void> getLoginResponse() async {
    try {
      // 1. GetでResponseを取得
      var response = await http
          .get(Uri.https('userpageuat.azurewebsites.net', '/api/Login', {
        'code': 'iTAx69vL/UuhBflxh82uUiwSd1XaFAneFbFWs/OhpJT5jKgzK85vbg==',
        'env': 'uat',
        'userId': 'kazumi.takayanagi@mtlo.co.jp',
        'passWord': 'Mamezou@001',
      }));
      // 2. 問題がなければ、Json型に変換したデータを格納
      var jsonResponse = _response(response);

      print('ErrorCode:');
      print(jsonResponse['ErrorCode']);
      print('RetMessage:');
      print(jsonResponse['RetMessage']);
      print('token:');
      print(jsonResponse['token']);

      var userInfo = jsonResponse['UserInfo'];
      print(userInfo['userId']);

      setState(() {}); // 画面を更新したいので setState も呼んでおきます

      // throw Exception();
    } on SocketException catch (socketException) {
      // ソケット操作が失敗した時にスローされる例外
      debugPrint("Error: ${socketException.toString()}");
      isError = true;
    } on Exception catch (exception) {
      // statusCode: 200以外の場合
      debugPrint("Error: ${exception.toString()}");
      isError = true;
    } catch (_) {
      debugPrint("Error: 何かしらの問題が発生しています");
      isError = true;
    }
  }

  dynamic _response(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        // 400 Bad Request : 一般的なクライアントエラー
        throw Exception('一般的なクライアントエラーです');
      case 401:
        // 401 Unauthorized : アクセス権がない、または認証に失敗
        throw Exception('アクセス権限がない、または認証に失敗しました');
      case 403:
        // 403 Forbidden ： 閲覧権限がないファイルやフォルダ
        throw Exception('閲覧権限がないファイルやフォルダです');
      case 404:
        // 404 not found ： 見つからない
        throw Exception('codeが違う可能性あり');
      case 500:
        // 500 何らかのサーバー内で起きたエラー
        throw Exception('何らかのサーバー内で起きたエラーです');

      default:
        // それ以外の場合
        throw Exception('何かしらの問題が発生しています');
    }
  }

  // この関数の中の処理は初回に一度だけ実行されます。
  @override
  void initState() {
    super.initState();

    // Loginレスポンスを取得します。
    getLoginResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
