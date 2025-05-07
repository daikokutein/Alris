import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:convert';
import 'result_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _saveLink() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final linksJson = prefs.getStringList('links') ?? [];
      
      final newLink = {
        'url': _linkController.text.trim(),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'description': 'No description available',
      };
      
      linksJson.add(jsonEncode(newLink));
      await prefs.setStringList('links', linksJson);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResultScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving link: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _goToHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alris'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _goToHistory,
            tooltip: 'View History',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 120,
                  height: 120,
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.2, end: 0, curve: Curves.easeOutQuad),
                
                const SizedBox(height: 30),
                
                Text(
                  'Enter a URL to analyze',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 500.ms),
                
                const SizedBox(height: 16),
                
                Text(
                  'Paste a link below and we\'ll scan it for you',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 500.ms),
                
                const SizedBox(height: 40),
                
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _linkController,
                          decoration: InputDecoration(
                            labelText: 'URL',
                            hintText: 'https://example.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Icons.link),
                            suffixIcon: _linkController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => setState(() {
                                      _linkController.clear();
                                    }),
                                  )
                                : null,
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _saveLink(),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a URL';
                            }
                            return null;
                          },
                          onChanged: (_) => setState(() {}),
                        ),
                      ],
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 500.ms)
                .slideY(delay: 600.ms, begin: 0.1, end: 0),
                
                const SizedBox(height: 40),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _saveLink,
                    icon: _isLoading 
                        ? Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(Icons.search),
                    label: Text(_isLoading ? 'Processing...' : 'Analyze Now'),
                  ),
                )
                .animate()
                .fadeIn(delay: 800.ms, duration: 500.ms),
                
                const SizedBox(height: 20),
                
                TextButton.icon(
                  onPressed: _goToHistory,
                  icon: const Icon(Icons.history),
                  label: const Text('View History'),
                )
                .animate()
                .fadeIn(delay: 1000.ms, duration: 500.ms),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 