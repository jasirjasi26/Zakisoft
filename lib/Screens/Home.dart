// @dart=2.9
import 'package:flutter_rest_api/Model/selectCategory.dart';
import 'package:flutter_rest_api/Services/Api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scrollController = ScrollController();
  Future<dynamic> _futureAllData;
  Future<dynamic> _futureCategory;
  Future<dynamic> _futureSubCategory;

  int selectedCategoryIndex;
  static int filter = 136;
  int selectedSubCategoryIndex;
  int favorite;
  static int offset = 0;

  @override
  void initState() {
    _futureCategory = ApiService.getCategories();
    _futureSubCategory = ApiService.getSubCategories();
    _futureAllData =
        ApiService.getAll(selectCategory.selectedSubCategory, offset);

    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0) {
          setState(() {
            offset = offset - 1;
            _futureAllData = ApiService.getAll(
                selectCategory.selectedSubCategory,
                offset);
          });
          print('ListView scroll at top');
        } else {
          print('ListView scroll at bottom');
          setState(() {
            offset = offset + 1;
            _futureAllData = ApiService.getAll(
                selectCategory.selectedSubCategory,
                offset);
          });
          // Load next documents
        }
      }
    });

    super.initState();
  }

  clickCategory(int index, int id) {
    offset = 0;
    selectCategory.selectedSubCategory = id;
    setState(() {
      filter = id;
      _futureSubCategory = ApiService.getSubCategories();
      selectedCategoryIndex = index;
      selectedSubCategoryIndex = null;
    });
  }

  clickSubCategory(int index, int id) {
    offset = 0;
    selectCategory.selectedSubCategory = id;
    setState(() {
      selectedSubCategoryIndex = index;
      _futureAllData =
          ApiService.getAll(selectCategory.selectedSubCategory, offset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Zakisoft',
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 26,
                fontWeight: FontWeight.bold)),
        leading: Icon(
          Icons.view_headline_rounded,
          size: 28,
          color: Colors.grey,
        ),
        actions: [
          Icon(
            Icons.search,
            size: 28,
            color: Colors.grey,
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 15, left: 5, right: 5),
        children: [
          Divider(
            height: 5,
          ),
          Container(
            height: 40,
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
                        width: 3,
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
                                  color: selectedCategoryIndex == index
                                      ? Colors.blue[800]
                                      : Colors.blueGrey[400],
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(2),
                              height: 35,
                              child: Row(
                                children: [
                                  Text(data[index]['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
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
          Container(
            height: 40,
            child: Row(
              children: [
                // GestureDetector(
                //   onTap: () {
                //     if (selectedSubCategoryIndex != null) {
                //       setState(() {
                //         selectedSubCategoryIndex = null;
                //       });
                //     }
                //     selectCategory.selectedSubCategory = 0;
                //   },
                //   child: Center(
                //     child: Container(
                //       decoration: BoxDecoration(
                //           color: selectedSubCategoryIndex == null ||
                //                   selectedSubCategoryIndex == -1
                //               ? Colors.blue[800]
                //               : Colors.blueGrey[400],
                //           borderRadius: BorderRadius.circular(5)),
                //       padding: EdgeInsets.all(10),
                //       margin: EdgeInsets.all(2),
                //       height: 35,
                //       width: 60,
                //       child: Center(
                //           child: Text("All",
                //               style: TextStyle(
                //                   color: Colors.white,
                //                   fontWeight: FontWeight.bold))),
                //     ),
                //   ),
                // ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  child: FutureBuilder(
                    future: _futureSubCategory,
                    builder: (context, snapshot) {
                      final data = snapshot.data;
                      if (snapshot.connectionState == ConnectionState.done) {
                        //selectCategory.selectedSubCategory = data[0]['id'];

                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 20,
                              width: 3,
                            );
                          },
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                clickSubCategory(index, data[index]['id']);
                              },
                              child: Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: selectedSubCategoryIndex == index
                                            ? Colors.blue[800]
                                            : Colors.blueGrey[400],
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(2),
                                    height: 35,
                                    child: Row(
                                      children: [
                                        Text(data[index]['name'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
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
                            width: 80, child: LinearProgressIndicator()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 8,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.78,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: _futureAllData,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return LazyLoadScrollView(
                        onEndOfPage: () {
                        },
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 8,
                            );
                          },
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return ListTile(
                              focusColor: Colors.white12,
                              hoverColor: Colors.white12,
                              selectedTileColor: Colors.blue,
                              tileColor: Colors.white12,
                              title: Text(data[index]['name'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              leading: Container(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGc5JIvQx5mAqDksfVyYeFtBLoJh4KN8ZDTfhHLEZljnAoOljWGCeYvvKI3rs8ODe_z0I&usqp=CAU",
                                    placeholder: (context, url) =>
                                        new CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                "${data[index]['price']['sale_price']}" +
                                    " SAR",
                                style: TextStyle(
                                    color: Colors.green[300],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                          physics: AlwaysScrollableScrollPhysics(),
                          controller: scrollController,
                          itemCount: data.length,
                        ));
                  } else {
                    if (snapshot.data != null) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Container(
                            // child: Text("No data..."),
                            ),
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
