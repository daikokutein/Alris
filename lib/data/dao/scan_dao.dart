import 'package:floor/floor.dart';
import '../models/scan_history.dart';

@dao
abstract class ScanDao {
  @Query('SELECT * FROM ScanHistory ORDER BY timestamp DESC')
  Future<List<ScanHistory>> getAllScans();

  @Insert()
  Future<void> insertScan(ScanHistory scan);

  @Query('DELETE FROM ScanHistory WHERE id = :id')
  Future<void> deleteScan(int id);

  @Query('DELETE FROM ScanHistory')
  Future<void> clearAll();
} 