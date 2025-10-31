import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';

class SuccessScreen extends StatefulWidget {
  final String userName;
  final String avatar;
  const SuccessScreen({
    super.key,
    required this.userName,
    this.avatar = "🙂",
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late final ConfettiController _confetti;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 5))
      ..play();
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      body: Stack(
        alignment: Alignment.center,
        children: [
          ConfettiWidget(
            confettiController: _confetti,
            blastDirectionality: BlastDirectionality.explosive,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.deepPurple,
                child: Text(
                  widget.avatar,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
              const SizedBox(height: 20),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Welcome, ${widget.userName}! 🎉',
                    textStyle: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                    speed: Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your adventure begins now!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
