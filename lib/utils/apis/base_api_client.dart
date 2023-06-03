import 'dart:convert';
import 'package:http/http.dart';

Future<dynamic> getRequest(String url, Map<String, String> _headers) async {
  print(_headers.toString());
  final response = await get(url, headers: _headers);
  final jsonData = json.decode(response.body);
  return jsonData;
}

Future<dynamic> postRequest(String url, Map<String, String> _headers, Map body) async {
  final response = await post(url,
      headers: _headers,
      body: body
  );
  final jsonData = json.decode(response.body);
  return jsonData;
}

Future<dynamic> deleteRequest(String url, Map<String, String> _headers) async {
  final response = await delete(url, headers: _headers);
  final jsonData = json.decode(response.body);
  return jsonData;
} 


Future<dynamic> putRequest(String url, Map<String, String> _headers, Map body) async {
  final response = await put(url,
  headers: _headers,
  body: body
  );
  print('response = ${response.toString()}');
  final jsonData = json.decode(response.body);
  return jsonData;
}

