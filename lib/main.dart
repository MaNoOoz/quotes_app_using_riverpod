import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:quotes_app/models/Quote.dart';
import 'package:quotes_app/view_models/FavoriteQuotesViewModel.dart';
import 'package:quotes_app/view_models/QuoteViewModel.dart';
import 'package:quotes_app/view_models/QuotesViewModel.dart';
import 'package:quotes_app/views/FavoritePage.dart';
import 'package:quotes_app/utils/helperFunctions.dart';
import 'package:connectivity/connectivity.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(QuoteAdapter());
  await Hive.openBox<Quote>(FAVLIST);

  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   statusBarColor: Colors.pink[300].withOpacity(0.1),
  // ));

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Color(0xffF06090)),
      home: QuotePageUsingRiverpod(),
    );
  }
}

class QuotePageUsingRiverpod extends StatefulWidget {
  @override
  _QuotePageUsingRiverpodState createState() => _QuotePageUsingRiverpodState();
}

class _QuotePageUsingRiverpodState extends State<QuotePageUsingRiverpod> {
  bool liked = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  StreamSubscription<ConnectivityResult> subscription;

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _scaffoldKey.currentState.showBottomSheet((context) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(), // closing showModalBottomSheet
            child: Container(
              color: Colors.redAccent,
              height: 150.0,
              child: new Center(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      "Check Network Please",
                      style: styleTitlesWhite,
                      maxFontSize: 50,
                      minFontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      } else {
        _scaffoldKey.currentState.showBottomSheet((context) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(), // closing showModalBottomSheet
            child: Container(
              color: Colors.green,
              height: 150.0,
              child: new Center(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AutoSizeText(
                      "You Have  Network",
                      style: styleTitlesWhite,
                      maxFontSize: 50,
                      minFontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final contactsBoxOpen = Hive.isBoxOpen(FAVLIST);
    // if (contactsBoxOpen) {
    //   log(" box is Open ? $contactsBoxOpen");
    // }
    return WillPopScope(
      onWillPop: () async {
        return helperFunctions.OnWillPop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          // centerTitle: true,
          title: AutoSizeText(
            "Quotes",
            style: styleTitlesWhite,
            minFontSize: 5,
            maxFontSize: 40,
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.bookmark),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FavoritePage(),
                      fullscreenDialog: false,
                    ),
                  );
                }),
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  context.refresh(futureQuoteViewModel);
                  context.refresh(rQuotesViewModel);
                }),
          ],
        ),
        body: ListView(
          children: [
            Container(
              color: Colors.pink,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  "Using GestureDetector swipe ",
                  style: styleTitlesWhite,
                  maxFontSize: 30,
                ),
              ),
            ),

            /// Using Single Quote View swipe left or right to refresh
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // color: Colors.pink[300],
                color: Colors.white70,
                boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, 5), blurRadius: 20)],
              ),
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              height: 400,
              child: GestureDetector(
                onHorizontalDragEnd: (details) async {
                  return context.refresh(futureQuoteViewModel);
                },
                child: Consumer(builder: (BuildContext context, ScopedReader watch, Widget child) {
                  final quotesList = watch(futureQuoteViewModel);
                  return quotesList.map(data: (asyncData) {
                    Quote q = asyncData.value;

                    return buildItem1(q, context);
                  }, loading: (asyncData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.pink[100],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.pink[300]),
                      ),
                    );
                  }, error: (error) {
                    return Text(error.toString());
                  });
                }),
              ),
            ),

            // TODO :  /// Uncomment to see more Views : Note this is for the demo only Ui
            /// Using PageView 3 random Quotes swipe Up to refresh
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.pink,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: AutoSizeText(
                      "<<<<< ~~~  Using Page View swipe  ~~~ >>>>",
                      style: styleTitlesWhite,
                      maxFontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // color: Colors.pink[300],
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 10)],
              ),
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer(
                    builder: (BuildContext context, ScopedReader watch, Widget consumerChild) {
                  final quotesList = watch(rQuotesViewModel);
                  return quotesList.map(data: (asyncData) {
                    var quotes = asyncData.value;
                    log("test : ${quotes.length}");

                    return quotes.length != 0
                        ? GestureDetector(
                            onVerticalDragEnd: (details) async {
                              return context.refresh(rQuotesViewModel);
                            },
                            child: Container(
                              // height: 100,
                              child: PageView.builder(
                                itemCount: quotes.length,
                                // shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, i) {
                                  Quote q = quotes[i];

                                  return Container(
                                      height: 300, width: 300, child: buildItem2(q, context));
                                },
                              ),

                              // height: 300,
                              // width: double.infinity,
                            ),
                          )
                        : Text("No Data");
                  }, loading: (asyncData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.pink[100],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.pink[300]),
                      ),
                    );
                  }, error: (error) {
                    return Text(error.toString());
                  });
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.pink,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: AutoSizeText(
                      "<<<<< ~~~ Using GridView swipe ~~~ >>>>",
                      style: styleTitlesWhite,
                      maxFontSize: 20,
                    ),
                  ),
                ),
              ),
            ),

            /// Using GridView 3 random Quotes swipe Up to refresh
            Container(
              height: 600,
              // width: 500,
              // width: double.infinity,
              child: Consumer(
                  builder: (BuildContext context, ScopedReader watch, Widget consumerChild) {
                final quotesList = watch(rQuotesViewModel);
                var crossAxisCount = 2;
                var childAspectRatio = 1.0;

                return quotesList.map(data: (asyncData) {
                  var quotes = asyncData.value;

                  log("test : ${quotes.length}");

                  return quotes.length != 0
                      ? GestureDetector(
                          onVerticalDragEnd: (details) async {
                            return context.refresh(rQuotesViewModel);
                          },
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: childAspectRatio,
                            ),

                            itemCount: quotes.length,
                            // shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, i) {
                              Quote q = quotes[i];
                              return Container(child: buildItem3(q, context));
                            },
                          ),
                        )
                      : Text("No Data");
                }, loading: (asyncData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.pink[100],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.pink[300]),
                    ),
                  );
                }, error: (error) {
                  return Text(error.toString());
                });
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem1(Quote quote, BuildContext context) {
    liked = context.read(favNotifier).isLiked;
    log("buildItem1 liked : $liked");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              height: 30,
              child: Image.asset("assets/quote.png"),
            ),
          ),
          Expanded(
            flex: 8,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  quote.content,
                  style: styleContenBlack,
                  maxFontSize: 50,
                  minFontSize: 20,
                ),
              ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Consumer(builder: (BuildContext context, ScopedReader watch, Widget child) {
            final favList = watch(favNotifier);
            final isfav2 = (favList.quotesList.map((e) => e.id).contains(quote.id));

            return Container(
              // color: Colors.purple[300],
              child: Row(
                children: [
                  IconButton(
                      icon: !isfav2
                          ? Icon(
                              Icons.bookmark_border,
                              color: Colors.black45,
                            )
                          : Icon(
                              Icons.bookmark,
                              color: Colors.black45,
                            ),
                      onPressed: () async {
                        !isfav2
                            ? context.read(favNotifier).addToFav(quote)
                            : context.read(favNotifier).removeFromFav(quote);

                        setState(() {});
                      }),
                  IconButton(
                      icon: Icon(
                        CupertinoIcons.share,
                        color: Colors.black54,
                      ),
                      onPressed: () => log("A")),
                  Spacer(),
                  Expanded(
                    child: AutoSizeText(
                      quote.author,
                      style: styleTitlesBlack,
                      maxFontSize: 22,
                      minFontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildItem(AsyncData<Quote> asyncData, BuildContext context) {
    // var qq = context.read(futureFavoriteQuotesViewModel).isLiked;
    // log("qq : $qq");

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              height: 30,
              child: Image.asset("assets/quote.png"),
            ),
          ),
          Expanded(
            flex: 8,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  asyncData.value.content,
                  style: styleContenBlack,
                  maxFontSize: 50,
                  minFontSize: 20,
                ),
              ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Container(
            // color: Colors.purple[300],
            child: Row(
              children: [
                IconButton(
                    icon: !liked
                        ? Icon(
                            Icons.bookmark_border,
                            color: Colors.black45,
                          )
                        : Icon(
                            Icons.bookmark,
                            color: Colors.black45,
                          ),
                    onPressed: () {
                      // if(isExist == null){
                      liked = context.read(favNotifier).changeFav();
                      log("chanege value : ${liked}");
                      log("qq : ${context.read(favNotifier).isLiked}");

                      // !liked
                      //     ? context.read(futureFavoriteQuotesViewModel).addToFav(asyncData.value)
                      //     : context
                      //         .read(futureFavoriteQuotesViewModel)
                      //         .removeFromFav(asyncData.value);
                      // // }

                      // var qq = context.read(futureFavoriteQuotesViewModel).isLiked;
                      // log("qq : $qq");

                      setState(() {
                        liked = !liked;
                        log("liked : $liked");
                      });
                      // liked = !liked;
                    }),
                IconButton(
                    icon: Icon(
                      CupertinoIcons.share,
                      color: Colors.black54,
                    ),
                    onPressed: () => log("A")),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    asyncData.value.author,
                    style: styleTitlesBlack,
                    maxFontSize: 22,
                    minFontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem2(Quote asyncData, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              height: 30,
              child: Image.asset("assets/quote.png"),
            ),
          ),
          Expanded(
            flex: 8,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  asyncData.content,
                  style: styleContenBlack,
                  maxFontSize: 50,
                  minFontSize: 20,
                ),
              ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Container(
            // color: Colors.purple[300],
            child: Row(
              children: [
                IconButton(
                    icon: !liked
                        ? Icon(
                            Icons.bookmark_border,
                            color: Colors.pink[300],
                          )
                        : Icon(
                            Icons.bookmark,
                            color: Colors.pink[300],
                          ),
                    onPressed: () {
                      // if(isExist == null){
                      !liked
                          ? context.read(favNotifier).addToFav(asyncData)
                          : context.read(favNotifier).removeFromFav(asyncData);
                      // }

                      setState(() {
                        liked = !liked;
                        log("liked : $liked");
                      });
                      // liked = !liked;
                    }),
                IconButton(
                    icon: Icon(
                      CupertinoIcons.share,
                      color: Colors.black54,
                    ),
                    onPressed: () => log("A")),
                Spacer(),
                Expanded(
                  child: AutoSizeText(
                    asyncData.author,
                    style: styleTitlesBlack,
                    maxFontSize: 22,
                    minFontSize: 20,
                    wrapWords: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem3(Quote q, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Colors.pink[300],
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black54, offset: Offset(1, 5), blurRadius: 10)],
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: GridTile(
        child: Column(
          children: [
            AutoSizeText(
              "${q.author}",
              style: styleTitlesBlack,
              minFontSize: 12,
              maxFontSize: 22,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: AutoSizeText(
                    q.content,
                    style: styleContentWhite,
                    minFontSize: 5,
                    maxFontSize: 28,
                    wrapWords: true,
                  ),
                ),
              ),
            ),
            Container(
              // color: Colors.purple[300],
              child: Row(
                children: [
                  IconButton(
                      icon: !liked
                          ? Icon(
                              Icons.bookmark_border,
                              color: Colors.pink[300],
                            )
                          : Icon(
                              Icons.bookmark,
                              color: Colors.pink[300],
                            ),
                      onPressed: () {
                        !liked
                            ? context.read(favNotifier).addToFav(q)
                            : context.read(favNotifier).removeFromFav(q);
                      }),
                  IconButton(
                      icon: Icon(
                        CupertinoIcons.share,
                        color: Colors.black54,
                      ),
                      onPressed: () => log("A")),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

