import 'dart:convert';
import 'package:demo_firebase_realtime/services/auth_firebase.dart';
import 'package:http/http.dart' as http;

class TokenService {
  final AuthFirebase _authFirebase = AuthFirebase();
  final String url =
      'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyBgqF9sPoJ4qxk55Kh1M_PU_A49Xl_3KkI';

  Future<bool> checkToken() async {
    //token chi co tac dung 1h
    String? token = await _authFirebase.getUserToken();
    if (token != null) {
      return await _verifyToken(token);
    }
    return false;
  }

  Future<bool> _verifyToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'idToken': token}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Token is invalid: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error verifying token: $e");
      return false;
    }
  }
}
