import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> uploadVideo() async {
    XFile? video = await pickVideo();
    if (video != null) {
      String videoUrl = await saveVideo(video.path);
      await _firestore
          .collection('videos')
          .add({'url': videoUrl, 'timeStamp': FieldValue.serverTimestamp()});
    } else {
      throw Exception();
    }
  }

  Future<String> saveVideo(String path) async {
    Reference ref = _storage.ref().child('videos/${DateTime.now()}.mp4');
    await ref.putFile(File(path));
    String videoUrl = await ref.getDownloadURL();
    return videoUrl;
  }

  Future<XFile?> pickVideo() async {
    ImagePicker picker = ImagePicker();
    XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    return video;
  }
}
