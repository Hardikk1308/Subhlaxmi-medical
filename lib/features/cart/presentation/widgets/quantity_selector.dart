import 'package:flutter/material.dart';

// You'll likely define these colors in a separate theme file or globally
const Color _primaryColor = Color(0xFF4CAF50); // A green shade
const Color _primaryLight = Color(0xFFE8F5E9); // Lighter green
const Color _iconColor = Color(0xFF4CAF50); // Icon color
const Color _textColor = Colors.black87; // Text color

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int>?
  onQuantityChanged; // Callback for when quantity changes
  final int minQuantity;
  final int maxQuantity;

  const QuantitySelector({
    super.key,
    this.initialQuantity = 1,
    this.onQuantityChanged,
    this.minQuantity = 1,
    this.maxQuantity = 99, // Sensible default max
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.initialQuantity;
  }

  void _decrementQuantity() {
    if (_currentQuantity > widget.minQuantity) {
      setState(() {
        _currentQuantity--;
      });
      widget.onQuantityChanged?.call(_currentQuantity);
    }
  }

  void _incrementQuantity() {
    if (_currentQuantity < widget.maxQuantity) {
      setState(() {
        _currentQuantity++;
      });
      widget.onQuantityChanged?.call(_currentQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _primaryLight, // Lighter background for the selector
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Keep the row compact
        children: [
          IconButton(
            constraints: const BoxConstraints(), // Remove default padding
            padding: EdgeInsets.zero,
            icon: Icon(Icons.remove, color: _iconColor, size: 20),
            onPressed: _decrementQuantity,
            // Disable if at min quantity
            color: _currentQuantity <= widget.minQuantity
                ? Colors.grey
                : _iconColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '$_currentQuantity',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
          ),
          IconButton(
            constraints: const BoxConstraints(), // Remove default padding
            padding: EdgeInsets.zero,
            icon: Icon(Icons.add, color: _iconColor, size: 20),
            onPressed: _incrementQuantity,
            // Disable if at max quantity
            color: _currentQuantity >= widget.maxQuantity
                ? Colors.grey
                : _iconColor,
          ),
        ],
      ),
    );
  }
}
