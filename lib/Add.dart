import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profitbook/Model/model.dart';
import 'package:sqflite/sqflite.dart';
import 'Database/databaseHelper.dart';
import 'package:profitbook/Model/admob_services.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '771D8CD6BE38F6BC0956E69D11CA8DE7';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final ams = AdMobServices();

  final _formKey = GlobalKey<FormState>();
  Transactions transactions = Transactions();

  DatabaseHelper helper = DatabaseHelper();
  TextEditingController productController = TextEditingController();
  TextEditingController buyController = TextEditingController();

  TextEditingController sellController = TextEditingController();
  DateTime dateTime;
  String productName;
  double buy = 0;
  double sell = 0;
  double profit = 0.0;
  double profitInp = 0;

  bool flag = false;

  // MobileAdTargetingInfo targetingInfo;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: [testDevice] != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>[
      'Game',
      'Mario',
      'all',
      'music',
      'anything',
      'sex',
      'money',
      'google',
    ],
  );
  BannerAd _bannerAd;
  InterstitialAd myInterstitial;

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: 'ca-app-pub-6414358134929772/3254410262',
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
        });
  }

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: 'ca-app-pub-6414358134929772/3299654056',
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  @override
  void initState() {
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-6414358134929772~3794478078');
    // _bannerAd = createBannerAd()
    //   ..load()
    //   ..show();
    super.initState();
    super.initState();
    dateTime = DateTime.now();
  }

  makeCalculation() {
    if (_formKey.currentState.validate()) {
      setState(() {
        profit = sell - buy;
        profitInp = ((100 * profit) / sell);
        flag = true;
      });
    }
  }

  Future addTransaction() async {
    // show_InterstitialAd();
    createInterstitialAd()
      ..load()
      ..show();
    transactions.gProduct = productName;
    transactions.gBuy = buy;
    transactions.gSell = sell;
    transactions.gProfit = profit;
    transactions.gProfitInP = profitInp;
    transactions.date = DateFormat.yMMMd().format(dateTime);

    final Future<Database> dbFuture = helper.initializeDatabase();

    if (_formKey.currentState.validate() && flag == true) {
      int result;

      result = await helper.insertNote(transactions);

      if (result != 0) {
        _showAlertDialog('Status', 'Transaction Add Successfully');
        setState(() {
          productController.clear();
          sellController.clear();
          buyController.clear();
          profit = 0.0;
          profitInp = 0.0;
          flag = false;
        });
      } else {
        _showAlertDialog('Status', 'Problem In Saving Transaction');
      }
    }
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    myInterstitial.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Add New Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 20.0),
              Text(
                "Product Name",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextFormField(
                controller: productController,
                validator: (value) {
                  return value.isEmpty ? "Required" : null;
                },
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Product Name...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                onChanged: (value) {
                  productName = value;
                },
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Buy Amount",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextFormField(
                controller: buyController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  return value.isEmpty ? "Required" : null;
                },
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Buy Amount...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                onChanged: (value) {
                  buy = double.parse(value);
                },
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Sell Amount",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5.0,
              ),
              TextFormField(
                controller: sellController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  return value.isEmpty ? "Required" : null;
                },
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Sell Amount...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                onChanged: (value) {
                  sell = double.parse(value);
                },
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: GestureDetector(
                  onTap: () {
                    makeCalculation();
                  },
                  child: Container(
                    width: 100.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        "CALCULATE",
                        style: TextStyle(
                            letterSpacing: 1.5,
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Profit In Amount",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${profit.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.red, fontSize: 30.0),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "₹",
                      style: TextStyle(color: Colors.red, fontSize: 40.0),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Profit In Percentage",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${profitInp.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.red, fontSize: 30.0),
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      "%",
                      style: TextStyle(color: Colors.red, fontSize: 35.0),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Select Date",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  _pickDate(context);
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 8),
                        child: Icon(
                          Icons.date_range,
                        ),
                      ),
                      VerticalDivider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "${dateTime.day}-${dateTime.month}-${dateTime.year}",
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: addTransaction,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        "ADD TRANSACTION",
                        style: TextStyle(
                            letterSpacing: 1.5,
                            color: Colors.white,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _pickDate(BuildContext context) async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(DateTime.now().year - 25),
      lastDate: DateTime(DateTime.now().year + 25),
    );
    if (date != null) {
      setState(() {
        dateTime = date;
      });
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
