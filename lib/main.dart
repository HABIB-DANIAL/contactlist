import 'package:contact_list/display/contactlist_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
   await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const ListOfContactsPage());
  }
}
