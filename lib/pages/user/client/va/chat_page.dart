import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/controller/new_chat_controller.dart';
import 'package:letter_a/pages/user/client/hire/will_hire_alert.dart';
import 'package:letter_a/pages/user/client/home/home_page.dart';
import 'package:letter_a/pages/user/client/main_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/checkbox_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';
import 'package:letter_a/controller/config.dart';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class VAChatPage extends StatefulWidget {
  final String role;
  final String vaID;
  final String chatId;
  final String userId;
  final String userPhoto;
  final String userName;
  final String lawanBicara;
  final String lawanBicaraPhoto;
  final String? textMessage;
  VAChatPage({
    required this.role,
    required this.vaID,
    required this.chatId,
    required this.userId,
    required this.userPhoto,
    required this.userName,
    required this.lawanBicara,
    required this.lawanBicaraPhoto,
    this.textMessage,
    super.key,
  });

  @override
  State<VAChatPage> createState() => _VAChatPageState();
}

class _VAChatPageState extends State<VAChatPage> {
  late String role;
  List<types.Message> _messages = [];
  late types.User _user;
  // late types.User _user; // Menggunakan late untuk menunda inisialisasi
  bool _isLoading = true; // Mulai dengan true jika data sedang dimuat
  bool _isChatEmpty = false;
  bool _isNewChat = false;
  final NewChatService newChatService = NewChatService();
  String _chatId = '';

  @override
  void initState() {
    super.initState();
    _chatId = widget.chatId;
    role = widget.role;
    inisiasi();
  }

  Future<void> inisiasi() async {
    await setUser();
    await _checkIsNewChat();
    await _loadMessages();
  }

  Future<void> setUser() async {
    _user = types.User(
      id: '${widget.userId}',
    );
  }

  Future<void> _checkIsNewChat() async {
    if (widget.chatId == '') {
      setState(() {
        _isNewChat = true;
      });
    }
    String? newChatId = await newChatService.createChatRoom(
      user1Id: '${widget.userId}', // Ganti dengan ID user 1 yang valid
      user2Id: '${widget.vaID}', // Ganti dengan ID user 2 yang valid
      context: context,
    );

    print('==== $newChatId');

    if (newChatId != null) {
      // Jika room berhasil dibuat, gunakan chatId di halaman lain
      setState(() {
        _isNewChat = false;
        _chatId = '$newChatId';
      });
      print('${widget.userId}');
      print('${widget.vaID}');
    }
  }

