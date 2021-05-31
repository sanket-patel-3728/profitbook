class Transactions {
  int id;
  String product;
  double buy;
  double sell;
  double profit;
  double profitInP;
  var date;

  Transactions({
    this.id,
    this.buy,
    this.product,
    this.profit,
    this.profitInP,
    this.sell,
    this.date,
  });

  int get gId => id;

  String get gProduct => product;

  double get gBuy => buy;

  double get gSell => sell;

  double get gProfit => profit;

  double get gProfitInP => profitInP;

  String get gDate => date;

  set gProduct(String productName) {
    this.product = productName;
  }

  set gBuy(double buy) {
    this.buy = buy;
  }

  set gSell(double sell) {
    this.sell = sell;
  }

  set gProfit(double profit) {
    this.profit = profit;
  }

  set gProfitInP(double profitInP) {
    this.profitInP = profitInP;
  }

  set gDate(String date) {
    this.date = date;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map["id"] = id;
    }
    map["product"] = product;
    map["buy"] = buy;
    map["sell"] = sell;
    map["profit"] = profit;
    map["profitInP"] = profitInP;
    map["date"] = date;

    return map;
  }

  Transactions.fromMapObject(Map<String, dynamic> map) {
    this.id = map["id"];
    this.product = map["product"];
    this.buy = map["buy"];
    this.sell = map["sell"];
    this.profit = map["profit"];
    this.profitInP = map["profitInP"];
    this.date = map["date"];
  }
}
