import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/academics.dart';
import 'school_model.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => SchoolModel(), child: const EduNexoraApp()));
}

class EduNexoraApp extends StatelessWidget {
  const EduNexoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduNexora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F6F8B),
          primary: const Color(0xFF1F6F8B),
          secondary: const Color(0xFF7DCFB6),
          background: Colors.white,
        ),
      ),
      home: const SchoolGate(),
    );
  }
}

class SchoolGate extends StatelessWidget {
  const SchoolGate({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<SchoolModel>().role;
    if (role == null) return const SignInPage();
    return const CampusPage();
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController(text: 'teacher@edunexora.dev');
  final _password = TextEditingController(text: 'demo1234');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = context.watch<SchoolModel>().error;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('EduNexora',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text(
              'Demo roles: admin, teacher, student, parent, accounts @edunexora.dev. Password demo1234. Client hiding is not authorization.',
            ),
            const SizedBox(height: 16),
            TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            if (error != null) Text(error),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => context
                  .read<SchoolModel>()
                  .signIn(_email.text, _password.text),
              child: const Text('Open campus'),
            ),
          ],
        ),
      ),
    );
  }
}

class CampusPage extends StatelessWidget {
  const CampusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SchoolModel>();
    final role = model.role!;
    const book = AttendanceBook();
    final fees = const FeePlan(totalMinor: 480000, installments: 4).amounts();
    final grade = const GradeScale().letter(86);
    return Scaffold(
      appBar: AppBar(title: Text(role.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Batch: Northbridge Year 8 · Science. Fictional records.'),
          const SizedBox(height: 12),
          Text(
              'Attendance ${(book.rate(model.marks) * 100).toStringAsFixed(0)}%'),
          for (var i = 0; i < model.marks.length; i++)
            CheckboxListTile(
              value: model.marks[i],
              onChanged: canTakeAttendance(role)
                  ? (_) => context.read<SchoolModel>().toggle(i)
                  : null,
              title: Text('Session ${i + 1}'),
            ),
          Text('Sample grade for 86 is $grade.'),
          if (canViewFees(role))
            Text(
                'Fee installments: ${fees.map((n) => '\$${(n / 100).toStringAsFixed(2)}').join(', ')}')
          else
            const Text('Fee totals are hidden for this demo role.'),
          const SizedBox(height: 8),
          const Text(
              'PDF export is described in the README and not generated in this build.'),
        ],
      ),
    );
  }
}
