

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'colors.dart';


double childAspectRatio = 0.62;

/*double getChildAspectRatio(context){
  return MediaQuery.of(context).size.width /
      (MediaQuery.of(context).size.height / 1.4);
}*/
double getChildAspectRatio(context){
  return  (150.0 / 220.0);
}

int calcRanks(ranks) {
  double multiplier = 1.0;
  return (multiplier * ranks).round();
}

String discountCalculate(String? price, String? discount) {
  return price != null && discount != null
      ? (double.parse(discount) / double.parse(price) * 100).toInt().toString()
      : "0";
}

const formatFull = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

String dateParse({date, input, output}) {
  if (date == null || date == "") return "";
  // date = '2021-01-26T03:17:00.000000Z';
  DateTime parseDate = DateFormat(input).parse(date);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat(output);
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

String statusHandle(status) {
  if (status == "0") {
    return "Waiting For Quotation";
  } else if (status == "1") {
    return "Waiting for Approval";
  } else if (status == "2") {
    return "Accepted Order";
  } else if (status == "3") {
    return "Rejected Order";
  }
  return "Loading...";
}

String status(status) {
  if (status == "0") {
    return "Pending";
  } else if (status == "1") {
    return "Accepted";
  } else if (status == "2") {
    return "Preparing";
  } else if (status == "3") {
    return "Picked Up";
  } else if (status == "4") {
    return "Completed";
  } else if (status == "5") {
    return "Completed";
  } else if (status == "6") {
    return "Cancelled";
  }
  return "Loading...";
}

dynamic statusColor2(status) {
  if (status == "0") {
    return bgColor;
  } else if (status == "1") {
    return blackColor70;
  } else if (status == "2") {
    return blackColor70;
  } else if (status == "3") {
    return  blackColor70;
  }else if (status == "4") {
    return  greenColor;
  }else if (status == "5") {
    return  greenColor;
  }else if (status == "6") {
    return  Colors.red;
  }
  return Colors.red;
}

// dynamic statusColor(status, isLight) {
//   if (status == "0") {
//     return isLight ? loderColor : AppColors.carModelColor4;
//   } else if (status == "1") {
//     return isLight ? AppColors.lightblue : AppColors.blue;
//   } else if (status == "2") {
//     return isLight ? AppColors.lightGreen : AppColors.greenColor1;
//   } else if (status == "3") {
//     return isLight ? AppColors.lightRed : AppColors.heavyRed;
//   }
//   return isLight ? AppColors.lightRed : AppColors.heavyRed;
// }

String convertToAgo(dateTime) {
  DateTime input = DateFormat('yyyy-MM-DDTHH:mm:ss.SSSSSSZ').parse(dateTime, true);
  Duration diff = DateTime.now().difference(input);

  if (diff.inDays >= 1) {
    return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
  } else if (diff.inSeconds >= 1) {
    return '${diff.inSeconds} second${diff.inSeconds == 1 ? '' : 's'} ago';
  } else {
    return 'just now';
  }
}

List<TextSpan> highlightOccurrences(String source, String? query) {
  if (query == null || query.isEmpty || !source.toLowerCase().contains(query.toLowerCase())) {
    return [ TextSpan(text: source) ];
  }
  final matches = query.toLowerCase().allMatches(source.toLowerCase());

  int lastMatchEnd = 0;

  final List<TextSpan> children = [];
  for (var i = 0; i < matches.length; i++) {
    final match = matches.elementAt(i);

    if (match.start != lastMatchEnd) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, match.start),
      ));
    }

    children.add(TextSpan(
      text: source.substring(match.start, match.end),
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
    ));

    if (i == matches.length - 1 && match.end != source.length) {
      children.add(TextSpan(
        text: source.substring(match.end, source.length),
      ));
    }

    lastMatchEnd = match.end;
  }
  return children;
}

Widget lottieNetWork(url){
  return Lottie.network(url,
      repeat: true,
      fit: BoxFit.fill,
    );

}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);



String formatter(String? currency) {
  if(currency == null || currency == "") return "";
  final oCcy = NumberFormat("#,##0.00", "en_US");
  return oCcy.format(double.parse(currency)).toString();
}

bool different2Hours(String checkIn,String checkOut, hours){
  DateTime checkInDate =  DateFormat("dd/MM/yyyy hh:mm a").parse(checkIn.trim().toLowerCase());
  DateTime checkOutDate =  DateFormat("dd/MM/yyyy hh:mm a").parse(checkOut.trim().toLowerCase());
  print("object 2>>> $checkInDate");
  print("object 2>>> $checkOutDate");
  final difference = checkOutDate.difference(checkInDate).inHours;
  print("object >>> $difference");
  return difference < hours;
}
bool differentHours(String checkIn,String checkOut){
  DateTime checkInDate =  DateFormat("dd/MM/yyyy hh:mm a").parse(checkIn.trim().toLowerCase());
  DateTime checkOutDate =  DateFormat("dd/MM/yyyy hh:mm a").parse(checkOut.trim().toLowerCase());
  print("object 2>>> $checkInDate");
  print("object 2>>> $checkOutDate");
  //final difference = checkOutDate.difference(checkInDate).inHours;
  final c = checkInDate.hour;
  final o = checkOutDate.hour;
  //print("object >>> $difference");
  return c > o;
}

