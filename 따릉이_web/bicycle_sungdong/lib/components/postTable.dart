import 'package:flutter/material.dart';

class BoardTable extends StatelessWidget {
  final List data;
  final Function(Map rowData) onRowTap;
  const BoardTable({required this.data, required this.onRowTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text("순서")),
        DataColumn(label: Text("제목")),
        DataColumn(label: Text("작성자")),
        DataColumn(label: Text("날짜")),
      ],
      rows: [
        for (int i=0; i<data.length; i++)
          DataRow(
            cells: [
              DataCell(Text('${i+1}')),
              DataCell(Text(data[i]['bTitle'])),
              DataCell(Text(data[i]['bName'])),
              DataCell(Text(data[i]['bDate'])),
            ],
            onSelectChanged: (_) => onRowTap(data[i]),
          )
      ],
    );
  }
}
