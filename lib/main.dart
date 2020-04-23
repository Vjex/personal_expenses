import 'dart:io';

import 'package:flutter/cupertino.dart'; //For ioS styling
import 'package:flutter/material.dart'; //For Android styling.
import 'package:flutter/services.dart';
import './widgets/transaction_list.dart';

import './models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';

void main() {
  runApp(
    MaterialApp(
      //Material AppShould always be on Top od allWidget to get The Mediaquery Object Acces for the device installation
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
      home: MyHomePage(),
    ),
  );
  //Always after the runApp.
  //Defining the Orentation of the App.
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,
  // DeviceOrientation.portraitUp]);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [];

  bool _showChart = false;

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
    final mediaQuerryObject = MediaQuery.of(context);
    final isLanscape = (mediaQuerryObject.orientation == Orientation.landscape);

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'), //instead of title:
            trailing: Row(
              mainAxisSize: MainAxisSize
                  .min, //Just to give the Row a size to min otherwise the  Getsture Button will take complete space in the bar and middling will not appear.
              children: <Widget>[
                GestureDetector(
                  //Creating our own button as if we use FlatButton here under Cupertno design will through a error also with the CupertinoIcons intaed of Icons.
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startANewTransaction(context),
                ),
              ],
            ), //instaed of actions:
          )
        : AppBar(
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
          );

    //Adding Chart by Pasing recent 7 days Transactions.
    //List of the Expenses
    final transactionListWidget = Builder(
      builder: (context) => Container(
        height: (mediaQuerryObject.size.height -
                appBar.preferredSize.height -
                mediaQuerryObject.padding.top) *
            0.65,
        child: TransactionList(
          _transactions,
          _deleteATranasaction,
        ),
      ),
    );

    final chartWidget = Builder(
      builder: (context) => Container(
        height: (mediaQuerryObject.size.height -
                appBar.preferredSize.height -
                mediaQuerryObject.padding.top) *
            0.7,
        child: Chart(_getrecentTranctions),
      ),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLanscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart',style: Theme.of(context).textTheme.title,),
                  Switch.adaptive(
                      //.adaptive is used to just for patform based switch will be provide like for Ios and Android.
                      activeColor: Theme.of(context).accentColor,
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (!isLanscape)
              Container(
                height: (mediaQuerryObject.size.height -
                        appBar.preferredSize.height -
                        mediaQuerryObject.padding.top) *
                    0.3,
                child: Chart(_getrecentTranctions),
              ),
            if (!isLanscape) transactionListWidget,
            if (isLanscape) _showChart ? chartWidget : transactionListWidget,
          ],
        ),
      ),  
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startANewTransaction(context),
                  ),
          );
  }
}
