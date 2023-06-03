enum Gender { MALE, FEMALE }
enum Role { SUGAR_DADDY, SUGAR_MOMMY, SUGAR_COUPLE, SUGAR_BABY }
enum Imwe { MAN, WOMAN, MAN_WOMAN, WOMAN_WOMAN, MAN_MAN}

class UserTbl {
  String id;
  String email;
  Gender gender;
  Role role;
  Imwe imwe;
  Imwe intrst;
  int created;
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'gender': genderToString(gender),
    'role': roleToString(role),
    'imwe': imweToString(imwe),
    'intrst': imweToString(intrst),
    'created': created,
  };

  UserTbl(this.id, this.email, this.gender, this.role, this.imwe, this.intrst, this.created);

  UserTbl._internalFromJson(Map jsonMap)
    : id = jsonMap['id']?.toString() ?? '',
      email = jsonMap['email']?.toString() ?? '',
      gender = genderFromString(jsonMap['gender']?.toString() ?? ''),
      role = roleFromString(jsonMap['role']?.toString() ?? ''),
      imwe = imweFromString(jsonMap['imwe']?.toString() ?? ''),
      intrst = imweFromString(jsonMap['intrst']?.toString() ?? ''),
      created = jsonMap['created']?.toInt() ?? 0;

  factory UserTbl.fromJson(Map jsonMap) => UserTbl._internalFromJson(jsonMap);  
}

String genderToString(Gender gender) {
  if (gender == Gender.FEMALE) return 'Female';
  return 'Male';
}

Gender genderFromString(String genderStr) {
  if (genderStr == 'Female') return Gender.FEMALE;
  return Gender.MALE;
}

String roleToString(Role role) {
  if (role == Role.SUGAR_DADDY) return 'Sugar Daddy';
  else if (role == Role.SUGAR_MOMMY) return 'Sugar Mommy';
  else if (role == Role.SUGAR_COUPLE) return 'Sugar Couple';
  else if (role == Role.SUGAR_BABY) return 'Sugar Baby';
  return '';
}

Role roleFromString(String roleStr) {
  if (roleStr == 'Sugar Daddy') return Role.SUGAR_DADDY;
  else if (roleStr == 'Sugar Mommy') return Role.SUGAR_MOMMY;
  else if (roleStr == 'Sugar Couple') return Role.SUGAR_COUPLE;
  else if (roleStr == 'Sugar Baby') return Role.SUGAR_BABY;
  return null;
}

String imweToString(Imwe imwe){
  if (imwe == Imwe.MAN) return 'Man';
  else if (imwe == Imwe.WOMAN) return 'Woman';
  else if (imwe == Imwe.MAN_MAN) return 'Man+Man';
  else if (imwe == Imwe.MAN_WOMAN) return 'Man+Woman';
  else if (imwe == Imwe.WOMAN_WOMAN) return 'Woman+Woman';
  return '';
}

Imwe imweFromString(String imweStr) {
  if(imweStr == 'Man') return Imwe.MAN;
  else if(imweStr == 'Woman') return Imwe.WOMAN;
  else if(imweStr == 'Man+Man') return Imwe.MAN_MAN;
  else if(imweStr == 'Man+Woman') return Imwe.MAN_WOMAN;
  else if(imweStr == 'Woman+Woman') return Imwe.WOMAN_WOMAN;
  return null;
}


