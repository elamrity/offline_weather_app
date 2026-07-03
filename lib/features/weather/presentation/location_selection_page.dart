import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:weather/features/weather/presentation/blocs/weather_event.dart';
import '../blocs/weather_bloc.dart';

class LocationSelectionPage extends StatefulWidget {
  const LocationSelectionPage({super.key});

  @override
  State<LocationSelectionPage> createState() => _LocationSelectionPageState();
}

class _LocationSelectionPageState extends State<LocationSelectionPage> {
  final List<String> _citySuggestions = [
    'Cairo', 'Alexandria', 'Giza', 'Mansoura', 'Tanta', 'Asyut', 'Luxor', 'Aswan',
    'London', 'New York', 'Paris', 'Tokyo', 'Dubai', 'Riyadh', 'Berlin', 'Rome',
    'Madrid', 'Moscow', 'Sydney', 'Toronto', 'Mumbai', 'Beijing', 'Istanbul'
  ];

  void _submitCity(String cityName) async {
    final cleanCityName = cityName.trim();
    if (cleanCityName.isNotEmpty) {
      context.read<WeatherBloc>().add(FetchWeatherEvent(cleanCityName));
      final settingsBox = Hive.box('settingsBox');
      await settingsBox.put('last_city', cleanCityName);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // جعل الـ AppBar شفاف تماماً ليمتزج مع التدرج الخلفي للمشروع
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
            'Select Location',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // مطابقة التدرج اللوني مع صفحة الـ Dashboard الأساسية تماماً لتوحيد الهوية الهندسية
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[400]!,
              Colors.blue[100]!,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }

                    // البحث داخل الاقتراحات المخزنة محلياً
                    final filtered = _citySuggestions.where((String city) {
                      return city.toLowerCase().contains(textEditingValue.text.toLowerCase());
                    }).toList();

                    // حل مشكلة عدم ظهور باقي المدن: إذا لم تكن الكلمة المكتوبة مطابقة تماماً لأي اقتراح ثابت،
                    // نضيف خيار مخصص يسمح بالبحث عن النص المكتوب أياً كان اسم المدينة
                    if (!filtered.any((city) => city.toLowerCase() == textEditingValue.text.trim().toLowerCase())) {
                      filtered.insert(0, "Search for: '${textEditingValue.text.trim()}'");
                    }

                    return filtered;
                  },
                  onSelected: (String selection) {
                    // إذا كان الخيار المختار هو خيار البحث الديناميكي المخصص، نقوم بقص الكلمة الحقيقية فقط للبحث عنها
                    if (selection.startsWith("Search for: '")) {
                      final actualCity = selection.replaceAll("Search for: '", "").replaceAll("'", "");
                      _submitCity(actualCity);
                    } else {
                      _submitCity(selection);
                    }
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                    return Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9), // مربع زجاجي ناصع يتماشى مع الـ One UI
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]
                      ),
                      child: TextField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        textInputAction: TextInputAction.search,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Enter City Name',
                          labelStyle: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w500),
                          hintText: 'e.g., Cairo, London, Tokyo',
                          hintStyle: const TextStyle(color: Colors.black38),
                          prefixIcon: const Icon(Icons.location_city, color: Colors.blueAccent),
                          border: InputBorder.none, // إخفاء خط البوردر الحاد التقليدي
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.blueAccent),
                            onPressed: () => _submitCity(textEditingController.text),
                          ),
                        ),
                        onSubmitted: (value) => _submitCity(value),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        margin: const EdgeInsets.only(top: 8.0, right: 48.0),
                        child: Material(
                          color: Colors.white,
                          elevation: 6.0,
                          shadowColor: Colors.black12,
                          borderRadius: BorderRadius.circular(20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width - 48,
                              maxHeight: 250,
                            ),
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              shrinkWrap: true,
                              itemCount: options.length,
                              separatorBuilder: (context, index) => Divider(color: Colors.grey[100], height: 1, indent: 54),
                              itemBuilder: (BuildContext context, int index) {
                                final String option = options.elementAt(index);
                                final isCustomSearch = option.startsWith("Search for:");

                                return ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: isCustomSearch ? Colors.orange[50] : Colors.blue[50],
                                        shape: BoxShape.circle
                                    ),
                                    child: Icon(
                                        isCustomSearch ? Icons.search_sharp : Icons.location_on_outlined,
                                        size: 20,
                                        color: isCustomSearch ? Colors.orangeAccent : Colors.blueAccent
                                    ),
                                  ),
                                  title: Text(
                                    option,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isCustomSearch ? FontWeight.bold : FontWeight.w500,
                                        color: isCustomSearch ? Colors.orange[800] : Colors.black87
                                    ),
                                  ),
                                  trailing: Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                                  onTap: () => onSelected(option),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // استبدال الكارت العادي بكارت زجاجي متناسق (Samsung Glassmorphism Effect)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blueAccent),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Type any city name. Selecting a suggestion or pressing search will dynamically update your dashboard and store it for offline use.',
                            style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}