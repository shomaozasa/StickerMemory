import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム')),
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
            ElevatedButton(
              child: const Text('アカウント登録'),
              onPressed: () {
                Navigator.pushNamed(context, '/registration');
              },
            ),
          ],
        ),
      ),
    );
  }
}
