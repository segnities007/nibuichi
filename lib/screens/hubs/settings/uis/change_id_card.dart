import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:image/image.dart' as img;
import 'package:nibuichi/datas/firebase.dart';
import 'dart:typed_data';
import 'package:path/path.dart';

class ChangeIDCard extends StatelessWidget{
  const ChangeIDCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: ()async{

            },
            child: const Text("change Image")
        )
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<void> selectAndUploadImage()async{
  try{
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image == null)return;

    final img.Image? originalImage = img.decodeImage(File(image.path).readAsBytesSync());
    final img.Image resizedImage = img.copyResize(originalImage!, width: 300);
    final List<int> resizedBytes = img.encodeBmp(resizedImage);
    final Uint8List resizedUnit8List = Uint8List.fromList(resizedBytes);

    final uploadTask = await FirebaseInstances.storage.child("image/icon/${basename(image.path)}")
        .putData(resizedUnit8List);

    final url = await uploadTask.ref.getDownloadURL();

    final Map<String, dynamic> data = {
      "url": url,
      "path": "image/${basename(image.path)}"
    };
  }catch (e){
    Logger().i(e);
  }
}

Future<void> showImage()async{

}

Future<void> deleteImage()async{

}