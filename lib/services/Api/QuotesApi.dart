import 'dart:convert';
import 'dart:developer';

import 'package:quotes_app/models/Quote.dart';
import 'package:http/http.dart' as http;

class QuotesApi {
  static final String baseUrl = "https://api.quotable.io/random?tags=inspirational";

  Future<Quote> getQuote() async {
    var request = http.Request('GET', Uri.parse('$baseUrl'));

    http.StreamedResponse response = await request.send();

    try {
      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        var jsonData = jsonDecode(data);
        var quote = Quote.fromJson(jsonData);
        // // set default value for every new quote:
        // quote.liked =false;

        return quote;
      } else {
        log(response.reasonPhrase);
      }
    } catch (e) {
      log(e);
    }
  }

  Future<List<Quote>> getQuotes() async {
    List<Quote> quotes = [];

    var request = http.Request('GET', Uri.parse('$baseUrl'));

    http.StreamedResponse response = await request.send();

    try {
      if (response.statusCode == 200) {
        var data = await response.stream.bytesToString();
        var jsonData = jsonDecode(data);
        var quote = Quote.fromJson(jsonData);
        // // set default value for every new quote:
        // quote.liked =false;
        quotes.add(quote);

        return quotes;
      } else {
        log(response.reasonPhrase);
      }
    } catch (e) {
      log(e);
    }
  }

  Future<List<Quote>> getQuotes2() async {
    List<Quote> quotes = [];

    // quotes.add(q);

    for(var i = 0; i < 3; i++) {
      var q = await getQuote();
      quotes.add(q);
    }

    return quotes;
  }
}
