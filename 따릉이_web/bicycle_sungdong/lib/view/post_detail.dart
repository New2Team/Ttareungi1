import 'package:flutter/material.dart';
import 'package:bicycle_sungdong/model/gesigle.dart';

class GesigleDetailPage extends StatelessWidget {
  final Gesigle post;
  const GesigleDetailPage({required this.post, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(post.title)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('제목: ${post.title}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('작성일: ${post.datetime}', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 32),
            Text(post.content, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
