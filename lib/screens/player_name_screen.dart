import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class PlayerNameScreen extends StatefulWidget {
  const PlayerNameScreen({super.key});

  @override
  State<PlayerNameScreen> createState() => _PlayerNameScreenState();
}

class _PlayerNameScreenState extends State<PlayerNameScreen> {
  late final TextEditingController _player1Controller;
  late final TextEditingController _player2Controller;

  String? _player1Error;
  String? _player2Error;

  @override
  void initState() {
    super.initState();
    final gameProvider = context.read<GameProvider>();

    _player1Controller = TextEditingController(
      text: gameProvider.player1Name == 'Player 1'
          ? ''
          : gameProvider.player1Name,
    );
    _player2Controller = TextEditingController(
      text: gameProvider.player2Name == 'Player 2'
          ? ''
          : gameProvider.player2Name,
    );
  }

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

  String? _validateName(String name) {
    if (name.trim().isEmpty) return 'Name cannot be empty';
    if (name.trim().length > 50) return 'Name must be 50 characters or less';
    return null;
  }

  void _onStartGamePressed() {
    final player1Name = _player1Controller.text;
    final player2Name = _player2Controller.text;

    setState(() {
      _player1Error = _validateName(player1Name);
      _player2Error = _validateName(player2Name);
    });

    if (_player1Error != null || _player2Error != null) return;

    context.read<GameProvider>().setPlayerNames(
          player1Name.trim(),
          player2Name.trim(),
        );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Player Names'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Who is playing today?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 😎,
            const Text(
              'Enter a name for each player before starting.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _player1Controller,
              decoration: InputDecoration(
                labelText: 'Player 1  (plays X)',
                prefixIcon: const Icon(Icons.person, color: Colors.blue),
                border: const OutlineInputBorder(),
                errorText: _player1Error,
              ),
              onChanged: (_) => setState(() => _player1Error = null),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _player2Controller,
              decoration: InputDecoration(
                labelText: 'Player 2  (plays O)',
                prefixIcon: const Icon(Icons.person, color: Colors.red),
                border: const OutlineInputBorder(),
                errorText: _player2Error,
              ),
              onChanged: (_) => setState(() => _player2Error = null),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _onStartGamePressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Start Game', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
