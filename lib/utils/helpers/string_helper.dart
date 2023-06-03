import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

String dropFirst({str = String}) {
  return str.toString().substring(1);
}

String getExtension(File file) {
  String path = file.path;
  var splits = path.split('.');
  return splits.last;
}

String fromImageFile(File imageFile) {
  List<int> imageBytes = imageFile.readAsBytesSync();
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}

Image fromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

String extractBinFromCardNumber(String cardNumber) {
  if(cardNumber == null || cardNumber == '' || cardNumber.length < 16) return null;

  return cardNumber.substring(0, 6);
}

String capitalizeStartCharacter(String s) => s[0].toUpperCase() + s.substring(1);