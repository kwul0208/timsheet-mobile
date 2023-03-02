import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerWidget.dart';

class ShimmerRWDList extends StatelessWidget {
  const ShimmerRWDList({
    Key? key,
    required this.width,
  }) : super(key: key);

  final width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Config().line, width: 3))
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget(width: width/2, height: 20, isCircle: false),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ShimmerWidget(width: width/4, height: 18, isCircle: false),
                            SizedBox(width: 10,),
                            ShimmerWidget(width: width/4, height: 18, isCircle: false),
                          ],
                        ),
                        SizedBox(height: 3,),
                        Row(
                          children: [
                            ShimmerWidget(width: width/4, height: 18, isCircle: false),
                            SizedBox(width: 10,),
                            ShimmerWidget(width: width/4, height: 18, isCircle: false),
                          ],
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),

                  ],
                ),
                Column(
                  children: [
                    ShimmerWidget(width: width/4, height: 18, isCircle: false)
                  ],
                )
              ],
            ),
            // SizedBox(height: 16,),
            ShimmerWidget(width: width/4, height: 18, isCircle: false),
            SizedBox(height: 3,),
            ShimmerWidget(width: width/4, height: 18, isCircle: false),
            SizedBox(height: 3,),
            Align(
              alignment: Alignment.topRight,
              child: ShimmerWidget(width: width/2, height: 18, isCircle: false)),
            
          ],
        ),
      ),
    );
  }
}