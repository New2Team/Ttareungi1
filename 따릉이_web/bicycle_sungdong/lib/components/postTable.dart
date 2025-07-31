import 'package:flutter/material.dart';
import '../model/gesigle.dart';

class BoardTable extends StatelessWidget {
  final List<Gesigle> posts;
  final Function(Gesigle) onRowTap;

  const BoardTable({super.key, required this.posts, required this.onRowTap});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return const Center(child: Text("데이터가 없습니다"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderRow(),
        const Divider(thickness: 1),
        Expanded(
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return InkWell(
                onTap: () => onRowTap(post),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text('${index + 1}'),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 5,
                        child: Text(
                          post.title,
                          style: const TextStyle(fontSize: 14),
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Text(
                          post.datetime,
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: const [
        SizedBox(
          width: 40,
          child: Text("순서", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 5,
          child: Text("제목", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Text("날짜", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}