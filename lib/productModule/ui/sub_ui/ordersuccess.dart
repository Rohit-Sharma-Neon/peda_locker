
import 'package:cycle_lock/productModule/ui/home_dashboard.dart';
import 'package:cycle_lock/utils/images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/app_navigator.dart';
import '../dashboard_product.dart';
import 'orderdetails.dart';


class OrderSuccess extends StatefulWidget {
  const OrderSuccess({Key? key}) : super(key: key);

  @override
  State<OrderSuccess> createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
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
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 200),
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.asset(successcheckIcon,height: 200,),
                const SizedBox(height: 15,),
                 Text('ThankYou'.tr(),style: const TextStyle(color: Colors.black,fontSize: 37,fontWeight: FontWeight.w500),),
                const SizedBox(height: 15,),
                 Text('YourOrderSuccessfully'.tr(),style: const TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w500),),
                 Text('placedWith'.tr(),style: const TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.w500),),

                const SizedBox(height: 20,),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DashboardProduct()));

                  },
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 18,right: 18,top: 20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xFF79BF89)
                    ),
                    child:  Align(
                        alignment: Alignment.center,
                        child: Text("ContinueShopping".tr(),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)),
                  ),
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>   OrderDetailsScreen1()));

                  },
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.only(left: 18,right: 18,top: 20),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Color(0xFF79BF89)
                    ),
                    child:  Align(
                        alignment: Alignment.center,
                        child: Text("TrackOrder".tr(),style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),)),
                  ),
                )
              ],
            ),
          )
        ));
  }
}
