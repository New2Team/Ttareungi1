import 'package:flutter/material.dart';

class BoardPageControls extends StatelessWidget {
  final int currentPage;
  final int totalItems; // 전체 게시글 수
  final int pageSize;
  final VoidCallback onPrev, onNext;
  final bool isFirst, isLast;

  const BoardPageControls({
    required this.currentPage,
    required this.totalItems,
    required this.pageSize,
    required this.onPrev,
    required this.onNext,
    this.isFirst = false,
    this.isLast = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int start = ((currentPage - 1) * pageSize) + 1;
    int end = (start + pageSize - 1 < totalItems) ? (start + pageSize - 1) : totalItems;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: isFirst
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('첫 페이지입니다.')),
                  );
                }
              : onPrev,
          icon: Icon(Icons.arrow_back),
        ),
        Text('$start~$end / $totalItems'),
        IconButton(
          onPressed: isLast
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('마지막 페이지입니다.')),
                  );
                }
              : onNext,
          icon: Icon(Icons.arrow_forward),
        ),
      ],
    );
  }
}
