import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadIncidentPhoto({
    required File file,
    required String reporterId,
  }) async {
    final extension = file.path.split('.').last.toLowerCase();
    final photoRef = _storage.ref(
      'incident_photos/$reporterId/${DateTime.now().millisecondsSinceEpoch}.$extension',
    );
    await photoRef.putFile(file);
    return photoRef.getDownloadURL();
  }
}