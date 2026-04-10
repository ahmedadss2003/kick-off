import 'package:flutter/material.dart';
import 'package:kickoff/features/auth_screen/presentation/ui/widgets/auth_text_form_field.dart';
import 'package:kickoff/features/stadiums/data/models/stadium_model.dart';
import 'package:kickoff/features/stadiums/presentation/ui/widgets/stadium_card.dart';

/// Full grid of all stadiums (2 per row). Opened from home via "عرض الكل".
/// Search bar hits `GET user/fields/search?search=...`.
class AllStadiumsScreen extends StatefulWidget {
  static const String routeName = '/stadiums-all';

  final List<StadiumModel> stadiums;

  const AllStadiumsScreen({super.key, required this.stadiums});

  @override
  State<AllStadiumsScreen> createState() => _AllStadiumsScreenState();
}

class _AllStadiumsScreenState extends State<AllStadiumsScreen> {
  late final List<StadiumModel> _initial;
  late List<StadiumModel> _shown;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _initial = List<StadiumModel>.from(widget.stadiums);
    _shown = List<StadiumModel>.from(widget.stadiums);
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) {
      if (_shown.length != _initial.length) {
        setState(() {
          _shown = List<StadiumModel>.from(_initial);
        });
      } else {
        setState(() {}); // Rebuild for UI updates (e.g. show/hide clear icon)
      }
      return;
    }

    final filtered = _initial.where((s) {
      final nameMatches = s.name?.toLowerCase().contains(q) ?? false;
      final addressMatches = s.address?.toLowerCase().contains(q) ?? false;
      return nameMatches || addressMatches;
    }).toList();

    setState(() {
      _shown = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
        title: const Text(
          'كل الملاعب',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: AuthTextFormField(
              hintText: 'ابحث عن ملعب بالاسم أو العنوان...',
              controller: _searchController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              prefixIcon: const Icon(Icons.search, color: Color(0xFF757575)),
              validator: (_) => null,
              onFieldSubmitted: (_) => FocusManager.instance.primaryFocus?.unfocus(),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Color(0xFF757575)),
                      onPressed: _clearSearch,
                    ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Color(0xFF2E7D32)),
                    onPressed: () => FocusManager.instance.primaryFocus?.unfocus(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _shown.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.trim().isEmpty
                          ? 'لا توجد ملاعب'
                          : 'لا توجد نتائج للبحث',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.58,
                    ),
                    itemCount: _shown.length,
                    itemBuilder: (context, index) {
                      return StadiumCard(
                        stadium: _shown[index],
                        index: index,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
