import 'dart:math';

class CaptchaService {
  int a = 0;
  int b = 0;
  String operator = '+';
  int answer = 0;

  final _rand = Random();

  void generate() {
    a = _rand.nextInt(9) + 1;
    b = _rand.nextInt(9) + 1;

    // randomly choose + or -
    if (_rand.nextBool()) {
      operator = '+';
      answer = a + b;
    } else {
      // ensure no negative results
      if (a < b) {
        final temp = a;
        a = b;
        b = temp;
      }
      operator = '-';
      answer = a - b;
    }
  }

  bool validate(String input) {
    return int.tryParse(input) == answer;
  }
}

