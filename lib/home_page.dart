// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:torch_light/torch_light.dart';

import 'PersonData.dart';
import 'data_page.dart';
import 'database.dart';




class MyHomePage1 extends StatefulWidget {
  const MyHomePage1({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState1 createState() => _MyHomePageState1();
}

class _MyHomePageState1 extends State<MyHomePage1> {
  final rootRef = FirebaseDatabase.instance.ref();
  final strRef = FirebaseStorage.instance.ref();
  bool isLoading = false;
  int currentIndex = 0;
  List<Person> personList=[];
  String dropdownvalue = 'Male';
  var items = [
    'Male',
    'Female'

  ];

  List<XFile>? _imageFileList;
  XFile? videoFile;





  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  bool isVideo = false;
  bool flag = false;
  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;
      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      const double volume = kIsWeb ? 0.0 : 0.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      setState(() {});
    }
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (isVideo) {
      final XFile? file = await _picker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 30));
      videoFile = file;
      print(file?.path);

      await _playVideo(file);
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final genderController = TextEditingController();

    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null && flag==true) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                child: Text(
                    'Data Uploaded Successfuly!',
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),

              ),

            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                child: Text(
                    'Press button to record video again',
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),

              ),

            )
          ]
      );

    }
    else if(_controller == null && flag==false){
      return Container(
          padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
          child: Column(

              children: [


                Container(

                  width: MediaQuery.of(context).size.width,
                  height: 320,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.red.withOpacity(0.8),
                            Colors.white12.withOpacity(0.6)
                          ],
                          begin:Alignment.bottomLeft,
                          end: Alignment.centerRight
                      ),

                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topRight: Radius.circular(80)
                      ),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 40,
                            offset: Offset(8,10),
                            color: Colors.red
                        )
                      ]
                  ),
                  child:Container(
                    padding: const EdgeInsets.only(top: 20,left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          'This application is used to gather data for biometric verification using ppg signals. This application will record video for 30 seconds and store video with data in cloud database.',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  )

                ),

              ]
          ),

      );


    }

    return Padding(
        padding: const EdgeInsets.only(top: 100,left: 100,right: 100, bottom: 150),
        child: Column(
          children: [
            // Container(
            //     child: AspectRatioVideo(_controller)//file.path
            // ),
            Container(
              child: TextField(
                  controller: nameController,
                  decoration: new InputDecoration(
                      hintText: 'Name'
                  )
              ),

            ),
            Container(
              child: DropdownButton(
                value: dropdownvalue,
                  items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    dropdownvalue = value!;
                  });
                },

              ),

            ),
            Container(
              child: TextField(
                  controller: ageController,
                  decoration: new InputDecoration(
                      hintText: 'Age'

                  )
              ),

            ),
            Container(

                padding: EdgeInsets.all(32),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 24),
                    minimumSize: Size.fromHeight(50),
                    primary: Colors.red,

                    shape: StadiumBorder(),
                  ),
                  child: isLoading
                      ?CircularProgressIndicator(color: Colors.white,)
                      : Text('Save Data'),
                  onPressed: () async {
                    if(nameController.text.isEmpty || ageController.text.isEmpty){
                      AlertDialog alert = AlertDialog(
                        title: Text("Warning"),
                        content: Text("Fields must not be empty"),
                        actions: [

                        ],
                      );

                      // show the dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );
                    }
                    else{
                      String? randomKey;
                      randomKey =rootRef.push().key;

                      File file = File(videoFile!.path);
                      setState(() {
                        isLoading = true;
                      });
                      //uploading video to firebase storage
                      await strRef
                          .child('video')
                          .child(randomKey!)
                          .putFile(file);

                      //storing data in firebase database
                      await rootRef
                          .child('person')
                          .child(randomKey)
                          .set({
                        'id': randomKey,
                        'Name': nameController.text,
                        'Age':ageController.text,
                        'Gender' : dropdownvalue
                      })
                          .asStream();
                      setState(() {
                        _controller=null;
                        flag=true;

                        isLoading = false;
                      });

                      nameController.clear();
                      ageController.clear();
                    }



                  },





                )
            ) ],
        )








    );

  }



  Widget _handlePreview() {

    return _previewVideo();

  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
          _imageFileList = response.files;
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SingleChildScrollView(

        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
          future: retrieveLostData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Text(
                  'You have not yet picked an image.',
                  textAlign: TextAlign.center,
                );
              case ConnectionState.done:
                return _handlePreview();
              default:
                if (snapshot.hasError) {
                  return Text(
                    'Pick image/video error: ${snapshot.error}}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const Text(
                    'You have not yet picked an image.',
                    textAlign: TextAlign.center,
                  );
                }
            }
          },
        )
            : _handlePreview(),


      ),



       floatingActionButton: Container(
         padding: const EdgeInsets.only(top: 440,left: 30,right: 10),
         child: Column(
           children: [
             Container(
                 width: MediaQuery.of(context).size.width,
                 height: 150,
                 decoration: BoxDecoration(
                    color: Colors.white70,

                     borderRadius: BorderRadius.only(
                         topLeft: Radius.circular(20),
                         bottomLeft: Radius.circular(20),
                         bottomRight: Radius.circular(20),
                         topRight: Radius.circular(20)
                     ),
                   boxShadow: [
                     BoxShadow(
                       blurRadius: 40,
                       offset: Offset(8,10),
                       color: Colors.red
                     )
                   ]

                 ),

                 child:Container(
                   padding: const EdgeInsets.only(top: 5,left: 40,right: 20),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.end,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(
                         "Note: Don\'t forget to turn on flashlight while recording video",
                         style: TextStyle(
                             fontSize: 18,
                             color: Colors.white
                         ),
                       ),
                       SizedBox(height: 5,),
                      Row(

                      ),

                       FloatingActionButton(
                         backgroundColor: Colors.red,
                         onPressed: () {
                           isVideo = true;
                           _onImageButtonPressed(ImageSource.camera);
                         },
                         heroTag: 'video1',
                         tooltip: 'Take a Video',
                         child: const Icon(Icons.videocam),
                       ),
                     ],
                   ),
                 )

             )
           ],
         ),
    ),

    );

  }


  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }


  Future<void> _enableTorch(BuildContext context) async {
    try {
      await TorchLight.enableTorch();
    } on Exception catch (_) {
      _showMessage('Could not enable torch', context);
    }
  }
  void _showMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class AspectRatioVideo extends StatefulWidget {
  const AspectRatioVideo(this.controller);

  final VideoPlayerController? controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController? get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller!.value.isInitialized) {
      initialized = controller!.value.isInitialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller!.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller!.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller!.value.aspectRatio,
          child: VideoPlayer(controller!),
        ),
      );
    } else {
      return Container();
    }
  }

}


