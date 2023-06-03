class PhotoInfo {
  String id;
  bool publicflg;
  String photourl;

  Map<String, dynamic> toJson() => {
    'id': id,
    'publicflg': publicflg,
    'photourl': photourl,
  };

  PhotoInfo(this.id, this.publicflg, this.photourl);

  PhotoInfo._internalFromJson(Map jsonMap)
    : id = jsonMap['id']?.toString() ?? '',
      publicflg = jsonMap['publicflg'] ?? false,
      photourl = jsonMap['photourl']?.toString() ?? '';

  factory PhotoInfo.fromJson(Map jsonMap) => PhotoInfo._internalFromJson(jsonMap);  
}