import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class Person {
  final String name;
  final String age;
  final String gender;
  final String randomKey;


  Person(this.name, this.age,this.gender,this.randomKey);

}
