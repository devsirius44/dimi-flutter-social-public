import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';

abstract class ImagePickListener {
  onImagePicked(File image);
}

class ImagePickerDialog extends StatelessWidget {
  final BuildContext context;
  final ImagePickListener _listener;

  ImagePickerDialog(this.context, this._listener);

  show(){
    showDialog(
      context: context,
      builder: (context) => Container(
        child: this,
      )
    );
  }

  dismiss(){
    Navigator.pop(context);
  }
  handleImage(File file){
    _listener.onImagePicked(file);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Opacity(
        opacity: 1.0,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width*2/3,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        dismiss();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.close, size: 23,),
                      ),
                    ),
                  ),
                  CustomButton(
                    text: 'SELECT FROM PHOTO GALLERY',
                    onPressed: () async {
                      dismiss();
                      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                      handleImage(image);                    }
                  ),
                  // SizedBox(height: 15,),
                  CustomButton(
                    text: 'TAKE A PHOTO',
                    onPressed: () async {
                      dismiss();
                      var image = await ImagePicker.pickImage(source: ImageSource.camera);
                      handleImage(image);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      
    );
  }
}