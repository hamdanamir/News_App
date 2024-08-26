import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp1/modal/news_channel_headlines_modal.dart';

import '../modal/categores_news_modal.dart';

class NewsRepositery {
  Future<NewsChannelHeadlinesModal> fetchNewsChannelHeadlinesApi(
      String channelName) async {
    String url ="https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=88a250294b1441de9d50653d172b19f0";
    final response = await http.get(Uri.parse(url));
    // if(kDebugMode){
    //   print(response.body);
    // }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModal.fromJson(body);
    }
    else{
      throw Exception("Error");
    }

  }
  Future<CategoriesNewsModel> fetchCategoresNewsApi(
      String category) async {
    String url ="https://newsapi.org/v2/everything?q=${category}&apiKey=88a250294b1441de9d50653d172b19f0";
    final response = await http.get(Uri.parse(url));
    // if(kDebugMode){
    //   print(response.body);
    // }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    else{
      throw Exception("Error");
    }

  }
}
