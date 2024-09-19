import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/admin/notification/admin_detail_notification.dart';
import 'package:letter_a/pages/user/client/notification/client_detail_notification.dart';
import 'package:letter_a/pages/user/client/va/va_detail_page.dart';
import 'package:letter_a/pages/user/va/va/free_va_detail_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/input_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VANotificationListPage extends StatefulWidget {
  final String token;

  VANotificationListPage({required this.token});

  @override
  _VANotificationListPageState createState() => _VANotificationListPageState();
}

class _VANotificationListPageState extends State<VANotificationListPage> {
  List<dynamic> notifications = [];
  bool isLoading = true;
  String errorMessage = '';
  Map<String, bool> clickedNotifications = {};
  String _currentDate = '';
  String _currentTime = '';
  String currentUserId = '';

  @override
  void initState() {
    super.initState();
    // _updateDateTime();
    inisiasi();
    // _startTimer(); // Mulai timer
  }

  Future<void> _startTimer() async {
    Timer _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      // await inisiasi();
      await printSharedPreferences();
      await fetchNotifications();
    });
    // int sekian = 0;
    // setState(() {
    //   sekian = sekian + 1;
    // });
    //   print('update ke $sekian perlima detik');
  }

  Future<void> inisiasi() async {
    await printSharedPreferences();
    await fetchNotifications();
    await _startTimer(); // Mulai timer
  }

  Future<void> printSharedPreferences() async {
    // Ambil instance SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Ambil semua kunci yang ada
    /*Set<String> keys = prefs.getKeys();

    // Iterasi melalui semua kunci dan cetak nilai
    for (String key in keys) {
      dynamic value = prefs.get(key);
      print('Sharedpreferences ==>' + '$key: $value');
    }*/

    setState(() {
      currentUserId = prefs.getString('userId') ?? '0';
    });
  }

  void _updateDateTime() {
    final now = DateTime.now();
    final dateFormatter = DateFormat('dd-MM-yyyy');
    final timeFormatter = DateFormat('HH:mm');

    setState(() {
      _currentDate = dateFormatter.format(now);
      _currentTime = timeFormatter.format(now);
    });
  }

  Future<void> fetchNotifications() async {
    final response = await http.get(
      Uri.parse('$server/api/v1/api_get_notifications.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          notifications = data['data'];
          isLoading = false;
        });
        await loadClickedNotifications();
      } else {
        setState(() {
          errorMessage = data['message'];
          isLoading = false;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Failed to load notifications.';
        isLoading = false;
      });
    }
  }

  Future<void> loadClickedNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // print('$prefs');
      notifications.forEach((notification) {
        clickedNotifications[notification['id']] =
            prefs.getBool(notification['id']) ?? false;
      });
    });

    // Menghitung item yang belum diklik setelah data dimuat
    int unclickedCount = countUnclickedNotifications();
    // print('Jumlah item yang belum diklik: $unclickedCount');
  }

  Future<void> markNotificationAsClicked(String notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      clickedNotifications[notificationId] = true;
      prefs.setBool(notificationId, true);
    });
  }

  Future<void> markAllNotificationsAsClicked() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notifications.forEach((notification) {
        final notificationId = notification['id'];
        clickedNotifications[notificationId] = true;
        prefs.setBool(notificationId, true);
      });
    });
  }

  int countUnclickedNotifications() {
    return notifications.where((notification) {
      final notificationId = notification['id'];
      final isClicked = clickedNotifications[notificationId] ?? false;

      // Hitung item yang belum diklik
      return !isClicked;
    }).length;
  }

  // @override
  // void dispose() {
  //   _timer?.cancel(); // Hentikan timer saat widget dihapus
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: LColors.background,
        appBar: LAppBar(
          title: "Noifications",
          bgColor: LColors.primary,
          actions: [
            countUnclickedNotifications() != 0
                ? Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          color: LColors.red,
                          borderRadius: BorderRadius.circular(16)),
                      child: Center(
                        child: Text(
                          '${countUnclickedNotifications()}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: LColors.white),
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
            IconButton(
              highlightColor: LColors.white,
              icon: Icon(Icons.check),
              onPressed: () {
                markAllNotificationsAsClicked();
              },
            ),
          ],
          useFor: 'announcementV',
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SvgPicture.asset(
              'assets/icons/icon_back.svg',
              width: 200, // atur lebar gambar sesuai kebutuhan Anda
              height: 200, // atur tinggi gambar sesuai kebutuhan Anda
            ),
          ),
        ),
        body: TabBarView(children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          reverse: true, // Membalikkan urutan item di ListView
                          itemCount: notifications.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            final notificationId = notification['id'];
                            final isClicked =
                                clickedNotifications[notificationId] ?? false;

                            return GestureDetector(
                              onTap: () {
                                markNotificationAsClicked(notificationId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ClientNotificationDetailPage(
                                      token: widget.token,
                                      notificationId: int.parse(notificationId),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                margin: EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: isClicked
                                      ? Colors.white
                                      : const Color.fromARGB(
                                          255, 152, 255, 163),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.16),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        height: 56,
                                        width: 56,
                                        child: Image.network(
                                          '$server/api/v1/${notification['Thumbnail']}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            notification['Judul'],
                                            style: LText.labelDataTitle(),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.date_range_outlined,
                                                  size: 16),
                                              SizedBox(width: 4),
                                              Text(
                                                  '${notification['Tanggal']}'),
                                              SizedBox(width: 12),
                                              Icon(Icons.access_alarm_outlined,
                                                  size: 16),
                                              SizedBox(width: 4),
                                              Text('${notification['Pukul']}'),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${notification['Message']}',
                                            style: LText.description(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              reverse:
                                  true, // Membalikkan urutan item di ListView
                              itemCount: notifications.where((notification) {
                                final userId = notification['UserID'];
                                final tanggal = DateTime.parse(notification[
                                    'Tanggal']); // Pastikan format tanggal sesuai
                                final pukul = TimeOfDay(
                                  hour: int.parse(
                                      notification['Pukul'].split(':')[0]),
                                  minute: int.parse(
                                      notification['Pukul'].split(':')[1]),
                                );

                                final sekarang = DateTime.now();
                                final pukulSekarang = TimeOfDay.now();

                                // Filter berdasarkan UserID, Tanggal, dan Pukul
                                return userId == '909' &&
                                    (tanggal.isBefore(sekarang) ||
                                        (tanggal.isAtSameMomentAs(sekarang) &&
                                            (pukul.hour < pukulSekarang.hour ||
                                                (pukul.hour ==
                                                        pukulSekarang.hour &&
                                                    pukul.minute <=
                                                        pukulSekarang
                                                            .minute))));
                              }).length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                // Filter ulang untuk mendapatkan daftar notifikasi yang sesuai
                                final filteredNotifications =
                                    notifications.where((notification) {
                                  final userId = notification['UserID'];
                                  final tanggal =
                                      DateTime.parse(notification['Tanggal']);
                                  final pukul = TimeOfDay(
                                    hour: int.parse(
                                        notification['Pukul'].split(':')[0]),
                                    minute: int.parse(
                                        notification['Pukul'].split(':')[1]),
                                  );

                                  final sekarang = DateTime.now();
                                  final pukulSekarang = TimeOfDay.now();

                                  return userId == '909' &&
                                      (tanggal.isBefore(sekarang) ||
                                          (tanggal.isAtSameMomentAs(sekarang) &&
                                              (pukul.hour <
                                                      pukulSekarang.hour ||
                                                  (pukul.hour ==
                                                          pukulSekarang.hour &&
                                                      pukul.minute <=
                                                          pukulSekarang
                                                              .minute))));
                                }).toList();

                                final notification =
                                    filteredNotifications[index];
                                final notificationId = notification['id'];
                                final isClicked =
                                    clickedNotifications[notificationId] ??
                                        false;

                                return GestureDetector(
                                  onTap: () {
                                    markNotificationAsClicked(notificationId);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ClientNotificationDetailPage(
                                          token: widget.token,
                                          notificationId:
                                              int.parse(notificationId),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    margin: EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: isClicked
                                          ? Colors.white
                                          : Color.fromARGB(255, 152, 255, 163),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.16),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: SizedBox(
                                            height: 56,
                                            width: 56,
                                            child: Image.network(
                                              '$server/api/v1/${notification['Thumbnail']}',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   'User Id: ${notification['UserID']}',
                                              //   style: LText.labelDataTitle(),
                                              // ),
                                              Text(
                                                notification['Judul'],
                                                style: LText.labelDataTitle(),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                      Icons.date_range_outlined,
                                                      size: 16),
                                                  SizedBox(width: 4),
                                                  Text(
                                                      '${notification['Tanggal']}'),
                                                  SizedBox(width: 12),
                                                  Icon(
                                                      Icons
                                                          .access_alarm_outlined,
                                                      size: 16),
                                                  SizedBox(width: 4),
                                                  Text(
                                                      '${notification['Pukul']}'),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${notification['Message']}',
                                                style: LText.description(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
                  ? Center(child: Text(errorMessage))
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              reverse:
                                  true, // Membalikkan urutan item di ListView
                              itemCount: notifications.where((notification) {
                                final userId = notification['UserID'];
                                final tanggal = DateTime.parse(notification[
                                    'Tanggal']); // Pastikan format tanggal sesuai
                                final pukul = TimeOfDay(
                                  hour: int.parse(
                                      notification['Pukul'].split(':')[0]),
                                  minute: int.parse(
                                      notification['Pukul'].split(':')[1]),
                                );

                                final sekarang = DateTime.now();
                                final pukulSekarang = TimeOfDay.now();

                                // Filter berdasarkan UserID, Tanggal, dan Pukul
                                return userId == '$currentUserId' &&
                                    (tanggal.isBefore(sekarang) ||
                                        (tanggal.isAtSameMomentAs(sekarang) &&
                                            (pukul.hour < pukulSekarang.hour ||
                                                (pukul.hour ==
                                                        pukulSekarang.hour &&
                                                    pukul.minute <=
                                                        pukulSekarang
                                                            .minute))));
                              }).length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                // Filter ulang untuk mendapatkan daftar notifikasi yang sesuai
                                final filteredNotifications =
                                    notifications.where((notification) {
                                  final userId = notification['UserID'];
                                  final tanggal =
                                      DateTime.parse(notification['Tanggal']);
                                  final pukul = TimeOfDay(
                                    hour: int.parse(
                                        notification['Pukul'].split(':')[0]),
                                    minute: int.parse(
                                        notification['Pukul'].split(':')[1]),
                                  );

                                  final sekarang = DateTime.now();
                                  final pukulSekarang = TimeOfDay.now();

                                  return userId == '$currentUserId' &&
                                      (tanggal.isBefore(sekarang) ||
                                          (tanggal.isAtSameMomentAs(sekarang) &&
                                              (pukul.hour <
                                                      pukulSekarang.hour ||
                                                  (pukul.hour ==
                                                          pukulSekarang.hour &&
                                                      pukul.minute <=
                                                          pukulSekarang
                                                              .minute))));
                                }).toList();

                                final notification =
                                    filteredNotifications[index];
                                final notificationId = notification['id'];
                                final isClicked =
                                    clickedNotifications[notificationId] ??
                                        false;

                                return GestureDetector(
                                  onTap: () {
                                    markNotificationAsClicked(notificationId);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ClientNotificationDetailPage(
                                          token: widget.token,
                                          notificationId:
                                              int.parse(notificationId),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    margin: EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      color: isClicked
                                          ? Colors.white
                                          : Colors.blueAccent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.16),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: SizedBox(
                                            height: 56,
                                            width: 56,
                                            child: Image.network(
                                              '$server/api/v1/${notification['Thumbnail']}',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(
                                              //   'User Id: ${notification['UserID']}',
                                              //   style: LText.labelDataTitle(),
                                              // ),
                                              Text(
                                                notification['Judul'],
                                                style: LText.labelDataTitle(),
                                              ),
                                              SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                      Icons.date_range_outlined,
                                                      size: 16),
                                                  SizedBox(width: 4),
                                                  Text(
                                                      '${notification['Tanggal']}'),
                                                  SizedBox(width: 12),
                                                  Icon(
                                                      Icons
                                                          .access_alarm_outlined,
                                                      size: 16),
                                                  SizedBox(width: 4),
                                                  Text(
                                                      '${notification['Pukul']}'),
                                                ],
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${notification['Message']}',
                                                style: LText.description(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
        ]),
      ),
    );
  }
}
