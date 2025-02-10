import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text; 
  final VoidCallback onPressed; 
  final Color backgroundColor; 
  final Color textColor; 
  final double fontSize; 
  final double borderRadius; 


  // Constructor
  const CustomButton({super.key, 
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.lightGreen, 
    this.textColor = Colors.white, 
    this.fontSize = 16.0, 
    this.borderRadius = 8.0,
    
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      
      child: SizedBox(
        width: MediaQuery.of(context).size.width *
                    0.9,
        child: ElevatedButton(
          
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(backgroundColor),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
          ),

          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              wordSpacing: 2
            ),
          ),
        ),
      ),
    );
  }
}