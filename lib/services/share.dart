import 'package:share_plus/share_plus.dart';

class ShareContentService {
  shareContextDetails(name, phone, time) {
    String information = "Name : $name\nPhone : $phone\nTime : $time";
    Share.share(information);
  }
}
