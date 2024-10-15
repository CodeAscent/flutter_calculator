import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CalcModel {
  String? symbol;
  String? firstNum;
  String? secondNum;
  String? answer;
  CalcModel({
    this.symbol,
    this.firstNum,
    this.secondNum,
    this.answer,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'symbol': symbol,
      'firstNum': firstNum,
      'secondNum': secondNum,
      'answer': answer,
    };
  }

  factory CalcModel.fromMap(Map<String, dynamic> map) {
    return CalcModel(
      symbol: map['symbol'] != null ? map['symbol'] as String : null,
      firstNum: map['firstNum'] != null ? map['firstNum'] as String : null,
      secondNum: map['secondNum'] != null ? map['secondNum'] as String : null,
      answer: map['answer'] != null ? map['answer'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CalcModel.fromJson(String source) => CalcModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
