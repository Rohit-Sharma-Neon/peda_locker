

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cycle_lock/productModule/ui/sub_ui/product_detail.dart';
import 'package:cycle_lock/responses/all_subcategory_response.dart';
import 'package:cycle_lock/ui/widgets/common_widget.dart';
import 'package:cycle_lock/ui/widgets/custom_textfield.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/sizes.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import '../../../network/api_provider.dart';
import '../../../responses/all_category.dart';
import '../../../responses/product_list.dart';
import '../../../responses/variant_response.dart';
import '../../../responses/variants_response.dart';
import '../../../ui/widgets/loaders.dart';
import '../../../utils/contextnavigation.dart';
import '../../../utils/images.dart';

class ProductListing extends StatefulWidget {
  String? categoryId;
  String? subcategoryId;
  String? productId;
   ProductListing({Key? key,this.categoryId,this.subcategoryId}) : super(key: key);

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  Apis apis = Apis();
  DataProduct? data;
  List<Datas> datalist =[];
  List<Data> dataList2 = [];
  List<DataSubCategory> subcategorylist = [];

  TextEditingController searchController = TextEditingController();
  RangeValues _currentRangeValues =  const RangeValues(0,0);
  bool isSwitched = false;
  String? limit= '10';
  String? page='1';
  String? sortAlpha = '';
  String? sortPrice = '';
  String? price = '';
  int seriesId=0;
  int currentPage=0;
  var varientId;
  var productId;
  List<String> list =[];
  //String itemlist;
  var image =
      "https://frog-static.s3.ap-south-1.amazonaws.com/adventures_clan/1646736484/1646736484_91cycle-rider.jpg";

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        productListApi(widget.categoryId,widget.subcategoryId,page,limit,sortAlpha,sortPrice,"",varientId,searchController.text);
         variantApi(widget.categoryId,widget.subcategoryId);
        AllSubCategoryApi(widget.categoryId);
        addAllCategoryApi();

      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 60,
        backgroundColor: lightGreyColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: richText("BikeWheels".tr(),
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: ts22)),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.shopping_cart_outlined,
                size: 40, color: Colors.white),
          )
        ],
      ),
      body:   data?.product?.data!=null  /*&& (data?.product?.data ?? []).isNotEmpty*/ ? Column(
        children: [
          Container(
            color: Colors.black,
            child: CustomTextField(
              isRegister: false,
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
                size: 32,
              ),

              keyboardType: TextInputType.text,
              hintText: "search".tr(),
              hintColors: Colors.white,
              style: const TextStyle(color: Colors.white),
              cursorColor: buttonColor,
              controller: searchController,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (s){
               searchController;
               productListApi(widget.categoryId,widget.subcategoryId,page,limit,sortAlpha,sortPrice,"",varientId,searchController.text);
              },

            ),
          ),
          Expanded(
            child: Stack(
              children: [
                 (data?.product?.data ?? []).isNotEmpty?  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GridView.builder(
                      itemCount: data?.product?.data?.length ?? 0,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: .85),
                      itemBuilder: (context, index) => _categoryView(index)),
                ):SizedBox(),
              const SizedBox(
            height: double.infinity,
             ),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: 220,
                  //height: 100,
                  //color: Colors.green,
                  margin: const EdgeInsets.only(bottom: 20,left: 135,top: 10),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: (){

                            _modalBottomSheetMenu(data?.product?.data);
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                filterIcon,
                                height: 24,
                                width: 24,),
                               Padding(
                                padding:  const EdgeInsets.only(left: 8.0),
                                child: Text('Filter'.tr(),style: const TextStyle(color: Color(0xFF79BF89),fontSize: 16,fontWeight: FontWeight.w500),),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(top: 10,bottom: 10),
                          color: Colors.grey,
                          height: 25,width: 2,
                        ),


                        GestureDetector(
                          onTap: (){
                            _modalBottomSheetSortMenu();
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                sortIcon,
                                height: 24,
                                width: 24,),
                               Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('Sort'.tr(),style: const TextStyle(color: Color(0xFF79BF89),fontSize: 16,fontWeight: FontWeight.w500),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ) :const Align(
          alignment: Alignment.center,
          child: Text('Product List Not Found',style: TextStyle(color: greenColor,fontSize: 50,fontWeight: FontWeight.bold),)),
    );
  }

  _categoryView(index) {
    return GestureDetector(
      onTap: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProductDetails(productId: data?.product?.data?[index].id.toString(),)));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8,top: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: gray,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),
                    CachedNetworkImage(
                        imageUrl: "${data?.product?.data?[index].image}",
                          width: 120,
                          height: 120,
                        fit: BoxFit.cover,
                       // width: MediaQuery.of(context).size.width,
                        placeholder: (context, url) =>
                            Container(
                              color: gray,
                            )),
                    // Image.network(
                    //   "${data?.product?.data?[index].image}",
                    //   width: 120,
                    //   height: 120,
                    // ),
                    const SizedBox(height: 16),
                    richText(data?.product?.data?[index].name??"",
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: lightGreyColor)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: richText("AED ${data?.product?.data?[index].price}"??"",
                              maxLines: 1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.black)),
                        ),
                        const Spacer(),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 2, horizontal: 4),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(4),
                        //     color: Colors.white,
                        //   ),
                        //   child: Row(
                        //     children: [
                        //       Icon(Icons.star,
                        //           size: 16, color: Colors.yellow.shade700),
                        //       richText("4.5",
                        //           maxLines: 2,
                        //           style: const TextStyle(
                        //               fontWeight: FontWeight.w500,
                        //               fontSize: 14,
                        //               color: Colors.black)),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: richText("AED ${data?.product?.data?[index].price}"??"",
                    //       maxLines: 2,
                    //       style: const TextStyle(
                    //           fontWeight: FontWeight.w500,
                    //           fontSize: 14,
                    //           decoration: TextDecoration.lineThrough,
                    //           color: lightGreyColor)),
                    // ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 16,
                child: GestureDetector(
                  onTap: (){
                    setState(() async {
                      await addremovewishlistApi(data?.product?.data?[index].id ?? "");
                      if((data?.product?.data?[index].isFav ?? 0) == 1){
                        data?.product?.data?[index].isFav = 0;
                      }else{
                        data?.product?.data?[index].isFav = 1;
                      }
                    });

                  },
                  child: Column(
                    children: [
                  data?.product?.data?[index].isFav!=1? Image.asset(
                    heart,
                    height: 24,
                    width: 24,
                  ):Image.asset(fillheart,height: 24,width: 24,),
                    ],
                  ),
                ),
                // child:data?.product?.data?[index].isFav!=1? Image.asset(
                //   heart,
                //   height: 24,
                //   width: 24,
                // ):Image.asset(heart,color: Colors.red,height: 24,width: 24,),
              ),

            ],
          ),
        ),
      ),
    );
  }
  void _modalBottomSheetMenu(List<Data2>? data){


    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),topRight: Radius.circular(30)
          ),
        ),
        context: context,
        builder: (BuildContext c) {
          for (Data2 element in (data ?? [])) {
            list.add(element.price ?? "");
          }
          var minValue  = list.reduce((curr, next) => double.parse(curr) < double.parse(next)? curr: next);
          var maxValue  = list.reduce((curr, next) => double.parse(curr) > double.parse(next)? curr: next);
          print(minValue);
          print(maxValue);
          _currentRangeValues = RangeValues(double.parse(minValue),double.parse(maxValue));
          return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.70,
                margin: const EdgeInsets.only(top: 20),
                child:  Column(
                  children: [
                     Text('Filter'.tr(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 22),),
                    const SizedBox(height: 15,),

                    const Divider(height: 2,thickness: 1,),

                    const SizedBox(height: 15,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 15,right: 15),

                      child: DropdownButtonFormField<Data>(
                        decoration:  InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Product'.tr(),labelStyle: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500)),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_sharp,size: 35,),
                        items: dataList2.map((Data value) =>
                            DropdownMenuItem<Data>(
                              value: value,
                              child: Text(
                                '${value.name}',
                                softWrap: true,
                              ),
                            ))
                            .toList(),
                        // hint: Text(
                        //     '${selectedSetorTemp.nome} (${selectedSetorTemp.sigla})'),
                        onChanged: (Data? v) {
                          setState(() {
                            // do your logic here!
                            productId = v!.id;
                          });
                        },
                      ),
                      // child: DropdownButton<Datas>(
                      //   hint: Text('Variants'),
                      // icon:  Container(
                      //   margin: EdgeInsets.only(left: 350),
                      //     alignment: Alignment.centerRight,
                      //     child: Icon(Icons.keyboard_arrow_down_sharp)),
                      //   items: datalist.map((Datas value) {
                      //     return DropdownMenuItem<Datas>(
                      //       value: value,
                      //       child: Row(
                      //         children: [
                      //           Text(value.title ?? ""),
                      //         ],
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (v) {
                      //     _dropDownValue = v!.id ??0;
                      //   },
                      // ),
                    ),

                    const SizedBox(height: 20,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 15,right: 15),

                      child: DropdownButtonFormField<DataSubCategory>(
                        decoration:  InputDecoration(
                            border: InputBorder.none,
                            labelText: 'SubCategory'.tr(),labelStyle: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w500)),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_sharp,size: 35,),
                        items: subcategorylist.map((DataSubCategory valuename) =>
                            DropdownMenuItem<DataSubCategory>(
                              value: valuename,
                              child: Text(
                                '${valuename.name}',
                                softWrap: true,
                              ),
                            ))
                            .toList(),
                        // hint: Text(
                        //     '${selectedSetorTemp.nome} (${selectedSetorTemp.sigla})'),
                        onChanged: (DataSubCategory? newValue) {
                          setState(() {
                            // do your logic here!
                            varientId = newValue!.id;
                            print(newValue.id);
                          });
                        },
                      ),
                      // child: DropdownButton<Datas>(
                      //   hint: Text('Variants'),
                      // icon:  Container(
                      //   margin: EdgeInsets.only(left: 350),
                      //     alignment: Alignment.centerRight,
                      //     child: Icon(Icons.keyboard_arrow_down_sharp)),
                      //   items: datalist.map((Datas value) {
                      //     return DropdownMenuItem<Datas>(
                      //       value: value,
                      //       child: Row(
                      //         children: [
                      //           Text(value.title ?? ""),
                      //         ],
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (v) {
                      //     _dropDownValue = v!.id ??0;
                      //   },
                      // ),
                    ),

                    const SizedBox(height: 20,),
                     Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text('PriceRange'.tr(),style: const TextStyle(color: Color(0xFF4A4F58),fontSize: 16,fontWeight: FontWeight.w500),),
                        )),
                    RangeSlider(
                      values: _currentRangeValues,
                      min: 0,
                      max: 1000,
                      //divisions: 10,
                      activeColor: const Color(0xFF79BF89),
                      inactiveColor: Colors.white,
                      labels: RangeLabels(
                        _currentRangeValues.start.round().toString(),
                        _currentRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                        });
                      },
                    ),
                    const SizedBox(height: 15,),
                    Container(
                      margin: const EdgeInsets.only(left: 15,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          Text("AED ${_currentRangeValues.start.toStringAsFixed(2)}",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),),
                           Text("AED ${_currentRangeValues.end.toStringAsFixed(2)}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 16),)
                        ],
                      ),
                    ),

                    const SizedBox(height: 15,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 15,right: 15),

                      child: DropdownButtonFormField<Datas>(
                        decoration:  InputDecoration(
                          border: InputBorder.none,
                            hintText: 'Variants'.tr(),hintStyle: const TextStyle(color: Colors.black)),
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down_sharp,size: 35,),
                        items: datalist.map((Datas rtItem) =>
                            DropdownMenuItem<Datas>(
                              value: rtItem,
                              child: Text(
                                '${rtItem.variantName}',
                                softWrap: true,
                              ),
                            ))
                            .toList(),
                        // hint: Text(
                        //     '${selectedSetorTemp.nome} (${selectedSetorTemp.sigla})'),
                        onChanged: (Datas? newValue) {
                          setState(() {
                            // do your logic here!
                            varientId = newValue!.variantName;
                          });
                        },
                      ),
                      // child: DropdownButton<Datas>(
                      //   hint: Text('Variants'),
                      // icon:  Container(
                      //   margin: EdgeInsets.only(left: 350),
                      //     alignment: Alignment.centerRight,
                      //     child: Icon(Icons.keyboard_arrow_down_sharp)),
                      //   items: datalist.map((Datas value) {
                      //     return DropdownMenuItem<Datas>(
                      //       value: value,
                      //       child: Row(
                      //         children: [
                      //           Text(value.title ?? ""),
                      //         ],
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (v) {
                      //     _dropDownValue = v!.id ??0;
                      //   },
                      // ),
                    ),

                    // const SizedBox(height: 15,),
                    // Container(
                    //   margin: const EdgeInsets.only(left: 15,right: 15),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         children:  [
                    //           Text('Rating'.tr(),style: const TextStyle(color: Color(0xFF4A4F58),fontSize: 16,fontWeight: FontWeight.w500),),
                    //           const Align(
                    //               alignment: Alignment.centerLeft,
                    //               child: Text('5 Star',style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),))
                    //         ],
                    //       ),
                    //       const Icon(Icons.keyboard_arrow_down_sharp,color: Colors.grey,size: 35,)
                    //     ],
                    //   ),
                    // ),
                    //const SizedBox(height: 15,),
                    // Container(
                    //   margin: const EdgeInsets.only(left: 15,right: 15),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //        Text('InStock'.tr(),style: const TextStyle(color: Color(0xFF4A4F58),fontSize: 16,fontWeight: FontWeight.w500),),
                    //
                    //       CupertinoSwitch(
                    //         value: isSwitched,
                    //         activeColor: Colors.black,
                    //         trackColor: Colors.black,
                    //         thumbColor: Colors.green,
                    //         onChanged: (value) {
                    //           print("VALUE : $value");
                    //           setState(() {
                    //             isSwitched = value;
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 15,),
                    GestureDetector(
                      onTap: (){
                        var priceRange=  _currentRangeValues.start.toStringAsFixed(2) +","+_currentRangeValues.end.toStringAsFixed(2);
                        productListApi(widget.categoryId,widget.subcategoryId,page,limit,sortAlpha,sortPrice,varientId,priceRange.toString(),searchController.text);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 15,right: 15),
                        height: 60,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Color(0xFF79BF89)
                        ),
                        child:  Align(
                            alignment: Alignment.center,
                            child: Text("Filter".tr(),style: const TextStyle(color: Colors.white,fontSize: 16),)),
                      ),
                    )


                  ],
                ));
          },);
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
                height: MediaQuery.of(context).size.height * 0.30,
                margin: const EdgeInsets.only(top: 20),
                child:  Column(
                  children: [
                     Text('Sort'.tr(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 22),),
                    const SizedBox(height: 15,),

                    const Divider(height: 2,thickness: 1,),

                    const SizedBox(height: 15,),
                    GestureDetector(
                      onTap: (){
                        var priceRange=  _currentRangeValues.start.toStringAsFixed(2) +","+_currentRangeValues.end.toStringAsFixed(2);
                        productListApi(widget.categoryId,widget.subcategoryId,page,limit,"aToz",sortPrice,varientId,priceRange.toString(),searchController.text);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 15,right: 15),
                        child: Row(
                          children: [
                            Image.asset(alphabetIcon,height: 30,width: 30,),
                             Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('Alphabetically'.tr(),style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){
                       // context.read<ProductListing>().setSort("DESC");
                        var priceRange=  _currentRangeValues.start.toStringAsFixed(2) +","+_currentRangeValues.end.toStringAsFixed(2);
                        productListApi(widget.categoryId,widget.subcategoryId,page,limit,sortAlpha,"high",varientId,priceRange.toString(),searchController.text);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 15,right: 15),
                        child: Row(
                          children: [
                            Image.asset(arrowhighIcon,height: 30,width: 30,),
                             Padding(
                              padding:  const EdgeInsets.only(left: 8.0),
                              child: Text('PriceHighToLow'.tr(),style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){
                        var priceRange=  _currentRangeValues.start.toStringAsFixed(2) +","+_currentRangeValues.end.toStringAsFixed(2);
                        productListApi(widget.categoryId,widget.subcategoryId,page,limit,sortAlpha,'low',varientId,priceRange.toString(),searchController.text);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 15,right: 15),
                        child: Row(
                          children: [
                            Image.asset(arrowlowIcon,height: 30,width: 30,),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text('PriceLowToHigh'.tr(),style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w500),),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ));
          },);
        });


  }

  productListApi(categoryId,subcategoryId,page,limit,sortPrice,sortAlpha,varient,price,search) async {
    var context = NavigationService.navigatorKey.currentContext;
    Loaders().loader(context!);
    apis.productlstApi(categoryId,subcategoryId,page,limit,sortPrice,sortAlpha,price,varient,search).then((value) {
      Navigator.pop(context);
      if (value?.status ?? false) {
        setState(() {
          data = value?.data;
        });

      } else {
        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }


  variantApi(categoryId,subcategoryId) async {
    //showLoader(context);
    var context = NavigationService.navigatorKey.currentContext;
    Loaders().loader(context!);
    // setState(() {
    //   isLoading = true;
    // });
    apis.variantApi(categoryId,subcategoryId).then((value) {
      //isLoading = false;
      if (value?.status ?? false) {
        Navigator.pop(context);
        setState(() {
          datalist=value!.data!;
        });
      } else {
        Navigator.pop(context);
        setState(() {
          //isLoading = false;
        });

        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  addAllCategoryApi() async {
    //showLoader(context);
    var context = NavigationService.navigatorKey.currentContext;
  //  Loaders().loader(context!);
    // setState(() {
    //   isLoading = true;
    // });
    apis.addAllCategoryApi().then((value) {
      //isLoading = false;
      if (value?.status ?? false) {
       // Navigator.pop(context);
        setState(() {
          dataList2 = value!.data!;
          print(value.data);
        });

      } else {
       // Navigator.pop(context);
        setState(() {
          //isLoading = false;
        });

        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }

  AllSubCategoryApi(categoryId) async {
    //showLoader(context);
    var context = NavigationService.navigatorKey.currentContext;
   // Loaders().loader(context!);
    // setState(() {
    //   isLoading = true;
    // });
    apis.AllSubCategoryApi(categoryId).then((value) {
      //isLoading = false;
      if (value?.status ?? false) {
        //Navigator.pop(context);
        setState(() {
          subcategorylist = value!.data!;
          //print(value.data);
        });

      } else {
       // Navigator.pop(context);
        setState(() {
          //isLoading = false;
        });

        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }


  addremovewishlistApi(productId) async {
    //showLoader(context);
    var context = NavigationService.navigatorKey.currentContext;
    Loaders().loader(context!);
    // setState(() {
    //   isLoading = true;
    // });
    apis.addremovewishlistApi(productId.toString()).then((value) {
      //isLoading = false;
      if (value?.status ?? false) {
        Navigator.pop(context);
        setState(() {
          //subcategorylist = value!.data!;
          //print(value.data);
        });

      } else {
        Navigator.pop(context);
        setState(() {
          //isLoading = false;
        });

        Fluttertoast.showToast(msg: value?.message ?? "");
      }
    });
  }
}



