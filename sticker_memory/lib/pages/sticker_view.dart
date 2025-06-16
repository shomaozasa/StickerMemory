import 'package:flutter/material.dart';
import 'package:sticker_memory/pages/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// StatelessWidgetからStatefulWidgetに変更
class StickerViewPage extends StatefulWidget {
  @override
  _StickerViewPageState createState() => _StickerViewPageState();
}

class _StickerViewPageState extends State<StickerViewPage> {
  // Firestoreのデータストリームを保持する変数
  late final Stream<QuerySnapshot> _stickersStream;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    // ログインしているユーザーがいる場合のみ、そのユーザーのステッカーを取得するStreamを準備
    if (currentUser != null) {
      _stickersStream = FirebaseFirestore.instance
          .collection('stickers') // 'stickers'コレクションから
          .where('userId', isEqualTo: currentUser!.uid) // ログインユーザーのIDと一致するドキュメントに絞り込む
          .orderBy('date', descending: true) // 登録日が新しい順に並び替える
          .snapshots(); // データの変更を監視するStreamを取得
    }
  }

  @override
  Widget build(BuildContext context) {
    // ログインしていない場合はメッセージを表示
    if (currentUser == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'ステッカー一覧'),
        body: Center(
          child: Text("ログインしてください。"),
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'ステッカー一覧'),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stickersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // 1. エラーが発生した場合
          if (snapshot.hasError) {
            return Center(child: Text('エラーが発生しました: ${snapshot.error}'));
          }

          // 2. データの読み込み中
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 3. データが1件もなかった場合
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("まだステッカーが登録されていません。"));
          }

          // 4. データが正常に取得できた場合
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            // グリッドのレイアウト設定
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 1行に表示するアイテム数
              crossAxisSpacing: 8.0, // アイテム間の水平方向のスペース
              mainAxisSpacing: 8.0, // アイテム間の垂直方向のスペース
              childAspectRatio: 0.8, // アイテムの縦横比
            ),
            itemCount: snapshot.data!.docs.length, // 表示するアイテムの総数
            itemBuilder: (context, index) {
              // 個々のドキュメントのデータを取得
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

              // 各ステッカーを表示するカードウィジェット
              return Card(
                clipBehavior: Clip.antiAlias, // 画像がカードの角をはみ出さないようにする
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 画像表示
                    Expanded(
                      child: Image.network(
                        data['imageUrl'],
                        fit: BoxFit.cover,
                        // 画像読み込み中にもインジケーターを表示
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        // 画像読み込みエラー時の表示
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Icon(Icons.error));
                        },
                      ),
                    ),
                    // タイトルとメモ
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // 必要であればメモも表示
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    //   child: Text(
                    //     data['memo'],
                    //     overflow: TextOverflow.ellipsis,
                    //   ),
                    // ),
                    SizedBox(height: 8),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}