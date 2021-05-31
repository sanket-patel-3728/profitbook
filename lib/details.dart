import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:profitbook/Model/model.dart';

import 'Database/databaseHelper.dart';

class Details extends StatefulWidget {
  Transactions transactions;

  Details(this.transactions);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 300,
          width: 330,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Product : ",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.transactions.product,
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 2.0,
              ),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Buy Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.indigo),
                          ),
                          Text(
                            widget.transactions.buy.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Divider(
                            thickness: 2.0,
                            color: Colors.black,
                          ),
                          Text(
                            "Sell Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.indigo),
                          ),
                          Text(
                            widget.transactions.sell.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Profit Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.pink),
                          ),
                          Text(
                            widget.transactions.profit.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          Divider(
                            thickness: 2.0,
                            color: Colors.black,
                          ),
                          Text(
                            "Profit in %",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.pink),
                          ),
                          Text(
                            widget.transactions.profitInP.toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 2.0,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Date : ",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.transactions.date,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
