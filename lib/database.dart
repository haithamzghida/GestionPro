import 'package:frontend/database.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static final _pool = new ConnectionPool(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '',
      db: 'vitrine',
      max: 5
  );

  DatabaseHelper._privateConstructor();

  static Future<List<Map<String, dynamic>>> query(String sql, [List<dynamic> params = const []]) async {
    var conn = await _pool.getConnection();
    try {
      return await conn.query(sql, params);
    } catch (e) {
      rethrow;
    } finally {
      await conn.release();
    }
  }

  static Future<void> execute(String sql, [List<dynamic> params = const []]) async {
    var conn = await _pool.getConnection();
    try {
      await conn.query(sql, params);
    } catch (e) {
      rethrow;
    } finally {
      await conn.release();
    }
  }
}
