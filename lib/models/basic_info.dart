class BasicInfo {
  String id;
  String name;
  String heading;
  String birthday;
  String lookfor;
  String curlocation;
  String dashphotourl;


  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'heading': heading,
    'birthday': birthday,
    'lookfor': lookfor,
    'curlocation': curlocation,
    'dashphotourl': dashphotourl,
  };

  BasicInfo(this.id, this.name, this.heading, this.birthday, this.lookfor, this.curlocation, this.dashphotourl);

  BasicInfo._internalFromJson(Map jsonMap)
    : id = jsonMap['id']?.toString() ?? '',
      name = jsonMap['name']?.toString() ?? '',
      heading = jsonMap['heading']?.toString() ?? '',
      birthday = jsonMap['birthday']?.toString() ?? '',
      lookfor = jsonMap['lookfor']?.toString() ?? '',
      curlocation = jsonMap['curlocation']?.toString() ?? '',
      dashphotourl = jsonMap['dashphotourl']?.toString() ?? '';

  factory BasicInfo.fromJson(Map jsonMap) => BasicInfo._internalFromJson(jsonMap);  
}