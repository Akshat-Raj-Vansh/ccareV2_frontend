//@dart=2.9
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReplyImageCard extends StatelessWidget {
  ReplyImageCard({Key key, this.path, this.time}) : super(key: key);
  final String path;
  final String time;

  TextStyle styles = TextStyle(color: Colors.white, fontSize: 14.sp);
  TextStyle timeStyle = TextStyle(
    fontSize: 10.sp,
    color: Colors.grey[600],
  );
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 30.h,
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 50,
                    top: 5,
                    bottom: 10,
                  ),
                  child: Image(
                    image: NetworkImage(path),
                  )),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(time, style: timeStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
