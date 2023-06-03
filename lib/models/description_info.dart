class DescriptionInfo {
  String id;
  String aboutme;
  String wilookfor;

  Map<String, dynamic> toJson() => {
    'id': id,
    'aboutme': aboutme,
    'wilookfor': wilookfor,
  };

  DescriptionInfo(this.id, this.aboutme, this.wilookfor);

  DescriptionInfo._internalFromJson(Map jsonMap)
    : id = jsonMap['id']?.toString() ?? '',
      aboutme = jsonMap['aboutme']?.toString() ?? '',
      wilookfor = jsonMap['wilookfor']?.toString() ?? '';

  factory DescriptionInfo.fromJson(Map jsonMap) => DescriptionInfo._internalFromJson(jsonMap);  
}