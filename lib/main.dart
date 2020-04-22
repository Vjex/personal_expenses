import 'package:flutter/material.dart';
import 'package:personal_expenses/widgets/transaction_list.dart';

import './models/transaction.dart';
import './widgets/new_transaction.dart';

void main() => runApp(MyHomePage());

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 400.45,
      dateTime: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'New Watch',
      amount: 800,
      dateTime: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'New Clothes',
      amount: 2400,
      dateTime: DateTime.now(),
    ),
  ];

  void _addNewTransaction(String txTitle, double amount) {
    final newTxn = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: amount,
      dateTime: DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple, //primarySwatch is used for provideing also diffrrent shated to the widget automatically which is not possible through primary color.
        accentColor:Colors.amber, //accent provides the opposite contrasting color
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
              Container(
                width: double.infinity,
                child: Card(
                  child: Text('CArd is'),
                  color: Colors.blue,
                ),
              ),
              //List of the Expenses
              TransactionList(_transactions),
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