  Future<void> _loadMessages() async {
    //await _checkIsNewChat();
    final response = await http.get(
      Uri.parse('${apiBaseUrl}get-messages.php?chat_id=${_chatId}'),
    );

    if (response.statusCode == 200) {
      print('///${jsonDecode(response.body)['data']}');
      final responseBody = jsonDecode(response.body);

      if (responseBody['status'] == 'error') {
        setState(() {
          _isLoading = false;
        });
        if (responseBody['message'] == 'chat_id is required') {
          print('New chat');
          setState(() {
            _isNewChat = true;
          });
        }
        // Jika respons berstatus error, munculkan Snackbar
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(responseBody['message']),
        //     backgroundColor: Colors.red,
        //   ),
        // );
      } else {}

      final List<dynamic> messagesJson = jsonDecode(response.body)['data'];
      //print("${messagesJson[0]}");

      setState(() {
        _isLoading = false;
      });

      if (messagesJson.isNotEmpty) {
        final List<types.Message> messages = messagesJson.map((json) {
          final messageJson = json as Map<String, dynamic>;

          // Tentukan jenis pesan berdasarkan 'type'
          switch (messageJson['type']) {
            case 'text':
              return types.TextMessage(
                author: types.User(
                  id: messageJson['author']['id'] as String,
                  firstName: "${messageJson['author']['firstName'] as String}" +
                      " - ${DateFormat('dd-MM-yyyy - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch))}" +
                      " ${messageJson['author']['imageUrl']}",
                  imageUrl: (messageJson['author']['imageUrl'] != '' &&
                          messageJson['author']['imageUrl'] != null)
                      ? messageJson['author']['imageUrl'] as String
                      : null,
                ),
                createdAt: DateTime.fromMillisecondsSinceEpoch(
                        messageJson['createdAt'])
                    .millisecondsSinceEpoch,
                id: messageJson['id'] as String,
                text: messageJson['text'] as String,
              );
            case 'image':
              return types.ImageMessage(
                author: types.User(
                  id: messageJson['author']['id'] as String,
                  firstName: "${messageJson['author']['firstName'] as String}" +
                      " - ${DateFormat('dd-MM-yyyy - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch))}" +
                      " ${messageJson['author']['imageUrl']}",
                  imageUrl: (messageJson['author']['imageUrl'] != '' &&
                          messageJson['author']['imageUrl'] != null)
                      ? messageJson['author']['imageUrl'] as String
                      : null,
                ),
                createdAt: DateTime.fromMillisecondsSinceEpoch(
                        messageJson['createdAt'])
                    .millisecondsSinceEpoch,
                id: messageJson['id'] as String,
                name: messageJson['name'] as String,
                uri: 'https://letter-a.co.id/api/v1/chattings/' +
                    '${messageJson['uri'] as String}',
                size: int.parse('${messageJson['size']}'),
                width: double.parse('${messageJson['width']}'),
                height: double.parse('${messageJson['height']}'),
              );
            case 'file':
              return types.FileMessage(
                author: types.User(
                  id: messageJson['author']['id'] as String,
                  firstName: "${messageJson['author']['firstName'] as String}" +
                      " - ${DateFormat('dd-MM-yyyy - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch))}" +
                      " ${messageJson['author']['imageUrl']}",
                  imageUrl: (messageJson['author']['imageUrl'] != '' &&
                          messageJson['author']['imageUrl'] != null)
                      ? messageJson['author']['imageUrl'] as String
                      : null,
                ),
                createdAt: DateTime.fromMillisecondsSinceEpoch(
                        messageJson['createdAt'])
                    .millisecondsSinceEpoch,
                id: messageJson['id'] as String,
                name: messageJson['name'] as String,
                uri: 'https:letter-a.co.id/api/v1/chattings/' +
                    '${messageJson['uri'] as String}',
                size: messageJson['size'] as int,
                mimeType: messageJson['mimeType'] as String,
              );
            default:
              return types.TextMessage(
                author: types.User(
                  id: messageJson['author']['id'] as String,
                  firstName: "${messageJson['author']['firstName'] as String}" +
                      " - ${DateFormat('dd-MM-yyyy - HH:mm').format(DateTime.fromMillisecondsSinceEpoch(DateTime.fromMillisecondsSinceEpoch(messageJson['createdAt']).millisecondsSinceEpoch))}" +
                      " ${messageJson['author']['imageUrl']}",
                  imageUrl: (messageJson['author']['imageUrl'] != '' &&
                          messageJson['author']['imageUrl'] != null)
                      ? messageJson['author']['imageUrl'] as String
                      : null,
                ),
                createdAt: DateTime.fromMillisecondsSinceEpoch(
                        messageJson['createdAt'])
                    .millisecondsSinceEpoch,
                id: messageJson['id'] as String,
                text: messageJson['text'] as String,
              );
          }
        }).toList();

        setState(() {
          _messages = messages.reversed.toList();
        });
      } else {
        // Handle empty messages
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something's error"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something's error"),
          backgroundColor: Colors.red,
        ),
      );
      throw Exception('Failed to load messages');
    }
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _handleSendPressed(types.PartialText message) async {
    if (_isNewChat == true) {
      String? newChatId = await newChatService.createChatRoom(
        user1Id: '${widget.userId}', // Ganti dengan ID user 1 yang valid
        user2Id: '${widget.vaID}', // Ganti dengan ID user 2 yang valid
        context: context,
      );

      if (newChatId != null) {
        // Jika room berhasil dibuat, gunakan chatId di halaman lain

        setState(() {
          _isNewChat = false;
          _chatId = '$newChatId';
        });
      }
    }

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    try {
      final response = await http.post(
        Uri.parse('${apiBaseUrl}send-message.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'chat_id': _chatId,
          'author_id': _user.id,
          'author_first_name': widget.userName,
          'author_last_name': '',
          'author_image_url': widget.userPhoto,
          'text': message.text,
          'type': 'text', // Jenis pesan, 'text' dalam hal ini
          'status': 'sent', // Status pesan, 'sent' berarti pesan sudah dikirim
          'created_at': DateTime.now().millisecondsSinceEpoch,
          'created_at_column':
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'uri': '', // URL untuk file jika ada (kosong jika tidak)
          'name': '', // Nama file jika ada (kosong jika tidak)
          'size': 0, // Ukuran file jika ada (0 jika tidak)
          'mime_type': '', // MIME type file jika ada (kosong jika tidak)
          'width': 0, // Lebar file jika ada (0 jika tidak)
          'height': 0, // Tinggi file jika ada (0 jika tidak)
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody['status'] == 'success') {
          print('Message sent successfully: ${responseBody['data']['id']}');
          _addMessage(textMessage);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Something's error"),
              backgroundColor: Colors.red,
            ),
          );
          throw Exception('Failed to send message: ${responseBody['message']}');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something's error"),
            backgroundColor: Colors.red,
          ),
        );
        throw Exception('Failed to send message');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something's error"),
          backgroundColor: Colors.red,
        ),
      );
      // Tangani kesalahan pengiriman pesan di sini
      print('Error sending message: $e');
      // Tampilkan pesan kesalahan kepada pengguna jika diperlukan
    }
  }

  void _handleAttachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    //print('lihat gambar');
    // Cari index dari message berdasarkan id
    final index = _messages.indexWhere((element) => element.id == message.id);

    // Pastikan index ditemukan
    if (index != -1) {
      // Pastikan elemen yang ditemukan adalah TextMessage
      if (_messages[index] is types.TextMessage) {
        final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
          previewData: previewData,
        );

        // Update pesan di dalam _messages
        setState(() {
          _messages[index] = updatedMessage;
        });
      } else {
        // Log atau tangani jika tipe pesan tidak sesuai
        print('Pesan dengan id: ${message.id} bukan TextMessage');
      }
    } else {
      // Log atau tangani jika pesan tidak ditemukan
      print('Pesan dengan id: ${message.id} tidak ditemukan');
    }
  }

  void _handleImageSelection() async {
    if (_isNewChat == true) {
      String? newChatId = await newChatService.createChatRoom(
        user1Id: '${widget.userId}', // Ganti dengan ID user 1 yang valid
        user2Id: '${widget.vaID}', // Ganti dengan ID user 2 yang valid
        context: context,
      );

      if (newChatId != null) {
        // Jika room berhasil dibuat, gunakan chatId di halaman lain

        setState(() {
          _isNewChat = false;
          _chatId = '$newChatId';
        });
      }
    }

    print("==> ${widget.chatId}");
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();

      // Cek ukuran file
      final fileSizeMB = bytes.length / (1024 * 1024); // Konversi byte ke MB
      if (fileSizeMB > 25) {
        // Ukuran file lebih dari 25 MB
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File size exceeds the 25MB limit.'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Keluar dari fungsi jika ukuran file terlalu besar
      }

      final image = await decodeImageFromList(bytes);
      final fileExtension = result.name.split('.').last.toLowerCase();
      final mediaType = _getMediaType(fileExtension);
      final uri = Uri.parse('${apiBaseUrl}send-message-image.php');
      final request = http.MultipartRequest('POST', uri);

      request.fields['chat_id'] = '${_chatId}';
      request.fields['author_id'] = '${_user.id}';
      request.fields['author_first_name'] = '${widget.userName}';
      request.fields['author_last_name'] = '';
      request.fields['imageUrl'] = '${widget.userPhoto}';
      request.fields['type'] = 'image';
      request.fields['status'] = 'sent';
      request.fields['created_at'] =
          DateTime.now().millisecondsSinceEpoch.toString();
      request.fields['name'] = '${result.name}';
      //  request.fields['name'] =
      // '${DateTime.now().millisecondsSinceEpoch}' + '${result.name}';
      request.fields['size'] = bytes.length.toString();
      request.fields['mime_type'] =
          mediaType.toString(); // Tipe MIME dari file gambar
      request.fields['width'] = image.width.toString();
      request.fields['height'] = image.height.toString();

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: result.name,
          contentType: mediaType,
        ),
      );

      // Membuat pesan gambar
      final _message = types.ImageMessage(
        author: _user, // Data user pengirim
        createdAt: DateTime.now().millisecondsSinceEpoch, // Waktu pesan dibuat
        id: const Uuid().v4(), // ID unik untuk pesan
        //mimeType: mediaType, // Tipe MIME gambar
        name: result.name, // Nama file gambar
        size: bytes.length, // Ukuran file dalam byte
        uri: result.path, // Lokasi file gambar
        width: null, // Anda bisa menambahkan lebar gambar jika ingin
        height: null, // Anda bisa menambahkan tinggi gambar jika ingin
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        print('chat_id: ${widget.chatId}');
        print('author_id: ${_user.id}');
        print('author_first_name: ${widget.userName}');
        print('author_last_name: ');
        print('imageUrl: ${widget.userPhoto}');
        print('type: image');
        print('status: sent');
        print('created_at: ${DateTime.now().millisecondsSinceEpoch}');
        print('name: ${result.name}');
        print('size: ${bytes.length}');
        print('mime_type: ${mediaType.toString()}');
        print('width: ${image.width}');
        print('height: ${image.height}');

        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        if (jsonResponse['status'] == 'success') {
          print('Message sent successfully: ${jsonResponse['data']['id']}');
          _addMessage(_message);
        } else {
          print('Error sending message: ${jsonResponse['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(jsonResponse['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something's error"),
            backgroundColor: Colors.red,
          ),
        );
        print('Failed to send message: ${response.statusCode}');
      }
    }
  }

