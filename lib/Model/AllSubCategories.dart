// @dart=2.9
// To parse this JSON data, do
//
//     final allSubCategories = allSubCategoriesFromJson(jsonString);

import 'dart:convert';

List<AllSubCategories> allSubCategoriesFromJson(String str) => List<AllSubCategories>.from(json.decode(str).map((x) => AllSubCategories.fromJson(x)));

String allSubCategoriesToJson(List<AllSubCategories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllSubCategories {
  AllSubCategories({
    this.id,
    this.name,
    this.nameArabic,
    this.imageUrl,
    this.parentId,
  });

  int id;
  String name;
  String nameArabic;
  String imageUrl;
  int parentId;

  factory AllSubCategories.fromJson(Map<String, dynamic> json) => AllSubCategories(
    id: json["id"],
    name: json["name"],
    nameArabic: json["name_arabic"],
    imageUrl: json["image_url"],
    parentId: json["parent_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_arabic": nameArabic,
    "image_url": imageUrl,
    "parent_id": parentId,
  };
}
