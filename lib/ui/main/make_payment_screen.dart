import 'dart:math';
import 'package:sdk/screens/webview_screen.dart';
import 'package:xml/xml.dart';
import 'package:cycle_lock/providers/notification_provider.dart';
import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/ui/main/thankyou_screen.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/ui/widgets/custom_textfield.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sdk/components/network_helper.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../network/api_provider.dart';
import '../../utils/colors.dart';

import '../../utils/sizes.dart';
import '../widgets/primary_button.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_js/flutter_js.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdk/components/network_helper.dart';
import 'package:sdk/screens/webview_screen.dart';
import 'package:xml/xml.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'dart:math';
class MakePaymentScreen extends StatefulWidget {
  final String? orderId;
  final String? type;
  final String? parking_spot_id;
  final String? bike_id;
  final String? arrayCounters;
  final String? check_in_date;
  final String? check_out_date;
  final String? total_amount;

  MakePaymentScreen(
      {Key? key,
      this.parking_spot_id,
      this.type,
      this.arrayCounters,
      this.orderId,
      this.bike_id,
      this.check_in_date,
      this.check_out_date,
      this.total_amount})
      : super(key: key);

  @override
  _MakePaymentScreenState createState() => _MakePaymentScreenState();
}
class _MakePaymentScreenState extends State<MakePaymentScreen> {
  TextEditingController cardNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  Apis apis = Apis();
  bool isLoading = false;
  String transaction_id = "123456";
  DateTime selectedDate = DateTime.now();
  String _platformVersion = 'Unknown';

  late NotificationProvider notificationProvider;
  late final _amount;

  final _language = "en";
  final _currency = "AED";
  var _url = '';

  String evaluateJS() {
    String js = '''var telrSdk = {
    store_id : 0,
    currency: '',
    test_mode: 0,
    saved_cards: [],
    callback: null,

    onTokenReceive: function(){},

    init: function(params){
    store_id = (params.store_id) ? params.store_id : 0;
    currency = (params.currency) ? params.currency : "";
    test_mode = (params.test_mode) ? params.test_mode : 0;
    callback = (params.callback) ? params.callback : 0;
    saved_cards = (params.saved_cards &&  Array.isArray(params.saved_cards)) ? params.saved_cards : [];

    var telrMessage = {
    "message_id": "init_telr_config",
    "store_id": store_id,
    "currency": currency,
    "test_mode": test_mode,
    "saved_cards": saved_cards
    }

    var initMessage = JSON.stringify(telrMessage);

    var frameHeight = 300;
    if(saved_cards.length > 0){
    frameHeight += 30;
    frameHeight += (saved_cards.length * 110);
    }
    var iframeUrl = "https://uat.testourcode.com/telr-sdk/jssdk/token_frame.html?token=" + Math.floor((Math.random() * 9999999999) + 1);
    var iframeHtml = ' <iframe id="telr_iframe" src= "' + iframeUrl + '" style="width: 100%; height: ' + frameHeight + 'px; border: 0;margin-top: 20px;" sandbox="allow-forms allow-modals allow-popups-to-escape-sandbox allow-popups allow-scripts allow-top-navigation allow-same-origin"></iframe>';

    document.getElementById('telr_frame').innerHTML = iframeHtml;

    setTimeout(function(){
    document.getElementById('telr_iframe').contentWindow.postMessage(initMessage,"*");
    }, 1500);

    if (typeof window.addEventListener != 'undefined') {
    window.addEventListener('message', function(e) {
    var message = e.data;
    telrSdk.processResponseMessage(message);

    }, false);

    } else if (typeof window.attachEvent != 'undefined') { // this part is for IE8
    window.attachEvent('onmessage', function(e) {
    var message = e.data;
    telrSdk.processResponseMessage(message);

    });
    }

    },

    isJson: function(str) {
    try {
    JSON.parse(str);
    } catch (e) {
    return false;
    }
    return true;
    },

    processResponseMessage: function(message){
    if(message != ""){
    if(telrSdk.isJson(message) || (typeof message === 'object' && message !== null)){
    var telrMessage = (typeof message === 'object') ? message : JSON.parse(message);
    if(telrMessage.message_id != undefined){
    switch(telrMessage.message_id){
    case "return_telr_token":
    var payment_token = telrMessage.payment_token;
    if(payment_token != ""){
    callback(payment_token);
    }
    break;
    }
    }
    }
    }
    }
  }''';
    String result = getJavascriptRuntime().evaluate(js).stringResult;
    print('result = $result');
    return result;
  }

  @override
  void initState() {
    _amount = widget.total_amount.toString();
    //initPlatformState();
    evaluateJS();
    notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    super.initState();
  }

