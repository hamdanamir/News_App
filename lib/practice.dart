import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp1/modal/news_channel_headlines_modal.dart';

class practice {
  Future<NewsChannelHeadlinesModal> fetchnewsapi() async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=88a250294b1441de9d50653d172b19f0";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModal.fromJson(body);
    }
    throw Exception("Eroor");
  }
}

class hello {
  Future<NewsChannelHeadlinesModal> fetchapinews() async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=88a250294b1441de9d50653d172b19f0";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModal.fromJson(body);
    }
    throw Exception("Error");
  }
}

class News {
  final _rep = hello();

  Future<NewsChannelHeadlinesModal> fetchapinew() async {
    final response = _rep.fetchapinews();
    return response;
  }
}

class tasks extends StatefulWidget {
  const tasks({super.key});

  @override
  State<tasks> createState() => _tasksState();
}

class _tasksState extends State<tasks> {
  News news = News();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "News",
          style: GoogleFonts.anton(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Image.asset(
            "images/category_icon.png",
            height: 25,
            width: 30,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
              height: height * .35,
              width: width,
              child: FutureBuilder<NewsChannelHeadlinesModal>(
                  future: news.fetchapinew(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitCircle(
                          size: 40,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("Error${snapshot.error}"),
                      );
                    } else if (snapshot.hasData ||
                        snapshot.data!.articles!.isEmpty) {
                      return const Center(
                        child: Text("No data available"),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      placeholder: (context, url) =>
                                          SpinKitCircle(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  }))
        ],
      ),
    );
  }
}
