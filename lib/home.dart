import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _storedImage;
  var imageFile;

  @override
  void initState() {
    super.initState();

    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
     print(info);
    // _toastInfo(info);
  }

  Future<void> _takePicture() async {
    imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      //To set image resolution
      //maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  Future<void> _savePicture() async {
    if (imageFile == null) {
      return;
    }


    File file = imageFile;
    Uint8List bytes = file.readAsBytesSync();
    var img = ByteData.view(bytes.buffer);

    await ImageGallerySaver.saveImage(img.buffer.asUint8List());
    _toastInfo('Image saved to Gallery.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blueGrey[50],
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: Column(
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey[400],
                      child: _storedImage != null
                          ? Image.file(
                              _storedImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : Text(
                              'No image \n taken',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.roboto(),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
                color: Colors.blue,
                child: Text('Take Picture',
                    style: GoogleFonts.roboto(color: Colors.white)),
                onPressed: _takePicture),
            SizedBox(
              height: 20,
            ),
            FlatButton(
                child: Text('Save to Gallery',
                    style: GoogleFonts.roboto(color: Colors.blue)),
                onPressed: _savePicture)
          ],
        ),
      ),
    );
  }
}
