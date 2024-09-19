import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final String label;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const CheckboxWidget({
    Key? key,
    required this.label,
    required this.initialValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _value,
      onChanged: (newValue) {
        setState(() {
          _value = newValue!;
          if (widget.onChanged != null) {
            widget.onChanged!(newValue!);
          }
        });
      },
    );
  }
}
