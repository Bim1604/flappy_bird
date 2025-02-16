import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class SnackBarUtil {
  static void onShowSnackBar(BuildContext context, {required String title, required String content, ContentType? contentType}) {
    Size size = MediaQuery.sizeOf(context);
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.only(bottom: size.height / 1.25),
      content: AwesomeSnackbarContent(
        title: title,
        message: content,
        contentType: contentType ?? ContentType.success,
      ),
    );

    ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(snackBar);
  }
}