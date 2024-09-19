import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/client/auth/sign_up_personal_data_page.dart';
import 'package:letter_a/pages/user/client/hire/hired_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class PaymentPage extends StatefulWidget {
  final String vaID;
  const PaymentPage({super.key, required this.vaID});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userIdController = TextEditingController();
  TextEditingController vaidController =
      TextEditingController(text: 'checking');
  TextEditingController clientIdController = TextEditingController();
  TextEditingController statusController =
      TextEditingController(text: 'pending');
  TextEditingController tanggalPengajuanController = TextEditingController();
  TextEditingController tanggalMulaiController = TextEditingController();
  TextEditingController tanggalSelesaiController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController ratePriceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final rateMoney = MoneyMaskedTextController(
    decimalSeparator: '',
    thousandSeparator: '.',
    precision: 0,
  );
  File? _proofFile;

  bool showPayment = false;
  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  DateTime? _selectedDateTanggalMulai;
  DateTime? _selectedDateTanggalSelesai;
  String proofSelected = '';

  @override
  void initState() {
    super.initState();
    inisiasi();
  }

  Future<void> inisiasi() async {
    await loadSharepreferences();
    if (tanggalMulaiController.text.isEmpty ||
        tanggalMulaiController.text == '') {
      setState(() {
        tanggalMulaiController.text = "$today";
        tanggalSelesaiController.text = "$today";
      });
    } else {
      setState(() {
        tanggalMulaiController.text =
            "${DateFormat('dd-MM-yyyy').format(_selectedDateTanggalMulai!)}";
        tanggalSelesaiController.text =
            "${DateFormat('dd-MM-yyyy').format(_selectedDateTanggalMulai!)}";
      });
    }
    setState(() {
      vaidController.text = '0';
      userIdController.text = '${widget.vaID}';
      statusController.text = 'pending';
      tanggalPengajuanController.text = '$today';
    });
    await printData();
  }

  Future<void> printData() async {
    print('ratePriceController ${ratePriceController.text}');
    print('userIdController ${userIdController.text}');
    print('vaidController ${vaidController.text}');
    print('clientIdController ${clientIdController.text}');
    print('statusController ${statusController.text}');
    print('tanggalPengajuanController ${tanggalPengajuanController.text}');
    print('tanggalMulaiController ${tanggalMulaiController.text}');
    print('tanggalSelesaiController ${tanggalSelesaiController.text}');
    print('titleController ${titleController.text}');
    print('descriptionController ${descriptionController.text}');
  }

  Future<void> loadSharepreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    setState(() {
      clientIdController.text = '${prefs.getString('userId') ?? ''}';
    });
    for (String key in keys) {
      final value = prefs.get(key); // Mengambil nilai dari setiap kunci
      print('Key: $key, Value: $value, Type: ${value.runtimeType}');
    }
  }

  // Fungsi untuk menampilkan DatePicker dan menyimpan hasilnya
  Future<void> _selectDateTanggalMulai(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Tanggal awal yang akan ditampilkan
      firstDate: DateTime(2000), // Batas tanggal terawal
      lastDate: DateTime(2100), // Batas tanggal terakhir
    );
    if (pickedDate != null && pickedDate != _selectedDateTanggalMulai)
      setState(() {
        _selectedDateTanggalMulai = pickedDate;
        tanggalMulaiController.text =
            '${DateFormat('yyyy-MM-dd').format(_selectedDateTanggalMulai!)}';
      });
  }

  // Fungsi untuk menampilkan DatePicker dan menyimpan hasilnya
  Future<void> _selectDateTanggalSelesai(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Tanggal awal yang akan ditampilkan
      firstDate: DateTime(2000), // Batas tanggal terawal
      lastDate: DateTime(2100), // Batas tanggal terakhir
    );
    if (pickedDate != null && pickedDate != _selectedDateTanggalSelesai)
      setState(() {
        _selectedDateTanggalSelesai = pickedDate;
        tanggalSelesaiController.text =
            '${DateFormat('yyyy-MM-dd').format(_selectedDateTanggalSelesai!)}';
      });
  }

  Future<void> _showPayment() async {
    setState(() {
      ratePriceController.text = '${rateMoney.numberValue}';
    });
    await printData();
    if (titleController.text != '' &&
        (ratePriceController.text != '0.0' &&
            ratePriceController.text != '0' &&
            ratePriceController.text != '') &&
        descriptionController.text != '') {
      setState(() {
        showPayment = true;
      });
    } else {
      showOverlaySnackBar(
          context, 'Please complete all data first', LColors.black);
    }
  }

  void showOverlaySnackBar(BuildContext context, String message, Color color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            color: color == null ? Colors.black : color,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '$message',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  Future<void> _hidePayment() async {
    setState(() {
      showPayment = false;
    });
  }

  Future<void> submitApplication() async {
    print("RatePrice: ${ratePriceController.text}"); // Debug log

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$server/api/v1/applications/api_create_application.php'),
    );

    //request.fields['UserID'] = clientIdController.text;
    request.fields['UserID'] = userIdController.text;
    request.fields['Vaid'] = 'checking';
    request.fields['ClientID'] = clientIdController.text;
    request.fields['Status'] = statusController.text;
    request.fields['TanggalPengajuan'] = tanggalPengajuanController.text;
    request.fields['TanggalMulai'] = tanggalMulaiController.text;
    request.fields['TanggalSelesai'] = tanggalSelesaiController.text;
    request.fields['Title'] = titleController.text;
    request.fields['RatePrice'] = ratePriceController.text;
    request.fields['Description'] = descriptionController.text;

    if (_proofFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('Proof', _proofFile!.path));
    }

    if (proofSelected != '') {
      final response = await request.send();
      await printData();
      print('${response.statusCode}');
      if (response.statusCode == 201) {
        showOverlaySnackBar(
            context, 'Your application has been sent', LColors.primary);

        // Tambahkan delay 2 detik
        await Future.delayed(Duration(seconds: 2));
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HiredPage(
                    userIdVa: '${userIdController.text}',
                    applicationDescription: '${descriptionController.text}',
                    applicationTitle: '${titleController.text}',
                  )),
        );
      } else {
        showOverlaySnackBar(
            context, 'Failed to create application', LColors.black);
      }
    } else {
      showOverlaySnackBar(
          context, 'Upload your proof payment first', LColors.black);
    }
  }

  Future<void> _pickProofFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _proofFile = File(pickedFile.path);
        proofSelected = 'slected';
      });
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
          title: showPayment == true ? "Payment" : "Offer Detail",
          bgColor: LColors.primary,
          actions: <Widget>[],
          leading: GestureDetector(
            onTap: () {
              showPayment == false ? Navigator.pop(context) : _hidePayment();
            },
            child: SvgPicture.asset(
              'assets/icons/icon_back.svg',
              width: 200, // atur lebar gambar sesuai kebutuhan Anda
              height: 200, // atur tinggi gambar sesuai kebutuhan Anda
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: showPayment == false
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(children: [
                    /*
                    Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(color: LColors.secondary),
                        child: Text("Upload proof of your payment to VA",
                            style: LText.H3(color: LColors.white))),
                    */
                    SizedBox(
                      height: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectDateTanggalMulai(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: tanggalMulaiController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Tanggal Mulai',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ),
                    GapCInput(),
                    GestureDetector(
                      onTap: () {
                        _selectDateTanggalSelesai(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: tanggalSelesaiController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Tanggal Selesai',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                    ),
                    GapCInput(),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    GapCInput(),
                    TextFormField(
                      controller: rateMoney,
                      decoration: InputDecoration(
                        labelText: 'Rate/Cost',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    GapCInput(),
                    TextFormField(
                      controller: descriptionController,
                      minLines: 3,
                      maxLines: 7,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    GapCInput(),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedElevatedButton(
                            onPressed: () {
                              // if (_formKey.currentState!.validate()) {
                              _showPayment();
                              // }
                            },
                            text: 'NEXT',
                          ),
                        ),
                      ],
                    ),
                  ]),
                )
              : Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(color: LColors.secondary),
                        child: Text("Upload proof of your payment to VA",
                            style: LText.H3(color: LColors.white))),
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          'Please transfer payment to your prospective VA (Andi) via the following account number:',
                                          style: LText.description()),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text('Indonesian Sharia Bank',
                                            style: LText.H5())),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text('1135356677',
                                            style: LText.H3())),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text('A.N. Andi Setia Budi',
                                            style: LText.subtitle())),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                          'Then upload your scheenshot payment by the following button:',
                                          style: LText.description()),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: DottedBorder(
                                borderType: BorderType.RRect,
                                radius: Radius.circular(24),
                                strokeWidth: 2,
                                color: LColors.primary,
                                dashPattern: [8, 4], // panjang garis dan spasi

                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Color.fromARGB(55, 0, 152, 15),
                                    image: _proofFile == null
                                        ? null
                                        : DecorationImage(
                                            opacity: 0.16,
                                            image: FileImage(_proofFile!),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/icon_file.svg',
                                        color: LColors.primary,
                                        width: 80,
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      IconButtonWidget(
                                        onPressed: _pickProofFile,
                                        icon: 'icon_upload.svg',
                                        // color:
                                        text: _proofFile == null
                                            ? 'Upload'
                                            : 'Change File',
                                      ),
                                      Text(_proofFile == null
                                          ? ''
                                          : '${p.basename(_proofFile!.path)}'),
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),
                          GapCInput(),
                          Row(
                            children: [
                              Expanded(
                                child: RoundedElevatedButton(
                                  onPressed: () {
                                    // if (_formKey.currentState!.validate()) {
                                    submitApplication();
                                    // }
                                  },
                                  text: 'SEND',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Text(
                              "*You pay your VA directly, no third parties involved. It is important to make sure you have verified your choosen VA carefully",
                              style: LText.description(italic: 'true')),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
      scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
    );
  }
}
