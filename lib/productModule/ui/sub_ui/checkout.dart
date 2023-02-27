
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../network/api_provider.dart';
import '../../../providers/address_provider.dart';
import '../../../ui/widgets/loaders.dart';
import '../../../utils/app_navigator.dart';
import '../../../utils/contextnavigation.dart';
import '../../../utils/dialogs.dart';
import 'address_book.dart';

class CheckOut extends StatefulWidget {
  String? data;
   CheckOut({Key? key,this.data}) : super(key: key);

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  TextEditingController namecardController = TextEditingController();
  TextEditingController cardnumberController = TextEditingController();
  TextEditingController expdateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  Apis apis = Apis();


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Color(0xFF4A4F58),
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
                          padding: EdgeInsets.only(top: 18,left: 15),
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

                              const Padding(
                                padding: EdgeInsets.only(left: 12.0,top: 3),
                                child: Text('Checkout',style: TextStyle(color: Colors.white,fontSize: 22,fontWeight: FontWeight.w500),),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: Container(
                                    margin:
                                    const EdgeInsets.only(right: 20, left: 5),
                                    child:const Text('AED 560.00',style: TextStyle(
                                        color: Colors.white,fontSize: 22,fontWeight: FontWeight.w500),)

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
          child: Column(
            children: [
                 Container(
                   color: const Color(0xFFEFEFEF),
                   height: 59,
                   //margin: EdgeInsets.only(left: 15,right: 15,top: 0),
                   child:Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children:  [
                       const Padding(
                         padding: EdgeInsets.only(left: 15.0),
                         child: Text('Deliver to',style: TextStyle(color: Color(0xFF4A4F58),fontWeight: FontWeight.w500,fontSize: 16),),
                       ),
                       GestureDetector(
                         onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) =>  const AddressBookScreen()));
                         },
                         child: const Padding(
                           padding: EdgeInsets.only(right: 15.0),
                           child: Text('Change',
                             style: TextStyle(color: Color(0xFF79BF89),fontWeight: FontWeight.w500,fontSize: 16,decoration: TextDecoration.underline),),
                         ),
                       )
                     ],
                   ) ,
                 ),
              const SizedBox(height: 15,),

              Container(
                margin: const EdgeInsets.only(left: 15),
                child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Home',style:TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500) ,)),
              ),

              const SizedBox(height: 10,),

              Container(
                margin: const EdgeInsets.only(left: 15),
                child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('201, Abdullah Building, Building No - 7, Al Mankhool, UAE',style:TextStyle(color:Color(0xFF4A4F58),fontSize: 16,fontWeight: FontWeight.w500) ,)),
              ),

              const SizedBox(height: 16,),
              Container(
                color: const Color(0xFFEFEFEF),
                height: 59,
                //margin: EdgeInsets.only(left: 15,right: 15,top: 0),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text('Online Payment',style: TextStyle(color: Color(0xFF4A4F58),fontWeight: FontWeight.w500,fontSize: 16),),
                    ),
                  ],
                ) ,
              ),

              const SizedBox(height: 16,),
              Container(
                margin: const EdgeInsets.only(left: 15),
                child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Enter Card Detail',style:TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500) ,)),
              ),
              const SizedBox(height: 16,),
               Container(
                 margin: const EdgeInsets.only(left: 15,right: 15),
                 child: TextFormField(
                   controller: namecardController,
                  style: const TextStyle(color: Colors.black,fontFamily: 'poppins',fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  autocorrect: false,
                   keyboardType: TextInputType.number,
                    enableSuggestions: false,
                    inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    ],
                     decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            border: InputBorder.none,
            hintStyle: TextStyle(decorationColor: Colors.black,color: Colors.black),
            labelText:'Name on Card',
            labelStyle: TextStyle(color: Color(0xFF7B7979),fontSize: 18)
        ),
      ),
               ),


              const SizedBox(height: 16,),
              Container(
                margin: const EdgeInsets.only(left: 15,right: 15),
                child: TextFormField(
                  controller: cardnumberController,
                  style: const TextStyle(color: Colors.black,fontFamily: 'poppins',fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  autocorrect: false,
                 // keyboardType: TextInputType.number,
                  enableSuggestions: false,
                  // inputFormatters: [
                  //   LengthLimitingTextInputFormatter(10),
                  // ],
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      border: InputBorder.none,
                      hintStyle: TextStyle(decorationColor: Colors.black,color: Colors.black),
                      labelText:'Enter Card Number',
                      labelStyle: TextStyle(color: Color(0xFF7B7979),fontSize: 18)
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Row(
                children: [
                  Container(
                    width: 200,
                    margin: const EdgeInsets.only(left: 15,right: 15),
                    child: TextFormField(
                      controller: expdateController,
                      style: const TextStyle(color: Colors.black,fontFamily: 'poppins',fontWeight: FontWeight.w500),
                      cursorColor: Colors.black,
                      autocorrect: false,
                      //keyboardType: TextInputType.number,
                      enableSuggestions: false,
                      // inputFormatters: [
                      //   LengthLimitingTextInputFormatter(10),
                      // ],
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          border: InputBorder.none,
                          hintStyle: TextStyle(decorationColor: Colors.black,color: Colors.black),
                          labelText:'Exp. Date',
                          labelStyle: TextStyle(color: Color(0xFF7B7979),fontSize: 18)
                      ),
                    ),
                  ),

                  Container(
                    width: 120,
                    margin: const EdgeInsets.only(left: 5,right: 15),
                    child: TextFormField(
                      controller: cvvController,
                      style: const TextStyle(color: Colors.black,fontFamily: 'poppins',fontWeight: FontWeight.w500),
                      cursorColor: Colors.black,
                      autocorrect: false,
                      //keyboardType: TextInputType.number,
                      enableSuggestions: false,
                      // inputFormatters: [
                      //   LengthLimitingTextInputFormatter(10),
                      // ],
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          border: InputBorder.none,
                          hintStyle: TextStyle(decorationColor: Colors.black,color: Colors.black),
                          labelText:'CVV',
                          labelStyle: TextStyle(color: Color(0xFF7B7979),fontSize: 18)
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  checkOutApi(widget.data,"","");
                  print(widget.data);
                  //openOrderSuccess(context);
                 // openMyOrder(context);
                },
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(left: 13,right: 13,top: 20),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color(0xFF79BF89)
                  ),
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text("Pay Now",style: TextStyle(color: Colors.white,fontSize: 16),)),
                ),
              )
            ],
          ),
        ));
  }
  checkOutApi(cartID, refNo, transactionNo) async {
    refNo = "ref_"+ DateTime.now().microsecondsSinceEpoch.toString();
    transactionNo = "tra_"+ DateTime.now().microsecondsSinceEpoch.toString();
    var context = NavigationService.navigatorKey.currentContext;
    if(context!.read<AddressProvider>().defaultAddress != null){
      String? addressId = context.read<AddressProvider>().defaultAddress?.id.toString() ?? "";
      Loaders().loader(context);
      apis.checkOutApi(cartID.toString(), refNo,transactionNo, addressId).then((value) {
        Navigator.pop(context);
        if (value?.status ?? false) {
          openOrderSuccess(context);
        }else{
          appRedirectDialog(context, value?.message ?? "");
        }
      });
    }else{
      appRedirectDialog(context, "Please add your default address", onPressed: () {
        Navigator.pop(context);
        //Navigator.push(context, MaterialPageRoute(builder: (context) => AddressBookScreen()));
      },);
    }
  }
}
