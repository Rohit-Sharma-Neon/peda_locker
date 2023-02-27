import 'package:cycle_lock/productModule/ui/sub_ui/product_listing.dart';
import 'package:cycle_lock/productModule/ui/sub_ui/subcategory_product.dart';
import 'package:cycle_lock/providers/address_provider.dart';
import 'package:cycle_lock/ui/widgets/common_widget.dart';
import 'package:cycle_lock/ui/widgets/loaders.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/contextnavigation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../network/api_provider.dart';
import '../../providers/product_detail_provider.dart';
import '../../responses/all_category.dart';
import '../../responses/product_category.dart';
import '../../utils/dialogs.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);



  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {

  List<Category>? dataList = [];


  Apis apis = Apis();
  bool isLoading = true;
 // late ScrollController _scrollController;
  var image = "https://frog-static.s3.ap-south-1.amazonaws.com/adventures_clan/1646736484/1646736484_91cycle-rider.jpg";
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        addAllCategoryApi();
      }


    });

    super.initState();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
          clipBehavior: Clip.none,
          itemCount:  dataList?.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            mainAxisSpacing: 0,
            childAspectRatio: 1,
            mainAxisExtent: 190,
            crossAxisSpacing: 2
          ),
          itemBuilder: (context, index) => _categoryView(index)),
    );
  }

  _categoryView(index) {
    return GestureDetector(
      onTap: () {
      dataList?[index].subcategory_count ==0?
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProductListing(categoryId: dataList?[index].id.toString(),subcategoryId: "",))):
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  SubcategoryProduct(categoryId: dataList?[index].id.toString()),));

      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.network(
                  //image,
                  "${dataList![index].image}",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitWidth,
                  color: blandColor,
                  colorBlendMode: BlendMode.darken,
                )),
            Positioned(
              left: 16,
              bottom: 16,
              right: 1,
              child: richText(dataList![index].name ?? "",
                  textAlign: TextAlign.start,
                  style:
                      const TextStyle(fontWeight: FontWeight.w400, fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }


  addAllCategoryApi() async {
   //showLoader(context);
    var context = NavigationService.navigatorKey.currentContext;
   Loaders().loader(context!);
    // setState(() {
    //   isLoading = true;
    // });
    apis.addCategoryApi().then((value) {
      //isLoading = false;
      if (value?.status ?? false) {
        Navigator.pop(context);
        setState(() {
          dataList = value!.data!.category!;
          context.read<AddressProvider>().setDefaultAddress(value.data!.address);
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
