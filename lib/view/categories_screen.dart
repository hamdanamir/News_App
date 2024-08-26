import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:newsapp1/modal/categores_news_modal.dart';
import 'package:newsapp1/view/categories_details_screen.dart';

import '../view_modal/news_view_modal.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModal newsViewModal = NewsViewModal();
  final format = DateFormat('MMMM dd,yyyy');
  String Category = 'General';
  List<String> CategoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Bussiness',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: CategoriesList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Category = CategoriesList[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Category == CategoriesList[index]
                                  ? Colors.blue
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Center(
                                child: Text(
                              CategoriesList[index].toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            )),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModal.fetchCategoresNewsApi(Category),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NewsDetaiScreen(
                                              newimage: snapshot.data!
                                                  .articles![index].urlToImage
                                                  .toString(),
                                              newtitle: snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              newdate: snapshot.data!
                                                  .articles![index].publishedAt
                                                  .toString(),
                                              author: snapshot
                                                  .data!.articles![index].author
                                                  .toString(),
                                              description: snapshot.data!
                                                  .articles![index].description
                                                  .toString(),
                                              content: snapshot.data!
                                                  .articles![index].content
                                                  .toString(),
                                              source: snapshot
                                                  .data!.articles![index].source!.name
                                                  .toString(),
                                            )));
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
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data!.articles![index]
                                                  .source!.name
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10),
                                            ),
                                            Text(
                                              format.format(datetime),
                                              style: GoogleFonts.poppins(
                                                color: Colors.black54,
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
        ),
      ),
    );
  }
}

const spin2 = SpinKitCircle(
  size: 50,
  color: Colors.amber,
);
