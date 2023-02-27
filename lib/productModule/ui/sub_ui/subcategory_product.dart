import 'package:cycle_lock/productModule/ui/sub_ui/product_listing.dart';
import 'package:cycle_lock/ui/widgets/common_widget.dart';
import 'package:cycle_lock/ui/widgets/custom_textfield.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../network/api_provider.dart';
import '../../../responses/sub_category.dart';
import '../../../ui/widgets/loaders.dart';
import '../../../utils/contextnavigation.dart';

class SubcategoryProduct extends StatefulWidget {
  String? categoryId;
  SubcategoryProduct({Key? key, this.categoryId}) : super(key: key);


  @override
  State<SubcategoryProduct> createState() => _SubcategoryProductState();
}

class _SubcategoryProductState extends State<SubcategoryProduct> {
  var searchController = TextEditingController();
  Data? data;
  Apis apis = Apis();
  var image =
      "https://frog-static.s3.ap-south-1.amazonaws.com/adventures_clan/1646736484/1646736484_91cycle-rider.jpg";

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        subCategoryApi(widget.categoryId);
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
        title: richText("Bike Parts",
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
      body: Column(
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
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: data?.subCategory?.length ?? 0,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: .85),
                    itemBuilder: (context, index) => _subCategoryView(index)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _subCategoryView(index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProductListing(categoryId: data?.subCategory?[index].category?.id.toString(),subcategoryId: data?.subCategory?[index].id.toString(),)));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: .5, color: Colors.grey.withOpacity(.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                      height: 90,
                      width: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90.0),
                          color: lightGreyColor),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(
                            //image,
                            data?.subCategory?[index].image ?? "",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.contain,
                            color: blandColor,
                            colorBlendMode: BlendMode.srcATop,
                          )),),
                  const SizedBox(height: 10),
                  richText(data?.subCategory?[index].name,
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: lightGreyColor)),
                  const SizedBox(height: 4),
                  richText("#200",
                      maxLines: 1,
                      softWrap: false,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: buttonColor))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  subCategoryApi(categoryId) async {
      //showLoader(context);
      var context = NavigationService.navigatorKey.currentContext;
      Loaders().loader(context!);
      // setState(() {
      //   isLoading = true;
      // });
      apis.subCategoryApi(categoryId).then((value) {
        //isLoading = false;
        if (value?.status ?? false) {
          Navigator.pop(context);
          setState(() {
            data = value?.data ;
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
