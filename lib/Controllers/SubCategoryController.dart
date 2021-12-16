// @dart=2.9
import 'package:flutter_rest_api/Model/AllSubCategories.dart';
import 'package:flutter_rest_api/Services/Api.dart';
import 'package:get/get.dart';

class SubCategoryController extends GetxController{
  // ignore: deprecated_member_use
  var subCategoryList = List<AllSubCategories>().obs;

  @override
  void onInit() {

    fetchSubCategory();
    super.onInit();
  }

  Future<void> fetchSubCategory() async {
    var subcategory=await ApiService.getSubCategories();
    if(subcategory!=null){
      subCategoryList.value=subcategory;
    }
  }
}