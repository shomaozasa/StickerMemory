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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _uploadImageToFirebase(File file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    final ref = storage.ref(
      'stickers/${user.displayName}/${file.uri.pathSegments.last}',
    );
    try {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('画像がアップロードされました')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('アップロードエラー: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ステッカー登録'),
      body: Center(
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
            ),
            TextField(
              controller: _memoController,
              decoration: InputDecoration(labelText: 'メモ'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _pickImage, child: Text('画像を選択')),
            ElevatedButton(
              onPressed:
                  _selectedImage != null
                      ? () => _uploadImageToFirebase(_selectedImage!)
                      : null,
              child: Text('ステッカーを保存する'),
            ),
          ],
        ),
      ),
    );
  }
}
