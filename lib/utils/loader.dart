import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../config/exported_path.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color color;

  const LoadingWidget({super.key, this.size = 36.0, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: Platform.isIOS
            ? CupertinoActivityIndicator(
                color: color,
              )
            : CircularProgressIndicator(
                strokeWidth: 2.0,
                color: color,
              ),
      ),
    );
  }
}
