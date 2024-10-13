import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; //

class GameState extends ChangeNotifier {
  final int gridSize = 4;
  late List<bool> cardFlipped;  // To track whether a card is flipped or not

  GameState() {
    resetGame();
  }

  void resetGame() {
    cardFlipped = List.generate(gridSize * gridSize, (_) => false);
    notifyListeners(); // Notify listeners of changes
  }

  void flipCard(int index) {
    cardFlipped[index] = !cardFlipped[index];
    notifyListeners(); // Update UI when card is flipped
  }
}




void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(), // Provide GameState to the app
      child: const MemoryGameApp(),
    ),
  );
}

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memory Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context); // Access the GameState

    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              gameState.resetGame(); // Reset the game
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gameState.gridSize,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: gameState.gridSize * gameState.gridSize,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => gameState.flipCard(index),
              child: Card(
                color: Colors.blue, // Card color (for the border)
                child: Center(
                  child: gameState.cardFlipped[index]
                      ? const Icon(Icons.face, color: Colors.white, size: 48.0) // Front of the card (flipped state)
                      : const Text(
                          'Card',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,))
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
