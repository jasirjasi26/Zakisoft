// // @dart=2.9
// import 'package:flutter_rest_api/Model/AllData.dart';
// import 'package:flutter_rest_api/Model/AllSubCategories.dart';
// import 'package:flutter_rest_api/Services/Api.dart';
// import 'package:get/get.dart';
//
// class AllDataController extends GetxController{
//   // ignore: deprecated_member_use
//   var allDataList = List<AllData>().obs;
//   var isLoading =true.obs;
//
//   @override
//   void onInit() {
//
//     fetchAllData();
//     super.onInit();
//   }
//
//   Future<void> fetchAllData() async {
//     isLoading(true);
//     try {
//       var alldata=await ApiService.getAll();
//       if(alldata!=null){
//         allDataList.value=alldata;
//       }
//     } finally{
//       isLoading(false);
//     }
//
//   }
// }