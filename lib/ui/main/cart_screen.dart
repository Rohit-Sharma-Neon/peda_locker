import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/ui/main/thankyou_screen.dart';
import 'package:cycle_lock/ui/widgets/base_appbar.dart';
import 'package:cycle_lock/ui/widgets/custom_textfield.dart';
import 'package:cycle_lock/ui/widgets/not_found_text.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/loder.dart';
import 'package:cycle_lock/webview_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../main.dart';
import '../../network/api_provider.dart';
import '../../responses/cart_list_response.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/sizes.dart';
import '../../utils/strings.dart';
import '../widgets/heading_medium.dart';
import '../widgets/loaders.dart';
import '../widgets/primary_button.dart';
import 'dart:math';
import 'package:xml/xml.dart';
import 'package:sdk/components/network_helper.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_js/flutter_js.dart';

class CartScreen extends StatefulWidget {
  final String? orderID;
  final String? arrayCounters;
  final String? parking_spot_id;
  final String? bike_id;
  final String? check_in_date;
  final String? check_out_date;
  final String? type;

  CartScreen(
      {Key? key,
      this.orderID,
      this.arrayCounters,
      this.parking_spot_id,
      this.bike_id,
      this.check_in_date,
      this.type,
      this.check_out_date})
      : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var totalAmount;
  String arrayCounters = "";
  var baseAmount;
  int? couponId;
  Apis apis = Apis();
  bool isLoading = false;
  bool isShow = false;
  List<Cart>? data;
  var _url = '';
  CartListResponse? cartListResponse;
  final TextEditingController couponController = TextEditingController();

