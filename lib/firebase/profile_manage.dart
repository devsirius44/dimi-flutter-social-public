import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_app/firebase/auth_manage.dart';
import 'package:social_app/firebase/base.dart';
import 'package:social_app/models/appearance_info.dart';
import 'package:social_app/models/basic_info.dart';
import 'package:social_app/models/description_info.dart';
import 'package:social_app/models/financial_info.dart';
import 'package:social_app/models/personal_info.dart';
import 'package:social_app/models/photo_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_app/models/user_tbl.dart';
import 'package:social_app/utils/helpers/date_helper.dart';
import 'package:dio/dio.dart';
//import 'package:network_to_file_image/network_to_file_image.dart';

class ProfileManage {
  // Save the BasicInfo to database
  static Future<bool> saveBasicInfo(BasicInfo bInfo, FinancialInfo fInfo) async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      bInfo.id = uid;
      fInfo.id  = uid;
      // for the Basic Info collection
      var documentRef = await basicInfo.where('id', isEqualTo: uid).getDocuments();
      if(documentRef.documents.length == 0) {
        await basicInfo.add(bInfo.toJson());
      } else {
        var key = documentRef.documents[0].documentID;
        await basicInfo.document(key).updateData({'name': bInfo.name, 'heading': bInfo.heading,'birthday': bInfo.birthday, 'lookfor': bInfo.lookfor, 'dashphotourl': bInfo.dashphotourl});
      }
      // for the Financial Info collection
      documentRef = await financialInfo.where('id', isEqualTo: uid).getDocuments();
      if(documentRef.documents.length == 0) {
        await financialInfo.add(fInfo.toJson());
      } else {
        var key = documentRef.documents[0].documentID;
        await financialInfo.document(key).updateData({'lifestyle': fInfo.lifestyle, 'networth': fInfo.networth, 'annuincome': fInfo.annuincome});
      }
    } catch (e) {
      print(e.toString());
      return false;  
    }
    return true;
  }

  // Save the Personal Info to database
  static Future<bool> savePersonalInfo(AppearanceInfo aInfo, PersonalInfo pInfo) async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      aInfo.id = uid;
      pInfo.id  = uid;
      // for the Appearance Info collection
      var documentRef = await appearanceInfo.where('id', isEqualTo: uid).getDocuments();
      if(documentRef.documents.length == 0) {
        await appearanceInfo.add(aInfo.toJson());
      } else {
        var key = documentRef.documents[0].documentID;
        await appearanceInfo.document(key).updateData({'height': aInfo.height, 'bodytype': aInfo.bodytype, 'ethnicity': aInfo.ethnicity, 'eyecolor': aInfo.eyecolor, 'haircolor': aInfo.haircolor});
      }
      // for the Personal Info collection
      documentRef = await personalInfo.where('id', isEqualTo: uid).getDocuments();
      if(documentRef.documents.length == 0) {
        await personalInfo.add(pInfo.toJson());
      } else {
        var key = documentRef.documents[0].documentID;
        await personalInfo.document(key).updateData({'occupation': pInfo.occupation, 'education': pInfo.education, 'relationship': pInfo.relationship, 'children': pInfo.children, 'smoking': pInfo.smoking, 'drinking': pInfo.drinking, 'language': pInfo.language});
      }
    } catch (e) {
      print(e.toString());
      return false;  
    }
    return true;
  }
  
  // Save the Location Info to database
  static Future<bool> saveLocationInfo(String curLocation) async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      var documentRef = await basicInfo.where('id', isEqualTo: uid).getDocuments();
      if(documentRef.documents.length == 0){
        BasicInfo bInfo = BasicInfo(uid, 'Unknown', 'Unknown', 'Unknown','Unknown', curLocation, 'Unknown'); 
        await basicInfo.add(bInfo.toJson());
      }else {
        var key = documentRef.documents[0].documentID;
        await basicInfo.document(key).updateData({'curlocation': curLocation});
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  // Save the Description Info to database
  static Future<bool> saveDescriptionInfo(DescriptionInfo dInfo) async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      dInfo.id = uid;
      var documentRef = await descriptionInfo.where('id', isEqualTo: uid).getDocuments();
      if(documentRef.documents.length == 0){
        await descriptionInfo.add(dInfo.toJson());
      } else {
        var key = documentRef.documents[0].documentID;
        await descriptionInfo.document(key).updateData({'aboutme': dInfo.aboutme, 'wilookfor': dInfo.wilookfor});
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  // Save the avatar to database
  static Future<bool> saveAvatarToBasicInfo(String avatarUrl) async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      var documentRef = await basicInfo.where('id', isEqualTo: uid).getDocuments();
      if(documentRef.documents.length == 0){
        BasicInfo bInfo = BasicInfo(uid, 'Unknown', 'Unknown', 'Unknown','Unknown', 'Unknown', avatarUrl); 
        await basicInfo.add(bInfo.toJson());
      }else {
        var key = documentRef.documents[0].documentID;
        await basicInfo.document(key).updateData({'dashphotourl': avatarUrl});
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  // Save the Photo Info to database
  static Future<bool> savePhotoInfo(PhotoInfo pInfo) async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      pInfo.id = uid;
      await photoInfo.add(pInfo.toJson());

    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  // Upload the Photo and get it's URL
  static Future<String> getUploadedPhotoUrl(File photoFile) async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      QuerySnapshot querySnapshot =
          await userTbl.where('id', isEqualTo: uid).getDocuments();
      if (querySnapshot.documents.length == 0) return '';
      var _userJson = querySnapshot.documents[0].data;
      UserTbl user = UserTbl.fromJson(_userJson);
      print(user.email);

      String fileName = user.email +
          '/' +
          basenameWithoutExtension(photoFile.path) +
          Random().nextInt(10000).toString() +
          extension(photoFile.path);

      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(photoFile);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      final String dUrl = (await taskSnapshot.ref.getDownloadURL());

      return dUrl;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  static Future<File> getFileFromAsset(String path) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    ByteData data = await rootBundle.load(path);
    File file = File(tempPath + path.split('/').last);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await file.writeAsBytes(bytes);
    return file;
  }
  
  static Future<String> download(String imageUrl, String email) async {
    Dio dio = Dio();
    String savePath = '';
    try {
      var dir = await getApplicationDocumentsDirectory();
      savePath = dir.path + '/${email}_image.jpg';
      //File file = File(savePath);
      await dio.download(imageUrl, savePath);
      return savePath;      

      //File myFile = File(savePath);
      //NetworkToFileImage ntfImage = NetworkToFileImage(url: imageUrl, file: myFile);
      //return ntfImage.file.path;

    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  static Future<String> createAvatar(String email, Gender gender, String avatarUrl) async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    String documentPath = documentDir.path;
    String avatarPath;

    if(avatarUrl =='' || avatarUrl =='Unknown'){
      avatarPath = gender == Gender.MALE ? 'assets/images/male-avatar.png' : 'assets/images/female-avatar.png';
      ByteData data = await rootBundle.load(avatarPath);
      Directory dir = await Directory(documentPath + '/$email').create();
      File file = File(dir.path + '/' + '${getDateStringWithFormat(dateTime: DateTime.now(), format: 'MM_dd_yyy_hh_mm_ss')}_avatar.png');
      List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await file.writeAsBytes(bytes);
      return file.path;
    } else {
      avatarPath = await download(avatarUrl, email);
      return avatarPath; 
    }     
  
  }
  
  static Future<String> createNewAvatarPath(String email) async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    String documentPath = documentDir.path;
    documentPath += '/$email/${getDateStringWithFormat(dateTime: DateTime.now(), format: 'MM_dd_yyy_hh_mm_ss')}_avatar.png';
    return documentPath;
  } 
  
  static Future<String> getDefaultAvatarPath(String email, Gender gender) async {
    
    Directory documentDir = await getApplicationDocumentsDirectory();
    String documentPath = documentDir.path;
    File avatarFile = File(documentPath + '/$email/avatar.png');
    if(avatarFile.existsSync()) {
      return avatarFile.path;
    }
    String assetImagePath = gender == Gender.MALE ? 'assets/images/male-avatar.png' : 'assets/images/female-avatar.png';
    ByteData data = await rootBundle.load(assetImagePath);
    Directory dir = await Directory(documentPath + '/$email').create();
    File file = File(dir.path + '/' + 'avatar.png');
    List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await file.writeAsBytes(bytes);
    return file.path;
    
  }
  
  // Upload the Photo and get it's URL
  static Future<String> getUploadedAvatarUrl(Gender gender) async {
    try {
      File avatarFile;
      if (gender == Gender.MALE) {
        avatarFile = await getFileFromAsset('assets/images/male-avatar.png');
      } else {
        avatarFile = await getFileFromAsset('assets/images/female-avatar.png');
      }
    
      String fileName = basenameWithoutExtension(avatarFile.path) +
          Random().nextInt(10000).toString() +
          extension(avatarFile.path);

      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(avatarFile);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      final String dUrl = (await taskSnapshot.ref.getDownloadURL());

      return dUrl;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  // Update the user's Avatar in UserInfo collection
  static Future<bool> updateAvatarPhoto(String imgUrl) async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      var documentRef =
          await userTbl.where('id', isEqualTo: uid).getDocuments();
      var key = documentRef.documents[0].documentID;
      await userTbl.document(key).updateData({'avatar': imgUrl});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Delete the selected photo in Database
  static Future<bool> deleteSelectedPhoto(String imgUrl) async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      QuerySnapshot documnetRef = await photoInfo
          .where('id', isEqualTo: uid)
          .where('photourl', isEqualTo: imgUrl)
          .getDocuments();
      int len = documnetRef.documents.length;
      for(var index = 0; index < len; index++ ){
        String key = documnetRef.documents[index].documentID;
        await photoInfo.document(key).delete();
      }

      var ref = await FirebaseStorage.instance.getReferenceFromUrl(imgUrl);
      await ref.delete();
      
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Get the current user's BasicInfo from firebase
  static Future<BasicInfo> getCurUserBasicInfo() async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      var documentRef =
          await basicInfo.where('id', isEqualTo: uid).getDocuments();
      BasicInfo bInfo = BasicInfo.fromJson(documentRef.documents[0].data);
      return bInfo;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get the current user's AvartaUrl from firebase
  static Future<String> getCurUserAvatarUrl() async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      var documentRef =
          await basicInfo.where('id', isEqualTo: uid).getDocuments();
      BasicInfo bInfo = BasicInfo.fromJson(documentRef.documents[0].data);
      return bInfo.dashphotourl;
    } catch (e) {
      print(e.toString());
      return 'Non';
    }
  }

  // Get the current user's Financial Info from firebase
  static Future<FinancialInfo> getCurUserFinancialInfo() async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      var documentRef =
          await financialInfo.where('id', isEqualTo: uid).getDocuments();
      FinancialInfo fInfo = FinancialInfo.fromJson(documentRef.documents[0].data);
      return fInfo;
    } catch (e) {
      print(e.toString());
      return null;
    }
  } 

  // Get the current user's Appearance Info from firebase
  static Future<AppearanceInfo> getCurUserAppearanceInfo() async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      var documentRef =
          await appearanceInfo.where('id', isEqualTo: uid).getDocuments();
      AppearanceInfo apInfo = AppearanceInfo.fromJson(documentRef.documents[0].data);
      return apInfo;
    } catch (e) {
      print(e.toString());
      return null;
    }
  } 

  // Get the current user's Personal Info from firebase
  static Future<PersonalInfo> getCurUserPersonalInfo() async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      var documentRef =
          await personalInfo.where('id', isEqualTo: uid).getDocuments();
      PersonalInfo psInfo = PersonalInfo.fromJson(documentRef.documents[0].data);
      return psInfo;
    } catch (e) {
      print(e.toString());
      return null;
    }
  } 

  static List<String> publicProfilePhotos = [];
  static List<String> privateProfilePhotos = [];

  // Get the current user's PhotoList from firebase
  static Future<void> getCurUserPhotoList() async {
    try {
      publicProfilePhotos.clear(); //= [];
      privateProfilePhotos.clear(); //= [];
      String uid = await AuthManage.getFirebaseUserId();
      var documnetRef = await photoInfo.where('id', isEqualTo: uid).getDocuments();
      for(var index = 0; index < documnetRef.documents.length; index++){
        PhotoInfo pInfo = PhotoInfo.fromJson(documnetRef.documents[index].data);
        if(pInfo.publicflg){
          publicProfilePhotos.add(pInfo.photourl);
        }else {
          privateProfilePhotos.add(pInfo.photourl);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
  // Get the current user's Public Photos
  static List<String> getPublicPhotos() {
    return publicProfilePhotos;
  }
  // Get the current user's Private Photos
  static List<String> getPrivatePhotos() {
    return privateProfilePhotos;
  }

  static Future<String> getCurUserLocationInfo() async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      var documentRef = await basicInfo.where('id', isEqualTo: uid).getDocuments();
      BasicInfo bInfo = BasicInfo.fromJson(documentRef.documents[0].data);
      return bInfo.curlocation;
    } catch (e) {
      print(e.toString());
      return '';
    }
  }

  static Future<DescriptionInfo> getCurUserDescriptionInfo() async {
    try {
      String uid = await AuthManage.getFirebaseUserId();
      var documentRef = await descriptionInfo.where('id', isEqualTo: uid).getDocuments();
      DescriptionInfo dsInfo = DescriptionInfo.fromJson(documentRef.documents[0].data);
      return dsInfo;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}
