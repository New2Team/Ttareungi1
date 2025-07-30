import 'package:bicycle_sungdong/model/gesigle.dart';
import 'package:flutter/material.dart';
class BoardTable extends StatelessWidget {
  final List<Gesigle> posts;
  final Function(Gesigle) onRowTap;
  const BoardTable({required this.posts, required this.onRowTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(child: Text("데이터가 없습니다"));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,  // overflow 방지
      child: DataTable(
        showCheckboxColumn: false, 
        columns: const [
          DataColumn(label: Text("순서")),
          DataColumn(label: Text("제목")),
          DataColumn(label: Text("날짜")),
        ],
        rows: [
          for (int i = 0; i < posts.length; i++)
            DataRow(
              cells: [
                DataCell(Text('${i + 1}')),
                DataCell(Text(posts[i].title)),
                DataCell(Text(posts[i].datetime)),
              ],
              onSelectChanged: (_) => onRowTap(posts[i]),
            )
        ],
      ),
    );
  }
}
