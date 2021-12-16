// @dart=2.9
import 'dart:convert';
import 'package:flutter_rest_api/Model/AllCategory.dart';
import 'package:flutter_rest_api/Model/AllSubCategories.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rest_api/Model/selectCategory.dart';

class ApiService {
   static  var client =http.Client();

  static Future<List<AllCategory>> getCategories() async {
    final response = await client
        .get(Uri.parse('https://sta.farawlah.sa/api/mobile/categories'));
    if (response.statusCode == 200) {
      return allCategoryFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<List<AllSubCategories>> getSubCategories() async {
    final response = await client.get(Uri.parse(
        'https://sta.farawlah.sa/api/mobile/subcategories?parent_id=${selectCategory.selectedSubCategory}'));
    if (response.statusCode == 200) {
     return allSubCategoriesFromJson(response.body);
    } else {
      return null;
    }
  }

  static Future<List<dynamic>> getAll() async {
    final response = await client.get(Uri.parse(
        'https://sta.farawlah.sa/api/mobile/products?category_id=${selectCategory.selectedSubCategory}&limit=20&store_id=2&offset=${selectCategory.offset}'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
