import 'package:flutter/material.dart';

class DropDownList extends StatefulWidget {

  final ValueChanged<String> onChanged;
  //final String label;
  final List<String> itemList;
  final String fontFamily;
  final double fontSize;
  final Color labelColor;
  final int initialInex;
  
  DropDownList({Key key, this.itemList, this.fontSize = 16, this.onChanged, this.initialInex = 0,  this.labelColor = Colors.black, this.fontFamily = 'Lato-Regular'}) : super(key: key);

  @override
  DropDownListState createState() => DropDownListState();
}

class DropDownListState extends State<DropDownList> {
  
  List<DropdownMenuItem<String>> itemsList = [];
  String selectedItem = 'Select ...';
  
  @override
  void initState() {
    super.initState();
     
    if(widget.itemList == null) return;
    itemsList = widget.itemList.map<DropdownMenuItem<String>>((str) => DropdownMenuItem<String>(
      child: Text(str, maxLines: 2, style: TextStyle(color: widget.labelColor, fontFamily: widget.fontFamily, fontSize: widget.fontSize, height: 1)),
      value: str
    )).toList();
    int index = widget.initialInex;
    selectedItem = itemsList[index].value;
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      //padding: EdgeInsets.only(bottom: 5, top: 20, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(            
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
             decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black)
              ),
            child: Row(children: <Widget>[
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    child: DropdownButton(isExpanded: true, icon: Icon(Icons.arrow_drop_down, color:Colors.grey), items: itemsList, value: selectedItem, disabledHint: Text('$selectedItem', style: TextStyle(fontSize: 16, color: Colors.grey)), isDense: true, onChanged: (value) {                
                      setState(() {
                        selectedItem = value as String;
                      });
                      widget.onChanged(value as String);                  
                    }),
                  ),
                ) 
              )
            ]),
          )
        ],
      ),
    );
  }
}