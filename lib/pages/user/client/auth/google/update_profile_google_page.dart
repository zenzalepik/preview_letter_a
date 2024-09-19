import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letter_a/pages/user/client/auth/google/login_process_google_page.dart';
import 'package:letter_a/pages/user/client/auth/google/register_google_page.dart';
import 'package:letter_a/pages/user/client/auth/google/user_google_model.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

const String checkApiUrl = 'https://letter-a.co.id/api/v1/auth/check_data.php';
const String updateApiUrl =
    'https://letter-a.co.id/api/v1/auth/update_user.php';

class ProfilePage extends StatefulWidget {
  final UserProfile userProfile;
  // final String? idUser;
  // final String? emailUser;
  ProfilePage({
    // this.idUser,
    // this.emailUser,
    required this.userProfile,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _placeOfBirthController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _dateOfBirthController = TextEditingController(text: '1999-01-01');
  final _ijazahController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _linkedInController = TextEditingController();

  bool _loading = false;
  XFile? _webImage; // For web
  File? _imageFile;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _inisiasi() async {
    setState(() {
      // _idController.text = '${widget.userProfile.id}';
      _emailController.text = '${widget.userProfile.email}';
    });
    print('${_emailController.text}');
  }

  Future<void> _loadUserProfile() async {
    await _inisiasi();
    setState(() {
      _loading = true;
    });

    try {
      final result = await fetchUserProfile(_emailController.text);

      print('Hasil Load User${result}');
      if (result['status'] == '001') {
        final data = result['data'];
        print('Update data udulu yuk ${result['message']}');
        setState(() {
          _idController.text = '${data['id'] ?? ''}';
          _passwordController.text = '${data['password'] ?? ''}';
          _fullNameController.text = '${data['fullName'] ?? ''}';
          _placeOfBirthController.text = '${data['placeOfBirth'] ?? ''}';
          _cityController.text = '${data['city'] ?? ''}';
          _provinceController.text = '${data['province'] ?? ''}';
          _dateOfBirthController.text = '${data['dateOfBirth'] ?? ''}';
          _ijazahController.text = '${data['ijazah'] ?? ''}';
          _whatsappController.text = '${data['whatsapp'] ?? ''}';
          _facebookController.text = '${data['facebook'] ?? ''}';
          _instagramController.text = '${data['instagram'] ?? ''}';
          _linkedInController.text = '${data['linkedIn'] ?? ''}';
        });
      } else if (result['status'] == '201') {
        final data = result['data'];
        setState(() {
          _idController.text = '${data['id'] ?? ''}';
          _passwordController.text = '${data['password'] ?? ''}';
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginBerhasil(
                emailClient: '${_emailController.text}',
                passwordClient: '${_passwordController.text}'),
          ),
        );
        print('kamu sudah terdaftar ${result['message']}');
      } else if (result['status'] == '404') {
        print('server bingung ${result['message']}');
        print('++${_emailController.text}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserFormPage(userProfile: widget.userProfile),
          ),
        );
      } else {
        final data = result['data'];
        setState(() {
          _passwordController.text = '${data['password'] ?? ''}';
          _fullNameController.text = '${data['fullName'] ?? ''}';
          _placeOfBirthController.text = '${data['placeOfBirth'] ?? ''}';
          _cityController.text = '${data['city'] ?? ''}';
          _provinceController.text = '${data['province'] ?? ''}';
          _dateOfBirthController.text = '${data['dateOfBirth'] ?? ''}';
          _ijazahController.text = '${data['ijazah'] ?? ''}';
          _whatsappController.text = '${data['whatsapp'] ?? ''}';
          _facebookController.text = '${data['facebook'] ?? ''}';
          _instagramController.text = '${data['instagram'] ?? ''}';
          _linkedInController.text = '${data['linkedIn'] ?? ''}';
        });
        print('/////////////datapassword ?? ${data['password'] ?? ''}');
        print('${result['message']}');

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(result['message'])),
        // );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile(String email) async {
    // Future<Map<String, dynamic>> fetchUserProfile(String id, String email) async {
    final response = await http.get(
      Uri.parse('$checkApiUrl?email=$email'),
      // Uri.parse('$checkApiUrl?id=$id&email=$email'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        if (kIsWeb) {
          // For web, we can use the XFile directly and read as bytes
          _webImage = pickedImage;
          pickedImage.readAsBytes().then((bytes) {
            _base64Image = base64Encode(bytes);
          });
        } else {
          // For mobile platforms, use File
          _imageFile = File(pickedImage.path);
          _base64Image = base64Encode(_imageFile!.readAsBytesSync());
        }
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });

    try {
      final updates = {
        'password': _passwordController.text,
        'fullName': _fullNameController.text,
        //'email': _emailController.text,
        'placeOfBirth': _placeOfBirthController.text,
        'city': _cityController.text,
        'province': _provinceController.text,
        'dateOfBirth': _dateOfBirthController.text,
        'ijazah': _ijazahController.text,
        'whatsapp': _whatsappController.text,
        'facebook': _facebookController.text,
        'instagram': _instagramController.text,
        'linkedIn': _linkedInController.text,
      };

      await updateUserProfile(
          _emailController.text,
          // await updateUserProfile(_idController.text, _emailController.text,
          updates,
          _webImage,
          _imageFile);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> updateUserProfile(
      String email,
      // Future<void> updateUserProfile(String id, String email,
      Map<String, dynamic> updates,
      XFile? webImage,
      File? imageFile) async {
    try {
      var uri = Uri.parse(updateApiUrl);
      var request = http.MultipartRequest('POST', uri);

      // Menambahkan field non-file
      // request.fields['id'] = id;
      request.fields['email'] = email;

      // Menambahkan field dari updates, memastikan semua nilai adalah string
      updates.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Menambahkan file jika ada
      if (imageFile != null) {
        String mimeType = getMimeType(imageFile.path);
        request.files.add(
          http.MultipartFile(
            'profileImage',
            imageFile.readAsBytes().asStream(),
            imageFile.lengthSync(),
            filename: imageFile.uri.pathSegments.last,
            contentType: MediaType.parse(mimeType),
          ),
        );
      } else if (webImage != null) {
        String mimeType = getMimeType(webImage.name);
        request.files.add(
          http.MultipartFile.fromBytes(
            'profileImage',
            await webImage.readAsBytes(),
            filename: webImage.name,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      // Mengirim permintaan
      var response = await request.send();

      // Mengambil respons dari server
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        final responseData = jsonDecode(responseBody);
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: LColors.primary),
          );

          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text('Profile updated successfully')),
          // );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginBerhasil(
                  emailClient: '${_emailController.text}',
                  passwordClient: '${_passwordController.text}'),
            ),
          );
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to update data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Update failed: $e');
    }
  }

  String getMimeType(String filename) {
    return lookupMimeType(filename) ?? 'application/octet-stream';
  }

  Widget _buildImageDisplay() {
    if (_base64Image != null) {
      if (kIsWeb && _webImage != null) {
        _convertBase64ToFile();
        return Image.memory(
          base64Decode(_base64Image!),
          fit: BoxFit.cover,
          // width: 100,
          // height: 100,
        );
      } else if (!kIsWeb && _imageFile != null) {
        return Image.file(
          _imageFile!,
          fit: BoxFit.cover,
          // width: 100,
          // height: 100,
        );
      }
    }
    return Text('No image selected');
  }

  String? _filePathPhotoProfile;
  File? _filePhotoProfile;

  Future<void> _convertBase64ToFile() async {
    // Decode Base64 string
    Uint8List bytes = base64Decode(_base64Image!);

    // Get the temporary directory of the app
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/image.jpg';

    // Create a file and write the bytes to it
    final file = File(filePath);
    await file.writeAsBytes(bytes);

    setState(() {
      _filePathPhotoProfile = filePath;
      _filePhotoProfile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(''),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: _loading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      padding: EdgeInsets.all(16),
                                      decoration:
                                          BoxDecoration(color: LColors.primary),
                                      child: Text(
                                          "Let's complete your personal data first!",
                                          style:
                                              LText.H3(color: LColors.white))),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            "Upload again your photo profile, please",
                                            style: LText.subtitle(
                                                color: LColors.black)),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Visibility(
                                                        visible: true,
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        24),
                                                            child: SizedBox(
                                                                width: 280,
                                                                height: 280,
                                                                child:
                                                                    _buildImageDisplay())),
                                                      ),
                                                      SizedBox(
                                                        width: 280,
                                                        height: 280,
                                                        child: DottedBorder(
                                                          borderType:
                                                              BorderType.RRect,
                                                          radius:
                                                              Radius.circular(
                                                                  24),
                                                          strokeWidth: 2,
                                                          color:
                                                              LColors.primary,
                                                          dashPattern: [
                                                            8,
                                                            4
                                                          ], // panjang garis dan spasi

                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    24),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          24),
                                                              color: Color
                                                                  .fromARGB(
                                                                      55,
                                                                      0,
                                                                      152,
                                                                      15),
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                    height: 40),
                                                                Icon(
                                                                  Icons
                                                                      .image_outlined,
                                                                  color: _base64Image == null
                                                                      ? LColors
                                                                          .primary
                                                                      : LColors
                                                                          .white,
                                                                  size: 80,
                                                                ),
                                                                SizedBox(
                                                                  height: 24,
                                                                ),
                                                                IconButtonWidget(
                                                                  onPressed:
                                                                      _pickImage,
                                                                  icon:
                                                                      'icon_upload.svg',
                                                                  // color:
                                                                  text: _base64Image ==
                                                                          null
                                                                      ? 'Upload'
                                                                      : 'Change File',
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 32,
                                        ),

                                        ///
                                        ///ID
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: _idController,
                                                decoration: InputDecoration(
                                                  hintText: '',
                                                  labelText: 'ID',
                                                  border: OutlineInputBorder(),
                                                ),
                                                enabled: false,
                                              ),
                                            ),
                                          ],
                                        ),

                                        ///
                                        ///Email
                                        GapCInput(),
                                        TextFormField(
                                          controller: _emailController,
                                          decoration: InputDecoration(
                                              labelText: 'Email'),
                                          enabled: false,
                                        ),

                                        ///
                                        ///Password
                                        GapCInput(),
                                        TextFormField(
                                          controller: _passwordController,
                                          obscureText:
                                              true, // Mengatur input sebagai kata sandi
                                          decoration: InputDecoration(
                                            hintText: '********',
                                            labelText: 'Password',
                                            border: OutlineInputBorder(),
                                          ),
                                          enabled: true,
                                        ),

                                        ///
                                        ///Full Name
                                        GapCInput(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: _fullNameController,
                                                decoration: InputDecoration(
                                                  labelText: 'Full Name',
                                                  hintText: 'Budi Budiman',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        ///
                                        ///Place of Birth
                                        GapCInput(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    _placeOfBirthController,
                                                decoration: InputDecoration(
                                                  labelText: 'Place of Birth',
                                                  hintText: 'Surabaya',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        ///
                                        ///City
                                        GapCInput(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: _cityController,
                                                decoration: InputDecoration(
                                                  labelText: 'City',
                                                  hintText: 'Malang',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        ///
                                        ///Province
                                        GapCInput(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: _provinceController,
                                                decoration: InputDecoration(
                                                  labelText: 'Province',
                                                  hintText: 'Est Java',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        ///
                                        ///Date of Birth
                                        GapCInput(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    _dateOfBirthController,
                                                decoration: InputDecoration(
                                                  labelText: 'Date of Birth',
                                                  hintText: '1999-01-01',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        ///
                                        ///Ijazah
                                        GapCInput(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: _ijazahController,
                                                decoration: InputDecoration(
                                                  labelText: 'Ijazah',
                                                  hintText:
                                                      'Bachelor Degree of Data Science',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        ///
                                        ///Whatsapp
                                        GapCInput(),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: TextFormField(
                                                    controller:
                                                        _whatsappController,
                                                    decoration: InputDecoration(
                                                      labelText: 'WhatsApp',
                                                      hintText: '6285720075826',
                                                      border:
                                                          OutlineInputBorder(),
                                                    ))),
                                          ],
                                        ),

                                        ///
                                        ///Facebook
                                        GapCInput(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: _facebookController,
                                                decoration: InputDecoration(
                                                  labelText: 'Facebook',
                                                  hintText: '@facebook_account',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        ///
                                        ///Instagram
                                        GapCInput(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller:
                                                    _instagramController,
                                                decoration: InputDecoration(
                                                  labelText: 'Instagram',
                                                  hintText:
                                                      '@instagram_account',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        ///
                                        ///LinkedIn
                                        GapCInput(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                controller: _linkedInController,
                                                decoration: InputDecoration(
                                                  labelText: 'LinkedIn',
                                                  hintText: '@linkedin_account',
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: RoundedElevatedButton(
                                                onPressed: _updateProfile,
                                                text: 'Update Profile',
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            ///     SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
