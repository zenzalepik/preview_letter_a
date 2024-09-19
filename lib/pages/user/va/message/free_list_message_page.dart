import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letter_a/pages/user/client/auth/sign_up_personal_data_page.dart';
import 'package:letter_a/pages/info/data_protexttion_page.dart';
import 'package:letter_a/pages/info/imprint_page.dart';
import 'package:letter_a/pages/info/terms_and_onditions_page.dart';
import 'package:letter_a/pages/user/client/va/va_detail_page.dart';
import 'package:letter_a/pages/user/va/contract/free_contract_list_page.dart';
import 'package:letter_a/pages/user/va/message/free_list_message.dart';
import 'package:letter_a/pages/user/va/offer/free_list_offer_page.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/widgets/appbar_widgets.dart';
import 'package:letter_a/widgets/buttons_widgets.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';
import 'package:letter_a/widgets/item_message_widgets.dart';
import 'package:letter_a/widgets/menu_arrow_widgets.dart';
import 'package:letter_a/widgets/statistik_widgets.dart';

class FreeListMessagePage extends StatefulWidget {
  final String index;
  FreeListMessagePage({Key? key, this.index = ''}) : super(key: key);

  @override
  State<FreeListMessagePage> createState() => _FreeListMessagePageState();
}

class _FreeListMessagePageState extends State<FreeListMessagePage> {
  bool isLoading = true;
  String errorMessage = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // errorMessage = 'false';
    isLoading = false;
    widget.index == '' || widget.index == null
        ? _selectedIndex = 0
        : setState(() {
            _selectedIndex = int.parse(widget.index);
          });

    print('$_selectedIndex');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: LColors.primary),
      ),
      home: DefaultTabController(
        length: 3,
        initialIndex:
            _selectedIndex, // Gunakan _selectedIndex untuk initialIndex
        child: Scaffold(
            backgroundColor: LColors.background,
            appBar: AppBar(
              backgroundColor: LColors.secondary,
              title: Center(
                child: Image.asset(
                    'assets/images/img_logo_transparent_white.png',
                    width: 120),
              ),
              bottom: TabBar(
                indicatorColor: LColors.primary,
                indicatorWeight: 4,
                labelColor: LColors.white,
                unselectedLabelColor: LColors.white.withOpacity(0.72),
                tabs: [
                  Tab(text: 'Message'),
                  Tab(text: 'Offer'),
                  Tab(text: 'Contract'),
                ],
              ),
            ),
            body: TabBarView(children: [
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(child: Text(errorMessage))
                      : FreeListMessage(),
              FreeListOfferPage(),
              FreeContractListScreen(),
            ])),
      ),
    );
  }
}
