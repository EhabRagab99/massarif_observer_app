import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  const NewTransaction(this.addTx, {Key? key}) : super(key: key);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _ctlTitle = TextEditingController();
  final _ctlAmount = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if (_ctlAmount.text.isEmpty) {
      return;
    }

    final enteredTitle = _ctlTitle.text;
    final enteredAmount = double.parse(_ctlAmount.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    widget.addTx(
      _ctlTitle.text,
      double.parse(_ctlAmount.text),
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
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
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: mediaQuery.viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: _ctlTitle,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: _ctlAmount,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(),
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}'),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: const Text(
                              'Choose Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: _presentDatePicker,
                          )
                        : TextButton(
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                            ),
                            child: const Text(
                              'Choose Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: _presentDatePicker,
                          )
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text('Add Transaction'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle: TextStyle(
                      color: Theme.of(context).textTheme.button?.color),
                ),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
