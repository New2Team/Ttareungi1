import 'package:bicycle_sungdong/components/postTable.dart';
import 'package:bicycle_sungdong/components/postpagecontrols.dart';
import 'package:bicycle_sungdong/model/gesigle.dart';
import 'package:bicycle_sungdong/view/post_detail.dart';
import 'package:bicycle_sungdong/vm/database_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GesigleBoardPage extends StatefulWidget {
  const GesigleBoardPage({super.key});

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
      allPosts = res['posts'];
      lastDoc = res['lastDoc'];
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
    final totalPages = (allPosts.length / pageSize).ceil();
    final start = (currentPage - 1) * pageSize;
    final end = (start + pageSize < allPosts.length) ? start + pageSize : allPosts.length;
    final pagePosts = allPosts.sublist(start, end);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          '공지사항',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 게시판 테이블
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: BoardTable(
                      posts: pagePosts,
                      onRowTap: handleRowTap,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 페이지 컨트롤
                Align(
                  alignment: Alignment.center,
                  child: BoardPageControls(
                    currentPage: currentPage,
                    totalItems: allPosts.length,
                    pageSize: pageSize,
                    onPrev: goPrev,
                    onNext: goNext,
                    isFirst: currentPage == 1,
                    isLast: currentPage == totalPages,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}