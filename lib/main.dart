import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyPlantApp());
}

class MyPlantApp extends StatelessWidget {
  const MyPlantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PlantScreen(),
    );
  }
}

class PlantScreen extends StatelessWidget {
  const PlantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Affirmation Plant'),
      ),
      body: const Center(
        child: PlantWidget(),
      ),
    );
  }
}

class PlantWidget extends StatefulWidget {
  const PlantWidget({Key? key}) : super(key: key);

  @override
  PlantWidgetState createState() => PlantWidgetState();
}

class PlantWidgetState extends State<PlantWidget>
    with SingleTickerProviderStateMixin {
  bool isSpeechBubbleVisible = false;
  String affirmation = '';
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // Adjust the duration
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.8, // Adjust the rotation angle
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isSpeechBubbleVisible = true;
              affirmation = getRandomAffirmation();
              _controller.forward(from: 0.0); // Trigger rotation animation
            });

            // Stop the rotation animation after a short delay
            Future.delayed(const Duration(milliseconds: 500), () {
              _controller.reset();
            });
          },
          child: AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: Image.network(
                  'https://img.freepik.com/premium-vector/vector-houseplant-terracotta-pot-flat-illustration_646079-1986.jpg',
                  width: 300,
                  height: 300,
                ),
              );
            },
          ),
        ),
        Visibility(
          visible: isSpeechBubbleVisible,
          child: Positioned(
            top: 20,
            child: AnimatedSpeechBubble(affirmation: affirmation),
          ),
        ),
      ],
    );
  }

  String getRandomAffirmation() {
    List<String> affirmations = [
      "You are strong!",
      "You choose joy!",
      "You are confident!",
      "You are loved!",
      "You are capable!",
      "You are enough!",
      "You are grateful!",
      "You attract good!",
      "You are worthy!",
      "You are at peace!",
      "You are powerful!",
      "You are happy!",
      "You are positive!",
      "You are fearless!",
      "You are successful!",
      "You are kind!",
      "You are courageous!",
      "You are focused!",
      "You are optimistic!",
      "You are blessed!",
    ];
    return affirmations[DateTime.now().millisecondsSinceEpoch % affirmations.length];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


class AnimatedSpeechBubble extends StatefulWidget {
  final String affirmation;

  const AnimatedSpeechBubble({Key? key, required this.affirmation})
      : super(key: key);

  @override
  _AnimatedSpeechBubbleState createState() => _AnimatedSpeechBubbleState();
}

class _AnimatedSpeechBubbleState extends State<AnimatedSpeechBubble> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: 1.0,
      child: SpeechBubble(affirmation: widget.affirmation),
    );
  }
}

class SpeechBubble extends StatelessWidget {
  final String affirmation;

  const SpeechBubble({Key? key, required this.affirmation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          affirmation,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
