import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'history_screen.dart';
import '../ai_models/ai_analyzer.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String _url = '';
  bool _isLoading = true;
  late final AnalysisResult _result;

  @override
  void initState() {
    super.initState();
    _loadLatestUrl();
  }

  Future<void> _loadLatestUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final linksJson = prefs.getStringList('links') ?? [];
      
      if (linksJson.isNotEmpty) {
        final latestLink = jsonDecode(linksJson.last) as Map<String, dynamic>;
        _url = latestLink['url'] as String;
        
        // Simulate AI analysis with the dummy analyzer
        final analyzer = DummyAIAnalyzer();
        _result = await analyzer.analyzeUrl(_url);
      }
    } catch (e) {
      debugPrint('Error loading URL: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _launchDummyHelp(BuildContext context) async {
    const url = 'https://example.com/help';
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open help center'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final violetColor = const Color(0xFF5E35B1); // Rich violet color
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analysis Results',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: violetColor,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Analyzing URL...',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '(Demo: No actual analysis is performed)',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: isDarkMode ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUrlCard(context)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.1, end: 0),

                    const SizedBox(height: 24),

                    _buildStatusHeader(context)
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 24),

                    _buildSecurityCard(context)
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 24),

                    _buildDetailCard(context)
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 400.ms)
                      .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 40),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Back to Home'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: isDarkMode
                                    ? Colors.white24
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HistoryScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.history),
                            label: const Text('View History'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(delay: 800.ms, duration: 400.ms),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildUrlCard(BuildContext context) {
    final violetColor = const Color(0xFF5E35B1); // Rich violet color
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1) 
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: violetColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.link_rounded,
                color: violetColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analyzed URL',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode 
                          ? Colors.white70 
                          : violetColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _url,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode 
                          ? Colors.white 
                          : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.content_copy,
                color: violetColor.withOpacity(0.7),
                size: 20,
              ),
              onPressed: () {
                // Copy URL to clipboard - functionality would be implemented here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('URL copied to clipboard'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context) {
    final safetyColor = _result.safetyScore > 80 
        ? Colors.green 
        : _result.safetyScore > 50 
            ? Colors.orange 
            : Colors.red;
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final violetColor = const Color(0xFF5E35B1); // Rich violet color
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: safetyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: safetyColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: safetyColor,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    _result.isSafe ? Icons.check_circle : Icons.warning_rounded,
                    color: safetyColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _result.isSafe ? 'Safe to Visit' : 'Potentially Unsafe',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: safetyColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Safety Score: ${_result.safetyScore}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: _result.safetyScore / 100,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(safetyColor),
              borderRadius: BorderRadius.circular(10),
              minHeight: 8,
            ),
            const SizedBox(height: 12),
            Text(
              'Note: This is a demo with simulated results',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: isDarkMode ? Colors.white38 : Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.security,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Safety Score',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSafetyMeter(context, _result.safetyScore),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _result.categories.map((category) => 
                Chip(
                  label: Text(category),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.5),
                  side: BorderSide.none,
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyMeter(BuildContext context, int score) {
    Color getScoreColor(int value) {
      if (value > 80) return Colors.green;
      if (value > 50) return Colors.orange;
      return Colors.red;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Safety Level',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              '$score/100',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: getScoreColor(score),
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(getScoreColor(score)),
            minHeight: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Analysis Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            if (_result.warnings.isNotEmpty) ...[
              Text(
                'Warnings',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(_result.warnings.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _result.warnings[index],
                          style: TextStyle(
                            color: isDarkMode 
                                ? Colors.white70 
                                : Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
            ],
            Text(
              'Explanation',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _result.explanation,
              style: TextStyle(
                color: isDarkMode 
                    ? Colors.white70 
                    : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _launchDummyHelp(context),
              icon: const Icon(Icons.help_outline),
              label: const Text('Learn More'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 12, 
                  horizontal: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 