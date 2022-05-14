  import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ppg/main.dart';

class VideoPre extends StatelessWidget{
  const VideoPre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      title: 'PGBio',
      home: MyHomePage(title: 'Image Picker Example'),
    );
  }

}
