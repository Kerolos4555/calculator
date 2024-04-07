import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String number1 = '';
  String operator = '';
  String number2 = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '$number1$operator$number2'.isEmpty
                        ? '0'
                        : '$number1$operator$number2',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Wrap(
              children: ButtonValues.buttons.map(
                (e) {
                  return SizedBox(
                    width: e == ButtonValues.num0
                        ? MediaQuery.of(context).size.width / 2
                        : MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.width / 5,
                    child: buildButton(e),
                  );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color buttonColor(String value) {
    return [ButtonValues.delete, ButtonValues.clear].contains(value)
        ? Colors.blueGrey
        : [
            ButtonValues.per,
            ButtonValues.multiply,
            ButtonValues.add,
            ButtonValues.subtract,
            ButtonValues.divide,
            ButtonValues.calculate,
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: buttonColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            100,
          ),
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
        ),
        child: InkWell(
          onTap: () {
            return onButtonTap(value);
          },
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onButtonTap(String value) {
    if (value == ButtonValues.delete) {
      delete();
      return;
    }
    if (value == ButtonValues.clear) {
      clear();
      return;
    }
    if (value == ButtonValues.per) {
      toPercentage();
      return;
    }
    if (value == ButtonValues.calculate) {
      calculate();
      return;
    }
    getValue(value);
  }

  void calculate() {
    if (number1.isEmpty) {
      return;
    }
    if (operator.isEmpty) {
      return;
    }
    if (number2.isEmpty) {
      return;
    }
    double num1 = double.parse(number1);
    double num2 = double.parse(number2);
    var result = 0.0;
    switch (operator) {
      case ButtonValues.add:
        result = num1 + num2;
        break;
      case ButtonValues.subtract:
        result = num1 - num2;
        break;
      case ButtonValues.multiply:
        result = num1 * num2;
        break;
      case ButtonValues.divide:
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      number1 = '$result';
      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operator = '';
      number2 = '';
    });
  }

  void toPercentage() {
    if (number1.isNotEmpty && operator.isNotEmpty && number2.isNotEmpty) {
      calculate();
    }
    if (operator.isNotEmpty) {
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = '${(number / 100)}';
      operator = '';
      number2 = '';
    });
  }

  void clear() {
    setState(() {
      number1 = '';
      operator = '';
      number2 = '';
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operator.isNotEmpty) {
      operator = '';
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {});
  }

  void getValue(String value) {
    if (value != ButtonValues.dot && int.tryParse(value) == null) {
      if (operator.isNotEmpty && number2.isNotEmpty) {
        calculate();
      }
      operator = value;
    } else if (number1.isEmpty || operator.isEmpty) {
      if (value == ButtonValues.dot && number1.contains(ButtonValues.dot)) {
        return;
      }
      if (value == ButtonValues.dot &&
          (number1.isEmpty || number1 == ButtonValues.num0)) {
        value = '0.';
      }
      number1 += value;
    } else if (number2.isEmpty || operator.isNotEmpty) {
      if (value == ButtonValues.dot && number2.contains(ButtonValues.dot)) {
        return;
      }
      if (value == ButtonValues.dot &&
          (number2.isEmpty || number2 == ButtonValues.num0)) {
        value = '0.';
      }
      number2 += value;
    }
    setState(() {});
  }
}
