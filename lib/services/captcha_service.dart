import 'dart:math';

class CaptchaService {
  late int a, b, answer;
  late String operator;

  void generate() {
    final r = Random();
    a = r.nextInt(9) + 1;
    b = r.nextInt(9) + 1;
    operator = r.nextBool() ? "+" : "-";
    answer = operator == "+" ? a + b : a - b;
  }

  bool validate(String input) {
    return int.tryParse(input) == answer;
  }
}
