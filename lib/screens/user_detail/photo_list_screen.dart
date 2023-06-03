import 'package:flutter/material.dart';

class PhotoListScreen extends StatefulWidget {
  final List<String>photoList;
  final reverseFlag;

  const PhotoListScreen({Key key, this.photoList, this.reverseFlag = false}) : super(key: key);
  @override
  PhotoListScreenState createState() => PhotoListScreenState();
}

class PhotoListScreenState extends State<PhotoListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        reverse: widget.reverseFlag,
        scrollDirection: Axis.horizontal,
        itemCount: widget.photoList.length,
        itemBuilder: (context, index)=> photoItem(index),
      )
    );
  }

  Widget photoItem(int index){
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(widget.photoList[index]));
  }
}


