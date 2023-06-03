import 'package:flutter/material.dart';

class SavedSearches extends StatefulWidget {
  @override
  _SavedSearchesState createState() => _SavedSearchesState();
}

class _SavedSearchesState extends State<SavedSearches> {
  bool tap1Flag = false;
  bool tap2Flag = false;

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              setState(() {
                tap1Flag = !tap1Flag; 
              });              
            },
            title: Container(
              height: 40,
              color: tap1Flag ? Color(0xffe3e1e3) : Colors.white,
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: (){

                      },
                      child: Icon(tap1Flag ? Icons.edit : null, color: Colors.black45, size: 20,)
                    ),
                    SizedBox(width: 10,),
                    Text('Slim girls', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17),),
                    Spacer(),
                    InkWell(
                      onTap: () {

                      },
                      child: Icon(tap1Flag ? Icons.delete : null, color: Colors.black45, size: 20)
                    ),
                    SizedBox(width:10)
                  ],
                ),
              ),
            )
          ),

          ListTile(
            onTap: () {
              setState(() {
                tap2Flag = !tap2Flag; 
              });              
            },
            title: Container(
              height: 40,
              color: tap2Flag ? Color(0xffe3e1e3) : Colors.white,
              child: InkWell(
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {

                      },
                      child: Icon(tap2Flag ? Icons.edit : null, color: Colors.black45, size: 20,)
                    ),
                    SizedBox(width: 10),
                    Text('Blond girls', style: TextStyle(color: Color(0xff4a414e), fontFamily: 'Lato-Regular', fontSize: 17),),
                    Spacer(),
                    InkWell(
                      onTap: () {

                      },
                      child: Icon(tap2Flag ? Icons.delete : null, color: Colors.black45, size: 20,)
                    ),
                    SizedBox(width: 10,),                    
                  ],
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}