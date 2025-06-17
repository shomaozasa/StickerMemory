import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_account.dart';
import 'setting.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.pinkAccent,
        elevation: 5,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'StickerMemory',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            if (user != null)
              Text(
                'Hello！${user.displayName}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.pinkAccent,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              child: Text(
                'ログアウト',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 左側の縦ボタン群
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // ステッカーを登録する処理
                    Navigator.pushNamed(context, '/stamp');
                  },
                  child: Text('ステッカーを登録する', style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // ステッカーを見る処理
                    Navigator.pushNamed(context, '/sticker_view');
                  },
                  child: Text('ステッカーを見る', style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // ステッカーを飾る処理
                    Navigator.pushNamed(context, '/sticker_board');
                  },
                  child: Text('ステッカーを飾る', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),

            // 右側のプリセット表示エリア（仮の四角）
            Container(
              width: 180,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black87),
              ),
              alignment: Alignment.center,
              child: Text('今までのプリセットを表示'),
            ),
          ],
        ),
      ),
    );
  }
}
