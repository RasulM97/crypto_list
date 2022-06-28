class Crypto {
  String? id;
  int? rank;
  String? symbol;
  String? name;
  double? marketCapUsd;
  double? priceUsd;
  double? changePercent24Hr;

  Crypto({
    this.id,
    this.name,
    this.symbol,
    this.rank,
    this.priceUsd,
    this.marketCapUsd,
    this.changePercent24Hr,
  });

  factory Crypto.fromMapJson(Map<String, dynamic> jsonMapObject) => Crypto(
        id: jsonMapObject['id'],
        name: jsonMapObject['name'],
        symbol: jsonMapObject['symbol'],
        rank: int.parse(jsonMapObject['rank']),
        priceUsd: double.parse(jsonMapObject['priceUsd']),
        marketCapUsd: double.parse(jsonMapObject['marketCapUsd']),
        changePercent24Hr: double.parse(jsonMapObject['changePercent24Hr']),
      );
}
