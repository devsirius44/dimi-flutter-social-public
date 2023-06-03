import 'package:flutter/material.dart';

class VChatImageList extends StatelessWidget {
  final String imageUrlU;
  final String imageUrlB = 'assets/images/vchatB-icon.png';
  final String title;
  final String label;

  const VChatImageList({Key key, this.label, this.title, this.imageUrlU, }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(child: Padding(
                padding: const EdgeInsets.only(top: 35, bottom: 25),
                child: Image.asset(this.imageUrlU, height: 200,),
              )),
              Positioned(
                bottom: 13,
                child: Container(
                  height: 40,
                  width: 125,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,                        
                      image: new  AssetImage(this.imageUrlB, ),
                    )
                  ),
                  child: Center(child: Text(this.title, style: TextStyle(color: Colors.white, fontFamily: 'Lato-Heavy', fontSize: 10))),
                ),
              ),
            ],
          ),
          Text(this.label, style: TextStyle(color: Color(0xff342e37), fontFamily: 'PlayfairDisplay-Italic', fontSize: 17)),

        ],  
      ),
    );
  }
}