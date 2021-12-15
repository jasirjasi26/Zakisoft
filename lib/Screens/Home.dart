// @dart=2.9
import 'package:flutter_rest_api/Model/selectCategory.dart';
import 'package:flutter_rest_api/Services/Api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scrollController = ScrollController();
  Future<dynamic> _futureCategory;
  Future<dynamic> _futureSubCategory;

  int selectedCategoryIndex;
  int selectedSubCategoryIndex;
  static int offset = 0;
  List k = [];
  bool isLoading = false;

  @override
  Future<void> initState() {
    _futureCategory = ApiService.getCategories();

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          print('ListView scroll at top');
        } else {
          print('ListView scroll at bottom');
          setState(() {
            offset = offset + 1;
          });
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
    ApiService.getAll(selectCategory.selectedSubCategory, offset).then((value) {
      setState(() {
        k.addAll(value);
        isLoading = false;
      });
    });
    print(selectCategory.selectedSubCategory);
  }

  clickCategory(int index, int id) {
    k.clear();
    offset = 0;
    selectCategory.selectedSubCategory = id;
    setState(() {
      _futureSubCategory = ApiService.getSubCategories();
      selectedCategoryIndex = index;
      selectedSubCategoryIndex = null;
    });
  }

  clickSubCategory(int index, int id) {
    k.clear();
    offset = 0;
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
                  Container(
                    width: MediaQuery.of(context).size.width - 45,
                    height: 45,
                    child: FutureBuilder(
                      future: _futureCategory,
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.separated(
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
                                  clickCategory(index, data[index]['id']);
                                },
                                child: Center(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.fromBorderSide(
                                              BorderSide(
                                                  color: Colors.blueGrey,
                                                  width: 1)),
                                          color: selectedCategoryIndex == index
                                              ? Colors.green[800]
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: EdgeInsets.only(
                                          top: 8,
                                          bottom: 8,
                                          left: 20,
                                          right: 20),
                                      margin: EdgeInsets.all(2),
                                      height: 40,
                                      child: Row(
                                        children: [
                                          Text(data[index]['name'].toString(),
                                              style: TextStyle(
                                                  color:
                                                      selectedCategoryIndex ==
                                                              index
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontWeight:
                                                      selectedCategoryIndex ==
                                                              index
                                                          ? FontWeight.w900
                                                          : FontWeight.bold)),
                                        ],
                                      )),
                                ),
                              );
                            },
                            itemCount: data.length,
                          );
                        }
                        return Center(
                            // child: Container(width: 80, child: LinearProgressIndicator()),
                            );
                      },
                    ),
                  ),
                ],
              ),
              selectCategory.selectedSubCategory != 0
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
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.fromBorderSide(BorderSide(
                                      color: Colors.blueGrey, width: 1)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8, left: 20, right: 20),
                              margin: EdgeInsets.all(2),
                              height: 45,
                              child: Row(
                                children: [
                                  Text("All",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ],
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width - 105,
                            child: FutureBuilder(
                              future: _futureSubCategory,
                              builder: (context, snapshot) {
                                final data = snapshot.data;
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return ListView.separated(
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
                                          clickSubCategory(
                                              index, data[index]['id']);
                                        },
                                        child: Center(
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.fromBorderSide(
                                                      BorderSide(
                                                          color:
                                                              Colors.blueGrey,
                                                          width: 1)),
                                                  color:
                                                      selectedSubCategoryIndex ==
                                                              index
                                                          ? Colors.green[800]
                                                          : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding: EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 8,
                                                  left: 20,
                                                  right: 20),
                                              margin: EdgeInsets.all(2),
                                              height: 45,
                                              child: Row(
                                                children: [
                                                  Text(
                                                      data[index]['name']
                                                          .toString()
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          color:
                                                              selectedSubCategoryIndex ==
                                                                      index
                                                                  ? Colors.white
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
                                      );
                                    },
                                    itemCount: data.length,
                                  );
                                }
                                return Center(
                                  child: Container(
                                      width: 80,
                                      child: LinearProgressIndicator(
                                        minHeight: 1.5,
                                      )),
                                );
                              },
                            ),
                          ),
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
                          ? ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 1,
                                  //color: Colors.blueGrey,
                                );
                              },
                              itemCount: k.length,
                              controller: scrollController,
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                String image_url = k[index]['images'][0]
                                        ['image_url'];

                                return Container(
                                  padding: EdgeInsets.only(
                                      left: 5, bottom: 5, top: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.28,
                                        height: 90,
                                        child: image_url != "" ?ClipRRect(
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                "https://sta.farawlah.sa/storage/$image_url",
                                          ),
                                        ) : Container(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
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
                                                    fontSize: 16,
                                                    color: Colors.green[800],
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
                                                  color: Colors.green[700],
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
