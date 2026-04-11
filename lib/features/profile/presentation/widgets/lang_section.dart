import 'package:flutter/material.dart';
import 'package:kickoff/core/theming/colors.dart';

class LangSection extends StatefulWidget {
  const LangSection({super.key});

  @override
  State<LangSection> createState() => _LangSectionState();
}

class _LangSectionState extends State<LangSection> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.language, color: ColorsManager.mainColor),
      title: const Text(
        'Language',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(isEnglish ? 'English' : 'Arabic'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isEnglish ? "EN" : "AR",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Switch(
            value: isEnglish,
            activeColor: ColorsManager.mainColor,
            onChanged: (value) {
              setState(() {
                isEnglish = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
