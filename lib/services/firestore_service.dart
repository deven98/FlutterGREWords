import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gre/models/essay_model.dart';

class FirestoreService {
  Firestore _db = Firestore.instance;

  Future uploadEssay(
      String question, String type, String text, bool public, String uid) {
    return _db.collection('essays').document().setData({
      "question": question,
      "type": type,
      "text": text,
      "public": public,
      "uid": uid,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<EssayModel>> getUserEssays(String uid) async {
    var docs = await _db
        .collection('essays')
        .where("uid", isEqualTo: uid)
        .getDocuments();

    return docs.documents
        .map((e) => EssayModel.fromJson(e.data, e.documentID))
        .toList();
  }
}
