import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Loaders {
  static bool loading = false;
  static showLoader(BuildContext context) {
    if (!loading) {
      var alert = const AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.green,
        )),
      );

      showDialog(
          context: context, barrierDismissible: true, builder: (_) => alert);
    }
  }

  static hideLoader(BuildContext context) {
    if (loading) Navigator.pop(context);
  }

  static showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Theme.of(context).accentColor,
      content: Text(
        msg,
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(color: Colors.white, fontSize: 8.sp),
      ),
    ));
  }
}
