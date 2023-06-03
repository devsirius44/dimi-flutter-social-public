class AppearanceInfo {
  String id;
  String height;
  String bodytype;
  String ethnicity;
  String eyecolor;
  String haircolor;

  Map<String, dynamic> toJson() => {
    'id': id,
    'height': height,
    'bodytype': bodytype,
    'ethnicity': ethnicity,
    'eyecolor': eyecolor,
    'haircolor': haircolor,
  };

  AppearanceInfo(this.id, this.height, this.bodytype, this.ethnicity, this.eyecolor, this.haircolor);

  AppearanceInfo._internalFromJson(Map jsonMap)
    : id = jsonMap['id']?.toString() ?? '',
      height = jsonMap['height']?.toString() ?? '',
      bodytype = jsonMap['bodytype']?.toString() ?? '',
      ethnicity = jsonMap['ethnicity']?.toString() ?? '',
      eyecolor = jsonMap['eyecolor']?.toString() ?? '',
      haircolor = jsonMap['haircolor']?.toString() ?? '';

  factory AppearanceInfo.fromJson(Map jsonMap) => AppearanceInfo._internalFromJson(jsonMap);  
}