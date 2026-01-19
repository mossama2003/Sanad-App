import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/app_text_style.dart';

class SelectableSkillsWidget extends StatefulWidget {
  final List<String> skills;
  final String title;
  final ValueChanged<List<String>>? onSelectionChanged;

  const SelectableSkillsWidget({
    super.key,
    required this.skills,
    this.title = 'Skills & Interests',
    this.onSelectionChanged,
  });

  @override
  State<SelectableSkillsWidget> createState() =>
      _SelectableSkillsWidgetState();
}

class _SelectableSkillsWidgetState extends State<SelectableSkillsWidget> {
  final List<String> selectedSkills = [];

  void _toggleSkill(String skill) {
    setState(() {
      if (selectedSkills.contains(skill)) {
        selectedSkills.remove(skill);
      } else {
        selectedSkills.add(skill);
      }
    });

    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged!(selectedSkills);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty)
          Text(widget.title, style: TextStyle(color: AppColors.grey700).xs),
        SizedBox(height: AppSize.getHeight(8)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.skills.map((skill) {
            final isSelected = selectedSkills.contains(skill);
            return GestureDetector(
              onTap: () => _toggleSkill(skill),
              child: Container(
                padding: AppSize.padding(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                ),
                child: Text(
                  skill,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.black,
                    fontSize: AppSize.font(14),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
