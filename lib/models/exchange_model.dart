import 'dart:convert';

Exchange exchangeFromJson(String str) => Exchange.fromJson(json.decode(str));

class Exchange {
  Exchange({
    this.assetIdBase,
    this.assetIdQuote,
    this.rate,
  });

  String? assetIdBase;
  String? assetIdQuote;
  double? rate;

  factory Exchange.fromJson(Map<String, dynamic> json) => Exchange(
    assetIdBase: json["asset_id_base"],
    assetIdQuote: json["asset_id_quote"],
    rate: json["rate"].toDouble(),
  );
}
