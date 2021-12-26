import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatefulWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  const TransactionList(this.transactions, this.deleteTx, {Key? key})
      : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late Transaction _deletedTx;

  void _onDelete(Transaction tx, BuildContext context) {
    _deletedTx = tx;
    widget.deleteTx(tx.id);

    final snackBar = SnackBar(
      content: Text("${_deletedTx.title} was deleted"),
      action: SnackBarAction(
        label: "undo",
        onPressed: () {
          setState(() {
            widget.transactions.add(_deletedTx);
          });
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.transactions.isEmpty
          ? LayoutBuilder(
              builder: (ctx, constraint) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Not transactions added yet!',
                        style: Theme.of(context).textTheme.headline6),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        height: constraint.maxHeight * 0.6,
                        child: Image.asset(
                          'assets/images/waiting.png',
                          fit: BoxFit.cover,
                        )),
                  ],
                );
              },
            )
          : ListView.builder(
              itemCount: widget.transactions.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                              '\$${widget.transactions[index].amount.toStringAsFixed(2)}'),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.transactions[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat("dd/MM/yyyy")
                          .format(widget.transactions[index].date),
                    ),
                    trailing: MediaQuery.of(context).size.width > 460
                        ? TextButton.icon(
                            icon: const Icon(Icons.delete),
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).errorColor,
                            ),
                            label: const Text('Delete'),
                            onPressed: () =>
                                _onDelete(widget.transactions[index], context),
                          )
                        : IconButton(
                            icon: const Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () =>
                                _onDelete(widget.transactions[index], context)),
                  ),
                );
              },
            ),
    );
  }
}
