import 'package:flutter/material.dart';
import './widgets/transaction_list.dart';

import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyHomePage());

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];

  void _addNewTransaction(
      String txTitle, double amount, DateTime selectedDate) {
    final newTxn = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: amount,
      dateTime: selectedDate,
    );

    setState(() {
      _transactions.add(newTxn);
    });
  }

  void _startANewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        // '_' is the contxt for the modal sheed provided bt the flutter but we dont want to use that .
        //GestureDetectur is Used To Only clocse the sheet when background is tapped not on the sheet as some time tapping on sheet closes the sheet.
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteATranasaction(String id) {
    setState(() {
      _transactions.removeWhere((txn) => txn.id == id);
    });
  }

  List<Transaction> get _getrecentTranctions {
    return _transactions.where((txn) {
      return txn.dateTime.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors
            .purple, //primarySwatch is used for provideing also diffrrent shated to the widget automatically which is not possible through primary color.
        accentColor:
            Colors.amber, //accent provides the opposite contrasting color
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                ),
              ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Personal Expenses'),
          actions: <Widget>[
            Builder(
              //Builder() method is always used to provide context of app to ant Widget. Otherwise No MediaQuerry Error Will Occur.
              builder: (context) => IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startANewTransaction(context),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Chart(
                  _getrecentTranctions), //Adding Chart by Pasing recent 7 days Transactions.
              //List of the Expenses
              TransactionList(_transactions,_deleteATranasaction),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Builder(
          //Builder() method is always used to provide context of app to ant Widget. Otherwise No MediaQuerry Error Will Occur.
          builder: (context) => FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _startANewTransaction(context),
          ),
        ),
      ),
    );
  }
}
