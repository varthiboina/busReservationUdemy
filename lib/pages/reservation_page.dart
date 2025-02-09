import 'package:bus_reservation_udemy/customwidgets/reservation_item_body_view.dart';
import 'package:bus_reservation_udemy/customwidgets/reservation_item_header_view.dart';
import 'package:bus_reservation_udemy/customwidgets/search_box.dart';
import 'package:bus_reservation_udemy/providers/app_data_provider.dart';
import 'package:bus_reservation_udemy/utils/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reservation_expansion_item.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  bool isFirst = true;
  List<ReservationExpansionItem> items = [];

  @override
  void didChangeDependencies() {
    if (isFirst) {
      _getData();
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  _getData() async {
    final reservations =
        await Provider.of<AppDataProvider>(context, listen: false)
            .getAllReservations();

    setState(() {
      items = Provider.of<AppDataProvider>(context, listen: false)
          .getExpansionItems(reservations);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservation List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SearchBox(onSubmit: (value) {
              _search(value);
            }),
            ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                setState(() {
                  
                  items[index].isExpanded = isExpanded;
                });
              },
              children: items
                  .map((item) => ExpansionPanel(
                        isExpanded: item.isExpanded,
                        headerBuilder: (context, isExpanded) =>
                            ReservationItemHeaderView(header: item.header),
                        body: ReservationItemBodyView(
                          body: item.body,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _search(String value) async {
    final data = await Provider.of<AppDataProvider>(context, listen: false)
        .getReservationsByMobile(value);
    if (data.isEmpty) {
      showMsg(context, 'No record found');
      return;
    }
    setState(() {
      items = Provider.of<AppDataProvider>(context, listen: false)
          .getExpansionItems(data);
    });
  }
}
