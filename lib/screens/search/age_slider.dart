import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class AgeSlider extends StatefulWidget {
  @override
  _AgeSliderState createState() => _AgeSliderState();
}

class _AgeSliderState extends State<AgeSlider> {

  double minPrice = 18;
  double maxPrice = 60;
  double _lowerValue = 18;
  double _upperValue = 60;
  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FlutterSlider(
          handlerHeight: 19,
          handlerWidth: 19,
          values: [18, 60],
          rangeSlider: true,
          tooltip: FlutterSliderTooltip(
            disabled: true
          ),
          trackBar: FlutterSliderTrackBar(
            activeTrackBar: BoxDecoration(
              color: Color(0xFF423547),
            ),
            activeTrackBarHeight: 1.0,
            inactiveTrackBar: BoxDecoration(
              color: Colors.grey
            ),
            inactiveTrackBarHeight: 1.0
          ),
          touchSize: 10,
          max: 60,
          min: 18,
          handler: FlutterSliderHandler(            
            child: Image.asset('assets/images/age-thumb-icon.png')
          ),
          rightHandler: FlutterSliderHandler(
            child: Image.asset('assets/images/age-thumb-icon.png')
          ),
          onDragging: (_, lowerValue, upperValue) {
            setState(() {
            _lowerValue = lowerValue;
            _upperValue = upperValue;

            });
          },
        ),
         const SizedBox(height: 5),
          Row(
            children: <Widget>[
              const SizedBox(width: 10),
              Text(_lowerValue.ceil().toString(), style: TextStyle(color: Color(0xFF423547), fontFamily: 'Lato-Regular', fontSize: 15),),
              Spacer(),
              Text(_upperValue.ceil().toString(), style: TextStyle(color: Color(0xFF423547),  fontFamily: 'Lato-Regular', fontSize: 15)),
              Icon(Icons.add, size: 15,),
              const SizedBox(width: 5)
            ],
          ),
      ],
    );
  }
}