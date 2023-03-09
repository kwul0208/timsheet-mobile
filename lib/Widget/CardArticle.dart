import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/Provider/Dashboard/DashboardState.dart';

class CardArticle extends StatelessWidget {
  const CardArticle({
    Key? key,
    required this.width,
    this.date,
    this.message, this.sender, this.url_photo, this.index
  }) : super(key: key);

  final double width;
  final String ? url_photo;
  final String ? date;
  final String ? sender;
  final String ? message;
  final int ? index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: width,
        // height: 170,
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
              leading: url_photo == null ? CircleAvatar(
                backgroundImage: AssetImage("assets/aliza.jpg"),
              ) : CircleAvatar(
                backgroundImage: NetworkImage('${url_photo}'),
              ),
              title: Text("${sender}",style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
              subtitle: Text("$date",style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
            ),
            Consumer<DashboardState>(
              builder: (context, data, _) {
                if (data.showAll == true && data.showIndex == index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("${message}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black54)),
                  );
                }else{
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("${message!.length > 100 ? message!.substring(0, 100) : message}...", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black54)),
                  );
                }
              }
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  GestureDetector(
                    onTap: (){
                      Provider.of<DashboardState>(context, listen: false).changeShowALl(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Config().blue2, width: 2)),
                        child:  Consumer<DashboardState>(
                          builder: (context, data, _) {
                            if (data.showAll == true && data.showIndex == index) {
                              return Icon(
                                Icons.keyboard_arrow_up_rounded,
                                color: Config().blue2,
                                size: 22,
                              );
                            }else{
                              return Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Config().blue2,
                                size: 22,
                              );
                            }
                          }
                        ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}