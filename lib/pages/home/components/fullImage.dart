import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String tag;

  FullScreenImage({ required this.imageUrl, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag,
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
              imageUrl: imageUrl,
              httpHeaders: {
                            "Authorization":
                                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjFhMWU5ZGNiYWI4MjZkZTk4NjBmNzkzIiwiaWF0IjoxNjM4MjY1MzkxLCJleHAiOjE2Mzg4NzAxOTEsImlzcyI6ImNvbS5jY2FyZW5pdGgifQ.K-_DprXx2ipOwWt17DODlMDqQSgtWdv8aARjlPdEuzA"
                          }
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}