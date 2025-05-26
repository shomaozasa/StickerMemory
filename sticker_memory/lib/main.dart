import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_account.dart';
import 'pages/sticker_board.dart';
import 'pages/setting.dart';
import 'pages/sticker_view.dart';
import 'pages/registration_sticker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/registration_account.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sticker Memory',
      theme: ThemeData(primarySwatch: Colors.teal),
      // 認証状態の変更に反応するためにStreamBuilderを使用します
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 認証状態の確認中にローディングスピナーを表示
            return const CircularProgressIndicator();
          }
          if (snapshot.hasData) {
            // ユーザーがログインしている場合
            return const HomePage();
          } else {
            // ユーザーがログインしていない場合
            return LoginPage();
          }
        },
      ),
      routes: {
        // ログイン状態に関わらず、すべての可能なルートをここに定義します
        '/login': (context) => LoginPage(),
        '/registration': (context) => RegistrationPage(),
        '/sticker': (context) => StickerBoardPage(),
        '/stamp': (context) => ImagePickerPage(),
        '/setting': (context) => SettingsPage(),
        '/sticker_view': (context) => StickerViewPage(),
      },
    );
  }
}
