import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_account.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          alignment: Alignment.center, // Stack全体の中央に揃える
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ホームページ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  child: const Text('ログアウト'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text("ログアウトしました")));
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ),
            if (user != null)
              Text(
                'Hello！${user.displayName}', // ここでユーザー名を表示
                style: TextStyle(fontSize: 65),
              ),
          ],
        ),
        centerTitle: true, // 中央配置はStackに合わせる形で
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('スタンプ登録画面へGO！'),
              onPressed: () {
                Navigator.pushNamed(context, '/stamp');
              },
            ),
            ElevatedButton(
              child: const Text('ステッカー台紙へGO！'),
              onPressed: () {
                Navigator.pushNamed(context, '/sticker');
              },
            ),
            ElevatedButton(
              child: const Text('設定ページ'),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
