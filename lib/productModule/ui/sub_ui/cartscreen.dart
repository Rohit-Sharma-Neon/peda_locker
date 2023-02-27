
import 'dart:math';

import 'package:cycle_lock/productModule/ui/sub_ui/address_book.dart';
import 'package:cycle_lock/productModule/ui/sub_ui/checkout.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../network/api_provider.dart';
import '../../../providers/address_provider.dart';
import '../../../responses/add_cart_modal.dart';
import '../../../ui/widgets/loaders.dart';
import '../../../utils/app_navigator.dart';
import '../../../utils/contextnavigation.dart';
import '../../../utils/images.dart';


class AddCart extends StatefulWidget {
  const AddCart({Key? key}) : super(key: key);

  @override
  State<AddCart> createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  Apis apis = Apis();
  TextEditingController applyCouponController =TextEditingController();
  Data? data;

  var price;


  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Future.delayed(Duration.zero, () {
      if (mounted) {
        getCartApi();
      }
    });
    super.initState();
    final random = Random();
    print(random.nextInt(6));
  }

  Future<bool> _backPressed() async {
    Navigator.pop(context);
      return Future<bool>.value(false);
    }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: const Color(0xFF4A4F58),
        /* set Status bar color in Android devices. */

        statusBarIconBrightness: Brightness.light,
        /* set Status bar icons color in Android devices.*/
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness:
        Brightness.dark) /* set Status bar icon color in iOS. */
    );

    return WillPopScope(
      onWillPop: _backPressed,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            // Set this height
            child: Container(
              margin: const EdgeInsets.only(top: 28),
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    color: const Color(0xFF4A4F58),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 18,left: 15),
                            child: Row(
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    _backPressed();
                                  },
                                  child: const SizedBox(
                                    height: 16,
                                    width: 24,
                                    child: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,),
                                  ),
                                ),

                                 Padding(
                                  padding: const EdgeInsets.only(left: 8.0,top: 3),
                                  child: Text('Cart'.tr(),style: const TextStyle(color: Colors.white,fontSize: 18),),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 20),
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    clearCartApi(null,null);
                                  },
                                  child: Container(
                                    margin:
                                    const EdgeInsets.only(right: 20, left: 5),
                                    child: Text('clear'.tr(),style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.white,fontSize: 16),)

                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: data!=null? Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: data?.cartDetails?.length ?? 0 ,
                    itemBuilder: (BuildContext context,int index){
                      return Container(
                       height: MediaQuery.of(context).size.height*0.20,
                        margin: const EdgeInsets.only(left: 13,right: 13,top: 15),
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          color: const Color(0xFFEFEFEF),
                          elevation: 1.5,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10,left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 120,width: 113,
                                      child: Card(
                                        elevation:0,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10,top: 0,right: 10,bottom: 10),
                                          child: Image.asset(cycleIcon,height: 80,width: 80,),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 200,
                                          margin: const EdgeInsets.only(top: 10,left: 10),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(data?.cartDetails?[index].product?.name ??''.tr(),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                style: const TextStyle(color: Color(0xFF4A4F58),fontSize: 14),)),
                                        ),

                                        const SizedBox(height: 4,),
                                         Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("AED ${data?.cartDetails?[index].product?.price??''}".tr(),style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),)),
                                        ),
                                        const SizedBox(height: 10,),
                                        Row(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(left: 10),
                                              alignment: Alignment.centerLeft,
                                              height: 35,width: 120,
                                              decoration: const BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                  color: Colors.white
                                              ),
                                              child: Row(

                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap:() async {

                                                      if((data?.cartDetails?[index].totalItemQty ?? 0) != 0){
                                                        int count = (data?.cartDetails?[index].totalItemQty ?? 0) - 1;
                                                         await addToCartApi(data?.cartDetails?[index].productId,count, index);
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 3.0),
                                                      child: Image.asset(minesIcon,height: 30,width: 30,),
                                                    ),
                                                  ),
                                                  Text((data?.cartDetails?[index].totalItemQty ?? 0).toString().tr(),style: const TextStyle(color: Colors.black,fontSize: 14),),

                                                  GestureDetector(
                                                    onTap:(){
                                                      int count = (data?.cartDetails?[index].totalItemQty ?? 0) + 1;
                                                      addToCartApi(data?.cartDetails?[index].productId,count, index);
                                                      /*setState(() async {

                                                        await addToCartApi(data?.cartDetails?[index].productId,count, index);

                                                      });*/
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 3.0),
                                                      child: Image.asset(addIcon,height: 30,width: 30,),
                                                    ),
                                                  )


                                                ],
                                              ),
                                            ),
                                             Padding(
                                              padding: const EdgeInsets.only(left: 14.0),
                                              child: Text(data?.cartDetails?[index].totalAmount?? ''.tr(),style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight:FontWeight.w500),),
                                            )
                                          ],
                                        ),

                                      ],
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  clearCartApi(data?.cartDetails?[index].id,data?.cartDetails?[index].cartId);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 4,top: 5),
                                  alignment: Alignment.topRight,
                                    child: const Icon(Icons.clear,color: Color(0xFF79BF89),)),
                              )
                            ],
                          )
                        ),
                      );

                    }),
               const SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          height: 50,
                          margin: const EdgeInsets.only(left: 16,right: 16),
                          decoration: BoxDecoration(
                              color: greyBgColor,
                              borderRadius: BorderRadius.circular(10)),
                          //padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: TextField(
                              controller: applyCouponController..text = data?.discountCode ?? applyCouponController.text,
                              keyboardType: TextInputType.text,
                              cursorColor: greenColor,
                              style: const TextStyle(
                                  color: blackColor,
                                  fontSize: 14,),
                              decoration:  InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Coupon'.tr(),
                                hintStyle: const TextStyle(color: Colors.black),
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: (){
                        apiCall();
                      },
                      child: Container(
                        //width: 190,
                        height: 50,
                        margin: const EdgeInsets.only(right: 16),
                        decoration:  BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: data?.discountCode == null ?Color(0xFF79BF89):Colors.red,
                        ),
                        child:  Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(data?.discountCode == null ? 'ApplyCoupon'.tr() : 'remove'.tr(),style: const TextStyle(color:  Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
                            )),
                      ),
                    )

                  ],
                ),


                // Container(
                //   height: 60,
                //   margin: const EdgeInsets.only(left: 13,right: 13),
                //   child: GestureDetector(
                //     onTap: (){
                //       //applyRemoveCouponApi(data.cartDetails.)
                //     },
                //     child: Container(
                //       margin: const EdgeInsets.only(left: 10,right: 10),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children:  [
                //           SizedBox(
                //             height: 60,
                //             child: TextField(
                //               controller: applyCuponController..text =data?.discountCode ?? "",
                //               decoration: const InputDecoration(
                //                 border: OutlineInputBorder(),
                //                 //labelText: 'User Name',
                //                 hintText: 'Enter Your Name',
                //               ),
                //             ),
                //           ),
                //
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20,),

                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child:  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('PriceBreakdown'.tr(),style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),)),
                ),

                const SizedBox(height: 10,),
                Container(
                  margin: const EdgeInsets.only(left: 15,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                       Text('Price'.tr(),style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),
                      Text(data?.cartAmount??''.tr(),style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                    ],
                  ),
                ),

                // const SizedBox(height: 10,),
                // Container(
                //   margin: const EdgeInsets.only(left: 15,right: 15),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: const [
                //       Text('Delivery Charge:',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),
                //       Text('600.00',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                //     ],
                //   ),
                // ),

                 const SizedBox(height: 10,),
                 data?.discountAmount != null? Container(
                  margin: const EdgeInsets.only(left: 15,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                       Text('DiscountedPrice:'.tr(),style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),
                  Text((data?.discountAmount??'').toString(),style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                    ],
                  ),
                ):Container(),


                const SizedBox(height: 10,),
                 Container(
                  margin: const EdgeInsets.only(left: 15,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text('ShippingCharges:'.tr(),style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),
                       Text(( data?.shippingCharges == 0?data?.shippingCharges??'':"Free"),style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                    ],
                  ),
                ),

                const SizedBox(height: 10,),
                Container(
                  margin: const EdgeInsets.only(left: 15,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                       Text('Total'.tr(),style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),),
                      Text(data?.totalAmount??''.tr(),style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut(data: data?.id.toString(),)));

                  },
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 13,right: 13,top: 20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xFF79BF89)
                    ),
                    child:  Align(
                        alignment: Alignment.center,
                        child: Text("PayNow".tr(),style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),)),
                  ),
                )


              ],
            ):Container(
              //alignment: Alignment.center,
              child:  Align(
                  alignment: Alignment.center,
                  child: Text("DataNotFound".tr())),
            )
              )),
    );
  }

  getCartApi() async {
    var context = NavigationService.navigatorKey.currentContext;

    String? addressId = context!.read<AddressProvider>().defaultAddress?.id.toString() ?? "";
    Loaders().loader(context);
    apis.getCartApi(addressId).then((value) {
      Navigator.pop(context);
      if (value?.status ?? false) {
        setState(() {
          data =value!.data;
        });
      } else {
        setState(() {
          data = null;
        });
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  addToCartApi(productId, qty, index) async {
    var context = NavigationService.navigatorKey.currentContext;
    if(context!.read<AddressProvider>().defaultAddress != null){
      String? addressId = context.read<AddressProvider>().defaultAddress?.id.toString() ?? "";
      Loaders().loader(context);
      apis.addToCartApi(productId.toString(), qty, addressId).then((value) {
        Navigator.pop(context);
        if (value?.status ?? false) {
          getCartApi();
        } else {

          if(value?.is_location == true){appRedirectDialog(context, value?.message ?? "", onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddressBookScreen()));
            },);

          }else{
            appRedirectDialog(context, value?.message ?? "");
          }

        }
      });
    }else{
      appRedirectDialog(context, "Please add your default address", onPressed: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddressBookScreen()));
      },);
    }
  }



  clearCartApi(cartDetailId, cartId) async {
    var context = NavigationService.navigatorKey.currentContext;
    Loaders().loader(context!);
    apis.clearCartApi(cartDetailId,cartId).then((value) {
      Navigator.pop(context);
      if (value?.status ?? false) {
        getCartApi();
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  applyRemoveCouponApi(discountCode, cartId) async {
    var context = NavigationService.navigatorKey.currentContext;
    Loaders().loader(context!);
    apis.applyRemoveCouponApi(discountCode, cartId).then((value) {
      Navigator.pop(context);
      if (value?.status ?? false) {
        applyCouponController.text = "";
        getCartApi();
      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }





  apiCall() async {
    if (applyCouponController.text.isEmpty) {
      appDialog(context, "Please enter Coupon");
    } else {
      if(data?.discountCode == null){
        applyRemoveCouponApi(applyCouponController.text,data?.id);
      }else{
        applyRemoveCouponApi("",data?.id);

      }
      }
    }
  }

