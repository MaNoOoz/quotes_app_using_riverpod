import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes_app/services/Api/QuotesApi.dart';
import 'package:quotes_app/models/Quote.dart';

final changeQuotesViewModel = ChangeNotifierProvider<QuotesViewModel>((ref) {
  return QuotesViewModel();
});

final rQuotesViewModel = FutureProvider.autoDispose<List<Quote>>((ref) async {
  return await QuotesViewModel()._geQuotes();
});

class QuotesViewModel extends ChangeNotifier {
  List<Quote> _qoutes = [];

  List<Quote> get qoutes => _qoutes;

  set qoutes(List<Quote> value) {
    _qoutes = value;
  }

  Future<List<Quote>> _geQuotes() async {
    _qoutes = await QuotesApi().getQuotes2();
    // _qoutes.liked = false;
    notifyListeners();
    return _qoutes;
  }
}
