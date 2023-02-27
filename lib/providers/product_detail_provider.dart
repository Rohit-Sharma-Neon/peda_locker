import 'package:cycle_lock/network/api_provider.dart';
import 'package:cycle_lock/responses/added_bike_list_response.dart';
import 'package:flutter/cupertino.dart';

import '../responses/product_detail_modal.dart';

class ProductDetailProvider extends ChangeNotifier{

  int counter = 1;
  int cartCount = 1;

  setCounter(value){
    counter= value;
    notifyListeners();
  }

  void incrementCounter() {
    counter++;
    notifyListeners();
  }

  void decrementCounter() {
      if(counter > 0){
        counter--;
      }
      notifyListeners();
  }


  setCartCount(value){
    cartCount= value;
    notifyListeners();
  }

}