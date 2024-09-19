// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:letter_a/controller/config.dart';
// import 'package:letter_a/models/work_experience_model.dart';

// class ApiService {
//   static Future<bool> submitWorkExperience(WorkExperience experience) async {
//     try {
//       final response = await http.post(
//         Uri.parse(
//             '$server/api/v1/api_save_work_experience.php'), // Sesuaikan dengan endpoint API Anda
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(experience.toJson()),
//       );

//       if (response.statusCode == 200) {
//         // Berhasil terhubung dengan API dan data dikirim
//         return true;
//       } else {
//         // Gagal mengirim data
//         print('Failed to submit work experience: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       // Exception saat terhubung ke API
//       print('Exception during API call: $e');
//       return false;
//     }
//   }
// }
