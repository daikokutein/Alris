import 'package:floor/floor.dart';

@entity
class ScanHistory {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  
  final String link;
  final String description;
  final DateTime timestamp;

  ScanHistory({
    this.id,
    required this.link,
    required this.description,
    required this.timestamp,
  });
} 