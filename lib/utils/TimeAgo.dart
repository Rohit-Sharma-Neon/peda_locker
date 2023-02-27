import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSSZ").parse(dateString, true);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate.toLocal());

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1weekago'.tr() : 'Lastweek'.tr();
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1dayago'.tr() : 'Yesterday'.tr();
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1hourago'.tr() : 'Anhourago'.tr();
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1minuteago'.tr() : 'AMinuteAgo'.tr();
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'JustNow'.tr();
    }
  }

  static getFormatNumber(number){
    return number.replaceAllMapped(RegExp(r'(\d{2})(\d{3})(\d+)'), (Match m) => "${m[1]} ${m[2]} ${m[3]}");
  }
}
