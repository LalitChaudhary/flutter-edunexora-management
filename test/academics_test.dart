import 'package:edunexora/domain/academics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('installments absorb the remainder on the last bill', () {
    final amounts = const FeePlan(totalMinor: 10000, installments: 3).amounts();
    expect(amounts, [3333, 3333, 3334]);
    expect(amounts.fold<int>(0, (a, b) => a + b), 10000);
  });

  test('attendance rate ignores empty books', () {
    const book = AttendanceBook();
    expect(book.rate(const []), 0);
    expect(book.presentOf(const [true, false, true]), 2);
  });

  test('grade bands and fee visibility', () {
    expect(const GradeScale().letter(86), 'B');
    expect(canViewFees(Role.student), isFalse);
    expect(canTakeAttendance(Role.teacher), isTrue);
  });
}
