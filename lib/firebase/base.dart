import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final db = Firestore.instance;

final userTbl = db.collection('User');
final basicInfo = db.collection('BasicInfo');
final financialInfo = db.collection('FinancialInfo');
final appearanceInfo = db.collection('AppearanceInfo');
final personalInfo = db.collection('PersonalInfo'); 
final photoInfo = db.collection('PhotoInfo');
final locationInfo = db.collection('LocationInfo');
final descriptionInfo = db.collection('DescriptionInfo');
final chatCollection = db.collection('Chats');
final favoriteInfo = db.collection('FavoriteInfo');