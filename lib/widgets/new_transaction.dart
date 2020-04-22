import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitTransaction() {
//To check the amountController is empty otherwise it will through a error  of parsing a null data.

    if (_amountController.text.isEmpty) {
      return;
    }

    final String enteredTitle = _titleController.text;
    final double enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    } else {
      widget.addTransaction(
        //widget keyword is used to access the properties of the widget class inside the stateClass.
        enteredTitle,
        enteredAmount,
        _selectedDate
      );
      //To close the the AddTransactionModelSheet.
      Navigator.of(context).pop();
    }
  }

  void _presentDatePicker() {
    //Inbuilt Flutter Method to show A datePicker
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
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
              controller: _titleController,
              onSubmitted: (_) =>
                  _submitTransaction(), // '_' is used as argument of anonymus function indicates the argument passed to  the function  will not be cared or not required or will not be used (Not care about it.)

              // onChanged: (val){
              //   print(val);
              // },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
              ),
              controller: _amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) =>
                  _submitTransaction(), // '_' is used as argument of anonymus function indicates the argument passed to  the function  will not be cared or not required or will not be used (Not care about it.)
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No date choosen !!'
                        : 'Picked Date : ${DateFormat.yMd().format(_selectedDate)}',
                  ),
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    'Choose Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _presentDatePicker,
                )
              ],
            ),
            RaisedButton(
              color: Theme.of(context).primaryColor,
              onPressed: _submitTransaction,
              child: Text(
                'Add Transaction',
              ),
              textColor: Theme.of(context).buttonColor,
            )
          ],
        ),
      ),
    );
  }
}
