import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeFormatingService {
  late String loadedTime;
  TimeFormatingService({
    required this.loadedTime,
  });

  DateTime _toDatTime() {
    return DateTime.parse(loadedTime);
  }

  String convetToAgoTime() {
    Duration diff = DateTime.now().difference(_toDatTime());

    DateTime ago = DateTime.now().subtract(diff);

    if (diff.inDays >= 365) {
      var years = diff.inDays / 365;
      return "about ${years.round()} year(s) ago";
    } else {
      return timeago.format(ago);
    }
  }

  String toReadable() {
    String read = DateFormat.yMMMEd().format(_toDatTime());
    return read;
  }
}
