import 'package:flutter/material.dart';

class BackButtonImg extends StatefulWidget {
  final VoidCallback onPressed;

  const BackButtonImg({Key key, this.onPressed}) : super(key: key);
  @override
  _BackButtonImgState createState() => _BackButtonImgState();
}

class _BackButtonImgState extends State<BackButtonImg> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder:  (context, constraints) {
        return InkWell(
        onTap: widget.onPressed,
        child:Container(
          height: 40,
          child: Stack(
            children: <Widget>[
              Image.asset('assets/images/back-button-img.png', width: constraints.maxWidth, fit: BoxFit.fill),
              Align(
                alignment: Alignment.center,
                child: Text('BACK', style: TextStyle(fontFamily: 'Lato-Heavy', fontSize: 12),))
            ],
          ),
        ),        
      );
      },
    );
  }
}