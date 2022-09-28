import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'pages/login.dart';
import 'pages/login_new.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: MillSheetListWidget(),
      // home: MillSheetListWidget(),
      // home: LoginPage(),
      home: loginValidate(),
    );
  }
}
