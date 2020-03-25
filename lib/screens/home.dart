import 'dart:convert';
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:shopcut/models/recognised_text.dart';
import 'package:shopcut/screens/result/result.dart';
import 'package:shopcut/screens/welcome.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopcut/shared/loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool scanCompleted = false;
  bool loading = false;
  RecognisedText lines;

  Future _pickImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      loading = true;
    });
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    setState(() {
      scanCompleted = true;
      LineSplitter ls = new LineSplitter();
      lines = new RecognisedText(lines: ls.convert(readText.text));
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return scanCompleted
        ? Results(
            scannedText: lines,
          )
        : (loading
            ? Loading()
            : Scaffold(
                appBar: AppBar(
                  title: Text(
                    'ShopCut',
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.yellow[700],
                  actions: <Widget>[
                    FlatButton.icon(
                      icon: Icon(Icons.aspect_ratio),
                      label: Text('Scan list'),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
                body: Welcome(),
              ));
  }
}
