import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/firebase/base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/models/user_tbl.dart';

class AuthManage {
  static UserTbl curUser;
  
  // Log in the account with email and password
  static Future<dynamic> signIn(String email, String password) async {
    var res = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password); 
    print('Your are logged in with email = ${res.user.email}');
    return res.user;
  }

  // Get Current Firebase Authenticated User ID
  static Future<String> getFirebaseUserId() async {
    final FirebaseUser user = await auth.currentUser();
    return user.uid;
  }

  // Register the account with email and password
  static Future<bool> signUp(String email, String confPassword, UserTbl user ) async {
    var res = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: confPassword); //print('Your are signOuted in with email = ${res.user.email}');
    if(res == null) return false;
    user.id = await getFirebaseUserId();
    user.created = Timestamp.fromDate(new DateTime.now()).seconds;
    userTbl.add(user.toJson());
    return true;
  }
  
  // Get User Information
  static Future<UserTbl> getUserInfo() async {
    String uid = await AuthManage.getFirebaseUserId();
    QuerySnapshot querySnapshot = await userTbl.where('id', isEqualTo: uid).getDocuments();
    if(querySnapshot.documents.length == 0) return null;
    var _userJson = querySnapshot.documents[0].data;
    
    curUser = UserTbl.fromJson(_userJson);
    return curUser;
  }

  // Get Peer Information
  static Future<UserTbl> getPeerInfo(String peerId) async {
    //String uid = await AuthManage.getFirebaseUserId();
    QuerySnapshot querySnapshot = await userTbl.where('id', isEqualTo: peerId).getDocuments();
    if(querySnapshot.documents.length == 0) return null;
    var _userJson = querySnapshot.documents[0].data;
    
    UserTbl peer = UserTbl.fromJson(_userJson);
    return peer;
  }

}
