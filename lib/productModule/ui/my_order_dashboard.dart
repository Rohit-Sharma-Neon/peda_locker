import 'package:cycle_lock/productModule/ui/sub_ui/orderdetails.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../network/api_provider.dart';
import '../../responses/order_list_response.dart';
import '../../ui/widgets/loaders.dart';
import '../../utils/app_navigator.dart';
import '../../utils/contextnavigation.dart';
import '../../utils/utility.dart';

class MyOrderDashboard extends StatefulWidget {
  const MyOrderDashboard({Key? key}) : super(key: key);

  @override
  State<MyOrderDashboard> createState() => _MyOrderDashboardState();
}

class _MyOrderDashboardState extends State<MyOrderDashboard> {
  Apis apis = Apis();
  Data? data;
  String? limit= '10';
  String? page='1';
  String? type;
  int currentMatchIndex =0;
  var rating;
  TextEditingController starController =TextEditingController();


  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        orderListingApi(page, limit, "all", context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child:  Container(
          margin: const EdgeInsets.only(top: 20,left: 20,right: 20),
          child:  Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                height: 40,
                child:  DefaultTabController(
                    length: 4,
                    child:  Container(
                      child: TabBar(
                        labelPadding: const EdgeInsets.all(0),
                        onTap: (int index) {
                          if(index==0){
                            type = "all";
                          }else if(index==1){
                            type = "new";
                          }else if(index==2){
                            type = "complete";
                          }else {
                            type = "cancel";
                          }
                          setState(() {
                            currentMatchIndex = index;
                          });


                          orderListingApi(page, limit, type, context);

                        },
                        indicatorWeight:1,
                        indicator: const UnderlineTabIndicator(
                            borderSide: BorderSide(width: 2.0,color: Colors.green),
                            insets: EdgeInsets.symmetric(horizontal:5.0)
                        ),
                        isScrollable: false,
                        tabs: [
                          Text('AllOrders'.tr(),style: TextStyle(color: currentMatchIndex==0?Colors.green:Colors.grey,fontSize: 16),),
                          Text('New'.tr(),style: TextStyle(color: currentMatchIndex==1?Colors.green:Colors.grey,fontSize: 16),),
                          Text('Completed'.tr(),style: TextStyle(color: currentMatchIndex==2?Colors.green:Colors.grey,fontSize: 16),),
                          Text('Cancelled'.tr(),style: TextStyle(color: currentMatchIndex==3?Colors.green:Colors.grey,fontSize: 16),),
                        ],
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
      body:  SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: data?.order?.data != null ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: data?.order?.data?.length ?? 0 ,
            itemBuilder: (BuildContext context,int index) {
              return  GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>   OrderDetailsScreen1(id: data?.order?.data?[index].id.toString(),)));

                },
                child: Container(
                  //height: MediaQuery.of(context).size.height*0.39,
                  margin: const EdgeInsets.only(top: 10,left: 15,right: 15),
                 // padding: EdgeInsets.only(bottom: 16),
                  child: Card(
                    color: const Color(0xFFEFEFEF),
                    child:Column(
                      children: [
                        Container(
                          // padding: EdgeInsets.only(bottom: 16),
                          margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text("#${data?.order?.data?[index].orderNo??""}",style: const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                              Container(
                                height: 35,width: 120,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(2)),
                                    color: Colors.black
                                ),
                                child:  Align(
                                    alignment: Alignment.center,
                                    child:
                                    Text(statusText(data?.order?.data?[index].status.toString() ?? "") ?? "",style: const TextStyle(color: Colors.white,fontSize: 12),)                               )
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Row(
                            children:  [
                              const Icon(Icons.clean_hands),
                              Text("${data?.order?.data?[index].orderDate ??""}AM",style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                elevation:0,
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all( 16.0),
                                  child: Image.network(data?.order?.data?[index].orderDetails?[0].product?.image ?? ""
                                    ,height: 80,width: 80,),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 15,left: 0),
                                  child:  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(data?.order?.data?[index].orderDetails?[0].product?.name ?? "",style: TextStyle(color: Color(0xFF4A4F58),fontSize: 14),)),
                                ),
                                Text(data?.order?.data?[index].orderDetails?[0].product?.description ?? "",style: const TextStyle(color: Color(0xFF4A4F58),fontSize: 14),),
                                const SizedBox(height: 4,),
                                 Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('AED${data?.order?.data?[index].orderDetails?[0].product?.price ?? ""}*${data?.order?.data?[index].orderDetails?[0].totalItemQty ?? ""}',
                                      style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),)),
                                const SizedBox(height: 0,),
                                 Text('AED${data?.order?.data?[index].cartAmount ?? ""}',style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.w500),),

                              ],
                            )
                          ],
                        ),
                        const Divider(height: 1,thickness: .5,),
                        const SizedBox(height: 15,),
                        Container(
                            margin: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                data?.order?.data?[index].status==5?GestureDetector(
                                    onTap:(){
                                      _modalBottomSheetRatingMenu(data?.order?.data?[index].id);
                                      // openAddCart(context);
                                    },
                                    child: Container(
                                      height: 45,width: 155,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                          color: Color(0xFF79BF89)
                                      ),
                                      child:  Align(
                                          alignment: Alignment.center,
                                          child: Text("RateNow".tr(),style: const TextStyle(color: Colors.white,fontSize: 16),)),
                                    )):Container(),

                                data?.order?.data?[index].status==5 || data?.order?.data?[index].status==6 ?GestureDetector(
                                  onTap: (){
                                    reOrderApi(data?.order?.data?[index].id,context);
                                    //openCheckOut(context);
                                  },
                                  child: Container(
                                    height: 45,width: 155,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Color(0xFF79BF89)
                                    ),
                                    child:  Align(
                                        alignment: Alignment.center,
                                        child: Text("Rebook".tr(),style: const TextStyle(color: Colors.white,fontSize: 16),)),
                                  ),
                                ):const SizedBox()
                              ],
                            )),

                       (data?.order?.data?[index].status != 5 && data?.order?.data?[index].status != 6) ? GestureDetector(
                           onTap: (){
                             orderCancelledApi(data?.order?.data?[index].id, context);
                           },
                           child: Padding(
                             padding: const EdgeInsets.only(bottom: 8.0),
                             child: Container(
                              height: 45,
                              margin: const EdgeInsets.only(left: 16,right: 16),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Color(0xFF79BF89)
                              ),
                              child: const Align(
                                  alignment: Alignment.center,
                                  child: Text("Order Cancel",style: TextStyle(color: Colors.white,fontSize: 16),)),
                        ),
                           ),
                         ):const SizedBox()
                      ],
                    ) ,
                  ),
                ),
              );
            }):
         Center(child: Container(
             alignment: Alignment.center,
             padding: const EdgeInsets.symmetric(horizontal: 48,vertical: 300),
            child: const Text("Data Not Found",textAlign: TextAlign.center,
              style: TextStyle(color: buttonColor,fontSize: 36,fontWeight: FontWeight.bold),))),
      ),
    );
  }


  orderListingApi(page,limit,type, context) async {
    //showLoader(context);
    //var context = NavigationService.navigatorKey.currentContext;
    Loaders().loader(context);
    apis.orderListingApi(page,limit,type).then((value) {
       Navigator.pop(context);
      if (value?.status ?? false) {

        if(value?.data?.order?.data != null && value!.data!.order!.data!.isNotEmpty){
          data = value.data ;
        }else{
          data = null;
        }
        setState(() {});

      } else {
       // Navigator.pop(context);
        setState(() {
          data = null;
        });

        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }


  reOrderApi(orderId, context) async {
    //showLoader(context);
    //var context = NavigationService.navigatorKey.currentContext;
    Loaders().loader(context);
    apis.reOrderApi(orderId).then((value) {
      Navigator.pop(context);
      if (value?.status ?? false) {
        orderListingApi(page, limit, type, context);
      } else {
        // Navigator.pop(context);
        setState(() {
          data = null;
        });

        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  String? statusText(status){
    if(status=="0"){
      return "Pending";
    }else if(status=="1"){
      return "Accepted";
    }else if(status=="2"){
      return "Prepared";
    }else if(status=="3"){
      return "OnWay";
    }else if(status=="5"){
      return "Completed";
    }else if(status=="6"){
      return "Cancelled";
    }
    }

  void _modalBottomSheetRatingMenu(id){
    showModalBottomSheet(
      //isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),topRight: Radius.circular(30)
          ),
        ),
        context: context,
        builder: (BuildContext c) {
          return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.40,
                margin: const EdgeInsets.only(top: 20),
                child:  Column(
                  children: [
                    Text('Rating & Rating'.tr(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 22),),
                    const SizedBox(height: 15,),

                    const Divider(height: 2,thickness: 1,),

                    const SizedBox(height: 15,),

                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text("Give Rating",style:TextStyle(color: Color(0xFF4A4F58),fontWeight: FontWeight.w500,fontSize: 16) ,),
                        )),

                    SizedBox(
                      height: 50,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SmoothStarRating(
                              allowHalfRating: false,
                              onRated: (v) {
                                setState(() {
                                  rating=v;
                                });
                                print(rating);
                              },
                              starCount: 5,

                              size: 40.0,
                              // isReadOnly:true,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              color: Colors.orangeAccent,
                              borderColor: Colors.black,
                              spacing:10.0
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15,),

                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0),
                          child: Text("Give Review",style:TextStyle(color: Color(0xFF4A4F58),fontWeight: FontWeight.w500,fontSize: 16) ,),
                        )),

                    Container(
                        height: 50,
                        margin: const EdgeInsets.only(left: 16,right: 16),
                        decoration: BoxDecoration(
                          //color: greyBgColor,
                            borderRadius: BorderRadius.circular(10)),
                        //padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: TextField(
                            controller:starController,
                            keyboardType: TextInputType.text,
                            cursorColor: greenColor,
                            style: const TextStyle(
                              color: blackColor,
                              fontSize: 14,),
                            decoration:  InputDecoration(
                              // border: InputBorder.none,
                              hintText: 'Write Here...'.tr(),
                              hintStyle: const TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                          ),
                        )),
                    const SizedBox(height: 50,),

                    GestureDetector(
                      onTap: (){
                        orderRatingReviewApi(id,starController.text,rating,context);
                        print(starController.text);
                      },
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(left: 15,right: 15),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFF79BF89)
                        ),
                        child: const Align(
                            alignment: Alignment.center,
                            child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),)),
                      ),
                    )
                  ],
                ));
          },);
        });


  }

  orderRatingReviewApi(orderId,review,rating,context) async {
    //showLoader(context);
    //var context = NavigationService.navigatorKey.currentContext;
    Loaders().loader(context);
    apis.orderRatingReviewApi(orderId,review,rating).then((value) {
      Navigator.pop(context);
      if (value?.status ?? false) {
        orderListingApi(page, limit, type, context);

      } else {
        Navigator.pop(context);
        setState(() {
          data = null;
        });

        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }


  orderCancelledApi(orderId,context) async {
    //showLoader(context);
    //var context = NavigationService.navigatorKey.currentContext;
    Loaders().loader(context);
    apis.orderCancelledApi(orderId).then((value) {
      Navigator.pop(context);
      if (value?.status ?? false) {
        orderListingApi(page, limit, type, context);

      } else {
        Navigator.pop(context);
        setState(() {
          data = null;
        });

        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }
}
