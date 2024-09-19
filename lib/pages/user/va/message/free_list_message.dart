import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/va/va/free_chat_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/item_message_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreeListMessage extends StatefulWidget {
  const FreeListMessage({super.key});

  @override
  State<FreeListMessage> createState() => _FreeListMessageState();
}

class _FreeListMessageState extends State<FreeListMessage> {
  late Future<List<dynamic>> _chatListFuture;
  bool _isDataFetched = false;

  bool amITheFirstSender = true;
  String myUserId = '';
  String myUserName = '';
  String lawanBicara = '';
  String lawanBicaraPhoto = '';
  String userId1 = '';
  String userId2 = '';
  String userName1 = '';
  String userName2 = '';
  String userPhoto1 = '';
  String userPhoto2 = '';
  int hitung = 1;

  @override
  void initState() {
    super.initState();
    // amITheFirstSender = '104';
    //_saveDummyData();inisiasi();
    _chatListFuture = _fetchChatList();
    inisiasi();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataFetched) {
      _isDataFetched = true;
      //inisiasi();
    }
  }

  Future<void> inisiasi() async {
    // Pastikan FutureBuilder selesai memuat data
    await checkMyUser(); // Pastikan untuk memanggil checkMyUser di sini
    _chatListFuture = _fetchChatList();
    await _chatListFuture; // Tunggu hingga Future selesai
    _printAllSharedPreferencesData();
  }

  //Fungsi untuk menyimpan data contoh ke SharedPreferences
  Future<void> _saveDummyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', '104');
    await prefs.setString('userName', 'Admin');
  }

  // Fungsi untuk mencetak semua data di SharedPreferences
  Future<void> _printAllSharedPreferencesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs
        .getKeys(); // Mendapatkan semua kunci yang ada di SharedPreferences

    for (String key in keys) {
      // Mengambil nilai berdasarkan tipe data yang sesuai
      dynamic value = prefs.get(key);
      print('Key: $key, Value: $value');
    }
  }

  Future<void> checkMyUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _myIdUser = prefs.getString('userId') ?? '';
    String _myNameUser = prefs.getString('userName') ?? '';
    setState(() {
      myUserId = '$_myIdUser';
      myUserName = '$_myNameUser';
      //myUserId = '59';
    });

    print('>>My User $myUserId');
  }

  Future<List<dynamic>> _fetchChatList() async {
    setState(() {
      hitung++;
    });
    print('==$hitung');
    final response = await http
        .get(Uri.parse('${apiBaseUrl}chat-list.php?myIdUser=${myUserId}'));

    final jsonResponseError = jsonDecode(response.body);
    print('${jsonResponseError}');
    //print('${jsonResponseError['status']}');
    // if (jsonResponseError['status'] == 'error') {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(jsonResponseError['message']),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
    print('myUserId $myUserId');
    if (response.statusCode == 200 &&
        jsonResponseError['status'] == 'success') {
      print('${jsonDecode(response.body)}');
      return jsonDecode(response.body)['data'];
    } else {
      if (jsonResponseError['status'] == 'error') {
        if (hitung >= 4) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('>>>' + jsonResponseError['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      throw Exception('Failed to load chat list');
    }
  }

  String _isToday(String timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));

    // Ambil tanggal hari ini
    final today = DateTime.now();

    // Cek apakah tanggal dari API sama dengan hari ini
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today';
    } else {
      return DateFormat('dd-MM-yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                      color: LColors.primary,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text('Message (As Virtual Assistant)',
                            style: LText.description(color: LColors.white)),
                      )))),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(children: [
                FutureBuilder<List<dynamic>>(
                  future: _chatListFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text('Error: Can not load chats page'));
                      //return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No chats available'));
                    }

                    final chatList = snapshot.data!;

                    return ListView.builder(
                      itemCount: chatList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final chat = chatList[index];
                        // setState(() {
                        userId1 = chat['user_1_id'];
                        userId2 = chat['user_2_id'];
                        userName1 = chat['user1_name'];
                        userName2 = chat['user2_name'];
                        userPhoto1 = chat['user1_imageUrl'];
                        userPhoto2 = chat['user2_imageUrl'];
                        // });
                        return ItemMessageWidget(
                          //chat['chat_id']
                          role: 'va',
                          imageUrl: myUserId == userId1
                              ? 'https://letter-a.co.id/api/v1/${chat['user2_imageUrl']}'
                              : myUserId == userId2
                                  ? 'https://letter-a.co.id/api/v1/${chat['user1_imageUrl']}'
                                  : 'https://letter-a.co.id/api/v1/uploads/logo.png',
                          text: myUserId == userId1
                              ? chat['user2_name']
                              : myUserId == userId2
                                  ? chat['user1_name']
                                  : '404',
                          chat: '${chat['last_message'] ?? ''}',
                          lastTimeDate: (chat['updated_at'] != '' &&
                                  chat['updated_at'] != null &&
                                  chat['updated_at'] != 'null')
                              ? _isToday(chat['updated_at'])
                              : _isToday(chat['created_at']),
                          lastTime: (chat['updated_at'] != '' &&
                                  chat['updated_at'] != null &&
                                  chat['updated_at'] != 'null')
                              ? "${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(chat['updated_at'])))}"
                              : "${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(chat['created_at'])))}",
                          working: false,
                          read: true,
                          onTap: () {
                            // setState(() {
                            userId1 = chat['user_1_id'];
                            userId2 = chat['user_2_id'];
                            userName1 = chat['user1_name'];
                            userName2 = chat['user2_name'];
                            userPhoto1 = chat['user1_imageUrl'];
                            userPhoto2 = chat['user2_imageUrl'];
                            // });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FreeVAChatPage(
                                  chatId: chat['chat_id'],
                                  userId: '$myUserId',
                                  userName: '$myUserName',
                                  lawanBicara: myUserId == userId1
                                      ? chat['user2_name']
                                      : myUserId == userId2
                                          ? chat['user1_name']
                                          : '404',

                                  //: '404'

                                  lawanBicaraPhoto: myUserId == userId1
                                      ? chat['user2_imageUrl']
                                      : myUserId == userId2
                                          ? chat['user1_imageUrl']
                                          : '404',
                                  userPhoto: myUserId == userId1
                                      ? chat['user1_imageUrl']
                                      : myUserId == userId2
                                          ? chat['user2_imageUrl']
                                          : '404',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                )
              ])),
          SizedBox(height: 40)
        ],
      ),
    );
  }
}
