import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ImagurService {
  static Future<List<String>> uploadImage(File imageFile) async {
    try {
      const String clientId = "22f387293f767e7";
      final Uri uri = Uri.parse("https://api.imgur.com/3/image");
      final http.MultipartRequest request = http.MultipartRequest("POST", uri);

      request.headers["Authorization"] = "Client-ID $clientId";
      request.files
          .add(await http.MultipartFile.fromPath("image", imageFile.path));

      final http.StreamedResponse response = await request.send();
      final Map<String, dynamic> responseData =
          json.decode(await response.stream.bytesToString())
              as Map<String, dynamic>;

      if (response.statusCode == 200 && responseData["success"] == true) {
        return [
          responseData["data"]["link"],
          responseData["data"]["deletehash"]
        ];
      } else {
        print("Lỗi khi upload ảnh: ${responseData["data"]["error"]}");
      }
    } catch (e) {
      print("Lỗi ngoại lệ: $e");
    }
    return [];
  }

  static Future<bool> deleteImage(String tagImage) async {
    const String clientId = "22f387293f767e7";
    final Uri uri = Uri.parse("https://api.imgur.com/3/image/$tagImage");
    try {
      final respone = await http
          .delete(uri, headers: {"Authorization": "Client-ID $clientId"});
      if (respone.statusCode == 200) {
        return true;
      } else {
        print("Failed to delete image: ${respone.body}");
      }
    } catch (e) {
      print("Error deleteing image : $e");
    }
    return false;
  }
}
