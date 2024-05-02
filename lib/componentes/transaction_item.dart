import 'dart:math';

import 'package:despesas/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    super.key,
    required this.tr,
    required this.mediaQuery,
    required this.onRemove,
  });

  final Transacao tr;
  final MediaQueryData mediaQuery;
  final void Function(String p1) onRemove;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  static const colors = [
    Colors.blue,
    Colors.green,
    Colors.black,
    Colors.orange
  ];
  Color? _backGroudColor;

  @override
  void initState() {
    super.initState();

    int i = Random().nextInt(4);
    _backGroudColor = colors[i];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5,
        ),
        child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _backGroudColor,
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  child: Text(
                    'R\$${widget.tr.value}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            title: Text(
              widget.tr.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text(
              DateFormat('d MMM y').format(widget.tr.date),
            ),
            trailing: widget.mediaQuery.size.width > 480
                ? TextButton.icon(
                    onPressed: () => widget.onRemove(widget.tr.id),
                    icon: Icon(Icons.delete,
                        color: Theme.of(context).colorScheme.error),
                    label: Text(
                      'Excluir',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).colorScheme.error,
                    onPressed: () => widget.onRemove(widget.tr.id),
                  )),
      ),
    );
  }
}
