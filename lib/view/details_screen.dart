import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  String newimage, newtitle, newdate, author, description, content, source;

  DetailsScreen(
      {super.key,
      required this.newimage,
      required this.newtitle,
      required this.newdate,
      required this.author,
      required this.description,
      required this.content,
      required this.source});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final format = DateFormat('MMMM dd,yyyy');
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;
    DateTime dateTime=DateTime.parse(widget.newdate);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: height * 0.45,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(40)),
              child: CachedNetworkImage(
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                fit: BoxFit.cover,
                imageUrl: widget.newimage,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height * .4),
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            height: height * .6,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(40)
              ),
              color: Colors.white,
            ),
            child: ListView(
              children: [
                Text(
                  widget.newtitle,
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.source,
                      style: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ),
                    Text(format.format(dateTime),
                      style: GoogleFonts.poppins(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(
                  height: height*.03,
                  child: Text(
                    widget.description,
                    style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
