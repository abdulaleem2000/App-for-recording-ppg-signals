

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stats extends StatefulWidget{
  @override
  _Stats createState()=> _Stats();

}

class _Stats extends State<Stats>{
  var count,male='',female='';
  var max=0;
  var jp='';
  late Query _ref;
  int jmlPria=0,f1=0,m1=0;

  @override
  void initState(){
    getData();
    super.initState();
    _ref = FirebaseDatabase.instance.ref()
        .child('person')
        .orderByChild('id');
getData();

  }
  void wait() async{
    await getData();
  }
  Future<void> getData() async{

    await FirebaseDatabase.instance
        .reference()
        .child('person')
        .orderByChild('id')
        .once()
        .then((event) async {
     final dataSnapshot = await event.snapshot;
      Map personData = dataSnapshot.value as Map;
      jmlPria = personData.length;

      jp=jmlPria.toString();


    });

print(jp);
  }
  // Future<void> getData1() async{
  //   await FirebaseDatabase.instance
  //       .reference()
  //       .child('person')
  //
  //       .orderByChild('Gender')
  //       .equalTo('male')
  //       .once()
  //       .then((event) {
  //     final dataSnapshot = event.snapshot;
  //     Map personData = dataSnapshot.value as Map;
  //     m1 = personData.length;
  //
  //     male= m1.toString();
  //
  //
  //   });
  //   print('male');
  //   print(male);
  // }
  // Future<void> getData2() async{
  //   await FirebaseDatabase.instance
  //       .reference()
  //       .child('person')
  //
  //       .orderByChild('Gender')
  //       .equalTo('Female')
  //       .once()
  //       .then((event) {
  //     final dataSnapshot = event.snapshot;
  //     Map personData = dataSnapshot.value as Map;
  //     f1 = personData.length;
  //
  //
  //     female= f1.toString();
  //
  //
  //   });
  //   print('female');
  //   print(female);
  // }
  Widget _buildData(){
     //  print(c);
  getData();
    return  Container(
      padding: const EdgeInsets.only(left: 110,right: 10),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:<Widget> [

           Text('Total Records: '+jp,style: TextStyle(fontSize: 24,
                color: Colors.black,fontWeight: FontWeight.w600)),
            Text('No of Females: '+female.toString(),style: TextStyle(fontSize: 24,
    color: Colors.black,fontWeight: FontWeight.w600)),
            Text('No of Males: '+male.toString(),style: TextStyle(fontSize: 24,
               // color: Colors.black,fontWeight: FontWeight.w600)),
          ],


        ),


    );


  }
  @override
  Widget build(BuildContext context) {
getData();
    //getData1();
    //getData2();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: [

        ],
      ),

      body:_buildData()


      );


  }
  
}