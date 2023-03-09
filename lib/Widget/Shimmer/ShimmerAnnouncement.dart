import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerWidget.dart';

class ShimmerAnnouncement extends StatelessWidget {
  const ShimmerAnnouncement({
    Key? key,
    required this.width,
  }) : super(key: key);

  final width;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(0, 4))
        ] 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: ShimmerWidget(height: 50, width: 50, isCircle: true,),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ShimmerWidget(width: width/3, height: 18, isCircle: false),
                    SizedBox(height: 3,),
                    ShimmerWidget(width: width/3, height: 16, isCircle: false)
                  ],
                ),
                ShimmerWidget(width: 50, height: 12, isCircle: false)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20, top: 10, bottom: 1),
            child: ShimmerWidget(width: width, height: 18, isCircle: false,),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20, top: 2, bottom: 10),
            child: ShimmerWidget(width: width/1.5, height: 18, isCircle: false,),
          ),
        ],
      ),
    );
  }
}
