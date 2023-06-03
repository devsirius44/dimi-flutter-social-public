class FinancialInfo {
  String id;
  String lifestyle;
  String networth;
  String annuincome;

  Map<String, dynamic> toJson() => {
    'id': id,
    'lifestyle': lifestyle,
    'networth': networth,
    'annuincome': annuincome,
  };

  FinancialInfo(this.id, this.lifestyle, this.networth, this.annuincome);

  FinancialInfo._internalFromJson(Map jsonMap)
    : id = jsonMap['id']?.toString() ?? '',
      lifestyle = jsonMap['lifestyle']?.toString() ?? '',
      networth = jsonMap['networth']?.toString() ?? '',
      annuincome = jsonMap['annuincome']?.toString() ?? '';

  factory FinancialInfo.fromJson(Map jsonMap) => FinancialInfo._internalFromJson(jsonMap);  
}