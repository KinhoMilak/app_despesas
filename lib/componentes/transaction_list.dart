import 'package:despesas/componentes/transaction_item.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transacao> transaction;
  final void Function(String) onRemove;

  const TransactionList(this.transaction, this.onRemove, {super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool orientation = mediaQuery.orientation == Orientation.landscape;
    return transaction.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                SizedBox(height: constraints.maxHeight * 0.05),
                SizedBox(
                  height: constraints.maxHeight * 0.3,
                  child: Text(
                    'Nenhuma Transação cadastrada!!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                    height: constraints.maxHeight *
                        0.05), // Espaço entre componentes
                SizedBox(
                  height: constraints.maxHeight * (orientation ? 0.6 : 0.4),
                  child: Image.asset(
                    'assets/images/vazio.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView.builder(
            itemCount: transaction.length,
            itemBuilder: (ctx, index) {
              final tr = transaction[index];
              return TransactionItem(
                key: GlobalObjectKey(tr),
                tr: tr,
                mediaQuery: mediaQuery,
                onRemove: onRemove,
              );
            },
          );
  }
}
