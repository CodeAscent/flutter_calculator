import 'package:flutter/material.dart';
import 'package:flutter_calculator/controller/calc_controller.dart';
import 'package:flutter_calculator/models/calc_model.dart';
import 'package:flutter_calculator/repo/local_repo.dart';
import 'package:flutter_calculator/view/widgets/common_card.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List symbols = ['x', '+', '-', '%', '÷'];
  List<String> numbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
    '.',
  ];
  CalcModel calcModel = CalcModel();

  num calculation(num a, num b, String symbol) {
    switch (symbol) {
      case '+':
        return a + b;
      case 'x':
        return a * b;
      case '÷':
        return a / b;
      case '-':
        return a - b;
      case '%':
        return a % b;
      default:
        throw ArgumentError("Invalid operator");
    }
  }

  void clearCalc() {
    setState(() {
      calcModel = CalcModel();
      historyAdded = false;
    });
  }

  bool historyAdded = false;

  CalcController calcController = CalcController(localRepo: LocalRepo());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            color: Colors.yellow,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () async {
                          Vibration.vibrate();
                          List<CalcModel> history =
                              await calcController.getHistory(context);
                          kHistorySheet(context, history);
                        },
                        icon: Icon(
                          Icons.history,
                          size: 50,
                        )),
                    Spacer(),
                    Wrap(
                      spacing: 10,
                      alignment: WrapAlignment.end,
                      runAlignment: WrapAlignment.end,
                      children: [
                        Text(
                          calcModel.firstNum ?? '',
                          style: kCommonStyle(context)
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          calcModel.symbol ?? '',
                          style: kCommonStyle(context)
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          calcModel.secondNum ?? '',
                          style: kCommonStyle(context)
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                    if (calcModel.answer != null)
                      Text(
                        "= " + calcModel.answer!,
                        style:
                            kCommonStyle(context).copyWith(color: Colors.black),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.blue.shade400,
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  ...List.generate(numbers.length, (int index) {
                    String numb = numbers[index];

                    return InkWell(
                        borderRadius: BorderRadius.circular(10),
                        splashColor: Colors.yellowAccent.withOpacity(0.5),
                        onTap: () {
                          if (calcModel.symbol == null) {
                            calcModel.firstNum =
                                (calcModel.firstNum ?? '') + numb;
                          } else {
                            calcModel.secondNum =
                                (calcModel.secondNum ?? '') + numb;
                          }
                          setState(() {});
                          print('---------------> ${calcModel.firstNum}');
                          print('---------------> ${calcModel.symbol}');
                          print('---------------> ${calcModel.secondNum}');
                        },
                        child: CommonCard(label: numb));
                  }),
                  ...List.generate(symbols.length, (int index) {
                    return GestureDetector(
                        onTap: () {
                          calcModel.symbol = symbols[index];
                          setState(() {});
                          print('---------------> ${calcModel.symbol}');
                        },
                        child: CommonCard(label: symbols[index]));
                  }),
                  GestureDetector(
                      onTap: () {
                        if (calcModel.firstNum != null &&
                            calcModel.secondNum != null &&
                            calcModel.symbol != null) {
                          final firstNum = num.parse(calcModel.firstNum!);
                          final secondNum = num.parse(calcModel.secondNum!);
                          final symbol = calcModel.symbol;
                          print('---------------> ${firstNum}');
                          print('---------------> ${symbol}');
                          print('---------------> ${secondNum}');
                          Vibration.vibrate();

                          calcModel.answer =
                              calculation(firstNum, secondNum, symbol!)
                                  .toStringAsFixed(2);
                          if (!historyAdded) {
                            calcController.addHistoryItem(context, calcModel);
                            historyAdded = true;
                          }
                          setState(() {});
                        }
                      },
                      child: CommonCard(label: "  =  ")),
                  GestureDetector(
                      onTap: clearCalc, child: CommonCard(label: "Clear")),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> kHistorySheet(BuildContext context, List<CalcModel> history) {
    return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (history.length != 0)
              IconButton(
                  onPressed: () {
                    Vibration.vibrate();
                    calcController.clearHistory(context);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 50,
                  )),
            Expanded(
              child: history.length == 0
                  ? Center(
                      child: Text('No History'),
                    )
                  : SingleChildScrollView(
                      reverse: true,
                      child: Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ...List.generate(history.length, (int index) {
                                final historyItem = history[index];
                                return Column(
                                  children: [
                                    Text(
                                      "${historyItem.firstNum} ${historyItem.symbol} ${historyItem.secondNum}",
                                      style: kCommonStyle(context).copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "= ${historyItem.answer}",
                                      style: kCommonStyle(context)
                                          .copyWith(color: Colors.black),
                                    )
                                  ],
                                );
                              })
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

TextStyle kCommonStyle(BuildContext context) {
  double textScaleFactor = MediaQuery.of(context).size.width * 0.05;
  return TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w900,
    fontSize: textScaleFactor,
  );
}
