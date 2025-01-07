import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final Function onPress;
  final bool pressAttention;
  final int indexButton;
  const CustomButton({super.key, required this.label, required this.onPress, required this.indexButton, required this.pressAttention});

  @override
  State<StatefulWidget> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child:
              OutlinedButton(
              child: Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed:() {
                widget.onPress(widget.label, widget.indexButton);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 1.0, color: Colors.blue),
                backgroundColor: widget.pressAttention ? Colors.grey : Colors.black
              ),
            ),
          ),
        ),
      ),
    );
  }
}