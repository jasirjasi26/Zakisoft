// @dart=2.9
import 'package:flutter_rest_api/Controllers/CategoryController.dart';
import 'package:flutter_rest_api/Controllers/SubCategoryController.dart';
import 'package:flutter_rest_api/Model/selectCategory.dart';
import 'package:flutter_rest_api/Services/Api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CategoryController categoryController = Get.put(CategoryController());
  final SubCategoryController subCategoryController =
      Get.put(SubCategoryController());

  var scrollController = ScrollController();

  int selectedCategoryIndex;
  int selectedSubCategoryIndex;
  static int offset = 0;
  List k = [];
  bool isLoading = false;

  @override
  Future<void> initState() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          print('ListView scroll at top');
        } else {
          setState(() {
            offset = offset + 1;
          });

          selectCategory.offset = offset;
          getList();

          // Load next documents
        }
      }
    });
    getList();

    super.initState();
  }

  getList() async {
    isLoading = true;
    ApiService.getAll().then((value) {
      setState(() {
        k.addAll(value);
        isLoading = false;
      });
    });
  }

  clickCategory(int index, int id) {
    k.clear();
    offset = 0;
    selectCategory.offset = offset;
    selectCategory.selectedSubCategory = id;
    setState(() {
      selectedCategoryIndex = index;
      selectedSubCategoryIndex = null;
    });
    subCategoryController.fetchSubCategory();
    getList();
  }

  clickSubCategory(int index, int id) {
    k.clear();
    offset = 0;
    selectCategory.offset = offset;
    selectCategory.selectedSubCategory = id;
    setState(() {
      selectedSubCategoryIndex = index;
    });
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Container(
          height: 120,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("asset/strawberry.png"),
            ),
          ),
        ),
        leading: Icon(
          Icons.view_headline_rounded,
          size: 35,
          color: Colors.red[900],
        ),
        actions: [
          Icon(
            Icons.search,
            size: 35,
            color: Colors.red[900],
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: Stack(
        children: [
          ListView(
            //shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Divider(
                height: 1,
              ),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 45,
                    child: Icon(
                      Icons.now_widgets_outlined,
                      color: Colors.red[900],
                    ),
                  ),

                  ///Getx Categories
                  Container(
                      width: MediaQuery.of(context).size.width - 45,
                      height: 45,
                      child: Obx(() => ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 20,
                                width: 2,
                              );
                            },
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  clickCategory(
                                      index,
                                      categoryController
                                          .categoryList[index].id);
                                },
                                child: Card(
                                  color: selectedCategoryIndex == index
                                      ? Colors.green[800]
                                      : Colors.white,
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 20,
                                          right: 20),
                                      //margin: EdgeInsets.only(right: 2),
                                      height: 40,
                                      child: Center(
                                        child: Text(
                                            categoryController
                                                .categoryList[index].name
                                                .toString(),
                                            style: TextStyle(
                                                color: selectedCategoryIndex ==
                                                        index
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight:
                                                    selectedCategoryIndex ==
                                                            index
                                                        ? FontWeight.w900
                                                        : FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: categoryController.categoryList.length,
                          ))),
                ],
              ),
              selectedCategoryIndex != -1
                  ? Container(
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            height: 55,
                            width: 45,
                            child: Icon(
                              Icons.filter_alt_rounded,
                              color: Colors.red[900],
                            ),
                          ),
                          Card(
                            color:
                            selectedSubCategoryIndex == null
                                ? Colors.green[800]
                                : Colors.white,
                            child: GestureDetector(
                              onTap: () {
                                clickSubCategory(null, 0);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.only(
                                    top: 8, bottom: 8, left: 20, right: 20),
                                //margin: EdgeInsets.only(right: 2),
                                height: 45,
                                child: Center(
                                  child: Text("All",
                                      style: TextStyle(
                                          color:
                                          selectedSubCategoryIndex == null
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ),

                          ///Getx SubCategories
                          Container(
                              width: MediaQuery.of(context).size.width - 110,
                              height: 40,
                              child: Obx(() {
                                if (subCategoryController.isLoading.value) {
                                  return Row(
                                    children: [
                                      Spacer(),
                                      Container(
                                        width: 100,
                                        height: 1,
                                        child: Center(
                                          child: LinearProgressIndicator(
                                            minHeight: 1.5,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  );
                                } else {
                                  return ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          clickSubCategory(
                                              index,
                                              subCategoryController
                                                  .subCategoryList[index].id);
                                        },
                                        child: Card(
                                          color:
                                              selectedSubCategoryIndex == index
                                                  ? Colors.green[800]
                                                  : Colors.white,
                                          child: Center(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                padding: EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8,
                                                    left: 20,
                                                    right: 20),
                                                //margin: EdgeInsets.all(2),
                                                height: 40,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        subCategoryController
                                                            .subCategoryList[
                                                                index]
                                                            .name
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            color:
                                                                selectedSubCategoryIndex ==
                                                                        index
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                            fontWeight:
                                                                selectedSubCategoryIndex ==
                                                                        index
                                                                    ? FontWeight
                                                                        .w900
                                                                    : FontWeight
                                                                        .bold)),
                                                  ],
                                                )),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: subCategoryController
                                        .subCategoryList.length,
                                  );
                                }
                              })),
                        ],
                      ),
                    )
                  : Container(),
              Divider(
                height: 5,
              ),
              k.length > 0
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      child: k.length > 0
                          ? ListView.builder(

                              itemCount: k.length,
                              controller: scrollController,
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                String image_url =
                                    k[index]['images'][0]['image_url'];

                                return Card(
                                  margin: EdgeInsets.only(bottom: 0.8),
                                  color: Colors.white,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.28,
                                          height: 90,
                                          child: image_url != ""
                                              ? ClipRRect(
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl:
                                                        "https://sta.farawlah.sa/storage/$image_url",
                                                  ),
                                                )
                                              : Container(
                                                  height: 30,
                                                  width: 30,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1.5,
                                                  ),
                                                ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.only(left: 5, bottom: 5),
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.6,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(k[index]['name'],
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "${k[index]['price']['sale_price']}" +
                                                      " SAR",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.green[600],
                                                      fontWeight:
                                                          FontWeight.w900)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.1,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.favorite_border,
                                                size: 20,
                                                color: Colors.red[900],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.add_circle,
                                                    size: 27,
                                                    color: Colors.green[600],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : Text("No data"))
                  : SizedBox(),
            ],
          ),
          isLoading
              ? Positioned(
                  bottom: 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Container(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.red[900],
                            strokeWidth: 1.5,
                          )),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
