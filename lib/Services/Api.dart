// @dart=2.9
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_rest_api/Model/selectCategory.dart';

class ApiService {
  static Future<List<dynamic>> getCategories() async {
    final response = await http
        .get(Uri.parse('https://sta.farawlah.sa/api/mobile/categories'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<List<dynamic>> getSubCategories() async {
    final response = await http.get(Uri.parse(
        'https://sta.farawlah.sa/api/mobile/subcategories?parent_id=${selectCategory.selectedSubCategory}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static Future<List<dynamic>> getAll(int id, int offset) async {
    final response = await http.get(Uri.parse(
        'https://sta.farawlah.sa/api/mobile/products?category_id=$id&limit=20&store_id=2&offset=$offset'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
