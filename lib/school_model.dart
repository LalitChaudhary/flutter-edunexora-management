import 'package:flutter/foundation.dart';

import 'domain/academics.dart';

class SchoolModel extends ChangeNotifier {
  Role? role;
  String? error;
  final marks = <bool>[true, true, false, true, true];

  void signIn(String email, String password) {
    const directory = {
      'admin@edunexora.dev': Role.admin,
      'teacher@edunexora.dev': Role.teacher,
      'student@edunexora.dev': Role.student,
      'parent@edunexora.dev': Role.parent,
      'accounts@edunexora.dev': Role.accountant,
    };
    if (password != 'demo1234' || !directory.containsKey(email.trim())) {
      error = 'Use one of the five demo roles. Password is demo1234.';
      notifyListeners();
      return;
    }
    role = directory[email.trim()];
    error = null;
    notifyListeners();
  }

  void toggle(int index) {
    if (role == null || !canTakeAttendance(role!)) return;
    marks[index] = !marks[index];
    notifyListeners();
  }
}
