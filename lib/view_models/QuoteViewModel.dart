import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quotes_app/models/Quote.dart';
import 'package:quotes_app/services/Api/QuotesApi.dart';


final futureQuoteViewModel = FutureProvider.autoDispose<Quote>((ref) async {
  return await QuoteViewModel().geQuote();
});

class QuoteViewModel extends ChangeNotifier {

  Future<Quote> geQuote() async {
    Quote _quote = await QuotesApi().getQuote();
    _quote.liked = false;
    notifyListeners();
    return _quote;
  }


}
