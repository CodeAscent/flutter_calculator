import 'package:flutter/material.dart';
import 'package:flutter_calculator/calc_model.dart';
import 'package:flutter_calculator/local_repo.dart';

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

  LocalRepo localRepo = LocalRepo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: Container(
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
                              List<CalcModel> history =
                                  await localRepo.getHistory();
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
                              style: kCommonStyle(),
                            ),
                            Text(
                              calcModel.symbol ?? '',
                              style: kCommonStyle(),
                            ),
                            Text(
                              calcModel.secondNum ?? '',
                              style: kCommonStyle(),
                            ),
                          ],
                        ),
                        if (calcModel.answer != null)
                          Text(
                            "= " + calcModel.answer!,
                            style: kCommonStyle(),
                          ),
                      ],
                    ),
                  ),
                ),
              )),
          Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                color: Colors.blue.shade400,
                child: Wrap(
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

                            calcModel.answer =
                                calculation(firstNum, secondNum, symbol!)
                                    .toStringAsFixed(2);
                            if (!historyAdded) {
                              localRepo.addHistoryItem(calcModel);
                              historyAdded = true;
                            }
                            setState(() {});
                          }
                        },
                        child: CommonCard(label: "=")),
                    GestureDetector(
                        onTap: clearCalc, child: CommonCard(label: "Clear")),
                  ],
                ),
              )),
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
                    localRepo.clearHistory();
                    setState(() {});
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 50,
                  )),
            Expanded(
              child: SingleChildScrollView(
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
                                style: kCommonStyle().copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "= ${historyItem.answer}",
                                style: kCommonStyle()
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

class CommonCard extends StatelessWidget {
  const CommonCard({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.yellow, width: 4)),
      child: Text(
        label,
        style: kCommonStyle(),
      ),
    );
  }
}

TextStyle kCommonStyle() {
  return TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w900,
    fontSize: 30,
  );
}
