import 'dart:convert';

import 'package:contact_list/models/contact_details.dart';
import 'package:flutter/services.dart' show rootBundle;

class JsonServices {
  Future<List<ContactDetails>> getUsers() async {
    //  load data from json file
    var info = await rootBundle.loadString("assets/contact_details.json");

    // convert json file to list
    List<dynamic> userList = json.decode(info);
    print(userList);

    return Future.delayed(const Duration(milliseconds: 2),
        () => userList.map((e) => ContactDetails.fromJson(e)).toList());
  }

  Future<List> userCountController(int count) async {
    var userListcount = await getUsers();
    var newList = [];

    userListcount.sort((date1, date2) => DateTime.parse(date2.checkinTime)
        .compareTo(DateTime.parse(date1.checkinTime)));

    print(userListcount);
    for (var i = 0; i < count; i++) {
      newList.add(userListcount[i]);
    }
    return Future.delayed(const Duration(milliseconds: 20), () => newList);
    // return newList;
  }
}
