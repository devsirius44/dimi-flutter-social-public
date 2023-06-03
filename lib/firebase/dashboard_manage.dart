import 'package:intl/intl.dart';
import 'package:social_app/firebase/auth_manage.dart';
import 'package:social_app/firebase/base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/appearance_info.dart';
import 'package:social_app/models/basic_info.dart';
import 'package:social_app/models/description_info.dart';
import 'package:social_app/models/favorite_info.dart';
import 'package:social_app/models/new_member.dart';
import 'package:social_app/models/personal_info.dart';
import 'package:social_app/models/photo_info.dart';
import 'package:social_app/models/user_detail.dart';
import 'package:social_app/models/user_tbl.dart';


class DashboardManage {
  static List<String> publicPhotosUserDetail = [];
  static List<String> privatePhotosUserDetail = [];
  static UserDetail usrDetail; 

  // Get the memberList for all members beside self
  static Future<List<NewMember>> getMemberList(List<String> inList, String sid) async {
    List<NewMember> resList = [];
    
    try {
      for(var index = 0; index < inList.length; index++ ){
        String uid = inList[index];
        if(uid == sid) continue;

        var documentRef = await basicInfo.where('id', isEqualTo: uid).getDocuments();
        String uname = 'Unknown';
        String ubirthday = 'Unknown';
        String ulocation = 'Unknown';
        String uphotourl = 'Unknown';
        int uage = 0;
        bool online = true;  // Must be updated after. 

        if(documentRef.documents.length != 0) {
          BasicInfo bInfo = BasicInfo.fromJson(documentRef.documents[0].data);
          uname = bInfo.name;
          ubirthday = bInfo.birthday;
          uage = getAgeFromBirthday(ubirthday);
          ulocation = bInfo.curlocation;
          uphotourl = bInfo.dashphotourl;
        }

        var documentRef1 = await userTbl.where('id', isEqualTo: uid).getDocuments();
        String ugender = 'Unknown';
        if(documentRef1.documents.length != 0) {
          UserTbl suser = UserTbl.fromJson(documentRef1.documents[0].data);
          if(suser.gender == Gender.MALE) ugender = 'Male';
          else ugender = 'Female'; 
        }

        if((uname != 'Unknown') && (uage != 0) && (ulocation != 'Unknown') && (uphotourl != 'Unknown')){
          NewMember newMember = NewMember(uid, uname, ugender, uage, ulocation, uphotourl, online);
          resList.add(newMember);
        }
      }
      return resList; 
    } catch (e) {
      print(e.toString());
      return [];
    }

  } 
  
  // Get the newest members from database
  static Future<List<NewMember>> getNewestMembers() async {
    int limitUsers = 10;
    List<NewMember> mList = [];
    List<String> idList = [];
    try {
      QuerySnapshot querySnapshot =  await userTbl.orderBy('created', descending: true).limit(limitUsers ).getDocuments();
      List<UserTbl> uList = querySnapshot.documents.map((doc)=>UserTbl.fromJson(doc.data)).toList();
      String sid = await AuthManage.getFirebaseUserId();
      
      for(var index = 0; index < uList.length; index++ ) {
        String uid = uList[index].id; 
        idList.add(uid);
      }

      mList  = await getMemberList(idList, sid);

      return mList;
    } catch (e) {
      print(e.toString());
      return [];    
    }
  }

