import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:profitbook/Database/databaseHelper.dart';
import 'package:profitbook/Model/model.dart';
import 'package:profitbook/details.dart';
import 'package:sqflite/sqflite.dart';

class OldTransactionList extends StatefulWidget {
  @override
  _OldTransactionListState createState() => _OldTransactionListState();
}

class _OldTransactionListState extends State<OldTransactionList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Transactions> tList;
  int count = 0;
  double totalBuy;
  double totalSell;
  double totalProfit;
  double totalPinP = 0.00;

  @override
  void initState() {
    temp();
    super.initState();
  }

  temp() async {
    var d = await databaseHelper.calculateBuy();
    totalBuy = d[0]["Total"];
    print(totalBuy);
    var a = await databaseHelper.calculateSell();
    totalSell = a[0]["Total"];
    print(totalSell);

    totalProfit = totalSell - totalBuy;
    totalPinP = ((100 * totalProfit) / totalSell);

    print(totalProfit);
    print(totalPinP);
  }

  @override
  Widget build(BuildContext context) {
    if (tList == null) {
      tList = List<Transactions>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Old Transaction"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border(left: BorderSide(color: Colors.red, width: 7.0)),
              ),
              height: 200,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total Buy",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.indigo),
                          ),
                          Text(
                            totalBuy.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Divider(
                            thickness: 2.0,
                            color: Colors.black,
                          ),
                          Text(
                            "Total Sell",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.indigo),
                          ),
                          Text(
                            totalSell.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 2.0,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total Profit",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.indigo),
                          ),
                          Text(
                            totalProfit.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Divider(
                            thickness: 2.0,
                            color: Colors.black,
                          ),
                          Text(
                            "Total Profit in %",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.indigo),
                          ),
                          Text(
                            totalPinP.toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: count,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                          color: Colors.amber[200],
                          borderRadius: BorderRadius.circular(11.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  this.tList[index].product,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  this.tList[index].date,
                                  style: TextStyle(fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              // navigateToDetails(this.tList[index]);
                              bottomSheet(context, tList[index]);
                            },
                            child: Text(
                              "ViewDetails",
                              style: TextStyle(
                                color: Colors.deepPurpleAccent,
                                decoration: TextDecoration.underline,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 30.0,
                              color: Colors.red,
                            ),
                            color: Colors.red,
                            onPressed: () {
                              _delete(context, tList[index]);
                              initState();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void _delete(BuildContext context, Transactions transactions) async {
    int result = await databaseHelper.deleteNote(transactions.id);
    if (result != null) {
      _showSnackBar(context, "Transaction Deleted Successfully");
    }
  }

  _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
    updateListView();
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Transactions>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((ttList) {
        setState(() {
          this.tList = ttList;
          this.count = ttList.length;
        });
      });
    });
  }

  void navigateToDetails(Transactions transactions) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Details(transactions)));
  }

  bottomSheet(context, Transactions transactions) {
    return showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Details(transactions);
        });
  }
}
