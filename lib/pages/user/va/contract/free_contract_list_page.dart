import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:letter_a/controller/config.dart';
import 'package:letter_a/models/contract_model.dart';
import 'package:http/http.dart' as http;
import 'package:letter_a/pages/user/client/contract/contract_detail_page.dart';
import 'package:letter_a/pages/user/va/contract/free_contract_detail_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreeContractListScreen extends StatefulWidget {
  @override
  _FreeContractListScreenState createState() => _FreeContractListScreenState();
}

class _FreeContractListScreenState extends State<FreeContractListScreen> {
  String userId = '';

  @override
  void initState() {
    super.initState();
    getClientId();
  }

  Future<void> getClientId() async {
    final prefs = await SharedPreferences.getInstance();
    String vaId = prefs.getString('userId') ?? '';

    setState(() {
      userId = vaId;
    });
    print('User ID >>> $userId');
  }

  Future<List<Contract>> _fetchContracts() async {
    final response = await http.get(Uri.parse(
        '$server/api/v1/contracts/get_contracts_for_va.php?UserID=${userId}'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data is List) {
        return data.map((item) => Contract.fromJson(item)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load contracts');
    }
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12.0),
        child: FutureBuilder<List<Contract>>(
          future: _fetchContracts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No contracts available.'));
            } else {
              final contracts = snapshot.data!;
              return ListView.builder(
                itemCount: contracts.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final contract = contracts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: LColors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                              width: 1,
                              color: Color.fromARGB(104, 223, 223, 223)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 32,
                                spreadRadius: -12,
                                color: Color.fromARGB(255, 204, 228, 211),
                                offset: Offset.fromDirection(-24, 16))
                          ]),
                      child: ListTile(
                        // title:
                        subtitle: Column(
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  child: Center(
                                      child: Icon(Icons.assignment_outlined,
                                          color: LColors.primary, size: 32)
                                      /*Text(
                                        '${contract.application_id.substring(0, 1)}',
                                        style: LText.H5(color: LColors.primary)),
                                  */
                                      ),
                                  decoration: BoxDecoration(
                                    color: LColors.secondary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'Contract ID:',
                                          )),
                                          SizedBox(
                                            height: 9,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 2),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: contract.Status ==
                                                        'running'
                                                    ? LColors.blue
                                                    : contract.Status ==
                                                            'pending'
                                                        ? LColors.yellow
                                                        : contract.Status ==
                                                                'done'
                                                            ? LColors.primary
                                                            : contract.Status ==
                                                                    'reject'
                                                                ? LColors.red
                                                                : contract.Status ==
                                                                        'failded'
                                                                    ? LColors
                                                                        .failed
                                                                    : contract.Status ==
                                                                            'review'
                                                                        ? LColors
                                                                            .transparentPrimary
                                                                        : LColors
                                                                            .black),
                                            child: Text(
                                              (contract.ApprovalClient !=
                                                          'approved') &&
                                                      contract.Status ==
                                                          'reject'
                                                  ? 'Request Reject'
                                                  : (contract.ApprovalClient ==
                                                              'approved') &&
                                                          contract.Status ==
                                                              'reject'
                                                      ? 'Rejected'
                                                      : (contract.ApprovalClient !=
                                                                  'approved') &&
                                                              contract.Status ==
                                                                  'pending'
                                                          ? 'Request to Pause'
                                                          : (contract.ApprovalClient ==
                                                                      'approved') &&
                                                                  contract.Status ==
                                                                      'pending'
                                                              ? 'Pending'
                                                              : '${capitalizeFirstLetter(contract.Status)}',
                                              style: LText.labelDataTahun(
                                                // weight: widget.read == false || widget.read == null ?
                                                weight: FontWeight.w700,
                                                color:
                                                    contract.Status == 'pending'
                                                        ? LColors.black
                                                        : contract.Status ==
                                                                'review'
                                                            ? LColors.primary
                                                            : LColors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                                'L3TTER${contract.application_id}',
                                                style: LText.labelData()),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Opacity(
                                              opacity: 0.64,
                                              child: Text(
                                                  '${contract.TanggalApprove}',
                                                  style: LText.description())),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FreeContractDetailScreen(contract: contract),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
