import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  
  final String title;
  final String subTitle;
  final BuildContext context;
  final VoidCallback onConfirm;
  ConfirmDialog(this.context, {this.onConfirm, this.subTitle = 'Are you sure you want to delete ?', this.title  = 'DELETE ITEM'});
  
  show() {
    showDialog(
        context: context,
        builder: (context) => Container(
            child: this
        )
    );
  }
  
  dismiss() {
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          color: Color(0x99FFFFFF),
          child: Center(
            child: Container(
              color: Theme.of(context).primaryColor,
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10, bottom: 5),                    
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            dismiss();
                          },
                          child: Image.asset('assets/images/icon_cross.png', width: 20, fit: BoxFit.fitWidth),
                        ),
                      ),
                    ),
                  ),   
                  Text(title, style: TextStyle(fontFamily: 'Nexabold', fontSize: 20, color: Colors.white)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(subTitle, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Nexalight', fontSize: 20, color: Colors.white) ),
                  ),
                  
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.only(left: 15, right: 5, bottom: 15),
                          child: InkWell(
                            onTap: () {
                              if(onConfirm != null) {
                                onConfirm();
                              }
                              dismiss();
                            },
                            child: Container(
                              height: 45,                        
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                border: Border.all(color: Colors.black, width: 1.0)
                              ),
                              child: Center(
                                child: Text('YES', style: TextStyle(fontFamily: 'Nexabold', fontSize: 18, height: 1),),
                              ),
                            ),
                          ),
                        ),
                      ), 
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.only(left: 5, right: 15, bottom: 15),
                          child: InkWell(
                            onTap: () {
                              dismiss();
                            },
                            child: Container(
                              height: 45,                        
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                border: Border.all(color: Colors.black, width: 1.0)
                              ),
                              child: Center(
                                child: Text('NO', style: TextStyle(fontFamily: 'Nexabold', fontSize: 18, height: 1),),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}