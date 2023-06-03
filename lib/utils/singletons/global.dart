import 'package:flutter_webrtc/webrtc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/models/user_tbl.dart';
import 'package:social_app/screens/room/signaling.dart';

class Global {

  static const bool TEST_MODE = true;
  static const bool OFFLINE_MODE = false;
  static Gender gender;
  static String email;
  static Signaling signaling;
  //static bool peerIsOnline = false;
  static bool isCalling = false;
  static RTCVideoRenderer localRenderer = new RTCVideoRenderer();
  static RTCVideoRenderer remoteRenderer = new RTCVideoRenderer();
  static List<dynamic> peers;
  static String selfId;
  static String serverIP = '192.168.208.82';


  static hideSoftKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  
  static void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Color.fromRGBO(30, 30, 30, 0.6),
        textColor: Colors.white
    );
  }

  static void connect() async {
    if (signaling == null) {
      signaling = new Signaling(serverIP)..connect(email);
      //isOnline = true;

      signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
            // this.setState(() {
               isCalling = true;
            // });
            break;
          case SignalingState.CallStateBye:
            //this.setState(() {
              localRenderer.srcObject = null;
              remoteRenderer.srcObject = null;
              isCalling = false;
            //});
            break;
          case SignalingState.CallStateInvite:
          case SignalingState.CallStateConnected:
          case SignalingState.CallStateRinging:
          case SignalingState.ConnectionClosed:
          case SignalingState.ConnectionError:
          case SignalingState.ConnectionOpen:
            break;
        }
      };

      signaling.onPeersUpdate = ((event) async {
        //this.setState(() {
          selfId = event['self'];
          peers = event['peers'];
        //});
        // peerIdr = await _invitePeer(widget.chat.opponentName, false);
        // this.setState((){
        // });
      });

      signaling.onLocalStream = ((stream) {
        localRenderer.srcObject = stream;
      });

      signaling.onAddRemoteStream = ((stream) {
        remoteRenderer.srcObject = stream;
      });

      signaling.onRemoveRemoteStream = ((stream) {
        remoteRenderer.srcObject = null;
      });
    }
  }

  static Future<void> freeSignaling() async {
    if (signaling != null ) signaling.close();
    // if(localRenderer != null) await localRenderer.dispose();
    // if(remoteRenderer != null) await remoteRenderer.dispose();
  }

  static bool getPeerOnlineState(String peerName ){
    
    if(Global.peers == null){
      Global.showToastMessage('Video Chat Server does not work perfectly.');
    } else {
      for(int i=0; i<Global.peers.length; i++){
        var peer = Global.peers[i];
        if(peerName==peer['name']) {
          return true;
        }
      }
    }
    return false;    
  }
}