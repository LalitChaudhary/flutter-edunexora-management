enum Role { admin, teacher, student, parent, accountant }

class FeePlan {
  const FeePlan({required this.totalMinor, required this.installments});

  final int totalMinor;
  final int installments;

  List<int> amounts() {
    if (installments <= 0) {
      throw ArgumentError('Installments must be positive.');
    }
    final base = totalMinor ~/ installments;
    final remainder = totalMinor - base * installments;
    return [
      for (var i = 0; i < installments; i++)
        base + (i == installments - 1 ? remainder : 0),
    ];
  }
}

class AttendanceBook {
  const AttendanceBook();
  int presentOf(List<bool> marks) => marks.where((present) => present).length;

  double rate(List<bool> marks) {
    if (marks.isEmpty) return 0;
    return presentOf(marks) / marks.length;
  }
}

class GradeScale {
  const GradeScale();

  String letter(int score) {
    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    return 'F';
  }
}

bool canViewFees(Role role) =>
    role == Role.admin || role == Role.accountant || role == Role.parent;

bool canTakeAttendance(Role role) => role == Role.admin || role == Role.teacher;
