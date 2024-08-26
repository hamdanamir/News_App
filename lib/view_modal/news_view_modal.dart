import 'package:newsapp1/modal/categores_news_modal.dart';
import 'package:newsapp1/modal/news_channel_headlines_modal.dart';
import 'package:newsapp1/repositery/news_repositery.dart';

class NewsViewModal {
  final _rep = NewsRepositery();
  Future<NewsChannelHeadlinesModal> fetchNewsChannelHeadlinesApi(
      String channelName) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(channelName);
    return response;
  }



  Future<CategoriesNewsModel> fetchCategoresNewsApi(
      String category) async {
    final response = await _rep.fetchCategoresNewsApi(category);
    return response;
  }
}
