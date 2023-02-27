import 'package:cycle_lock/productModule/ui/favourite_product.dart';
import 'package:cycle_lock/productModule/ui/home_dashboard.dart';
import 'package:cycle_lock/productModule/ui/my_order_dashboard.dart';
import 'package:cycle_lock/providers/notification_provider.dart';
import 'package:cycle_lock/ui/main/dashboard_screen.dart';
import 'package:cycle_lock/ui/main/edit_profile_Screen.dart';
import 'package:cycle_lock/ui/main/my_account_screen.dart';
import 'package:cycle_lock/ui/main/notification_screen.dart';
import 'package:cycle_lock/ui/widgets/common_widget.dart';
import 'package:cycle_lock/utils/colors.dart';
import 'package:cycle_lock/utils/dialogs.dart';
import 'package:cycle_lock/utils/images.dart';
import 'package:cycle_lock/utils/sizes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../ui/main/other_service_Screen.dart';

class DashboardProduct extends StatefulWidget {

  const DashboardProduct({Key? key}) : super(key: key);

  @override
  State<DashboardProduct> createState() => _DashboardProductState();
}

class _DashboardProductState extends State<DashboardProduct> {

  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late NotificationProvider notificationProvider;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: const [
            HomeDashboard(),
            MyOrderDashboard(),
            FavoriteProduct(),
            NotificationScreen(),
            MyAccountScreen(),
          ],
        ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }


  _buildAppBar() {
    return AppBar(
      toolbarHeight: 80,
      actions: [
        _selectedIndex == 0 ?
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.shopping_cart_outlined, size: 40,color: Colors.white),
        ) : const SizedBox(),
        _selectedIndex == 4
            ? GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen(userType: "editProfile")));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.edit_outlined,
                size: 35,
                color: buttonColor,
              ),
            ),
          ),
        ) : const SizedBox(),
        _selectedIndex == 3
            ? PopupMenuButton(
          color: Colors.black,
          onSelected: (result) {
            if (result == 0) {
              showNotificationActionDialog(
                  context, "Delete", notificationProvider);
            }
            if (result == 1) {
              showNotificationActionDialog(context, "Read", notificationProvider);
            }
            if (result == 2) {
              showNotificationActionDialog(
                  context, "UnRead", notificationProvider);
            }
          },
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<int>(
                  value: 0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 15),
                    dense: true,
                    title: Text(
                      "clearAll".tr(),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16),
                    ),
                  )),
              PopupMenuItem<int>(
                  value: 1,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 15),
                    title: Text("markAsAllRead".tr(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16)),
                  )),
              PopupMenuItem<int>(
                  value: 2,
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 15),
                    title: Text("markAsAllUnread".tr(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16)),
                  )),
            ];
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: SvgPicture.asset(icMore, color: buttonColor, colorBlendMode: BlendMode.srcIn),
          ),
        )
            : const SizedBox(),
        GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashBoardScreen()),
                      (route) => false);
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.home_outlined, size: 40,color: Colors.white),
            )),
      _selectedIndex==0?  GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const OthersServiceScreen()));
            },
            child:  Padding(
              padding: EdgeInsets.all(20.0),
              child: Image.asset(cube,height: 10,color: Colors.white,),
            )):const SizedBox()
      ],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      titleSpacing: 0,
      backgroundColor: lightGreyColor,
      centerTitle: _selectedIndex == 0 ? true : false,
      automaticallyImplyLeading: false,
      title: _selectedIndex == 0 ?
      GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            icSplashPedaLogo,
            height: 50,
            alignment: Alignment.center,
          ),
        ),
      ) : richText( _selectedIndex == 1 ? "myOrders".tr()
          : _selectedIndex == 2 ? "myFavourites".tr()
          :_selectedIndex == 3  ? "notification".tr()
          :_selectedIndex == 4  ? "profile".tr()
          : const SizedBox(),
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: ts22)),
    );
  }

  _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: lightGreyColor,
      currentIndex: _selectedIndex,
      selectedItemColor: buttonColor,
      unselectedItemColor: Colors.white,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w100,
        fontSize: 10,
      ),
      selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w100,
          fontSize: 10
      ),
      onTap: (index) {
        FocusScope.of(context).unfocus();
        setState(() {
          _selectedIndex = index;
          _pageController.jumpToPage(index);
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          label: 'home'.tr(),
          backgroundColor: lightGreyColor,
          icon: Image.asset(
            home,
            height: 24,
            width: 24,
            color: _selectedIndex == 0 ? buttonColor : Colors.white,
          ),
        ),
        BottomNavigationBarItem(
            label: 'orders'.tr(),
            backgroundColor: lightGreyColor,
            icon: Image.asset(
              order,
              height: 24,
              width: 24,
              color: _selectedIndex == 1 ? buttonColor : Colors.white,
            )),
        BottomNavigationBarItem(
            label: 'favourites'.tr(),
            backgroundColor: lightGreyColor,
            icon: Image.asset(
              heart,
              height: 24,
              width: 24,
              color: _selectedIndex == 2 ? buttonColor : Colors.white,
            )),
        BottomNavigationBarItem(
          label: 'notification'.tr(),
          backgroundColor: lightGreyColor,
          icon: Stack(
            overflow: Overflow.visible,
            children: [
              Image.asset(
                notificationBell,
                height: 24,
                width: 24,
                color: _selectedIndex == 3 ? buttonColor : Colors.white,
              ),
              Consumer<NotificationProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  return value.unReads > 0 && _selectedIndex != 3
                      ? Positioned(
                    top: -14,
                    right: value.unReads > 9 ? -20 : -12,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: buttonColor,
                      ),
                      child: Text(
                        value.unReads > 9 ? "9+" : value.unReads.toString(),
                        style: const TextStyle(
                            fontSize: 10.0, color: Colors.white),
                      ),
                    ),
                  )
                      : const SizedBox();
                },
              )
            ],
          ),
        ),
        BottomNavigationBarItem(
            label: 'profile'.tr(),
            backgroundColor: lightGreyColor,
            icon: Image.asset(
              more,
              height: 24,
              width: 24,
              color: _selectedIndex == 4 ? buttonColor : Colors.white,
            )),
      ],
    );
  }




  showNotificationActionDialog(
      BuildContext context, String title, NotificationProvider value) {
    Dialogs().confirmationDialog(context, onContinue: () {
      Navigator.pop(context);
      if (title == "Read") {
        value.notificationReadApi("", true, context);
      } else if (title == "UnRead") {
        value.notificationUnReadApi(true, context);
      } else {
        value.notificationDeleteApi("", context, true);
      }
    },
        message: title == "Read"
            ? "NotificationsReadAlert".tr()
            : title == "UnRead"
            ? "Are you sure want to Unread all notifications?"
            : "NotificationsDeleteAlert".tr());
  }
}
