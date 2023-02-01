import 'package:flutter/material.dart';
import 'package:timsheet_mobile/Config/Config.dart';
import 'package:timsheet_mobile/views/pages/WFH/CRUD/EditWFH.dart';

class DetailOT extends StatefulWidget {
  const DetailOT({super.key});

  @override
  State<DetailOT> createState() => _DetailOTState();
}

class _DetailOTState extends State<DetailOT> {
  @override
  Widget build(BuildContext context) {
    var size, height, width;

    // getting the size of the window
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Detail Overtime",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        centerTitle: true,
        elevation: .5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              children: [
                // --- Status ---
                Row(
                  children: [
                    Text("Status", style: TextStyle(fontSize: 17),),
                    SizedBox(width: 70,),
                    Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("Pending", style: TextStyle(color: Colors.white, fontSize: 11),),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Divider(),

                // --- Date ---
                Row(
                  children: [
                    Text("Date", style: TextStyle(fontSize: 17),),
                    SizedBox(width: 82,),
                    Flexible(child: Text("20 Jan 2023", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                  ],
                ),
                SizedBox(height: 10),
                Divider(),

                // --- Time ---
                Row(
                  children: [
                    Text("Time", style: TextStyle(fontSize: 17),),
                    SizedBox(width: 78,),
                    Flexible(child: Text("19:00 - 21:00", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                  ],
                ),
                SizedBox(height: 10),
                Divider(),

                // --- Inputed for ---
                Row(
                  children: [
                    Text("Inputed for", style: TextStyle(fontSize: 17),),
                    SizedBox(width: 33,),
                    Flexible(child: Text("Ahmad Wahyu Awaludin", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                  ],
                ),
                SizedBox(height: 10),
                Divider(),

                // --- Inputed By ---
                Row(
                  children: [
                    Text("Inputed by", style: TextStyle(fontSize: 17),),
                    SizedBox(width: 38,),
                    Flexible(child: Text("Danti Iswandhari", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                  ],
                ),
                SizedBox(height: 10),
                Divider(),

                // --- Duration ---
                Row(
                  children: [
                    Text("Inputed on", style: TextStyle(fontSize: 17),),
                    SizedBox(width: 38,),
                    Flexible(child: Text("20/01/2023 18:00", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                  ],
                ),
                SizedBox(height: 10),
                Divider(),

                // --- Reason ---
                Row(
                  children: [
                    Text("Description", style: TextStyle(fontSize: 17),),
                    SizedBox(width: 32,),
                    Flexible(child: Text("Wfh", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),))
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 20),

                // --- Button ---
                
                SizedBox(height: height/3),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Config().primary,
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  onPressed: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditWFH()));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                       Text(
                        'Edit',
                        style: TextStyle(fontSize: 24),
                      ),
                      Icon(Icons.navigate_next_outlined, size: 30,)
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