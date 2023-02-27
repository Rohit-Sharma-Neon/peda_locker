
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../network/api_provider.dart';
import '../../../responses/order_details_modal.dart';
import '../../../ui/widgets/loaders.dart';
import '../../../utils/app_navigator.dart';
import '../../../utils/colors.dart';
import '../../../utils/images.dart';

class OrderDetailsScreen1 extends StatefulWidget {
  String? id;
   OrderDetailsScreen1({Key? key,this.id}) : super(key: key);

  @override
  State<OrderDetailsScreen1> createState() => _OrderDetailsScreen1State();
}

class _OrderDetailsScreen1State extends State<OrderDetailsScreen1> {

  List<Step> steps = [];
  Apis apis = Apis();
  Data? data;
  int? index;
  var rating;
  TextEditingController starController =TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        orderDetailsApi(widget.id, context);
      }
    });
    super.initState();
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

    return Scaffold(
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
                                  Navigator.pop(context);
                                },
                                child: const SizedBox(
                                  height: 16,
                                  width: 24,
                                  child: Icon(Icons.arrow_back_ios_outlined,color: Colors.white,),
                                ),
                              ),

                               Padding(
                                padding: const EdgeInsets.only(left: 8.0,top: 3),
                                child: Text('#${data?.orderNo ?? ""}',style: const TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w500),),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
            child:Column(
              children: [
                const SizedBox(height: 10,),
                Container(
                  margin: const EdgeInsets.only(top: 10,left: 15,right:15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text('#${data?.orderNo ?? ""}',style: const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
                      Container(
                        //height: 30,
                        //margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                            color: Color(0xFF4A4F58)
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Text(statusText(data?.status.toString() ?? "") ?? "",style: const TextStyle(color: Colors.white,fontSize: 12),),
                            )),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Row(
                    children:  [
                      const Icon(Icons.clean_hands),
                      Text('${data?.orderDate ?? ""}AM',style: const TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w500),)
                    ],
                  ),
                ),

                const SizedBox(height: 20,),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: data?.orderDetails?.length ?? 0,
                    itemBuilder: (BuildContext context,int index)  {
                    return Container(
                      height: MediaQuery.of(context).size.height*0.20,
                      margin: const EdgeInsets.only(top: 10,left: 15,right: 15),
                      child: Card(
                        color: const Color(0xFFEFEFEF),
                        child:Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Card(
                                    elevation:0,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all( 14.0),
                                      child: Image.network(
                                      "${data?.orderDetails?[0].product?.image}",
                                      height: 80,width: 80,),
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
                                          child: Text(data?.orderDetails?[0].product?.name ?? "",style: const TextStyle(color: Color(0xFF4A4F58),fontSize: 14),)),
                                    ),
                                            Text(data?.orderDetails?[0].product?.description ?? "",style: TextStyle(color: const Color(0xFF4A4F58),fontSize: 14),),

                                     const SizedBox(height: 4,),
                                     Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('AED${data?.orderDetails?[0].product?.price ?? ""}*${data?.orderDetails?[0].totalItemQty ?? ""}',style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),)),
                                     Text('AED${data?.cartAmount ?? ""}',style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight:FontWeight.w500),),

                                  ],
                                )
                              ],
                            ),
                          ],
                        ) ,
                      ),
                    );
                  }
                ),

                const SizedBox(height: 20,),

                Container(
                  color: const Color(0xFFEFEFEF),
                  height: 59,
                  //margin: EdgeInsets.only(left: 15,right: 15,top: 0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text('DeliverTo'.tr(),style: const TextStyle(color: Color(0xFF4A4F58),fontWeight: FontWeight.w500,fontSize: 16),),
                      ),
                    ],
                  ) ,
                ),
                const SizedBox(height: 15,),

                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child:  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Home'.tr(),style:const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500) ,)),
                ),

                const SizedBox(height: 0,),

                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child:  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(data?.orderAddress?.address ?? "",style:TextStyle(color:Color(0xFF4A4F58),fontSize: 16,fontWeight: FontWeight.w500) ,)),
                ),

                const SizedBox(height: 16,),
                Container(
                  color: const Color(0xFFEFEFEF),
                  height: 65,
                  //margin: EdgeInsets.only(left: 15,right: 15,top: 0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text('OrderStatus'.tr(),style: const TextStyle(color: Color(0xFF4A4F58),fontWeight: FontWeight.w500,fontSize: 16),),
                      ),
                    ],
                  ) ,
                ),
                buildOrderStatus(),

                data?.status==5? GestureDetector(
                  onTap: (){
                  },
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 15,right: 15,top: 20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xFF4A4F58)
                    ),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Text("Download Receipt",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)),
                  ),
                ):Container(),


                const SizedBox(height: 15,),
                Container(
                    margin: const EdgeInsets.only(bottom: 10,left: 15,right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        data?.status==5?GestureDetector(
                            onTap:(){
                              _modalBottomSheetSortMenu();
                            },
                            child: Container(
                              height: 50,width: 161,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  color: Color(0xFF79BF89)
                              ),
                              child:  Align(
                                  alignment: Alignment.center,
                                  child: Text("RateNow".tr(),style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),)),
                            )):Container(),

                        data?.status==5 || data?.status==6 ?  GestureDetector(
                          onTap: (){
                            openCheckOut(context);
                          },
                          child: Container(
                            height: 50,width: 161,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Color(0xFF79BF89)
                            ),
                            child:  Align(
                                alignment: Alignment.center,
                                child: Text("Rebook".tr(),style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),)),
                          ),
                        ):Container()
                      ],
                    ))
              ],
            )
        ));
  }

  buildOrderStatus() {

      _stepBuild();


    return  Theme(
      data: ThemeData(colorScheme: const ColorScheme.light(primary: Colors.green)),
      child: Stepper(
        physics: const NeverScrollableScrollPhysics(),
        // currentStep: currentStep,
        steps: steps,
        type: StepperType.vertical,
        controlsBuilder: (BuildContext ctx, ControlsDetails dtl) {
          return Row(
            children: const [],
          );
        },
      ),
    ) ;
  }


  _stepBuild() {
    steps = [];
    steps = [
      const Step(
          title: Text('Accepted by store',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),),
          content: Text(''),
          subtitle: Text('01-07-2022, 5:00 pm',style: TextStyle(color: Color(0xFF4A4F58),fontSize: 14,fontWeight: FontWeight.bold)),
          isActive: true,
          state: StepState.complete
          //state: (data?.orderTracks?.length ?? 0) > 0 ?  StepState.complete : StepState.indexed
      ),

        const Step(
            title: Text('Being Prepared',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
            subtitle: Text('01-07-2022, 5:00 pm',style: TextStyle(color: Color(0xFF4A4F58),fontSize: 14,fontWeight: FontWeight.bold)),
            content: Text(''),
            isActive: true,
            state: StepState.complete
            //state: (data?.orderTracks?.length ?? 0) > 1 ?  StepState.complete : StepState.indexed
        ),

        const Step(
            title: Text('On the way',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)
               ),
            content: Text(''),
            subtitle: Text('01-07-2022, 5:00 pm',style: TextStyle(color: Color(0xFF4A4F58),fontSize: 14,fontWeight: FontWeight.bold)),
            isActive: true,
            state: StepState.complete
            //state: (data?.orderTracks?.length ?? 0) > 2 ?  StepState.complete : StepState.indexed
        ),
        const Step(
            title: Text('Delivered',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)),
            content: Text(''),
            subtitle: Text('01-07-2022, 5:00 pm',style: TextStyle(color: Color(0xFF4A4F58),fontSize: 14,fontWeight: FontWeight.bold)),
            //isActive: true,
            state: StepState.complete
            //state: (data?.orderTracks?.length ?? 0) > 3 ?  StepState.complete : StepState.indexed
        ),

    ];
  }
  orderDetailsApi(orderId, context) async {
    //showLoader(context);
    //var context = NavigationService.navigatorKey.currentContext;
    Loaders().loader(context);
    apis.orderDetailsApi(orderId).then((value) {
      Navigator.pop(context);
      if (value?.status ?? false) {

        if(value?.data != null && value!.data!.orderDetails!.isNotEmpty){
          data = value.data ;
        }else{
          data = null;
        }
        setState(() {});

      } else {
         Navigator.pop(context);
        setState(() {
          data = null;
        });

        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  void _modalBottomSheetSortMenu(){
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
                        orderRatingReviewApi(widget.id,starController.text,rating,context);
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

      } else {
        Navigator.pop(context);
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
}