  // Future<void> initPlatformState() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // We also handle the message potentially returning null.
  //   try {
  //     platformVersion = await TelrPaymentGateway.platformVersion ??
  //         'Unknown platform version';
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }
  //
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;
  //
  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }

  // payment() async {
  //   String message;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // We also handle the message potentially returning null.
  //   try {
  //     message = await TelrPaymentGateway.callTelRForTransaction(
  //           store_id: "25798",
  //           key: "Nbsw5^mDR5@3m9Nc",
  //           amount: "20",
  //           app_install_id: "123456",
  //           app_name: "TelR",
  //           app_user_id: "12345",
  //           app_version: "1.0.0",
  //           sdk_version: "123",
  //           mode: "1",
  //           tran_type: "sale",
  //           tran_cart_id: "1003",
  //           desc: "First Transaction",
  //           tran_lang: "EN",
  //           tran_currency: "AED",
  //           bill_city: "Dubai",
  //           bill_country: "AE",
  //           bill_region: "Dubai",
  //           bill_address: "SIT GTower",
  //           bill_first_name: "Deep",
  //           bill_last_name: "Amin",
  //           bill_title: "Mr",
  //           bill_email: "deep@innovuratech.com",
  //           bill_phone: "528636596",
  //         ) ??
  //         'Unknown Message';
  //   } on PlatformException {
  //     message = 'Failed to get Message.';
  //   }
  //   print("Clicked Message == $message");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: "payment".tr(),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  "AED " +
                      double.parse(widget.total_amount.toString())
                          .toStringAsFixed(2),
                  style: const TextStyle(
                      fontSize: ts24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(width: 20),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text("enterCardDetail".tr(),
                  style:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: ts26)),
              const SizedBox(height: 40),
              CustomTextField(
                  maxLength: 20,
                  hintText: "nameOnCard".tr(),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                  ],
                  keyboardType: TextInputType.text,
                  capitalization: TextCapitalization.sentences,
                  controller: cardNameController),
              const SizedBox(height: 40),
              CustomTextField(
                  maxLength: 16,
                  hintText: "cardNumber".tr(),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  ],
                  keyboardType: TextInputType.number,
                  controller: cardNumberController),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: IgnorePointer(
                        child: CustomTextField(
                            hintText: "expDate".tr(),
                            controller: expDateController),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: CustomTextField(
                        maxLength: 3,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        keyboardType: TextInputType.number,
                        hintText: "cvv".tr(),
                        controller: cvvController),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                  onPressed: () {
                    if (cardNameController.text.isEmpty) {
                      showAlertDialog(context, "PleaseEnterCardName".tr());
                    } else if (cardNumberController.text.isEmpty) {
                      showAlertDialog(context, "PleaseEnterCardNumber".tr());
                    } else if (cardNumberController.text.length < 16) {
                      showAlertDialog(
                          context, "PleaseEnterValidCardNumber".tr());
                    } else if (expDateController.text.isEmpty) {
                      showAlertDialog(context, "PleaseEnterExpireDate".tr());
                    } else if (cvvController.text.isEmpty) {
                      showAlertDialog(context, "PleaseEnterCvv".tr());
                    } else if (cvvController.text.length < 3) {
                      showAlertDialog(context, "PleaseEnterValidCvv".tr());
                    } else {
                      startPaymentProcess();
                      // payment();
                      //createOrderApi(context);
                    }
                  },
                  title: Text("payNow".tr(),
                      style: const TextStyle(fontSize: ts22))),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: lightGreyColor,
              surface: Colors.pink, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final DateFormat formatter = DateFormat('MM/yy');
        final String formatted = formatter.format(selectedDate);
        //String dateSlug = "${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year.toString()}";
        expDateController.text = formatted;
      });
    }
  }

  createOrderApi(BuildContext context,) async {
    showLoader(context);
    setState(() {
      isLoading = true;
    });
    apis
        .orderCreateApi(
            widget.type ?? "",
            widget.arrayCounters ?? "",
            widget.parking_spot_id ?? "",
            widget.bike_id ?? "",
            widget.check_in_date ?? "",
            widget.check_out_date ?? "",
            transaction_id,
            widget.total_amount ?? "",
            widget.orderId ?? "", cartId)
        .then((value) {
      isLoading = false;
      if (value?.status ?? false) {
        //notificationProvider.notificationListingApi(context, false);
       // showAlertDialog1(context, value?.message ?? "");

        if (widget.type == "complete") {
          showAlertDialog1(context, value?.message?.capitalize() ?? "");
        } else {
          // Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => const DashBoardScreen()),
          //         (route) => false);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ThankyouScreen()));
        }
        showApiDialog(
            context, value?.message?.capitalize() ?? "Your order is done");
      } else {
        setState(() {
          isLoading = false;
        });
        //Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  showAlertDialog1(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK".tr(), style: const TextStyle(color: lightGreyColor)),
      onPressed: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const DashBoardScreen()),
            (route) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert".tr()),
      content: Text(message.capitalize()),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  showAlertDialog(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message);
  }

  showApiDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK".tr(), style: const TextStyle(color: lightGreyColor)),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ThankyouScreen()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Peda Locker"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  startPaymentProcess() {
    var random = new Random();

    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('mobile', nest: () {
      builder.element('store', nest: () {
       // builder.text('15996');
        builder.text('26981');
      });
      builder.element('key', nest: () {
        //builder.text('pQ6nP-7rHt@5WRFv');
        builder.text('KzsRs#thrj6-8Vwq');
      });

      builder.element('testMode', nest: () {
        builder.text(true);
      });

      builder.element('device', nest: () {
        builder.element('type', nest: () {
          builder.text('iOS');
        });
        builder.element('id', nest: () {
          builder.text('37fb44a2ec8202a3');
        });
      });

      // app
      builder.element('app', nest: () {
        builder.element('name', nest: () {
          builder.text('Telr');
        });
        builder.element('version', nest: () {
          builder.text('1.1.6');
        });
        builder.element('user', nest: () {
          builder.text('2');
        });
        builder.element('id', nest: () {
          builder.text('123');
        });
      });

      //tran
      builder.element('tran', nest: () {
        builder.element('test', nest: () {
          builder.text('1');
        });
        builder.element('type', nest: () {
          builder.text('Sale');
        });
        builder.element('class', nest: () {
          builder.text('paypage');
        });
        builder.element('cartid', nest: () {
          builder.text(100000000 + random.nextInt(999999999));
        });
        builder.element('description', nest: () {
          builder.text('Test for Mobile API order');
        });
        builder.element('currency', nest: () {
          builder.text(_currency);
        });
        builder.element('amount', nest: () {
          builder.text(_amount);
        });
        builder.element('language', nest: () {
          builder.text(_language);
        });
        builder.element('firstref', nest: () {
          builder.text('first');
        });
        builder.element('ref', nest: () {
          builder.text('null');
        });
      });

      //billing
      builder.element('billing', nest: () {
        // name
        builder.element('name', nest: () {
          builder.element('title', nest: () {
            builder.text('');
          });
          builder.element('first', nest: () {
            builder.text('Div');
          });
          builder.element('last', nest: () {
            builder.text('V');
          });
        });
        //custref savedcard
        builder.element('custref', nest: () {
          builder.text('231');
        });
        // address
        builder.element('address', nest: () {
          builder.element('line1', nest: () {
            builder.text('Dubai');
          });
          builder.element('city', nest: () {
            builder.text('Dubai');
          });
          builder.element('region', nest: () {
            builder.text('');
          });
          builder.element('country', nest: () {
            builder.text('AE');
          });
        });

        builder.element('phone', nest: () {
          builder.text('551188269');
        });
        builder.element('email', nest: () {
          builder.text('divya.thampi@telr.com');
        });
      });
    });

    final bookshelfXml = builder.buildDocument();

    // print(bookshelfXml);
    pay(bookshelfXml);
  }

  String cartId="";

  void pay(XmlDocument xml) async {
    final cartid = xml.findAllElements('cartid').map((node) => node.text);
    String cartId = cartid.toString();
    cartId = cartId.replaceAll('(', '');
    cartId = cartId.replaceAll(')', '');
    this.cartId = cartId;
    NetworkHelper _networkHelper = NetworkHelper();
    var response = await _networkHelper.pay(xml);
    print(response);
    if (response == 'failed' || response == null) {
      // failed
      alertShow('Failed');
    } else {
      final doc = XmlDocument.parse(response);
      final url = doc.findAllElements('start').map((node) => node.text);
      final code = doc.findAllElements('code').map((node) => node.text);
      print(url);
      _url = url.toString();
      String _code = code.toString();
      if (_url.length > 2) {
        _url = _url.replaceAll('(', '');
        _url = _url.replaceAll(')', '');
        _code = _code.replaceAll('(', '');
        _code = _code.replaceAll(')', '');
        _launchURL(_url, _code, xml);
      }
      print(_url);
      final message = doc.findAllElements('message').map((node) => node.text);
      print('Message =  $message');
      if (message.toString().length > 2) {
        String msg = message.toString();
        msg = msg.replaceAll('(', '');
        msg = msg.replaceAll(')', '');
        createOrderApi(context);
        //alertShow(msg);
      }
    }
  }

  void _launchURL(String url, String code, XmlDocument xml) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => WebViewScreen(
                  url: url,
                  code: code,
                )));
  }

  void alertShow(String text) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          '$text',
          style: const TextStyle(fontSize: 15),
        ),
        // content: Text('$text Please try again.'),
        actions: <Widget>[
          BasicDialogAction(
              title: const Text('Ok'),
              onPressed: () {
                setState(() {
                  // _showLoader = false;
                });
                createOrderApi(context);
              }),
        ],
      ),
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}