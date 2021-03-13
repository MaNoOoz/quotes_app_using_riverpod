import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes_app/models/Quote.dart';

final FAVLIST = "favlist";
//
final favNotifier = ChangeNotifierProvider<FavoriteQuotesViewModel>((ref) {
  return FavoriteQuotesViewModel();
});

class FavoriteQuotesViewModel extends ChangeNotifier {
  List<Quote> _quotesList = [];

  List<Quote> get quotesList => _quotesList;
  bool _isLiked = false;

  bool get isLiked => _isLiked;

  set isLiked(bool value) {
    _isLiked = value;
  }

  bool changeFav() {
    _isLiked = !_isLiked;
    notifyListeners();
    return _isLiked;
  }

  set quotesList(List<Quote> value) {
    _quotesList = value;
  }

  Future<List<Quote>> getFavList() {
    Future.value(_quotesList);
  }

  void addToFav(Quote quote) {
    log("Added");

    _quotesList.add(quote);

    notifyListeners();
  }

  void removeFromFav(Quote quote) {
    log("Removed");
    _quotesList.remove(quote);

    // favoriteBox.delete(quote);
    // log("removeFromFav : favoriteBox: ${favoriteBox.length}");

    notifyListeners();
  }
}
