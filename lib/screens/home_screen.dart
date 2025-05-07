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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _linkController.dispose();
    _pulseController.dispose();
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
    final primaryColor = Theme.of(context).colorScheme.primary;
    final violetColor = const Color(0xFF5E35B1); // Rich violet color
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alris AI',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: _goToHistory,
            tooltip: 'View History',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Alris AI'),
                  content: const Text(
                    'Alris AI is a concept demo for a URL analytics application. Currently, this is just a UI demonstration and does not perform actual analysis.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('CLOSE'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'About',
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
                const SizedBox(height: 40),
                
                Text(
                  'Alris AI Analytics',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDarkMode ? Colors.white : violetColor,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 500.ms),
                
                const SizedBox(height: 16),
                
                Text(
                  'Enter any link to analyze. Note: This is a UI demo and does not perform real analysis yet.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 500.ms),
                
                const SizedBox(height: 40),
                
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: violetColor.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'URL to analyze',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isDarkMode 
                                ? Colors.white70 
                                : violetColor,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _linkController,
                            decoration: InputDecoration(
                              hintText: 'https://example.com',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: Icon(
                                Icons.link_rounded,
                                color: violetColor.withOpacity(0.7),
                              ),
                              suffixIcon: _linkController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () => setState(() {
                                        _linkController.clear();
                                      }),
                                    )
                                  : null,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: violetColor,
                                  width: 2,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _saveLink(),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter a URL';
                              }
                              
                              // Simple URL validation
                              if (!value.startsWith('http://') && 
                                  !value.startsWith('https://')) {
                                return 'URL must start with http:// or https://';
                              }
                              return null;
                            },
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _saveLink,
                              icon: _isLoading 
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: isDarkMode ? Colors.black54 : Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Icon(Icons.search_rounded),
                              label: Text(_isLoading ? 'Analyzing...' : 'Analyze Now'),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: violetColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .animate()
                .fadeIn(delay: 600.ms, duration: 500.ms)
                .slideY(delay: 600.ms, begin: 0.1, end: 0, curve: Curves.easeOutQuint),
                
                const SizedBox(height: 40),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoCard(
                      icon: Icons.security_rounded,
                      title: 'AI Security',
                      description: 'Future feature: Advanced AI-based link analysis',
                      delay: 800,
                      iconColor: violetColor,
                    ),
                    const SizedBox(width: 16),
                    InfoCard(
                      icon: Icons.history_rounded,
                      title: 'History',
                      description: 'Keep track of all your previously analyzed links',
                      delay: 900,
                      onTap: _goToHistory,
                      iconColor: violetColor,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Alris AI Analytics - Concept Demo',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white38 : Colors.grey[400],
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 1200.ms, duration: 500.ms),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int delay;
  final VoidCallback? onTap;
  final Color iconColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.delay,
    this.onTap,
    this.iconColor = const Color(0xFF6366F1),
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode 
                ? Theme.of(context).colorScheme.surface
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDarkMode 
                  ? Colors.white.withOpacity(0.1) 
                  : Colors.grey[200]!,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.white60 : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    )
    .animate()
    .fadeIn(delay: Duration(milliseconds: delay), duration: 500.ms)
    .slideY(delay: Duration(milliseconds: delay), begin: 0.2, end: 0);
  }
} 