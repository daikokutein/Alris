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
    final logoColor = const Color(0xFF00E5FF); // Using the cyan color from the logo
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                logoColor, 
                BlendMode.srcIn
              ),
            ),
            const SizedBox(width: 8),
            const Text('Alris'),
          ],
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
                  title: const Text('About Alris'),
                  content: const Text(
                    'Alris is a privacy-focused URL analyzer that helps you check links safely.',
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
                const SizedBox(height: 20),
                // Logo container with dark background
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: isDarkMode 
                        ? const Color(0xFF1A0F3C) 
                        : const Color(0xFF2D1B69),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: logoColor.withOpacity(0.3),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow effect behind the logo
                            Container(
                              width: 160 + (_pulseController.value * 15),
                              height: 160 + (_pulseController.value * 15),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: logoColor.withOpacity(0.3 + (_pulseController.value * 0.2)),
                                    blurRadius: 30 + (_pulseController.value * 20),
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                            // Actual logo
                            Hero(
                              tag: 'logo',
                              child: SvgPicture.asset(
                                'assets/images/logo.svg',
                                width: 140 + (_pulseController.value * 10),
                                height: 140 + (_pulseController.value * 10),
                                colorFilter: ColorFilter.mode(
                                  logoColor,
                                  BlendMode.srcIn
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 800.ms)
                .scale(
                  begin: const Offset(0.7, 0.7), 
                  end: const Offset(1, 1),
                  duration: 1000.ms,
                  curve: Curves.easeOutBack
                ),
                
                const SizedBox(height: 32),
                
                Text(
                  'Smart URL Analysis',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDarkMode ? Colors.white : const Color(0xFF1A0F3C),
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 500.ms),
                
                const SizedBox(height: 16),
                
                Text(
                  'Enter any link and Alris will analyze it for potential security threats.',
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
                        color: logoColor.withOpacity(0.15),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'URL to analyze',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isDarkMode 
                                ? Colors.white70 
                                : const Color(0xFF2D1B69),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _linkController,
                            decoration: InputDecoration(
                              hintText: 'https://example.com',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: Icon(
                                Icons.link_rounded,
                                color: logoColor.withOpacity(0.7),
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
                                  color: logoColor,
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
                          const SizedBox(height: 24),
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
                                backgroundColor: logoColor,
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
                
                const SizedBox(height: 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoCard(
                      icon: Icons.security_rounded,
                      title: 'Secure',
                      description: 'Your data stays private and never leaves your device',
                      delay: 800,
                      iconColor: logoColor,
                    ),
                    const SizedBox(width: 16),
                    InfoCard(
                      icon: Icons.history_rounded,
                      title: 'History',
                      description: 'Keep track of all your previously analyzed links',
                      delay: 900,
                      onTap: _goToHistory,
                      iconColor: logoColor,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Alris - Smart URL Analysis',
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
          padding: const EdgeInsets.all(16),
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
              const SizedBox(height: 4),
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