import 'dart:core';

// creating contact details class
class ContactDetails {
  late String user;
  late String phone;
  late String checkinTime;

  ContactDetails({
    required this.user,
    required this.phone,
    required this.checkinTime,
  });

  ContactDetails.fromJson(Map<String, dynamic> json) {
    user = json["user"];
    phone = json["phone"];
    checkinTime = json["check-in"];
  }
}
