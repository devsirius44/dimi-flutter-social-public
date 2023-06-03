class FavoriteInfo {
  String firstId;
  String secondId;
  bool viewed;
  bool favorited;
  int viewedTime;
  int favoritedTime;

  Map<String, dynamic> toJson() => {
    'firstId': firstId,
    'secondId': secondId,
    'viewed': viewed,
    'favorited': favorited,
    'viewedTime': viewedTime,
    'favoritedTime': favoritedTime,
  };

  FavoriteInfo(this.firstId, this.secondId, this.viewed, this.favorited, this.viewedTime, this.favoritedTime);

  FavoriteInfo._internalFromJson(Map jsonMap)
    : firstId = jsonMap['firstId']?.toString() ?? '',
      secondId = jsonMap['secondId']?.toString() ?? '',     
      viewed = jsonMap['viewed'] ?? false,
      favorited = jsonMap['favorited'] ?? false,
      viewedTime = jsonMap['viewedTime'] ?? 0,
      favoritedTime = jsonMap['favoritedTime'] ?? 0;

  factory FavoriteInfo.fromJson(Map jsonMap) => FavoriteInfo._internalFromJson(jsonMap);  
}