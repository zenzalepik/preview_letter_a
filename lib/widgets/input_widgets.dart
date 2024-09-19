import 'package:flutter/material.dart';
import 'package:letter_a/styles/colors_style.dart';

class InputTextWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final Color? borderColor;
  final ValueChanged<String>? onChanged;

  const InputTextWidget({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.borderColor,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class InputTextAreaWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final Color? borderColor;
  final ValueChanged<String>? onChanged;

  const InputTextAreaWidget({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.borderColor,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      controller: controller,
      maxLines: null, // Set maxLines ke null untuk membuat input area
      keyboardType: TextInputType.multiline, // Set keyboardType ke multiline
      minLines: 5,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: borderColor ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class InputDateWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final Color? borderColor;
  final ValueChanged<String>? onChanged;

  const InputDateWidget({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.borderColor,
    this.onChanged,
  }) : super(key: key);

  @override
  _InputDateWidgetState createState() => _InputDateWidgetState();
}

class _InputDateWidgetState extends State<InputDateWidget> {
  late TextEditingController _textController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();
    _selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _textController.text =
            _formatDate(picked); // Format tanggal sebelum menampilkan
        if (widget.onChanged != null) {
          widget.onChanged!(_textController.text);
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: TextField(
            onTap: () => _selectDate(context),
            readOnly: true, // Buat input teks hanya bisa dibaca
            controller: _textController,
            decoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.borderColor ?? Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 8,
          top: 0,
          bottom: 0,
          child: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const CustomSearchBar({
    Key? key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8, 0, 0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(width: 2, color: LColors.borderInput),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}

class InputDropdown extends StatefulWidget {
  final List<String> options;
  final String selectedOption;
  final void Function(String?) onChanged;

  const InputDropdown({
    Key? key,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  }) : super(key: key);

  @override
  _InputDropdownState createState() => _InputDropdownState();
}

class _InputDropdownState extends State<InputDropdown> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: LColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 1, color: LColors.borderInput)),
          child: DropdownButton<String>(
            icon: Icon(Icons.home, color: Colors.white),
            value: widget.selectedOption,
            onChanged: widget.onChanged,
            items: widget.options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            underline: Container(),
          ),
        ),
        Positioned(
            right: 16, top: 0, bottom: 0, child: Icon(Icons.arrow_drop_down)),
      ],
    );
  }
}
