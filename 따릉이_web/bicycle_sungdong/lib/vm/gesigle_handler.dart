import 'package:bicycle_sungdong/model/gesigle.dart';
import 'package:flutter/material.dart';

class BoardProvider with ChangeNotifier {
  List<Gesigle> posts = [];
  int total = 0;
  int page = 1;
  bool isLoading = false;

  Future<void> fetchPosts({int page = 1}) async {
    isLoading = true;
    notifyListeners();
    // --- 네트워크 요청 및 posts/total set ---
    // posts = ...;
    // total = ...;
    // page = page;
    isLoading = false;
    notifyListeners();
  }

  // 검색/필터 등 추가 가능
}