  // Get the viewedMe members from database
  static Future<List<NewMember>> getViewedMeMembers() async {
    int limitUsers = 5;
    List<NewMember> mList = [];  
    List<String> idList = [];
    try {
      String userId = await AuthManage.getFirebaseUserId();
      QuerySnapshot querySnapshot =  await favoriteInfo
        .where('secondId', isEqualTo: userId)
        .orderBy('viewedTime', descending: true).limit(limitUsers ).getDocuments();
      List<FavoriteInfo> uList = querySnapshot.documents.map((doc)=>FavoriteInfo.fromJson(doc.data)).toList();
      //String sid = await AuthManage.getFirebaseUserId();
      for(var index = 0; index < uList.length; index++ ) {
        String uid = uList[index].firstId; 
        idList.add(uid);
      }
      mList  = await getMemberList(idList, 'sid');
      return mList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
  
  // Get the favorite members from database
  static Future<List<NewMember>> getFavoritedMembers() async {
    int limitUsers = 5;
    List<NewMember> mList = [];  
    List<String> idList = [];
    try {
      String firstId = await AuthManage.getFirebaseUserId();
      QuerySnapshot querySnapshot =  await favoriteInfo
        .where('firstId', isEqualTo: firstId)
        .orderBy('favoritedTime', descending: true).limit(limitUsers ).getDocuments();
      List<FavoriteInfo> uList = querySnapshot.documents.map((doc)=>FavoriteInfo.fromJson(doc.data)).toList();
      //String sid = await AuthManage.getFirebaseUserId();
      for(var index = 0; index < uList.length; index++ ) {
        String uid = uList[index].secondId; 
        idList.add(uid);
      }
      mList  = await getMemberList(idList, 'sid');
      return mList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Get the favoritedMe members recently (at lest within 30 hours)
  static Future<List<NewMember>> getLastFavoritedMeMembers() async {
    int limitUsers = 20;
    List<NewMember> mList = [];  
    List<String> idList = [];
    int curTime = Timestamp.fromDate(new DateTime.now()).seconds;
    int limitTime = 108000;  // 30 hours
    try {
      String userId = await AuthManage.getFirebaseUserId();
      QuerySnapshot querySnapshot =  await favoriteInfo
        .where('secondId', isEqualTo: userId)
        .orderBy('favoritedTime', descending: true).limit(limitUsers ).getDocuments();
      List<FavoriteInfo> uList = querySnapshot.documents.map((doc)=>FavoriteInfo.fromJson(doc.data)).toList();
      //String sid = await AuthManage.getFirebaseUserId();
      int curTime = Timestamp.fromDate(new DateTime.now()).seconds;

      for(var index = 0; index < uList.length; index++ ) {
        int diffTime = curTime - uList[index].favoritedTime;
        if( diffTime < 108000){
          String uid = uList[index].firstId; 
          idList.add(uid);
        }
      }
      mList  = await getMemberList(idList, 'sid');
      return mList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Get the favoritedMe members from database
  static Future<List<NewMember>> getFavoritedMeMembers() async {
    int limitUsers = 5;
    List<NewMember> mList = [];  
    List<String> idList = [];
    try {
      String userId = await AuthManage.getFirebaseUserId();
      QuerySnapshot querySnapshot =  await favoriteInfo
        .where('secondId', isEqualTo: userId)
        .orderBy('favoritedTime', descending: true).limit(limitUsers ).getDocuments();
      List<FavoriteInfo> uList = querySnapshot.documents.map((doc)=>FavoriteInfo.fromJson(doc.data)).toList();
      //String sid = await AuthManage.getFirebaseUserId();
      for(var index = 0; index < uList.length; index++ ) {
        String uid = uList[index].firstId; 
        idList.add(uid);
      }
      mList  = await getMemberList(idList, 'sid');
      return mList;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Get the SearchHome members by filter contents
  static Future<List<NewMember>> getSearchHomeMembers (bool maleFlag, bool femaleFlag, bool viewedFlag, bool unviewFlag,
    bool viewMeFlag, bool photoFlag, bool favoritedFlag, bool favorMeFlag, bool premiumFlag, bool backgCheckFlag, bool colledgeFlag) async {

    List<NewMember> mList = [];
    List<String> idList1 = [];
    List<String> idList2 = [];
    List<String> idList3 = [];
    List<String> idList4 = [];

    try {
      Query query1 = userTbl;
      if(maleFlag) {
        if(!femaleFlag) {
          query1 = query1.where('gender', isEqualTo: 'Male');
        }      
      } else if(femaleFlag) {
        query1 = query1.where('gender', isEqualTo: 'Female');
      }     
      // if(premiumFlag) {
      //   query1 = query1.where('premium', isEqualTo: 'true');
      // }
      // if(backgCheckFlag) {
      //   query1 = query1.where('backcheck', isEqualTo: 'true');
      // }
      // if(colledgeFlag) {
      //   query1 = query1.where('college', isEqualTo: 'true');
      // }
      QuerySnapshot querySnapshot =  await query1.getDocuments();
      List<UserTbl> uList = querySnapshot.documents.map((doc)=>UserTbl.fromJson(doc.data)).toList();
      for(var index = 0; index < uList.length; index++ ) {
        String uid = uList[index].id; 
        idList1.add(uid);

      }

      QuerySnapshot querySnapshotAll =  await basicInfo.getDocuments();
      List<BasicInfo> bListAll = querySnapshotAll.documents.map((doc)=>BasicInfo.fromJson(doc.data)).toList();
      List<String> idListAvatar = [];

      for(var index = 0; index < bListAll.length; index++ ) {
        String bid = bListAll[index].id;
        if(bListAll[index].dashphotourl.contains('avatar')) {
          idListAvatar.add(bid);
        } else {
          idList2.add(bid);
        }
      }
 
      if(!photoFlag) {
        idList2 = idListAvatar;
      } 
      
      // for checkbox "vewed", "unviewed", "favorited"      
      String curId = await AuthManage.getFirebaseUserId();
      Query query3 = favoriteInfo.where('firstId', isEqualTo: curId);
      if(viewedFlag) {
        if(!unviewFlag) {
          query3 = query3.where('viewed', isEqualTo: true);
        }
      } else if(unviewFlag) {
        query3 = query3.where('viewed', isEqualTo: false);
      } else if(favoritedFlag) {
        query3 = query3.where('favorited', isEqualTo: true);
      }

      QuerySnapshot querySnapshot3 =  await query3.getDocuments();
      List<FavoriteInfo> fList = querySnapshot3.documents.map((doc)=>FavoriteInfo.fromJson(doc.data)).toList();
      for(var index = 0; index < fList.length; index++ ) {
        String fid = fList[index].secondId; 
        idList3.add(fid);
      }

      Query query4 = favoriteInfo.where('secondId', isEqualTo: curId);
      if(viewMeFlag) {
        query4 = query4.where('viewed', isEqualTo: true);
      } else if(favorMeFlag) {
        query4 = query4.where('favorited', isEqualTo: true);
      }
      QuerySnapshot querySnapshot4 =  await query4.getDocuments();
      List<FavoriteInfo> fListR = querySnapshot4.documents.map((doc)=>FavoriteInfo.fromJson(doc.data)).toList();
      for(var index = 0; index < fListR.length; index++ ) {
        String fid = fListR[index].firstId; 
        idList4.add(fid);
      }

      // // remove duplicate elements in two lists
      // for (int i = 0; i < idList1.length; i++) {
      //   for (int j = 0; j < idList2.length; j++) {
      //     if(idList1[i] == idList2[j]) {
      //       print('object');
      //       idList2.remove(idList2[j]);
      //     }
      //   }
      //   for (int j = 0; j < idList3.length; j++) {
      //     if(idList1[i] == idList3[j]) {
      //       idList3.remove(idList3[j]);
      //     }
      //   }
      //   for (int j = 0; j < idList4.length; j++) {
      //     if(idList1[i] == idList4[j]) {
      //       idList4.remove(idList4[j]);
      //     }
      //   }
      // }

      // // merge the all elements in Lists
      // for (int i = 0; i < idList2.length; i++){
      //   idList1.add(idList2[i]);
      // }
      // for (int i = 0; i < idList3.length; i++){
      //   idList1.add(idList3[i]);
      // }
      // for(int i = 0; i < idList4.length; i++){
      //   idList1.add(idList4[i]);
      // }

      // mList  = await getMemberList(idList1, curId);

      // get the same elements between gender and photo tables
      List<String> idListF = [];
      for (int i = 0; i < idList1.length; i++) {
        for (int j = 0; j < idList2.length; j++) {
          if(idList1[i] == idList2[j]) {
            idListF.add(idList1[i]);
          }
        }
      }
      // for view&favorite, get the same elements between idListF and view&favorite tables  
      List<String> idListS = [];
      for (int i = 0; i < idListF.length; i++) {
        for (int j = 0; j < idList3.length; j++) {
          if(idListF[i] == idList3[j]) {
            idListS.add(idListF[i]);
          }
        }
      }
      
      // for viewedMe&favoriteddMe, get the same elements between idListF and viewMe&favoriteMe tables
      List<String> idListT = [];
      for (int i = 0; i < idListF.length; i++) {
        for (int j = 0; j < idList4.length; j++) {
          if(idListF[i] == idList3[j]) {
            idListT.add(idListF[i]);
          }
        }
      }
      
      
      for (int i = 0; i < idListS.length; i++) {
        for (int j = 0; j < idListT.length; j++) {
          if(idListS[i] == idListT[j]) {
            idListT.remove(idListT[i]);   // remove the same element
          }
        }
      }
      for(int i = 0; i < idListT.length; i++ ){
        idListS.add(idListT[i]);
      }

      mList  = await getMemberList(idListS, curId);
      return mList;
    } catch (e) {
      print(e.toString());
      return []; 
    }
  }

  static int getAgeFromBirthday(String birthday){
    DateFormat newFormat = DateFormat('MM-dd-yyyy');
    DateTime bDate = newFormat.parse(birthday);
    DateTime curDate = DateTime.now();
    int age = curDate.year - bDate.year;
    return age;
  }

  static Future<void> downlaodUserDetails(String uid) async {
    // get pub/private photos
    publicPhotosUserDetail.clear();
    privatePhotosUserDetail.clear();

    try {
      var documnetRef = await photoInfo.where('id', isEqualTo: uid).getDocuments();
      for(var index = 0; index < documnetRef.documents.length; index++){
        PhotoInfo pInfo = PhotoInfo.fromJson(documnetRef.documents[index].data);
        if(pInfo.publicflg){
          publicPhotosUserDetail.add(pInfo.photourl);
        }else {
          privatePhotosUserDetail.add(pInfo.photourl);
        }
      }
      // get data from the desdriptionInfo
      String aboutme = 'Unknown';
      String wilookfor = 'Unknown';
      documnetRef = await descriptionInfo.where('id', isEqualTo: uid).getDocuments();
      for(var index = 0; index < documnetRef.documents.length; index++){
        DescriptionInfo desInfo = DescriptionInfo.fromJson(documnetRef.documents[index].data);
        aboutme = desInfo.aboutme;
        wilookfor = desInfo.wilookfor;       
      }
      // get some data from the basicInfo 
      String heading = 'Unknown';
      String lookfor = 'Unknown';
      documnetRef = await basicInfo.where('id', isEqualTo: uid).getDocuments();
      for(var index = 0; index < documnetRef.documents.length; index++){
        BasicInfo bInfo = BasicInfo.fromJson(documnetRef.documents[index].data);
        heading = bInfo.heading;
        lookfor = bInfo.lookfor;       
      }
      // get data from the appearanceInfo
      String lifestyle = 'Unknown';


      String height = 'Unknown';
      String bodytype = 'Unknown';
      String ethnicity = 'Unknown';
      String haircolor = 'Unknown';
      String eyecolor = 'Unknown';
      documnetRef = await appearanceInfo.where('id', isEqualTo: uid).getDocuments();
      for(var index = 0; index < documnetRef.documents.length; index++){
        AppearanceInfo apInfo = AppearanceInfo.fromJson(documnetRef.documents[index].data);
        height = apInfo.height;
        bodytype = apInfo.bodytype;
        ethnicity = apInfo.ethnicity;
        haircolor = apInfo.haircolor;
        eyecolor = apInfo.eyecolor;
      }
      // get data from the personalInfo
      String education = 'Unknown';
      String occupation = 'Unknown';
      String relationship = 'Unknown';
      String children = 'Unknown';
      String smokes = 'Unknown';
      String drinks = 'Unknown';
      documnetRef = await personalInfo.where('id', isEqualTo: uid).getDocuments();
      for(var index = 0; index < documnetRef.documents.length; index++){
        PersonalInfo psInfo = PersonalInfo.fromJson(documnetRef.documents[index].data);
        education = psInfo.education;
        occupation = psInfo.education;
        relationship = psInfo.relationship;
        children = psInfo.children;
        smokes = psInfo.smoking;
        drinks = psInfo.drinking;
      }
      usrDetail = UserDetail(heading, aboutme, wilookfor, lookfor, lifestyle, height, bodytype,
            ethnicity, haircolor, eyecolor, education, occupation, relationship, children, smokes, drinks);

    } catch (e) {
      print(e.toString());
    }
  }

  static List<String> getPublicPhotos(){
    return publicPhotosUserDetail;
  }

  static List<String> getPrivatePhotos(){
    return privatePhotosUserDetail;
  }

  static UserDetail getUserDetails(){
    return usrDetail;
  } 

  // register favorite member to FavoriteInfo
  static Future<bool> registerFavoriteMember(String secondId) async {
    try {
      String firstId = await AuthManage.getFirebaseUserId();
      var documentRef = await favoriteInfo
        .where('firstId', isEqualTo: firstId)
        .where('secondId', isEqualTo: secondId)
        .getDocuments();
      var key = documentRef.documents[0].documentID;
      int curTime = Timestamp.fromDate(new DateTime.now()).seconds;
      await favoriteInfo.document(key).updateData({'favorited': true, 'favoritedTime': curTime});

    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  // register viewed member to FavoriteInfo
  static Future<bool> registerViewMember(String secondId) async {
    try {
      String firstId = await AuthManage.getFirebaseUserId();
      var documentRef = await favoriteInfo
        .where('firstId', isEqualTo: firstId)
        .where('secondId', isEqualTo: secondId)
        .getDocuments();
      int curTime = Timestamp.fromDate(new DateTime.now()).seconds;
      if(documentRef.documents.length == 0){
        FavoriteInfo faInfo = FavoriteInfo(firstId, secondId, true, false, curTime, 0); 
        await favoriteInfo.add(faInfo.toJson());
      }else {
        var key = documentRef.documents[0].documentID;
        await favoriteInfo.document(key).updateData({'viewed': true, 'viewedTime': curTime});
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  // get some data from the basicInfo 
  static Future<BasicInfo> getBasicInfo( String userId) async {
    BasicInfo bInfo;
    try {
      var documnetRef = await basicInfo.where('id', isEqualTo: userId).getDocuments();
      for(var index = 0; index < documnetRef.documents.length; index++){
        bInfo = BasicInfo.fromJson(documnetRef.documents[index].data);
      }
      return bInfo;
    } catch (e){
      print(e.toString());
      return null;
    }
  }

}