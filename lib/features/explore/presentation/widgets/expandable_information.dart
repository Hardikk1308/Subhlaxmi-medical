import 'dart:math' as math;
import 'package:flutter/material.dart';

class ExpandableTile extends StatefulWidget {
  final String title;
  final String content;
  final bool initiallyExpanded;

  const ExpandableTile({
    Key? key,
    required this.title,
    required this.content,
    this.initiallyExpanded = false,
  }) : super(key: key);

  @override
  State<ExpandableTile> createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile>
    with SingleTickerProviderStateMixin {
  late bool _isOpen;
  late AnimationController _controller;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _isOpen = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _arrowAnimation = Tween<double>(
      begin: 0,
      end: math.pi,
    ).animate(_controller);

    if (_isOpen) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      _isOpen ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _arrowAnimation,
                  builder: (context, child) => Transform.rotate(
                    angle: _arrowAnimation.value,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _isOpen
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              widget.content,
              style: TextStyle(color: Colors.grey.shade700, height: 1.5),
            ),
          ),
          secondChild: const SizedBox.shrink(),
        ),
        // const Divider(height: 0),
      ],
    );
  }
}
