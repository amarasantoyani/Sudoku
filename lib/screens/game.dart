import 'package:flutter/material.dart';
import 'package:sudoku_dart/sudoku_dart.dart';

class GameScreen extends StatefulWidget {
  final String username;
  final String level;

  const GameScreen({super.key, required this.username, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Sudoku _sudokuInstance;
  late List<int> _puzzleBoard;
  late List<int> _solutionBoard;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final difficulty = {
      'easy': Level.easy,
      'medium': Level.medium,
      'hard': Level.hard,
      'expert': Level.expert,
    }[widget.level]!;

    _sudokuInstance = Sudoku.generate(difficulty);
    _puzzleBoard = List<int>.from(_sudokuInstance.puzzle);
    _solutionBoard = List<int>.from(_sudokuInstance.solution);
  }

  bool _isMoveValid(int index, int number) {
    int row = index ~/ 9;
    int col = index % 9;

    for (int i = 0; i < 9; i++) {
      if (_puzzleBoard[row * 9 + i] == number) return false;
    }

    for (int i = 0; i < 9; i++) {
      if (_puzzleBoard[i * 9 + col] == number) return false;
    }

    int startRow = row ~/ 3 * 3;
    int startCol = col ~/ 3 * 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        int blockIndex = (startRow + i) * 9 + (startCol + j);
        if (_puzzleBoard[blockIndex] == number) return false;
      }
    }
    return true;
  }

  void _verifyCompletion() {
    if (!_puzzleBoard.contains(-1)) {
      bool isComplete = true;
      for (int i = 0; i < 81; i++) {
        if (_puzzleBoard[i] != _solutionBoard[i]) {
          isComplete = false;
          break;
        }
      }

      String resultMessage = isComplete
          ? "Parabéns, você completou o jogo corretamente!"
          : "Tabuleiro incorreto. Tente novamente!";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultMessage)));
    }
  }

  Future<void> _inputNumberDialog(BuildContext context, int index) async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Escolha um número (1-9)"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: "Número"),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
            TextButton(
              onPressed: () {
                int? number = int.tryParse(controller.text);
                if (number != null && number >= 1 && number <= 9) {
                  if (_isMoveValid(index, number)) {
                    setState(() {
                      _puzzleBoard[index] = number;
                    });
                    _verifyCompletion();
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Movimento inválido!")),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Número entre 1 e 9 apenas")),
                  );
                }
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Jogador: ${widget.username}')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                  childAspectRatio: 1,
                ),
                itemCount: 81,
                itemBuilder: (context, index) {
                  bool isPreset = _sudokuInstance.puzzle[index] != -1;
                  int cellValue = _puzzleBoard[index];

                  int row = index ~/ 9;
                  int col = index % 9;

                  double leftBorder = col % 3 == 0 ? 3.0 : 0.5;
                  double topBorder = row % 3 == 0 ? 3.0 : 0.5;

                  return GestureDetector(
                    onTap: isPreset ? null : () => _inputNumberDialog(context, index),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: leftBorder),
                          top: BorderSide(width: topBorder),
                          right: const BorderSide(width: 0.5),
                          bottom: const BorderSide(width: 0.5),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cellValue == -1 ? '' : cellValue.toString(),
                        style: TextStyle(
                          color: isPreset ? Colors.black : Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
