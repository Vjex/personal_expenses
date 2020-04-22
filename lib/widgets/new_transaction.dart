import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void submitTransaction() {
    final String enteredTitle = titleController.text;
    final double enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    } else {

      widget.addTransaction(       //widget keyword is used to access the properties of the widget class inside the stateClass.
        enteredTitle,
        enteredAmount,
      );
      //To close the the AddTransactionModelSheet.
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              controller: titleController,
              onSubmitted: (_) =>
                  submitTransaction(), // '_' is used as argument of anonymus function indicates the argument passed to  the function  will not be cared or not required or will not be used (Not care about it.)

              // onChanged: (val){
              //   print(val);
              // },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) =>
                  submitTransaction(), // '_' is used as argument of anonymus function indicates the argument passed to  the function  will not be cared or not required or will not be used (Not care about it.)
            ),
            FlatButton(
              onPressed: submitTransaction,
              child: Text(
                'Add Transaction',
              ),
              textColor: Colors.purple,
            )
          ],
        ),
      ),
    );
  }
}
