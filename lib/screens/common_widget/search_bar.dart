import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final bool loading;

  const SearchBar({Key key, this.onSearch, this.loading=false}) : super(key: key);
  
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String query;  
  @override
  void initState() {
    super.initState();
    query = "";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 2),
        color: Color(0xff0000),
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 5),
                Expanded(
                  child: TextFormField(
                    onChanged: (String value) {
                      query = value;
                      widget.onSearch(query);
                    },
                    style: TextStyle(color: Colors.black, fontFamily: 'lato-Regular', fontSize: 14),
                    decoration: InputDecoration.collapsed(hintText: 'Search message', hintStyle: TextStyle(color: Color(0xff939094), fontFamily: 'Lato-Regular', fontSize: 14))
                  ),
                ),

               widget.loading ? SizedBox( height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 3, valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[500]))) : Container(),

              ],
            ),
            Container(
              height: 2,
              color: Color(0xFF939094),
            )
          ],
        ),
      );
  }
}