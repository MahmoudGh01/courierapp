import 'dart:io';
import 'package:http/http.dart' as http;

class UploadService {
  static const String endpoint = "https://uploadthing.com/api/upload"; // replace
  static const String apiKey   = "sk_live_84aef6f3d6f92adabbbbc98dc273effa463571c90a2a980c080606e39290da0c"; // secure this!

  static Future<String?> uploadFile(File file) async {
    final request = http.MultipartRequest('POST', Uri.parse(endpoint))
      ..headers['Authorization'] = "Bearer $apiKey"
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final res = await request.send();
    final body = await res.stream.bytesToString();

    if (res.statusCode == 200) {
      // Parse JSON response for file URL
      final url = body.contains("url")
          ? RegExp(r'"url":"([^"]+)"').firstMatch(body)?.group(1)
          : null;
      return url;
    } else {
      throw Exception("Upload failed: ${res.statusCode} $body");
    }
  }
}
