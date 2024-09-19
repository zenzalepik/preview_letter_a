import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:letter_a/controller/config.dart';
import 'package:letter_a/pages/user/va/va/free_va_detail_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/input_widgets.dart';

class FreeSearchVAPage extends StatefulWidget {
  @override
  _FreeSearchVAPageState createState() => _FreeSearchVAPageState();
}

class _FreeSearchVAPageState extends State<FreeSearchVAPage> {
  List<dynamic> users = [];
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _searchVa(String query) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('$server/api/v1/api_search_va.php?search=$query'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      setState(() {
        users = data['users'];
        isLoading = false;
      });
      print('${data['users']}');
    } else {
      setState(() {
        users = [];
        isLoading = false;
      });
      print('Failed to fetch users: ${data['message']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.background,
      appBar: LAppBar(
        title: "Search VA",
        bgColor: LColors.primary,
        actions: <Widget>[],
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomSearchBar(
                controller: _searchController,
                // decoration: InputDecoration(
                //   labelText: 'Search',
                //   suffixIcon: IconButton(
                //     icon: Icon(Icons.search),
                //     onPressed: () {
                //       _searchVa(_searchController.text);
                //     },
                //   ),
                // ),
                onSubmitted: (query) {
                  _searchVa(query);
                },
                hintText: 'Cari nama atau email VA...',
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 24),
                          child: ListView.builder(
                            itemCount: users.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final user = users[index];
                              // double rating =
                              //     double.tryParse(user['rating'].toString()) ?? 0.0;

                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                LColors.black.withOpacity(0.08),
                                            blurRadius: 16.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(0, 16),
                                          ),
                                        ]),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FreeVADetailPage(
                                                    userIdVa: '${user['id']}',
                                                  )),
                                        );
                                      },
                                      child: Card(
                                        color: LColors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 8.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 64,
                                                height: 64,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: Container(
                                                      width: 64,
                                                      height: 64,
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              '$server/api/v1/${user['profileImage']}'),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('${user['fullName']}',
                                                        style: LText.subtitle(
                                                            color:
                                                                LColors.black)),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.star,
                                                            color:
                                                                LColors.yellow,
                                                            size: 20),
                                                        Flexible(
                                                          child: Text(
                                                            "${user['rating'] == null || user['rating'] == 'null' ? '5.0' : user['rating']}  --  ${user['city']}, ${user['province']}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
