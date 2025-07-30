import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/gesigle.dart';

class GesigleRepository {
  final CollectionReference gesigleCollection =FirebaseFirestore.instance.collection('gesigle');

  // 추가(Create)
  Future<void> insertGesigle(Gesigle gesigle) async {
    await gesigleCollection.add(gesigle.toMap());
  }

  // 전체 조회(Read)
  Future<List<Gesigle>> queryGesigle() async {
    final snapshot = await gesigleCollection.orderBy('datetime', descending: true).get();
    return snapshot.docs
        .map((doc) => Gesigle.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // 실시간 스트림 (자동 갱신)
  Stream<List<Gesigle>> gesigleStream() {
    return gesigleCollection.orderBy('datetime', descending: true).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Gesigle.fromMap(doc.data() as Map<String, dynamic>))
          .toList(),
    );
  }

  // 수정(Update) - id로 문서 찾기
  Future<void> updateGesigle(Gesigle gesigle) async {
    // id가 같은 문서 쿼리 후 update
    final snapshot = await gesigleCollection.where('id', isEqualTo: gesigle.id).get();
    for (final doc in snapshot.docs) {
      await gesigleCollection.doc(doc.id).update(gesigle.toMap());
    }
  }

  // 삭제(Delete) - id로 문서 찾기
  Future<void> deleteGesigle(int id) async {
    final snapshot = await gesigleCollection.where('id', isEqualTo: id).get();
    for (final doc in snapshot.docs) {
      await gesigleCollection.doc(doc.id).delete();
    }
  }
}
