import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:sticker_memory/pages/custom_appbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  File? _selectedImage;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _memoController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  // 変更点1: ローディング状態を管理する変数を追加
  bool _isLoading = false;

  Future<void> _pickImage() async {
    // ローディング中は画像選択ボタンも押せないようにする
    if (_isLoading) return;

    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _uploadImageToFirebase(File file) async {
    // 変更点2: 処理開始時にローディング状態をtrueにする
    setState(() {
      _isLoading = true;
    });

    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      final ref = storage.ref(
        'stickers/${user.displayName}/${file.uri.pathSegments.last}',
      );
      
      // Firebase Storageに画像をアップロード
      await ref.putFile(file);
      final imageUrl = await ref.getDownloadURL();

      // Firestoreに画像のURLを保存
      await FirebaseFirestore.instance.collection('stickers').add({
        'userId': user.uid,
        'title': _titleController.text,
        'memo': _memoController.text,
        'date': Timestamp.now(),
        'imageUrl': imageUrl,
      });

      // アップロード成功のメッセージ
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('画像がアップロードされました')));
        // 成功したら入力内容をクリアして初期状態に戻す
        _titleController.clear();
        _memoController.clear();
        setState(() {
          _selectedImage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('アップロードエラー: ${e.toString()}')));
      }
    } finally {
      // 変更点3: 処理が成功しても失敗しても、必ずローディング状態をfalseに戻す
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ステッカー登録'),
      body: Center(
        child: SingleChildScrollView( // コンテンツが画面に収まらない場合にスクロール可能にする
          padding: const EdgeInsets.all(24.0), // 全体に余白を追加
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : Text('画像が選択されていません'),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'ステッカー名'),
                // ローディング中は入力を無効化
                enabled: !_isLoading, 
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _memoController,
                decoration: InputDecoration(labelText: 'メモ'),
                // ローディング中は入力を無効化
                enabled: !_isLoading, 
              ),
              const SizedBox(height: 30),
              // 変更点4: ローディング状態に応じて表示を切り替える
              if (_isLoading)
                const CircularProgressIndicator() // ローディング中はインジケーターを表示
              else ...[
                // ローディング中でなければボタンを表示
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('画像を選択'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _selectedImage != null
                      ? () => _uploadImageToFirebase(_selectedImage!)
                      : null,
                  child: Text('ステッカーを保存する'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}