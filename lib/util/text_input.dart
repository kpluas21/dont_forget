import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class IntFormField extends StatefulWidget {
  final String initialValue;
  final String labelText;
  final Function(String?) onSaved;

  const IntFormField({
    super.key,
    required this.initialValue,
    required this.labelText,
    required this.onSaved,
  });

  @override
  IntFormFieldState createState() => IntFormFieldState();
}

class IntFormFieldState extends State<IntFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(labelText: widget.labelText),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (value) {
          if (value!.isEmpty) {
            return '${widget.labelText} missing';
          }
          return null;
        },
        onSaved: (value) {
          widget.onSaved(value);
        },
      ),
    );
  }
}