  @override
  void initState() {
    evaluateJS();
    arrayCounters = "";
    if (widget.arrayCounters != null) {
      arrayCounters = widget.arrayCounters.toString();
    }
    cartApi(context);
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          title: "Cart".tr(),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                cartListResponse?.baseAmount != null
                    ? Text("AED ${(cartListResponse?.baseAmount.toString())}",
                        style: const TextStyle(
                            fontSize: ts24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white))
                    : const SizedBox(),
                const SizedBox(width: 20),
              ],
            ),GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashBoardScreen()),
                          (route) => false);
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child:  Icon(Icons.home_outlined, size: 40, color: buttonColor,),
                ))
          ],
        ),
        body: isLoading
            ?  Center(
                child: Loader.load(),
              )
            : data != null && data!.isNotEmpty
                ? Stack(
                    children: [
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildBody(),
                                Column(
                                  children: [
                                    CustomTextField(
                                        keyboardType: TextInputType.name,
                                        hintText: "EnterCouponCode".tr(),
                                        controller: couponController),
                                    const SizedBox(height: 30),
                                    PrimaryButton(
                                      onPressed: () {
                                        if(couponController.text.isNotEmpty){
                                          applyCouponApi(couponController.text.toString());
                                        }
                                      },
                                      title: Text("Apply".tr(),
                                          style:
                                          const TextStyle(color: Colors.white, fontSize: ts20)),
                                    ),
                                  ],
                                ),
                               /* GestureDetector(
                                  onTap: () async {
                                    final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CouponScreen(
                                            isShow: true,
                                          ),
                                        ));
                                    setState(() {
                                      couponId = result;
                                      cartApi(context);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: greyBgColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                coupon,
                                                height: 40,
                                                width: 40,
                                              ),
                                              const SizedBox(width: 20),
                                              Row(
                                                children: [
                                                  Text(
                                                      cartListResponse
                                                                  ?.coupon_code !=
                                                              null
                                                          ? cartListResponse
                                                                  ?.coupon_code
                                                                  .toString() ??
                                                              ""
                                                          : "ApplyCoupon".tr(),
                                                      style: const TextStyle(
                                                          color: greyFontColor,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: ts20)),
                                                  const SizedBox(width: 20),
                                                  cartListResponse
                                                              ?.coupon_code !=
                                                          null
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            couponId = null;
                                                            cartApi(context);
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .cancel_outlined,
                                                            size: 30,
                                                            color: Colors.grey,
                                                          ),
                                                        )
                                                      : const SizedBox()
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  CustomTextField(
                                                      keyboardType: TextInputType.name,
                                                      hintText: "EnterCouponCode".tr(),
                                                      controller: couponController),
                                                  const SizedBox(height: 30),
                                                  PrimaryButton(
                                                    onPressed: () {
                                                      if(couponController.text.isNotEmpty){
                                                        applyCouponApi(couponController.text.toString());
                                                      }
                                                    },
                                                    title: Text("Apply".tr(),
                                                        style:
                                                        const TextStyle(color: Colors.white, fontSize: ts20)),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            size: 25,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),*/
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Amount".tr(),
                                        style: const TextStyle(
                                            color: greyFontColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: ts20)),
                                    Text(
                                       // "AED ${(cartListResponse?.baseAmount.toDouble()).toString()}",
                                        "AED ${((cartListResponse?.baseAmount).toString())}",
                                        style: const TextStyle(
                                            color: greyFontColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: ts20)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                cartListResponse?.discountAmount != 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("DiscountAmount".tr(),
                                              style: const TextStyle(
                                                  color: greyFontColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ts20)),
                                          Text(
                                              "- AED ${(cartListResponse?.discountAmount).toString()}",
                                              style: const TextStyle(
                                                  color: greyFontColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: ts20)),
                                        ],
                                      )
                                    : const SizedBox(),
                                cartListResponse?.extra_charge != null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Charges".tr(),
                                              style: const TextStyle(
                                                  color: greyFontColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: ts20)),
                                          Text(
                                              "AED ${(cartListResponse?.extra_charge).toString()}",
                                              style: const TextStyle(
                                                  color: greyFontColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: ts20)),
                                        ],
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("TotalAmount".tr(),
                                        style: const TextStyle(
                                            color: greyFontColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: ts20)),
                                    Text(
                                        "AED ${(cartListResponse?.totalAmount).toString()}",
                                        style: const TextStyle(
                                            color: greyFontColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: ts20)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                const SizedBox(height: 30),
                                PrimaryButton(
                                    onPressed: () {
                                      showLoader(context);
                                      startPaymentProcess();
                                      /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>

                                                  MakePaymentScreen(
                                                    type: cartListResponse
                                                        ?.extraCharge
                                                        .toString(),
                                                    arrayCounters:arrayCounters,
                                                    parking_spot_id: widget
                                                            .parking_spot_id ??
                                                        "",
                                                    bike_id:
                                                        widget.bike_id ?? "",
                                                    orderId: widget.orderID,
                                                    check_in_date: widget
                                                        .check_in_date
                                                        .toString(),
                                                    check_out_date:
                                                        widget.check_out_date ??
                                                            "",
                                                    total_amount:
                                                        cartListResponse
                                                            ?.totalAmount
                                                            .toString(),
                                                  )));*/
                                    },
                                    title: Text("payNow".tr(),
                                        style: const TextStyle(fontSize: ts22))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      isShow
                          ? Center(
                              child: Lottie.network(
                                applyCouponLottieUrl,
                                repeat: false,
                                fit: BoxFit.fill,
                              ),
                            )
                          : const SizedBox()
                    ],
                  )
                : Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             // Lottie.network(animCycleUrl),
              notFound("dataNotFound".tr())
            ],
          ),
                  ));
  }

  _buildBody() {
    return isLoading
        ?  Center(
            child: Loader.load(),
          )
        : data != null && data!.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data!.length,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemBuilder: (context, index) {
                  return buildUserCard(index);
                })
            : Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Lottie.network(animCycleUrl),
          notFound("dataNotFound".tr())
        ],
      ),
              );
  }

  buildUserCard(position) {
    return Container(
      padding: const EdgeInsets.all(15),
      // width: width/1.2,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 0),
            spreadRadius: 4),
      ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.network(
                    "${data![position].imageUrl}/${data![position].bikeImage}",
                    errorBuilder: (context, error, stackTrace) {
                      return SvgPicture.asset(
                        icSmallBicycle,
                        width: 20,
                        height: 20,
                        fit: BoxFit.fitWidth,
                        color: lightGreyColor,
                      ); //do something
                    },
                    height: 32,
                    width: 32,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    data![position].bikeName?.toString() ?? "",
                    style:
                        const TextStyle(fontSize: ts22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              headingMedium("AED ${double.parse((data![position].charge).toString()).toStringAsFixed(2)} "),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SvgPicture.asset(
                icCalendar,
                color: buttonColor,
                height: 25,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                //"${DateFormat(dateFormatSlash).format(DateTime.parse(data?[position].checkInDate.toString()??""))} - ${DateFormat(dateFormatSlash).format(DateTime.parse(data?[position].checkOutDate.toString()??""))}",
                "${data?[position].checkInDate.toString() ?? ""}\n${data?[position].checkOutDate.toString() ?? ""}",
                style: const TextStyle(fontSize: ts22, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  cartApi(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    apis
        .cartListApi(
            widget.parking_spot_id ?? "",
            widget.arrayCounters ?? "",
            widget.bike_id ?? "",
            widget.check_in_date ?? "",
            widget.check_out_date ?? "",
            widget.type ?? "",
            couponId ?? "",
            widget.orderID.toString())
        .then((value) {
      isLoading = false;
      if (value?.status ?? false) {
        setState(() {
          //type = cartListResponse?.extraCharge;
          data = value?.data;
          for (var a in data!) {
            if (a.locker_no != null) {
              arrayCounters == "";
              if (arrayCounters == "") {
                arrayCounters = a.locker_no.toString();
              } else {
                arrayCounters += "," + a.locker_no.toString();
              }
            }
          }

          cartListResponse = value;
          totalAmount = cartListResponse?.totalAmount ?? 0.0;
          baseAmount = cartListResponse?.baseAmount ?? 0.0;

          if (couponId != null) {
            isShow = true;
            showAlertDialog(context, value?.message ?? "");
          } else {
            isShow = false;
          }
        });
      } else {
        isShow = false;
        showAlertDialog2(context, value?.message ?? "",);
        setState(() {
          isLoading = false;
        });
        //Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  showAlertDialog(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message, onTap: () {
      setState(() {
        isShow = false;
      });
      Navigator.pop(context);
    });
  }

  showAlertDialog2(BuildContext context, String message) {
    Dialogs().errorDialog(context, title: message, onTap: () {
      setState(() {
        isShow = false;
      });
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  showApiDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK".tr()),
      onPressed: () {
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) =>
        //         const DashBoardScreen()),
        //         (route) => false);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ThankyouScreen()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Peda Lock"),
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
    var random = Random();
    final builder = XmlBuilder();
    String cartId;
    builder.processing('xml', 'version="1.0"');
    builder.element('mobile', nest: () {
      builder.element('store', nest: () {
        //builder.text('15996');
        builder.text('26981');
      });
      builder.element('key', nest: () {
       // builder.text('pQ6nP-7rHt@5WRFv');
        builder.text('KzsRs#thrj6-8Vwq');
      });

     /* builder.element('firstref', nest: () {
        //builder.text('040028642015');
        builder.text(spPreferences.getString(SpUtil.USER_ID).toString());
      });

      builder.element('ref', nest: () {
        builder.text(spPreferences.getString(SpUtil.USER_ID).toString());
      });*/

      builder.element('testMode', nest: () {
        builder.text(true);
      });

      builder.element('device', nest: () {
        builder.element('type', nest: () {
          builder.text(spPreferences.getString(SpUtil.DEVICE_TYPE).toString());
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
          builder.text("AED");
        });
        builder.element('amount', nest: () {
          builder.text(totalAmount.toString());
        });
        builder.element('language', nest: () {
          builder.text(spPreferences.getString(SpUtil.USER_LANGUAGE) ?? "en");
        });
        // builder.element('firstref', nest: () {
        //   builder.text('first');
        // });

       /* builder.element('firstref', nest: () {
          builder.text('040028642015');
        });*/

        builder.element('firstref', nest: () {
          builder.text('040028642015');
          //builder.text(spPreferences.getString(SpUtil.USER_ID).toString());
        });

       /* builder.element('ref', nest: () {
          builder.text('null');
        });*/

        builder.element('ref', nest: () {
          builder.text(spPreferences.getString(SpUtil.USER_ID).toString());
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
            builder.text(spPreferences.getString(SpUtil.NAME).toString());
          });
          builder.element('last', nest: () {
            builder.text('');
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
          builder.text(spPreferences.getString(SpUtil.MOBILE).toString());
        });
        builder.element('email', nest: () {
          builder.text(spPreferences.getString(SpUtil.EMAIL).toString());
        });
      });
    });

    final bookshelfXml = builder.buildDocument();

    // print(bookshelfXml);
    pay(bookshelfXml);
  }

  void pay(XmlDocument xml) async {
    NetworkHelper _networkHelper = NetworkHelper();
    var response = await _networkHelper.pay(xml);
    print(response);
    Navigator.pop(context);

    if (response == 'failed' || response == null) {
      // failed
      alertShow('Failed');
    } else {
      final doc = XmlDocument.parse(response);
      final url = doc.findAllElements('start').map((node) => node.text);
      final code = doc.findAllElements('code').map((node) => node.text);
      print("if======??? ${url}");
      _url = url.toString();
      String _code = code.toString();
      if (_url.length > 2) {
        _url = _url.replaceAll('(', '');
        _url = _url.replaceAll(')', '');
        _code = _code.replaceAll('(', '');
        _code = _code.replaceAll(')', '');
        print("call_launchURL======???");

        _launchURL(_url, _code, xml);
      }
      print("_url======??? ${_url}");
      final message = doc.findAllElements('message').map((node) => node.text);
      print('Message =  $message');
      if (message.toString().length > 2) {
        String msg = message.toString();
        msg = msg.replaceAll('(', '');
        msg = msg.replaceAll(')', '');
        //createOrderApi(context, "123456");
        alertShow(msg);
      }
    }
  }

  void _launchURL(String url, String code, XmlDocument xml) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => WebViewScreen(
                  type: cartListResponse?.extraCharge.toString(),
                  arrayCounters: arrayCounters,
                  parking_spot_id: widget.parking_spot_id ?? "",
                  xml: xml,
                  bike_id: widget.bike_id ?? "",
                  orderId: widget.orderID,
                  check_in_date: widget.check_in_date.toString(),
                  check_out_date: widget.check_out_date ?? "",
                  total_amount: cartListResponse?.totalAmount.toString(),
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
                Navigator.pop(context);
                setState(() {
                  // _showLoader = false;
                });
                // createOrderApi(context);
              }),
        ],
      ),
    );
  }

  createOrderApi(BuildContext context, transaction_id) async {
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
            cartListResponse?.totalAmount.toString() ?? "",
            widget.orderID ?? "", "")
        .then((value) {
      isLoading = false;
      if (value?.status ?? false) {
        //showAlertDialog1(context, value?.message ?? "");

        //notificationProvider.notificationListingApi(context, false);
        if (widget.type == "complete") {
          showAlertDialog1(context, value?.message?.capitalize() ?? "");
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ThankyouScreen(

                      )));
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
  applyCouponApi(name) async {
    Loaders().loader(context);
    apis.applyCouponApi(name).then((value) {
      Navigator.of(context).pop();
      if (value?.status ?? false) {
        setState(() {

          couponId = value?.data?.id;
          cartApi(context);

          isLoading = false;
        });
      } else {
        couponController.text="";
        setState(() {
          showAlertDialog(context, value?.message ?? "");
          isLoading = false;
        });
      }
    });
  }



}
