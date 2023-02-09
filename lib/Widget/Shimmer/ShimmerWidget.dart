import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final bool isCircle;

  const ShimmerWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.isCircle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCircle == false) {
      return Shimmer.fromColors(
        baseColor: Color.fromARGB(255, 235, 235, 235),
        highlightColor: Colors.white,
          child: Container(
            width: width,
            height: height,
            color: Color.fromARGB(255, 235, 235, 235)
          )
        );
      
    } else {
      return Shimmer.fromColors(
        baseColor: Color.fromARGB(255, 235, 235, 235),
        highlightColor: Colors.white,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
            color: Color.fromARGB(255, 235, 235, 235),
              borderRadius: BorderRadius.circular(50)
            ),
          )
        );
    }
  }
}
