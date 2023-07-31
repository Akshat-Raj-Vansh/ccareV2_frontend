import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OwnImageCard extends StatelessWidget {
  OwnImageCard({Key key, this.path, this.time}) : super(key: key);
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
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Color(0xffdcf8c6),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ),
                child: Image(image: NetworkImage(path)),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(time, style: timeStyle),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    // Icon(
                    //   Icons.done_all,
                    //   size: 20,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
