import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'data/database/app_database.dart';
import 'data/models/scan_history.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Set system UI overlay style (status bar color for Android)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF3F51B5),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  
  // Initialize database (with platform-specific handling)
  try {
    final database = await AppDatabase.getInstance();
    runApp(MyApp(database: database));
  } catch (e) {
    print('Error initializing database: $e');
    // Fall back to a version without database if there's an error (mainly for web)
    runApp(const MyApp(database: null));
  }
}

class MyApp extends StatelessWidget {
  final AppDatabase? database;
  
  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan History',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        useMaterial3: true, // Use Material 3 design
        appBarTheme: const AppBarTheme(
          elevation: 2,
          centerTitle: true,
          backgroundColor: Color(0xFF3F51B5),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3F51B5),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3F51B5),
            foregroundColor: Colors.white,
          ),
        ),
        listTileTheme: const ListTileThemeData(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      home: database != null 
          ? ScanHistoryScreen(database: database!) 
          : const WebFallbackScreen(),
    );
  }
}

// Fallback screen for web platform
class WebFallbackScreen extends StatelessWidget {
  const WebFallbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History - Web'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.amber),
            const SizedBox(height: 20),
            const Text(
              'SQLite database has limited support on web platform',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'For full functionality, please run this app on Android, iOS or desktop.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a simulation. For full functionality, use Android/iOS/desktop.'))
                );
              },
              child: const Text('Simulate Adding Scan'),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanHistoryScreen extends StatefulWidget {
  final AppDatabase database;
  
  const ScanHistoryScreen({Key? key, required this.database}) : super(key: key);

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> with SingleTickerProviderStateMixin {
  List<ScanHistory> _scans = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadScans();
    
    // Optimize app on Android - use HapticFeedback
    if (!kIsWeb && Theme.of(context).platform == TargetPlatform.android) {
      HapticFeedback.lightImpact();
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadScans() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get all scans from the database
      final scans = await widget.database.scanDao.getAllScans();
      
      setState(() {
        _scans = scans;
        _isLoading = false;
      });
      
      // Print scans to console
      if (scans.isEmpty) {
        print('No scans found in database');
      } else {
        print('Found ${scans.length} scans:');
        for (final scan in scans) {
          print('ID: ${scan.id}, Link: ${scan.link}, Description: ${scan.description}, Time: ${scan.timestamp}');
        }
      }
    } catch (e) {
      print('Error loading scans: $e');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading scans: $e'))
        );
      }
    }
  }

  Future<void> _addDummyScan() async {
    try {
      final scan = ScanHistory(
        link: 'https://example.com',
        description: 'Test link',
        timestamp: DateTime.now(),
      );
      
      // Add haptic feedback for Android
      if (!kIsWeb && Theme.of(context).platform == TargetPlatform.android) {
        HapticFeedback.mediumImpact();
      }
      
      await widget.database.scanDao.insertScan(scan);
      print('Added dummy scan: ${scan.link}');
      
      _loadScans();
      
      // Show material-style confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scan added successfully'),
            backgroundColor: Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    } catch (e) {
      print('Error adding scan: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding scan: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    }
  }

  Future<void> _clearAllScans() async {
    try {
      // Add haptic feedback for Android
      if (!kIsWeb && Theme.of(context).platform == TargetPlatform.android) {
        HapticFeedback.heavyImpact();
      }
      
      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Clear All Scans'),
          content: const Text('Are you sure you want to delete all scans? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('CLEAR ALL', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      
      if (confirmed != true) return;
      
      await widget.database.scanDao.clearAll();
      print('Cleared all scans');
      
      _loadScans();
      
      // Show material-style confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All scans cleared'),
            backgroundColor: Color(0xFF9E9E9E),
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    } catch (e) {
      print('Error clearing scans: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error clearing scans: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan History${kIsWeb ? ' - Web' : ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _clearAllScans,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _scans.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.history, size: 80, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'No scans yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Add a test scan to get started',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('ADD TEST SCAN'),
                        onPressed: _addDummyScan,
                      ),
                    ],
                  ),
                )
              : AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return ListView.builder(
                      itemCount: _scans.length,
                      itemBuilder: (context, index) {
                        final scan = _scans[index];
                        // Use staggered animation for list items
                        Future.delayed(Duration(milliseconds: 50 * index), () {
                          if (_animationController.status != AnimationStatus.completed) {
                            _animationController.forward();
                          }
                        });
                        
                        return FadeTransition(
                          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _animationController,
                              curve: Interval((1 / _scans.length) * index, 1.0, curve: Curves.easeOut),
                            ),
                          ),
                          child: SlideTransition(
                            position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval((1 / _scans.length) * index, 1.0, curve: Curves.easeOut),
                              ),
                            ),
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              elevation: 2,
                              child: ListTile(
                                title: Text(
                                  scan.link,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(scan.description),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${scan.timestamp.day}/${scan.timestamp.month}/${scan.timestamp.year} ${scan.timestamp.hour}:${scan.timestamp.minute.toString().padLeft(2, '0')}',
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () async {
                                    if (scan.id != null) {
                                      try {
                                        // Add haptic feedback for Android
                                        if (!kIsWeb && Theme.of(context).platform == TargetPlatform.android) {
                                          HapticFeedback.lightImpact();
                                        }
                                        
                                        await widget.database.scanDao.deleteScan(scan.id!);
                                        _loadScans();
                                        
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Scan deleted'),
                                              behavior: SnackBarBehavior.floating,
                                              duration: Duration(seconds: 1),
                                            )
                                          );
                                        }
                                      } catch (e) {
                                        print('Error deleting scan: $e');
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Error deleting scan: $e'),
                                              backgroundColor: Colors.red,
                                              behavior: SnackBarBehavior.floating,
                                            )
                                          );
                                        }
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDummyScan,
        child: const Icon(Icons.add),
        tooltip: 'Add Test Scan',
      ),
    );
  }
} 