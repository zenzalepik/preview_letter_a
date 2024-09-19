import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:letter_a/controller/config.dart';

class NewChatService {
  final String apiUrl = '$server/api/v1/chattings/create-chat-room.php';

  // Fungsi untuk membuat room chat baru
  Future<String?> createChatRoom({
    required String user1Id,
    required String user2Id,
    required BuildContext context,
  }) async {
    try {
      // Data yang akan dikirim ke API
      Map<String, dynamic> data = {
        'user_1_id': user1Id,
        'user_2_id': user2Id,
      };

      // Melakukan request POST ke API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      // Mengecek status response
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['status'] == 'success') {
          final String chatId = responseBody['chat_id'];
          print('${responseBody['chat_id']}');

          // Room berhasil dibuat, kembalikan chat_id
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Room chat berhasil dibuat! ID: $chatId'),
              backgroundColor: Colors.green,
            ),
          );
          print('}}}}}$chatId');
          return chatId; // Kembalikan chat_id
        }
        /*else if (responseBody['message'] == 'Chat room already exists') {
          final String chatId = responseBody['chat_id'];
          // Tampilkan error jika room sudah ada atau gagal dibuat
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseBody['message']),
              backgroundColor: Colors.red,
            ),
          );
          print('${responseBody['message']}');
          return chatId; // Kembalikan chat_id
        }*/
        else {
          // Tampilkan error jika room sudah ada atau gagal dibuat
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text(responseBody['message']),
          //     backgroundColor: Colors.red,
          //   ),
          // );
          print('${responseBody['message']}');

          return null;
        }
      } else {
        // Jika ada kesalahan server atau request gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat room chat. Coba lagi nanti.'),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }
    } catch (e) {
      // Menangani error yang mungkin terjadi saat memanggil API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }
}
