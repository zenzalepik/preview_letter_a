import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:letter_a/controller/config.dart';
import 'package:letter_a/styles/colors_style.dart';

class AdminAddNotificationScreen extends StatefulWidget {
  final String token;

  AdminAddNotificationScreen({required this.token});

  @override
  _AdminAddNotificationScreenState createState() =>
      _AdminAddNotificationScreenState();
}

class _AdminAddNotificationScreenState
    extends State<AdminAddNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController(text: '909');
  final _messageController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _judulController = TextEditingController();
  File? _thumbnailImage;
  bool semuaUser = true;
  int _selectedRadio = 1; // Nilai yang dipilih oleh pengguna

  // Method to pick image from gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _thumbnailImage = File(pickedFile.path);
      });
    }
  }

  // Method to handle adding notification with image
  Future<void> _addNotification() async {
    String thumbnailBase64 = '';
    if (_thumbnailImage != null) {
      List<int> imageBytes = await _thumbnailImage!.readAsBytes();
      thumbnailBase64 = base64Encode(imageBytes);
    }

    final response = await http.post(
      Uri.parse('$server/api/v1/api_add_notification.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'token': widget.token,
        'UserID': _userIdController.text.isEmpty
            ? 59
            : int.parse(_userIdController.text),
        'Message': _messageController.text,
        'Tanggal':
            '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
        'Pukul': '${_selectedTime.hour}:${_selectedTime.minute}',
        'Judul': _judulController.text,
        'Thumbnail': thumbnailBase64,
      }),
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: LColors.primary, content: Text(data['message'])),
      );
      _formKey.currentState?.reset();
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  // Method to select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Method to select time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Notification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text('All User'),
                leading: Radio<int>(
                  value: 1,
                  groupValue: _selectedRadio,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedRadio = value!;
                      semuaUser = true;
                      _userIdController.text = '909';
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('One User'),
                leading: Radio<int>(
                  value: 2,
                  groupValue: _selectedRadio,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedRadio = value!;
                      semuaUser = false;
                      _userIdController.text = '';
                    });
                  },
                ),
              ),
              Visibility(
                visible: semuaUser == true ? false : true,
                child: TextFormField(
                  controller: _userIdController,
                  decoration: InputDecoration(labelText: 'User ID'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter user ID';
                    }
                    return null;
                  },
                ),
              ),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(labelText: 'Message'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Message';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(
                    'Tanggal: ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}'),
                onTap: () {
                  _selectDate(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text(
                    'Pukul: ${_selectedTime.hour}:${_selectedTime.minute}'),
                onTap: () {
                  _selectTime(context);
                },
              ),
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(labelText: 'Judul'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Judul';
                  }
                  return null;
                },
              ),
              // Image picker button
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pick Thumbnail'),
              ),
              // Display selected image
              if (_thumbnailImage != null)
                Image.file(
                  _thumbnailImage!,
                  height: 100,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addNotification();
                  }
                },
                child: Text('Add Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
