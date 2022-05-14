import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ppg/PersonData.dart';
import 'package:ppg/main.dart';

class DatabaseService extends StatefulWidget{
  @override
  _DataState createState()=> _DataState();

}

class _DataState extends State<DatabaseService>{
 var count=0;
  late Query _ref;
  @override
  void initState(){
    super.initState();
    _ref = FirebaseDatabase.instance.ref()
    .child('person')
    .orderByChild('id');
  }
  Widget _buildPersonsList({ required Map personData}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(10),
      height: 100,
      color: Colors.redAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.person,color: Colors.white,size: 20,),
            SizedBox(width: 6,),
            Text(personData['Name'],style: TextStyle(fontSize: 16,
                color: Colors.black,fontWeight: FontWeight.w600),),
          ],),
          SizedBox(height: 10,),
          Row(children: [
            Text('Age',style: TextStyle(fontSize: 16,
                color: Colors.black,fontWeight: FontWeight.w600),),
            SizedBox(width: 6,),
            Text(personData['Age'],style: TextStyle(fontSize: 16,
                color: Colors.white,fontWeight: FontWeight.w600),),
            SizedBox(width: 15,),
            Text('Gender',style: TextStyle(fontSize: 16,
                color: Colors.black,fontWeight: FontWeight.w600),),
            SizedBox(width: 6,),
            Text(personData['Gender'],style: TextStyle(fontSize: 16,
                color: Colors.white,fontWeight: FontWeight.w600),),
          ],)


        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('Available Records'),
       backgroundColor: Colors.red,
       centerTitle: true,
       actions: [

       ],
     ),
     body: Container(

       height: double.infinity,

       child: FirebaseAnimatedList(query: _ref,itemBuilder: (BuildContext context
           , DataSnapshot snapshot,Animation<double>animation,int index){
         Map personData = snapshot.value as Map;

         print('length: ' );
          count++;
          print(count);
         return _buildPersonsList(personData: personData);
       },),

     ),

   );
  }

}