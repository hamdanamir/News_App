import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsapp1/modal/news_channel_headlines_modal.dart';
import 'package:newsapp1/view/categories_screen.dart';
import 'package:newsapp1/view/details_screen.dart';
import 'package:newsapp1/view/extension.dart';
import 'package:newsapp1/view_modal/news_view_modal.dart';
import "package:intl/intl.dart";

import '../modal/categores_news_modal.dart';
import 'categories_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, aryNews, independent, reuters, cnn, alJazera }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModal newsViewModal = NewsViewModal();
  final format = DateFormat('MMMM dd,yyyy');
  ScrollController scrollController = ScrollController();
  FilterList? selectedMenu;
  String name = 'bbc-news';

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<FilterList>(
                onSelected: (FilterList item) {
                  if (FilterList.bbcNews.name == item.name) {
                    name = 'bbc-news';
                  }
                  if (FilterList.aryNews.name == item.name) {
                    name = 'ary-news';
                  }
                  if (FilterList.alJazera.name == item.name) {
                    name = 'al-jazeera-english';
                  }
                  setState(() {
                    selectedMenu = item;
                  });
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                initialValue: selectedMenu,
                itemBuilder: (context) => <PopupMenuEntry<FilterList>>[
                      const PopupMenuItem<FilterList>(
                          value: FilterList.bbcNews, child: Text("BBC News")),
                      const PopupMenuItem<FilterList>(
                          value: FilterList.aryNews, child: Text("ARY News")),
                      const PopupMenuItem<FilterList>(
                          value: FilterList.alJazera,
                          child: Text("AlJazera News"))
                    ]),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CategoriesScreen()));
            },
            icon: Image.asset(
              "images/category_icon.png",
              height: 25,
              width: 30,
            ),
          ),
          title: Text(
            "News",
            style:
                GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
          ),
        ),
        body: ListView(
          children: [
            SizedBox(
              height: height * .55,
              width: width,
              child: FutureBuilder<NewsChannelHeadlinesModal>(
                future: newsViewModal.fetchNewsChannelHeadlinesApi(name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 40,
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!.articles!.isEmpty) {
                    return const Center(
                      child: Text("NO data available"),
                    );
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime datetime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                            newimage: snapshot.data!
                                                .articles![index].urlToImage
                                                .toString(),
                                            newtitle: snapshot
                                                .data!.articles![index].title
                                                .toString(),
                                            author: snapshot
                                                .data!.articles![index].author
                                                .toString(),
                                            newdate: snapshot.data!
                                                .articles![index].publishedAt
                                                .toString(),
                                            description: snapshot.data!
                                                .articles![index].description
                                                .toString(),
                                            content: snapshot
                                                .data!.articles![index].content
                                                .toString(),
                                            source: snapshot.data!
                                                .articles![index].source!.name
                                                .toString(),
                                          )));
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: width * 1,
                                    height: height * .6,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: height * .02),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: spin2,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 15,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        height: height * .23,
                                        width: width * .8,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * 0.7,
                                              child: Text(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              width: width * .7,
                                              child: Row(
                                                // crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    snapshot
                                                        .data!
                                                        .articles![index]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15,
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    format.format(datetime),
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.grey,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  }
                  // else {
                  //   return ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: snapshot.data!.articles!.length,
                  //       itemBuilder: (context, index) {
                  //         return Container(
                  //           child: Stack(
                  //             alignment: Alignment.center,
                  //             children: [
                  //               Container(
                  //                 child: CachedNetworkImage(
                  //                   imageUrl: snapshot
                  //                       .data!.articles![index].urlToImage
                  //                       .toString(),
                  //                   fit: BoxFit.cover,
                  //                   placeholder: (context, url) =>
                  //                       Container(child: spin2),
                  //                   errorWidget: (context, url, error) =>
                  //                       const Icon(
                  //                     Icons.error_outline,
                  //                     color: Colors.red,
                  //                   ),
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         );
                  //       });
                  // }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModal.fetchCategoresNewsApi("General"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitCircle(
                        size: 40,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        // scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime datetime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: InkWell(
                              onTap: () {
                                context.navigateto(CategoriesDetailsScreen(
                                  newimage: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  newtitle: snapshot
                                      .data!.articles![index].title
                                      .toString(),
                                  newdate: snapshot
                                      .data!.articles![index].publishedAt
                                      .toString(),
                                  author: snapshot
                                      .data!.articles![index].author
                                      .toString(),
                                  description: snapshot
                                      .data!.articles![index].description
                                      .toString(),
                                  content: snapshot
                                      .data!.articles![index].content
                                      .toString(),
                                  source: snapshot
                                      .data!.articles![index].source!.name
                                      .toString(),
                                ));
                              },
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      height: height * .18,
                                      width: width * .3,
                                      imageUrl: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        child: spin2,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.only(left: 15),
                                    height: height * .18,
                                    child: Column(
                                      children: [
                                        Text(
                                          maxLines: 3,
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10),
                                            ),
                                            Text(
                                              format.format(datetime),
                                              style: GoogleFonts.poppins(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            )
          ],
        ));
  }
}

const spin2 = SpinKitCircle(
  size: 50,
  color: Colors.amber,
);
