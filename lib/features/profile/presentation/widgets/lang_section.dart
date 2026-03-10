import 'package:flutter/material.dart';

class LangSection extends StatefulWidget {
  const LangSection({super.key});

  @override
  State<LangSection> createState() => _LangSectionState();
}

class _LangSectionState extends State<LangSection> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        color: const Color.fromARGB(255, 221, 221, 221),
        child: ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          subtitle: Text(isEnglish ? 'English' : 'Arabic'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEnglish ? "EN" : "AR",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Switch(
                value: isEnglish,
                onChanged: (value) {
                  setState(() {
                    isEnglish = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