// Menentukan tipe MIME berdasarkan ekstensi file
  MediaType _getMediaType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      default:
        return MediaType('application', 'octet-stream'); // Default fallback
    }
  }

  void _handleFileSelection() async {
    if (_isNewChat == true) {
      String? newChatId = await newChatService.createChatRoom(
        user1Id: '${widget.userId}', // Ganti dengan ID user 1 yang valid
        user2Id: '${widget.vaID}', // Ganti dengan ID user 2 yang valid
        context: context,
      );

      if (newChatId != null) {
        // Jika room berhasil dibuat, gunakan chatId di halaman lain

        setState(() {
          _isNewChat = false;
          _chatId = '$newChatId';
        });
      }
    }

    try {
      // Ambil file yang dipilih pengguna
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      // Cek apakah file dipilih dan path file tidak null
      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        final bytes = file.bytes ?? await File(file.path!).readAsBytes();

// Cek ukuran file
        final fileSizeMB = bytes.length / (1024 * 1024); // Konversi byte ke MB
        if (fileSizeMB > 25) {
          // Ukuran file lebih dari 25 MB
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File size exceeds the 25MB limit.'),
              backgroundColor: Colors.red,
            ),
          );
          return; // Keluar dari fungsi jika ukuran file terlalu besar
        }

        // Mendapatkan ekstensi file dan menentukan tipe MIME
        final fileExtension = file.extension?.toLowerCase() ?? '';
        final mediaType = _getMediaFileType(file.path!);
        final uri = Uri.parse('${apiBaseUrl}send-message-file.php');
        final request = http.MultipartRequest('POST', uri);

        // Menambahkan fields yang dibutuhkan ke dalam request
        request.fields['chat_id'] = '${_chatId}';
        request.fields['author_id'] = '${_user.id}';
        request.fields['author_first_name'] = '${widget.userName}';
        request.fields['author_last_name'] = '';
        request.fields['imageUrl'] = '${widget.userPhoto}';
        request.fields['type'] = 'file';
        request.fields['status'] = 'sent';
        request.fields['created_at'] =
            DateTime.now().millisecondsSinceEpoch.toString();
        request.fields['name'] = file.name;
        request.fields['size'] = bytes.length.toString();
        request.fields['mime_type'] = mediaType.toString();

        // Menambahkan file ke dalam request sebagai multipart
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: file.name,
            contentType: mediaType,
          ),
        );

        // Mengirim pesan lokal sementara
        final messageFile = types.FileMessage(
          author: _user,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: const Uuid().v4(),
          mimeType: lookupMimeType(file.path!) ?? 'application/octet-stream',
          name: file.name,
          size: file.size,
          uri: file.path!,
        );

        // Mengirim request
        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final jsonResponse = json.decode(responseBody);

          if (jsonResponse['status'] == 'success') {
            print('Message sent successfully: ${jsonResponse['data']['id']}');
            _addMessage(messageFile);
          } else if (jsonResponse['status'] == 'error') {
            print('Message sent successfully: ${jsonResponse['message']}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(jsonResponse['message']),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            print('Error sending message: ${jsonResponse['message']}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(jsonResponse['message']),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Something's error"),
              backgroundColor: Colors.red,
            ),
          );
          print('Failed to send message: ${response.statusCode}');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something's error"),
            backgroundColor: Colors.red,
          ),
        );
        print('No file selected or invalid file path.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something's error"),
          backgroundColor: Colors.red,
        ),
      );
      print('Error selecting file: $e');
    }
  }

  MediaType _getMediaFileType(String filePath) {
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    final type = mimeType.split('/')[0];
    final subtype = mimeType.split('/')[1];
    return MediaType(type, subtype);
  }

  void _handleMessageTap(BuildContext context, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      // Konversi message.uri menjadi Uri
      final uri = Uri.parse(message.uri);

      // Jika URI adalah URL, buka di browser
      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);

          // Pastikan isLoading adalah parameter yang valid
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: false,
          );

          final updatedStopMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          // Menunda pengaturan isLoading ke false setelah 3 detik
          Future.delayed(Duration(seconds: 15), () {
            setState(() {
              _messages[index] =
                  (_messages[index] as types.FileMessage).copyWith(
                isLoading: false,
              );
            });
          });

          // Jika URL adalah link file, unduh file dan simpan ke penyimpanan lokal
          final response = await http.get(uri);
          final bytes = response.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            setState(() {
              _messages[index] =
                  (_messages[index] as types.FileMessage).copyWith(
                isLoading: false,
              );
            });
            await file.writeAsBytes(bytes);
          }

          // Buka file lokal
          await OpenFilex.open(localPath);
        } catch (e) {
          // Jika terjadi error
          print('Error opening file: $e');

          // Jika tidak bisa membuka file lokal, coba buka di browser
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            throw 'Could not launch ${message.uri}';
          }
        }
      } else {
        // Buka file lokal jika tidak berformat URL
        await OpenFilex.open(localPath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: LColors.primary),
      ),
      home: Scaffold(
        backgroundColor: LColors.background,
        appBar: LAppBar(
          title: "${widget.lawanBicara}",
          bgColor: LColors.primary,
          actions: <Widget>[
            widget.role == 'va'
                ? SizedBox()
                : RoundedElevatedButtonWhite(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MainPage()),
                      // );
                      _alertHire(context);
                    },
                    text: 'HIRE',
                  ),
          ],
          leading: SizedBox(
            width: 200,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/icon_back.svg',
                    width: 32, // atur lebar gambar sesuai kebutuhan Anda
                    height: 32, // atur tinggi gambar sesuai kebutuhan Anda
                  ),
                ),
                SizedBox(width: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 32, // atur lebar gambar sesuai kebutuhan Anda
                    height: 32, // atur tinggi gambar sesuai kebutuhan Anda
                    child: Image.network(
                      widget.lawanBicaraPhoto != '404'
                          ? 'https://letter-a.co.id/api/v1/${widget.lawanBicaraPhoto}'
                          : 'https://cdn.pixabay.com/photo/2021/10/11/00/59/warning-6699085_1280.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: _isLoading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Chat(
                theme: DefaultChatTheme(
                  //inputBackgroundColor: Colors.red,
                  // inputSurfaceTintColor: Colors.purple,
                  primaryColor: Colors.green,
                  sendButtonIcon: Container(
                    padding: EdgeInsets.fromLTRB(8, 6, 4, 6),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(16)),
                    child: Icon(
                      Icons.send, // Icon pesawat untuk tombol kirim
                      color: Colors.white, // Warna ikon
                      size: 28, // Ukuran ikon
                    ),
                  ),
                  inputPadding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 12), // Padding pada kotak input teks
                ),
                messages: _messages,
                onAttachmentPressed: _handleAttachmentPressed,
                // onAttachmentPressed: () async {
                //   final picker = ImagePicker();
                //   final pickedFile =
                //       await picker.pickImage(source: ImageSource.gallery);
                //   if (pickedFile != null) {
                //     final file = File(pickedFile.path);
                //     final directory = await getApplicationDocumentsDirectory();
                //     final newFile = await file.copy(
                //         '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png');
                //     // Implementasi untuk mengirim file
                //   }
                // },
                onMessageTap: _handleMessageTap,
                //onMessageTap: (context, message) {
                // Implementasi untuk tap pesan
                //},
                onPreviewDataFetched: _handlePreviewDataFetched,
                //onPreviewDataFetched: (message, previewData) {
                // Implementasi untuk preview data
                //},
                onSendPressed: _handleSendPressed,
                showUserAvatars: true,
                showUserNames: true,
                user: _user,
              ),
      ),
    );
  }

  void _alertHire(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return willHireVA(
          vaID: '${widget.vaID}',
        );
      },
    );
  }
}
