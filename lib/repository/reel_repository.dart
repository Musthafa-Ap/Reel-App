import 'package:cloud_firestore/cloud_firestore.dart';

class ReelRepository {
  Future<List<String>> fetchReels() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var usersCollection = firestore.collection('videos');
      var documents = await usersCollection.get();
      List<String> videoUrls = [];
      documents.docs
          .map(
            (e) => videoUrls.add(e['url']),
          )
          .toList();
      return videoUrls;
    } catch (e) {
      return [];
    }
  }
}
