import 'package:flutter/material.dart';

class DragDropScreen extends StatefulWidget {
  const DragDropScreen({super.key});

  @override
  State<DragDropScreen> createState() => _DragDropScreenState();
}

class _DragDropScreenState extends State<DragDropScreen> {
  final List<Color> ballColors = [Colors.red, Colors.blue, Colors.green];
  late Map<Color, bool> matched;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    matched = {for (var color in ballColors) color: false};
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Drag & Drop Balls"),
        centerTitle: true,
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: "Reset Game",
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // الكرات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ballColors.map((color) {
              return matched[color] == true
                  ? const SizedBox(width: 60, height: 60)
                  : Draggable<Color>(
                      data: color,
                      feedback: _buildBall(color, 60, withShadow: true),
                      childWhenDragging: _buildBall(color.withOpacity(0.3), 60),
                      child: _buildBall(color, 60),
                    );
            }).toList(),
          ),

          const SizedBox(height: 50),

          // الصناديق
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ballColors.map((color) {
              return DragTarget<Color>(
                onWillAccept: (data) => true,
                onAccept: (data) {
                  setState(() {
                    if (data == color) {
                      matched[color] = true;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Great! Matched ${_colorName(color)}"),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Oops! That doesn't match ${_colorName(color)}"),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    }
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  bool isHovering = candidateData.isNotEmpty;

                  Color lightShade = color.withOpacity(0.2);
                  Color darkShade = color.withOpacity(1);

                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: matched[color] == true ? darkShade : lightShade,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: color, width: 3),
                    ),
                    child: Center(
                      child: matched[color] == true
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 30)
                          : (isHovering
                              ? Icon(Icons.arrow_downward,
                                  color: color, size: 32)
                              : const SizedBox()),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBall(Color color, double size, {bool withShadow = false}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ]
            : [],
      ),
    );
  }

  String _colorName(Color color) {
    if (color == Colors.red) return "Red";
    if (color == Colors.blue) return "Blue";
    if (color == Colors.green) return "Green";
    return "Color";
  }
}
