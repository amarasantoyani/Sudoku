import 'package:flutter/material.dart';
import 'package:sudokuapp/screens/game.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _usernameController = TextEditingController();
  String _selectedLevel = 'easy';

  void _navigateToGame() {
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, insira um nome de usuário!")),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(
          username: _usernameController.text,
          level: _selectedLevel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> levelLabels = {
      "easy": "Fácil",
      "medium": "Médio",
      "hard": "Difícil",
      "expert": "Especialista"
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Nome de usuário:", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  textCapitalization: TextCapitalization.words,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.indigo),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                  ),
                ),
                const SizedBox(height: 32),

                const Text("Nível de Dificuldade:", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 16),
                Column(
                  children: ['easy', 'medium', 'hard', 'expert']
                      .map(
                        (difficulty) => Row(
                          children: [
                            Expanded(
                              child: ChoiceChip(
                                checkmarkColor: Colors.white,
                                label: Text(
                                  levelLabels[difficulty]!.toUpperCase(),
                                  style: TextStyle(
                                    color: _selectedLevel == difficulty
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                selected: _selectedLevel == difficulty,
                                onSelected: (selected) {
                                  setState(() => _selectedLevel = difficulty);
                                },
                                selectedColor: Colors.indigo,
                                backgroundColor: Colors.grey[300],
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _navigateToGame,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.indigo,
                  ),
                  child: const Text(
                    'Iniciar Jogo',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
