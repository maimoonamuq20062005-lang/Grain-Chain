import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class HomeClaimPage extends StatefulWidget {
  const HomeClaimPage({super.key});

  @override
  State<HomeClaimPage> createState() => _HomeClaimPageState();
}

class _HomeClaimPageState extends State<HomeClaimPage> {
  String selectedCategory = "Fast Food";

  final Map<String, String> preservationTips = {
    "Fast Food":
        "✅ Best Ways to Save Fast Food:\n\n"
        "- Store burgers and sandwiches in an airtight container\n"
        "- Reheat in oven or air fryer to maintain crispiness\n"
        "- Avoid microwaving fries (they become soggy)\n"
        "- Consume within 24 hours\n"
        "- Keep sauces separately to prevent sogginess\n"
        "- Refrigerate immediately after buying",

    "Desi Food":
        "✅ Preserve Desi Food Properly:\n\n"
        "- Store curries in airtight containers\n"
        "- Always cool before refrigeration\n"
        "- Reheat only the portion you will eat\n"
        "- Keep roti wrapped in foil or cloth\n"
        "- Consume within 2 days\n"
        "- Avoid keeping rice at room temperature for long",

    "Fruits & Vegetables":
        "✅ Freshness Tips:\n\n"
        "- Keep leafy greens in zip bags with tissue\n"
        "- Store fruits like apples & oranges separately\n"
        "- Do not wash vegetables before storing\n"
        "- Use airtight bags for cut fruits\n"
        "- Keep potatoes & onions away from sunlight",

    "Dairy":
        "✅ Dairy Preservation:\n\n"
        "- Store milk in the back of the fridge (coldest part)\n"
        "- Keep cheese wrapped tightly\n"
        "- Yogurt must remain sealed\n"
        "- Do not freeze fresh milk\n"
        "- Consume within expiry",

    "Bakery":
        "✅ Bakery Items:\n\n"
        "- Keep bread in airtight bags\n"
        "- Refrigerate cakes with cream\n"
        "- Use foil to wrap pastries\n"
        "- Freeze bread for long-term use\n"
        "- Avoid moisture",
  };

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Preservation"),
        backgroundColor: const Color(0xFFE91E63),
        elevation: 4,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Food Category:",
              style: TextStyle(
                fontSize: SizeConfig.sp(18),
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE91E63),
              ),
            ),
            SizedBox(height: SizeConfig.hp(1.5)),

            // Dropdown
            DropdownButtonFormField(
              initialValue: selectedCategory,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Color(0xFFE91E63)),
                ),
              ),
              items: preservationTips.keys.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category, style: const TextStyle(fontSize: 16)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            SizedBox(height: SizeConfig.hp(3)),

            // Tips Card
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Text(
                    preservationTips[selectedCategory]!,
                    style: TextStyle(fontSize: SizeConfig.sp(16), height: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
