// @dart=2.9
import 'package:flutter_rest_api/Model/AllCategory.dart';
import 'package:flutter_rest_api/Services/Api.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController{
  // ignore: deprecated_member_use
  var categoryList = List<AllCategory>().obs;

  @override
  void onInit() {

    fetchCategory();
    super.onInit();
  }

  Future<void> fetchCategory() async {
    var category=await ApiService.getCategories();
    if(category!=null){
      categoryList.value=category;
    }
  }
}