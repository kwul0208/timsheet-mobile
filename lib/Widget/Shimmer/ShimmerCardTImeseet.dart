import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Widget/Shimmer/ShimmerWidget.dart';

class ShimmerCardTImesheet extends StatelessWidget {
  const ShimmerCardTImesheet({
    Key? key,
    required this.width,
  }) : super(key: key);

  final width;

  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.all(10.0),
       child: Container(
         width: width,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10),
           color: Colors.white,
           boxShadow: [
             BoxShadow(
                 blurRadius: 5,
                 color: Color.fromARGB(
                     255, 221, 221, 221),
                 offset: Offset(0, 5))
           ] //
         ),
         child: Padding(
           padding: EdgeInsets.all(10.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               ShimmerWidget(width: width/1.5, height: 16, isCircle: false),
               SizedBox(height: 30,),
               ShimmerWidget(width: width/1.5, height: 16, isCircle: false),
               SizedBox(height: 30,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   ShimmerWidget(width: width/3, height: 16, isCircle: false),
                   ShimmerWidget(width: width/3, height: 16, isCircle: false)
                 ],
               )
             ],
           ),
         ),
       ),
     );
  }
}
