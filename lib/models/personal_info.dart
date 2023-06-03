class PersonalInfo {
  String id;
  String occupation;
  String education;
  String relationship;
  String children;
  String smoking;
  String drinking;
  String language;

  Map<String, dynamic> toJson() => {
    'id': id,
    'occupation': occupation,
    'education': education,
    'relationship': relationship,
    'children': children,
    'smoking': smoking,
    'drinking': drinking,
    'language': language,
  };

  PersonalInfo(this.id, this.occupation, this.education, this.relationship, this.children, this.smoking, this.drinking, this.language);

  PersonalInfo._internalFromJson(Map jsonMap)
    : id = jsonMap['id']?.toString() ?? '',
      occupation = jsonMap['occupation']?.toString() ?? '',
      education = jsonMap['education']?.toString() ?? '',
      relationship = jsonMap['relationship']?.toString() ?? '',
      children = jsonMap['children']?.toString() ?? '',
      smoking = jsonMap['smoking']?.toString() ?? '',
      drinking = jsonMap['drinking']?.toString() ?? '',
      language = jsonMap['language']?.toString() ?? '';

  factory PersonalInfo.fromJson(Map jsonMap) => PersonalInfo._internalFromJson(jsonMap);  
}