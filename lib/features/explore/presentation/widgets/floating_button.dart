import 'package:flutter/material.dart';
import 'package:mediecom/core/style/app_colors.dart';

class FloatingCartButton extends StatefulWidget {
  final int itemCount;
  // final double totalAmount;
  final VoidCallback onTap;

  const FloatingCartButton({
    super.key,
    required this.itemCount,
    // required this.totalAmount,
    required this.onTap,
  });

  @override
  State<FloatingCartButton> createState() => _FloatingCartButtonState();
}

class _FloatingCartButtonState extends State<FloatingCartButton> {
  late bool istrue;

  @override
  void initState() {
    super.initState();
    // Start expanded if there are items
    istrue = widget.itemCount > 0;
  }

  void setIstrue() {
    setState(() {
      istrue = !istrue;
    });
  }

  @override
  void didUpdateWidget(FloatingCartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep expanded when items are in cart
    if (widget.itemCount > 0) {
      if (!istrue) {
        setState(() {
          istrue = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 1.0),
          child: GestureDetector(
            onTap: istrue ? widget.onTap : setIstrue,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colours.primaryColor,
                borderRadius: BorderRadius.circular(38),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: istrue
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Cart icon
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Texts
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "View cart",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${widget.itemCount} items  ",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 20),

                        // Arrow
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.white,
                        ),
                      ],
                    )
                  : // Cart icon
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
