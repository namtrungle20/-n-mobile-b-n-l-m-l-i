import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthenticationService {
  final String apiUrl = 'http://10.0.2.2:3000';

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/0'), // Thêm /0 vào đường dẫn API
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Xử lý phản hồi thành công
        return true;
      } else {
        // Xử lý phản hồi lỗi
        return false;
      }
    } catch (e) {
      // Xử lý lỗi nếu có lỗi xảy ra trong quá trình gửi yêu cầu hoặc nhận phản hồi từ API
      print('Error during login: $e');
      return false;
    }
  }
}