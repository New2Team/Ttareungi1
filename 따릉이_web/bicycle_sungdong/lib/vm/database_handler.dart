import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/gesigle.dart';

class GesigleRepository {
  final CollectionReference gesigleCollection =
      FirebaseFirestore.instance.collection('gesigle');

  // 게시글 추가 (Create)
  Future<void> insertGesigle(Gesigle gesigle) async {
    await gesigleCollection.add(gesigle.toMap());
  }

  
  Future<Map<String, dynamic>> fetchGesiglePageWithCursor({
  DocumentSnapshot? lastDoc,
  int pageSize = 8, // 필요 시 변경
}) async {
  Query query = gesigleCollection
      .orderBy('datetime', descending: true)
      .limit(pageSize);

  if (lastDoc != null) {
    query = query.startAfterDocument(lastDoc);
  }

  final snapshot = await query.get();
  final posts = snapshot.docs
      .map((doc) => Gesigle.fromMap(doc.data() as Map<String, dynamic>))
      .toList();

  return {
    'posts': posts,
    'lastDoc': snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
  };
}

  // 게시글 수정 (Update) - id로 문서 찾아서 update
  Future<void> updateGesigle(Gesigle gesigle) async {
    final snapshot =
        await gesigleCollection.where('id', isEqualTo: gesigle.id).get();
    for (final doc in snapshot.docs) {
      await gesigleCollection.doc(doc.id).update(gesigle.toMap());
    }
  }

  // 게시글 삭제 (Delete) - id로 문서 찾아서 삭제
  Future<void> deleteGesigle(int id) async {
    final snapshot = await gesigleCollection.where('id', isEqualTo: id).get();
    for (final doc in snapshot.docs) {
      await gesigleCollection.doc(doc.id).delete();
    }
  }

  // 실시간 스트림 (옵셔널)
  Stream<List<Gesigle>> gesigleStream({int pageSize = 8}) {
    return gesigleCollection
        .orderBy('datetime', descending: true)
        .limit(pageSize)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Gesigle.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
Future<List<Gesigle>> fetchRecentNotices({int limitCount = 5}) async {
  final snapshot = await gesigleCollection
      .orderBy('datetime', descending: true)
      .limit(limitCount)
      .get();

  return snapshot.docs
      .map((doc) => Gesigle.fromMap(doc.data() as Map<String, dynamic>))
      .toList();
}


}

