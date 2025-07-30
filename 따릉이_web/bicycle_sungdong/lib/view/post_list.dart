import 'package:bicycle_sungdong/components/postTable.dart';
import 'package:bicycle_sungdong/components/postpagecontrols.dart';
import 'package:bicycle_sungdong/model/gesigle.dart';
import 'package:bicycle_sungdong/view/post_detail.dart';
import 'package:bicycle_sungdong/vm/database_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GesigleBoardPage extends StatefulWidget {
  const GesigleBoardPage({Key? key}) : super(key: key);

  @override
  State<GesigleBoardPage> createState() => _GesigleBoardPageState();
}

class _GesigleBoardPageState extends State<GesigleBoardPage> {
  final GesigleRepository repository = GesigleRepository();
  List<Gesigle> allPosts = [];
  int currentPage = 1;
  final int pageSize = 8;
  DocumentSnapshot? lastDoc;

  @override
  void initState() {
    super.initState();
    fetchAllPosts();
  }

Future<void> fetchAllPosts() async {
  final res = await repository.fetchGesiglePageWithCursor();
  setState(() {
    allPosts = res['posts'];      // 게시글 리스트
    lastDoc = res['lastDoc'];     // 다음 페이지 커서 (필요시)
    currentPage = 1;
  });
}


  void handleRowTap(Gesigle post) {
  Get.to(() => GesigleDetailPage(post: post));
}

  void goPrev() {
    if (currentPage > 1) setState(() => currentPage--);
  }

  void goNext() {
    final totalPages = (allPosts.length / pageSize).ceil();
    if (currentPage < totalPages) setState(() => currentPage++);
  }

  @override
  Widget build(BuildContext context) {
    // 페이지별 데이터
    final totalPages = (allPosts.length / pageSize).ceil();
    final start = (currentPage - 1) * pageSize;
    final end = (start + pageSize < allPosts.length) ? start + pageSize : allPosts.length;
    final pagePosts = allPosts.sublist(start, end);

    return Scaffold(
      appBar: AppBar(title: Text('게시판')),
      body: Column(
        children: [
          Expanded(
            child: BoardTable(
              posts: pagePosts,
              onRowTap: handleRowTap,
            ),
          ),
          BoardPageControls(
                currentPage: currentPage,
                totalItems: allPosts.length,    // 전체 게시글 수
                pageSize: pageSize,             // 한 페이지당 글 수
                onPrev: goPrev,
                onNext: goNext,
                isFirst: currentPage == 1,
                isLast: currentPage == totalPages,
              ),
        ],
      ),
    );
  }
}
