import 'package:flutter/material.dart';
import 'package:social_app/screens/common_widget/bottom_region.dart';
import 'package:social_app/screens/common_widget/custom_button.dart';
import 'package:social_app/screens/common_widget/input_text.dart';
import 'package:social_app/screens/search/age_slider.dart';
import 'package:social_app/screens/search/body_type_checkboxs.dart';
import 'package:social_app/screens/search/dropdown_list.dart';
import 'package:social_app/screens/search/expandable_panel.dart';
import 'package:social_app/screens/search/saved_searches.dart';

class FilterScreen extends StatefulWidget {
  @override
  FilterScreenState createState() => FilterScreenState();
}

class FilterScreenState extends State<FilterScreen> {
  List<String> distanceList = [];

  @override
  void initState() {
    distanceList.add('Distance');
    distanceList.add('Height');
    distanceList.add('Width');

    super.initState();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4a414e),
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            SizedBox(width: 15,),
            InkWell(onTap: () {
              Navigator.pop(context);
              setState(() {
                //showDropdownList = true;
              });
            }, child: Text('Cancel', style: TextStyle(color: Color(0xffffffff), fontFamily: 'Lato-Regular', fontSize: 15))),
            Spacer(),
            InkWell(onTap: () {
              setState(() {
                //showDropdownList = true;
              });
            }, child: Text('Filter', style: TextStyle(color: Color(0xffffffff), fontFamily: 'Lato-Regular', fontSize: 16, fontWeight: FontWeight.bold),)),
            Spacer(),
            InkWell(onTap: () {
              setState(() {
                //showDropdownList = true;
              });
            }, child: Text('Reset', style: TextStyle(color: Color(0xffffffff), fontFamily: 'Lato-Regular', fontSize: 15))),
            SizedBox(width: 15,),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          child:Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(7),
                child: Column(
                  //shrinkWrap: true,
                  children: <Widget>[

                    ExpandablePanel(title: 'Saved searches',child: SavedSearches(),),
                    SizedBox(height: 10,),

                    Row(
                      children: <Widget>[
                        SizedBox(width: 12,),
                        Icon(Icons.fiber_manual_record, color: Color(0xfff4b639), size: 23,),
                        SizedBox(width: 10,),
                        Text('Profile text', style: TextStyle(color: Color(0xff423547), fontFamily: 'Lato-Regular', fontSize: 19, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 10, bottom: 10),
                      child: InputText(hint: 'e.g., John Dae, Shopping',fontFamily: 'Lato-Regular', fSize: 14, textAlign: TextAlign.left,),
                    ),
                    SizedBox(height: 12,),
                    
                    Row(
                      children: <Widget>[
                        SizedBox(width: 12,),
                        Icon(Icons.fiber_manual_record, color: Color(0xfff4b639), size: 23,),
                        SizedBox(width: 10,),
                        Text('Location', style: TextStyle(color: Color(0xff423547), fontFamily: 'Lato-Regular', fontSize: 19, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 12,),
                        Image.asset('assets/images/other-location-icon.png',height: 23, width: 23,),
                        SizedBox(width: 10,),
                        Text('Other location', style: TextStyle(color: Color(0xff423547), fontFamily: 'Lato-Regular', fontSize: 14, )),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.all(15),
                      child: DropDownList(itemList: distanceList, labelColor: Color(0xff99969a), fontSize: 14,),
                    ),

                    ExpandablePanel(title: 'Body type',child: BodyTypeCheckBoxs(),),
                    SizedBox(height: 10,),

                    ExpandablePanel(title: 'Age',child: AgeSlider(),),
                    SizedBox(height: 10,),

                    ExpandablePanel(title: 'Ethnicity',child: Text('Here the Widget must be added !!!!'),),
                    SizedBox(height: 10,),

                    ExpandablePanel(title: 'Height',child: Text('Here the Widget must be added !!!!'),),
                    SizedBox(height: 10,),

                    ExpandablePanel(title: 'Eye Color',child: Text('Here the Widget must be added !!!!'),),
                    SizedBox(height: 10,),

                    ExpandablePanel(title: 'Hair Color',child: Text('Here the Widget must be added !!!!'),),
                    SizedBox(height: 10,),

                    ExpandablePanel(title: 'Smoking',child: Text('Here the Widget must be added !!!!')),
                    SizedBox(height: 10,),

                    ExpandablePanel(title: 'Relationship',child: Text('Here the Widget must be added !!!!'),),
                    SizedBox(height: 10,),

                    ExpandablePanel(title: 'Education',child: Text('Here the Widget must be added !!!!'),),
                    SizedBox(height: 10,),

                    ExpandablePanel(title: 'Children',child: Text('Here the Widget must be added !!!!'),),
                    SizedBox(height: 10,),

                    ExpandablePanel(title: 'Language',child: Text('Here the Widget must be added !!!!'),),
                    SizedBox(height: 10,),

                    ExpandablePanel(title: 'Expectation',child: Text('Here the Widget must be added !!!!'),),
                    SizedBox(height: 10,),
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 10),
                      child: CustomButton(
                        text: 'SEARCH',
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: CustomButton(
                        text: 'RESET',
                      ),
                    ),                
                  ],
                ),
              ),
              BottomRegion()
            ],
            
          )
        ),
      ),
      
    );
  }
}

