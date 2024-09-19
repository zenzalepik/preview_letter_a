import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ApplicationForm(),
    );
  }
}

class ApplicationForm extends StatefulWidget {
  @override
  _ApplicationFormState createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userIdController = TextEditingController(text: '59');
  TextEditingController vaidController =
      TextEditingController(text: 'checking');
  TextEditingController clientIdController = TextEditingController(text: '910');
  TextEditingController statusController =
      TextEditingController(text: 'pending');
  TextEditingController tanggalPengajuanController =
      TextEditingController(text: '2024-08-20');
  TextEditingController tanggalMulaiController =
      TextEditingController(text: '2024-08-20');
  TextEditingController tanggalSelesaiController =
      TextEditingController(text: '2024-08-20');
  TextEditingController titleController =
      TextEditingController(text: 'Import Excel');
  TextEditingController ratePriceController =
      TextEditingController(text: '900000');
  TextEditingController descriptionController =
      TextEditingController(text: '500file');
  File? _proofFile;

  Future<void> submitApplication() async {
    print("RatePrice: ${ratePriceController.text}"); // Debug log

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://letter-a.co.id/api/v1/applications/api_create_application.php'),
    );

    request.fields['UserID'] = userIdController.text;
    request.fields['Vaid'] = vaidController.text;
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

    final response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Application berhasil dibuat')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal membuat Application')));
    }
  }

  Future<void> _pickProofFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _proofFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Application Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: userIdController,
                decoration: InputDecoration(labelText: 'User ID'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: vaidController,
                decoration: InputDecoration(labelText: 'Vaid'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: clientIdController,
                decoration: InputDecoration(labelText: 'Client ID'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
              TextFormField(
                controller: tanggalPengajuanController,
                decoration: InputDecoration(labelText: 'Tanggal Pengajuan'),
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                controller: tanggalMulaiController,
                decoration: InputDecoration(labelText: 'Tanggal Mulai'),
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                controller: tanggalSelesaiController,
                decoration: InputDecoration(labelText: 'Tanggal Selesai'),
                keyboardType: TextInputType.datetime,
              ),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: ratePriceController,
                decoration: InputDecoration(labelText: 'Rate/Cost'),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              ElevatedButton(
                onPressed: _pickProofFile,
                child: Text(_proofFile == null ? 'Pilih Bukti' : 'Ganti Bukti'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitApplication();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
