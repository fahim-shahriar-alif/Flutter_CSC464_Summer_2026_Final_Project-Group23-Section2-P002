import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/player_name_screen.dart';
import '../screens/login_screen.dart';

class GameControlsWidget extends StatelessWidget {
  const GameControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildButton(
            label: 'Reset',
            icon: Icons.refresh,
            color: Colors.deepPurple,
            onPressed: () => context.read<GameProvider>().resetBoard(),
          ),
          _buildButton(
            label: 'Switch Starter',
            icon: Icons.swap_horiz,
            color: Colors.indigo,
            onPressed: () =>
                context.read<GameProvider>().switchStartingPlayer(),
          ),
          _buildButton(
            label: 'Change Names',
            icon: Icons.edit,
            color: Colors.teal,
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PlayerNameScreen()),
            ),
          ),
          _buildButton(
            label: 'Logout',
            icon: Icons.logout,
            color: Colors.red.shade600,
            onPressed: () => _onLogoutPressed(context),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
    );
  }

  Future<void> _onLogoutPressed(BuildContext context) async {
    try {
      await context.read<AuthProvider>().signOut();
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign out failed. Please try again.')),
      );
    }
  }
}