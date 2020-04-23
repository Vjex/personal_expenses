import 'package:flutter/material.dart';

import '../models/transaction.dart';
import './transaction_list_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteATransaction;

  TransactionList(this.transactions, this.deleteATransaction);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transaction added yet!!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.60,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              //Here now we User ListView.builder better otimized way of onl ListView.
              return TransactionListItem(
                  key: ValueKey(transactions[index].id),
                  transaction: transactions[index],
                  deleteATransaction: deleteATransaction);
            },
            itemCount: transactions.length,
          );
  }
}
