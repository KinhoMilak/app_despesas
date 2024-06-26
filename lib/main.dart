import 'dart:math';
import 'package:despesas/componentes/chart.dart';
import 'package:despesas/componentes/transaction_form.dart';
import 'package:despesas/componentes/transaction_list.dart';
import 'package:flutter/material.dart';
import 'models/transaction.dart';

void main() => runApp(DespesasApp());

class DespesasApp extends StatelessWidget {
  final ThemeData tema = ThemeData();

  DespesasApp({super.key});
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);// trava a orientação na vertical
    return MaterialApp(
      home: const MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.yellow,
        ),
        textTheme: tema.textTheme.copyWith(
          titleLarge: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          labelLarge: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transacao> _transacao = [];
  bool _showChart = false;

  void iniState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void didChangeApplifeCycleState(AppLifecycleState state) {}

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  List<Transacao> get _recentTransaction {
    return _transacao.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transacao(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transacao.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removetransaction(String id) {
    setState(() {
      _transacao.removeWhere((tr) => tr.id == id);
    });
  }

  _openTransactionForModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool orientation =
        mediaQuery.orientation == Orientation.landscape; //landscape é paisagem
    final appBar = AppBar(
      title: const Text('Despesas Pessoais'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _openTransactionForModal(context),
        ),
        if (orientation)
          IconButton(
              onPressed: () {
                setState(
                  () {
                    _showChart = !_showChart;
                  },
                );
              },
              icon: Icon(_showChart ? Icons.list : Icons.pie_chart)),
      ],
    );
    final avaliableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_showChart || !orientation)
                SizedBox(
                    height: avaliableHeight * (orientation ? 0.75 : 0.25),
                    child: Chart(_recentTransaction)),
              if (!_showChart || !orientation)
                SizedBox(
                    height: avaliableHeight * 0.75,
                    child: TransactionList(_transacao, _removetransaction)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openTransactionForModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
