import 'package:flutter/material.dart';

class ProgressTracker extends StatefulWidget {
  final int progress; // 0..100
  const ProgressTracker({super.key, required this.progress});

  @override
  State<ProgressTracker> createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  String _message = "Let's get started!";
  int _lastBucket = -1;

  static String _milestoneText(int pct) {
    if (pct >= 100) return "Ready for adventure!";
    if (pct >= 75)  return "Almost done!";
    if (pct >= 50)  return "Halfway there!";
    if (pct >= 25)  return "Great start!";
    return "Let's get started!";
  }

  int _bucket(int p) {
    if (p >= 100) return 100;
    if (p >= 75)  return 75;
    if (p >= 50)  return 50;
    if (p >= 25)  return 25;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _anim = Tween<double>(begin: 0, end: widget.progress.toDouble())
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.forward();
    _message = _milestoneText(widget.progress);
    _lastBucket = _bucket(widget.progress);
  }

  @override
  void didUpdateWidget(covariant ProgressTracker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _anim = Tween<double>(
      begin: oldWidget.progress.toDouble(),
      end: widget.progress.toDouble(),
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl
      ..reset()
      ..forward();

    final b = _bucket(widget.progress);
    if (b != _lastBucket) {
      setState(() {
        _message = _milestoneText(widget.progress);
        _lastBucket = b;
      });
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final pct = _anim.value.clamp(0, 100);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _message,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                minHeight: 10,
                value: pct / 100.0,
                backgroundColor: Colors.deepPurple.shade100,
                valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${pct.toStringAsFixed(0)}% completed',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        );
      },
    );
  }
}
