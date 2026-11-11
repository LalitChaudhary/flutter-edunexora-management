import 'package:edunexora/main.dart';
import 'package:edunexora/school_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('teacher sees attendance controls', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
          create: (_) => SchoolModel(), child: const EduNexoraApp()),
    );
    await tester.tap(find.text('Open campus'));
    await tester.pumpAndSettle();
    expect(find.text('Session 1'), findsOneWidget);
  });
}
