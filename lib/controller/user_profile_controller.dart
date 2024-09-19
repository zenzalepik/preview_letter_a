import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String server;

  UserService(this.server);

  Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    final url = '$server/api/v1/info/api_user_data.php?id=$userId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['data'];  // Return the user data
        } else {
          throw Exception('Failed to load user profile');
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error fetching user profile: $e');
    }
  }
}
