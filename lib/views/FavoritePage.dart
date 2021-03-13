import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quotes_app/models/Quote.dart';
import 'package:quotes_app/view_models/FavoriteQuotesViewModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';


TextStyle textStylefavtext1 = GoogleFonts.caveat(
  textStyle: TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontWeight: FontWeight.normal,
  ),
);
TextStyle styleContenBlack = GoogleFonts.caveat(
  textStyle: TextStyle(
    color: Colors.black87,
    fontSize: 100,
    fontWeight: FontWeight.normal,
  ),
);
TextStyle styleContentWhite = GoogleFonts.caveat(
  textStyle: TextStyle(
    color: Colors.black87,
    fontSize: 100,
    fontWeight: FontWeight.normal,
  ),
);
TextStyle styleTitlesWhite = GoogleFonts.caveat(
  textStyle: TextStyle(
    color: Colors.white,
    fontSize: 100,
    fontWeight: FontWeight.normal,
  ),
);
TextStyle styleTitlesWhite2 = GoogleFonts.alike(
  textStyle: TextStyle(
    color: Colors.white,
    fontSize: 100,
    fontWeight: FontWeight.normal,
  ),
);
TextStyle styleInfoWhite = GoogleFonts.caveat(
  textStyle: TextStyle(
    color: Colors.white,
    fontSize: 40,
    fontWeight: FontWeight.normal,
  ),
);
TextStyle styleTitlesBlack = GoogleFonts.caveat(
  textStyle: TextStyle(
    color: Colors.black54,
    fontSize: 100,
    fontWeight: FontWeight.normal,
  ),
);

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  Box<Quote> favoriteBox;
  List<Quote> favoriteList = [];

  init() async {
    // await Hive.openBox(FAVLIST);
    favoriteBox = Hive.box(FAVLIST);
    log("init : favoriteBox: ${favoriteBox.length}");
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FavoriteQuotes",
          style: styleInfoWhite,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                final cBox = Hive.isBoxOpen(FAVLIST);
                log("cBox List ${cBox}");


                for (var i in favoriteList) {
                  favoriteBox.add(i);
                }
                log("cBox List ${favoriteBox.length}");
                setState(() {});
              }),
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                context.refresh(favNotifier);
                // if(favoriteBox.isNotEmpty)
                await favoriteBox.clear();
                favoriteList.clear();
                log("CLEAR ALL :  ${favoriteBox.length} - ${favoriteList.length}");
                setState(() {});
              }),
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            color: Colors.pink,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "Favorite List In Memory ",
                style: styleTitlesWhite2,
                maxFontSize: 22,
              ),
            ),
          ),
          Container(
            height: 400,
            child: Consumer(builder: (BuildContext context, ScopedReader watch, Widget child) {
              final favList = watch(favNotifier);
              final _list = favList.quotesList;
              favoriteList = _list.toList();
              log("Fav List ${favList.quotesList.length}");
              log("favoriteList${favoriteList.length}");
              // final cBox =  Hive.box(FAVLIST);
              // log("cBox List ${cBox.length}");
              return favoriteList.length != 0
                  ? _buildListViewFav(context, favList)
                  : Center(
                      child: Text(
                        "No Data",
                        style: textStylefavtext1,
                      ),
                    );
            }),
          ),
          Container(
            color: Colors.pink,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "Favorite List In Local Storage ",
                style: styleTitlesWhite2,
                maxFontSize: 22,
              ),
            ),
          ),
          Container(
            height: 400,
            child: favoriteBox.length != 0
                ? _buildListViewFromLocalStorage(context)
                : Center(
                    child: Text(
                      "No Data",
                      style: textStylefavtext1,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildListViewFav(BuildContext context, FavoriteQuotesViewModel favList) {
    var crossAxisCount = 2;
    var childAspectRatio = 1.0;
    var fList = favList.quotesList;
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
      ),

      // crossAxisCount: 2,
      // mainAxisSpacing: 10.0,
      // crossAxisSpacing: 4.0,
      padding: const EdgeInsets.all(4.0),
      // childAspectRatio: 1.3,
      itemCount: fList.length,
      itemBuilder: (BuildContext context, int index) {
        final quote = fList[index];

        return Card(
          child: GridTile(
            child: Column(
              children: [
                AutoSizeText(
                  "${quote.author}",
                  style: styleTitlesBlack,
                  minFontSize: 5,
                  maxFontSize: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: AutoSizeText(
                        quote.content,
                        style: styleContentWhite,
                        minFontSize: 5,
                        maxFontSize: 28,
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.share,
                        color: Colors.pink[300],
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () async {
                        // await favoriteBooksBox.deleteAt(index);
                        return context.read(favNotifier).removeFromFav(fList[index]);
                      },
                      icon: Icon(
                        Icons.bookmark,
                        color: Colors.pink[300],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListViewFromLocalStorage(BuildContext context) {
    // log("_buildListView : favoriteBooksBox List ${favoriteBooksBox.length}");
    var crossAxisCount = 2;
    var childAspectRatio = 0.5;
    return WatchBoxBuilder(
      box: favoriteBox,
      builder: (ctx, contactsBox) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
          ),

          // crossAxisCount: 2,
          // mainAxisSpacing: 10.0,
          // crossAxisSpacing: 4.0,
          padding: const EdgeInsets.all(4.0),
          // childAspectRatio: 1.3,
          itemCount: contactsBox.length,
          itemBuilder: (BuildContext context, int index) {
            final contact = contactsBox.getAt(index) as Quote;

            return Card(
              child: GridTile(
                child: Column(
                  children: [
                    AutoSizeText(
                      "${contact.author}",
                      style: styleTitlesBlack,
                      minFontSize: 5,
                      maxFontSize: 20,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: AutoSizeText(
                            contact.content,
                            style: styleContentWhite,
                            minFontSize: 5,
                            maxFontSize: 28,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        // IconButton(
                        //   onPressed: () {},
                        //   icon: Icon(
                        //     Icons.share,
                        //     color: Colors.black54,
                        //   ),
                        // ),
                        Spacer(),
                        IconButton(
                          onPressed: () async {
                            await favoriteBox.deleteAt(index);
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.remove_circle_outlined,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildListViewFav3(BuildContext context, favList) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1,
        color: Colors.black12,
      ),
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: favList.quotesList.length,
      // itemCount: cBox.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        // final cBox =  Hive.box(FAVLIST);
        // final readFromDatabase = cBox.getAt(index) as Quote;
        // log("readFromDatabase: ${readFromDatabase.id}");

        var quote = favList.quotesList[index];
        var quoteContent = favList.quotesList[index].content;
        // var quoteContent = readFromDatabase.content;
        var quoteAuthor = favList.quotesList[index].author;
        // var quoteAuthor = readFromDatabase.author;
        // var isLiked = favList.quotesList[index].liked;
        // var isLiked = readFromDatabase.liked;

        final width = MediaQuery.of(context).size.width;

        return Column(
          children: [
            GestureDetector(
              // onTap: () {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (_) => ProductsScreen(product: product),
              //     ),
              //   );
              // },
              child: Card(
                margin: EdgeInsets.all(10),
                child: Container(
                  width: width,
                  height: 150,
                  child: Stack(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// RightSide
                          Column(
                            textDirection: TextDirection.rtl,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.black12,
                                height: 11,
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            color: Colors.black12,
                          ),

                          /// Center
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ListTile(
                                      title: Text(
                                        quoteContent,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
                                        // style: textStyleCardProductName,
                                      ),
                                      // subtitle: Text(product.type ?? ""),

                                      isThreeLine: false,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    // margin: const EdgeInsets.only(bottom: 1.0),
                                    // height: 30,
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(left: 10, right: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      color: Colors.blueAccent,
                                    ),
                                    child: Center(
                                      child: RichText(
                                          // overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(children: [
                                            // TextSpan(text: 'ر.س ', style: textStyleCardSymble),
                                            TextSpan(
                                              text: '$quoteAuthor',
                                              // style: textStyleCardPrice,
                                            )
                                          ])),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// left side
                          Container(
                            width: 1,
                            color: Colors.black12,
                          ),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        favList.removeFromFav(favList.quotesList[index]);
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.bookmark,
                                          color: Colors.pink[300],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 1,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        log("Pressed");

                                        // await launchShare(context, "s");
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.share,
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 1,
                                      color: Colors.black26,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       appBar: AppBar(
//         actions: [],
//         title: AutoSizeText(
//           "Favorite",
//           style: styleTitlesWhite,
//           minFontSize: 5,
//           maxFontSize: 55,
//         ),
//       ),
//       body: _buildListView(context));
// }
