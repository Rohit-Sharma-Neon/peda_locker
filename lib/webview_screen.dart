import 'dart:async';
import 'dart:io';
import 'package:cycle_lock/ui/main/thankyou_screen.dart';
import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/sizes.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sdk/components/network_helper.dart';
import 'package:sdk/screens/home_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xml/xml.dart';
import 'package:easy_localization/easy_localization.dart';

import 'network/api_provider.dart';

class WebViewScreen extends StatefulWidget {
  final url;
  final code;
  final String? orderId;
  final String? type;
  final String? parking_spot_id;
  final String? bike_id;
  final String? arrayCounters;
  final String? check_in_date;
  final String? check_out_date;
  final String? total_amount;
  XmlDocument? xml;

  WebViewScreen(
      {@required this.url,
      @required this.code,
      @required this.xml,
      this.parking_spot_id,
      this.type,
      this.arrayCounters,
      this.orderId,
      this.bike_id,
      this.check_in_date,
      this.check_out_date,
      this.total_amount});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String _url = '';
  String _code = '';
  bool _showLoader = false;
  bool _showedOnce = false;
  Apis apis = Apis();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("call__WebViewScreenState======???");

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _url = widget.url;
    _code = widget.code;
    print('url in webview $_url, $_code');
  }

  void complete(XmlDocument xml) async {
    setState(() {
      _showLoader = true;
    });
    NetworkHelper _networkHelper = NetworkHelper();
    var response = await _networkHelper.completed(xml);
    print("trel Response===>>>>>>  $response");
    if (response == 'failed' || response == null) {
      alertShow('Failed. Please try again', false);
      setState(() {
        _showLoader = false;
      });
    } else {
      final doc = XmlDocument.parse(response);
      final message = doc.findAllElements('message').map((node) => node.text);
      if (message.toString().length > 2) {
        String msg = message.toString();
        msg = msg.replaceAll('(', '');
        msg = msg.replaceAll(')', '');
        setState(() {
          _showLoader = false;
        });

        if (msg != "Cancelled") {
          if (!_showedOnce) {
            _showedOnce = true;
            final transaction_id = doc.findAllElements('tranref').map((node) => node.text);
            String msg = transaction_id.toString();
            msg = msg.replaceAll('(', '');
            msg = msg.replaceAll(')', '');
            createOrderApi(context, msg);

            //alertShow('Your transaction is $msg', true);
          }
        } else {
          Navigator.pop(context);
        }
        // https://secure.telr.com/gateway/webview_start.html?code=a8caa483fe7260ace06a255cc32e
      }
    }
  }

  createOrderApi(BuildContext context, transaction_id) async {
    showLoader(context);

    final cartid = widget.xml?.findAllElements('cartid').map((node) => node.text);
    String cartId = cartid.toString();
    cartId = cartId.replaceAll('(', '');
    cartId = cartId.replaceAll(')', '');
    print("xml data ${widget.xml}");
    print("xml cartId ${cartId}");
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
            transaction_id.toString(),
            widget.total_amount ?? "",
            widget.orderId ?? "", cartId)
        .then((value) {
      isLoading = false;
      if (value?.status ?? false) {
        //notificationProvider.notificationListingApi(context, false);
        showAlertDialog1(context, value?.message?.capitalize() ?? "");

        // if (widget.type == "complete") {
        //   showAlertDialog1(context, value?.message ?? "");
        // } else {
        //   showAlertDialog1(context, value?.message ?? "");
        // }
        // showApiDialog(
        //     context, value?.message.toString() ?? "Your order is done");
      } else {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        Navigator.pop(context);
        Fluttertoast.showToast(msg: value?.message ?? "");
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
      content: Text(message),
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

  void alertShow(String text, bool pop) {
    print('popup thrown');

    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(
          '$text',
          style: TextStyle(fontSize: 15),
        ),
        // content: Text('$text Please try again.'),
        actions: <Widget>[
          BasicDialogAction(
              title: Text('Ok'),
              onPressed: () {
                print(pop.toString());
                if (pop) {
                  print('inside pop');
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, HomeScreen.id);
                } else {
                  print('inside false');
                  Navigator.pop(context);
                }
              }),
        ],
      ),
    );
  }

  void createXml() {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('mobile', nest: () {
      builder.element('store', nest: () {
        builder.text('15996');
      });
      builder.element('key', nest: () {
        builder.text('pQ6nP-7rHt@5WRFv');
      });
      builder.element('complete', nest: () {
        builder.text(_code);
      });
    });

    final bookshelfXml = builder.buildDocument();
    print(bookshelfXml);
    complete(bookshelfXml);
  }

  String _token = '';
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    print("url===>"+_url.toString());
    return ModalProgressHUD(
      inAsyncCall: _showLoader,
      color: Colors.white,
      opacity: 0.5,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: lightGreyColor,
            brightness: Brightness.light,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment',
                  style: TextStyle(
                      fontSize: ts24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                        fontSize: ts20,
                        fontWeight: FontWeight.w400,
                        color: Colors.red),
                  ),
                )
              ],
            ),
          ),
          body: WebView(

            initialUrl: _url,
            key: UniqueKey(),
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
              _showedOnce = false;
              if (url.contains('close')) {
                print('call the api');
              }
              if (url.contains('abort')) {
                print('show fail and pop');
              }
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
              if (url.contains('close')) {
                print('call the api');
                createXml();
              }
              if (url.contains('abort')) {
                print('show fail and pop');
              }
              if (url.contains('telr://internal?payment_token=')) {
                print('Token found');
                String finalurl = url;

                _token =
                    finalurl.replaceAll('telr://internal?payment_token=', '');
              } else {
                _token = '';
              }
            },
            zoomEnabled: true,

            gestureNavigationEnabled: true,
          )),
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}