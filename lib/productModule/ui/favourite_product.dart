import 'package:cycle_lock/ui/widgets/common_widget.dart';
import 'package:cycle_lock/ui/widgets/custom_textfield.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../network/api_provider.dart';
import '../../responses/wishlist_response.dart';
import '../../ui/widgets/loaders.dart';
import '../../utils/contextnavigation.dart';

class FavoriteProduct extends StatefulWidget {
  const FavoriteProduct({Key? key}) : super(key: key);

  @override
  State<FavoriteProduct> createState() => _FavoriteProductState();
}

class _FavoriteProductState extends State<FavoriteProduct> {
  var searchController = TextEditingController();
  List<Data>? datalist =[];
  Apis apis = Apis();
  var image =
      "https://e7.pngegg.com/pngimages/966/13/png-clipart-bicycle-tires-bicycle-wheels-bicycle-tyre-bicycle-frame-bicycle.png";

  void initState() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
       wishlistApi();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return datalist!=null && (datalist ?? []).isNotEmpty? Column(
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
          ),
        ),
        Expanded(
          child:datalist!=null? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
                itemCount: datalist?.length ,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: .85),
                itemBuilder: (context, index) => _categoryView(index))
          ):Container(
            margin: EdgeInsets.only(top: 40),
            child: const Align(
                alignment: Alignment.center,
                child:  Text("Data Not Found",style: TextStyle(color: Colors.black,fontSize: 20),)),
        )
        ),
      ],
    ):const Align(
        alignment: Alignment.center,
        child: Text('Data Not Found',style: TextStyle(color: greenColor,fontSize: 20,fontWeight: FontWeight.bold),));

  }

  _categoryView(index) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context) => const SubcategoryProduct()));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    Image.network(
                      datalist?[index].image ?? "",
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 16),
                    richText(datalist?[index].name ?? "",
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: lightGreyColor)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        richText("AED 150.00",
                            maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Colors.black)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star,
                                  size: 16, color: Colors.yellow.shade700),
                              richText("4.5",
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: Colors.black)),
                            ],
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: richText(datalist?[index].price ?? "",
                          maxLines: 2,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: lightGreyColor)),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 16,
                child: GestureDetector(
                  onTap: (){
                    addremovewishlistApi(datalist?[index].id);
                    datalist?.removeAt(index);
                    },
                  child: Image.asset(
                    fillheart,
                    height: 24,
                    width: 24,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  wishlistApi() async {
    //showLoader(context);
    var context = NavigationService.navigatorKey.currentContext;
    Loaders().loader(context!);
    // setState(() {
    //   isLoading = true;
    // });
    apis.wishlistApi().then((value) {
      //isLoading = false;
      if (value?.status ?? false) {
        Navigator.pop(context);
        setState(() {
          datalist = value!.data!;
        });
      } else {
        Navigator.pop(context);
        setState(() {
          //isLoading = false;
        });

        Fluttertoast.showToast(msg: value?.message ?? "",textColor: Colors.green);
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
