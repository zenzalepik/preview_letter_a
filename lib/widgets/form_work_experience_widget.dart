import 'package:flutter/material.dart';
import 'package:letter_a/models/work_experience_model.dart';
import 'package:letter_a/styles/typography_style.dart';
import 'package:letter_a/widgets/gap_column_input_style.dart';
import 'package:letter_a/widgets/input_widgets.dart';

class ExperienceForm extends StatefulWidget {
  final WorkExperience experience;
  final VoidCallback onRemove;
  final List<String> years;

  ExperienceForm({
    required this.experience,
    required this.onRemove,
    required this.years,
  });

  @override
  State<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends State<ExperienceForm> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Year Start',
                        textAlign: TextAlign.left, style: LText.description()),
                    InputDropdown(
                      options: widget.years,
                      selectedOption: widget.experience.yearStart.isEmpty
                          ? widget.years[0]
                          : widget.experience.yearStart,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            widget.experience.yearStart = value;
                          });
                        }
                      },
                    ),
                  ],
                )),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Year End',
                        textAlign: TextAlign.left, style: LText.description()),
                    InputDropdown(
                      options: widget.years,
                      selectedOption: widget.experience.yearEnd.isEmpty
                          ? widget.years[0]
                          : widget.experience.yearEnd,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            widget.experience.yearEnd = value;
                          });
                        }
                      },
                    ),
                  ],
                )),
              ],
            ),
            GapCInput(),
            Row(
              children: [
                Expanded(
                    child: InputTextWidget(
                  labelText: 'Job Title',
                  hintText: 'Finance Admin',
                  borderColor: Colors.blue, // Opsional: mengatur warna border
                  onChanged: (value) {
                    widget.experience.jobTitle = value;
                  },
                )),
              ],
            ),
            GapCInput(),
            Row(
              children: [
                Expanded(
                    child: InputTextWidget(
                  labelText: 'Company',
                  hintText: 'PT. Bumi Bermanfaat',
                  borderColor: Colors.blue, // Opsional: mengatur warna border
                  onChanged: (value) {
                    widget.experience.company = value;
                  },
                )),
              ],
            ),
            GapCInput(),
            Row(
              children: [
                Expanded(
                    child: InputTextAreaWidget(
                  labelText: 'Description',
                  hintText: 'Description.....',
                  borderColor: Colors.blue, // Opsional: mengatur warna border

                  onChanged: (value) {
                    widget.experience.description = value;
                  },
                )),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: widget.onRemove,
              child: Text('Remove'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
