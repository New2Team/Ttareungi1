import 'package:bicycle_sungdong/components/postTable.dart';
import 'package:bicycle_sungdong/components/postpagecontrols.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List data = [];
  int page = 1;
  int total = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getJsonData(page);
  }

  Future<void> getJsonData(int page) async {
    setState(() { isLoading = true; });
    // ... 네트워크 fetch 코드 (data/total 갱신)
    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("게시판")),
      body: isLoading ? Center(child: CircularProgressIndicator())
      : Column(
        children: [
          Expanded(
            child: BoardTable(
              data: data,
              onRowTap: (rowData) {
                // 상세/수정 페이지 이동
              },
            ),
          ),
          BoardPageControls(
            currentPage: page,
            total: total,
            onPrev: () {
              if(page > 1) getJsonData(page-1);
            },
            onNext: () {
              if(page < (total/8).ceil()) getJsonData(page+1);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 등록 페이지 이동
        },
        child: Icon(Icons.edit_note),
      ),
    );
  }
}
