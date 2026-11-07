import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class StorageService {
  Future<String> uploadIncidentPhoto({
    required File file,
    required String reporterId,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://api.cloudinary.com/v1_1/${CloudinaryConfig.cloudName}/image/upload',
      ),
    );
    request.fields['upload_preset'] = CloudinaryConfig.uploadPreset;
    request.fields['folder'] = 'incident_photos/$reporterId';
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    final data = jsonDecode(responseBody);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      var message = 'Cloudinary upload failed';
      if (data is Map<String, dynamic>) {
        final error = data['error'];
        if (error is Map<String, dynamic> && error['message'] is String) {
          message = error['message'] as String;
        }
      }
      throw StateError(message.toString());
    }

    if (data is! Map<String, dynamic> || data['secure_url'] is! String) {
      throw const FormatException('Cloudinary returned no image URL');
    }

    return data['secure_url'] as String;
  }
}
