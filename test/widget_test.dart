import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/main.dart';
import 'package:tic_tac_toe/providers/auth_provider.dart';
import 'package:tic_tac_toe/providers/game_provider.dart';
import 'package:tic_tac_toe/providers/history_provider.dart';

void main() {
  testWidgets('App shows login screen when logged out', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => GameProvider()),
          ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ],
        child: const TicTacToeApp(),
      ),
    );

    expect(find.text('Tic Tac Toe'), findsOneWidget);
  });
}
