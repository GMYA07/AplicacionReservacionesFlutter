// ignore_for_file: avoid_print
// tool/insert_hotels.dart

import 'dart:io';

/// Script de consola para insertar hoteles y habitaciones de prueba en SQLite
/// Se ejecuta con: `dart run tool/insert_hotels.dart`
void main() async {
  print('\x1B[36m==========================================================\x1B[0m');
  print('\x1B[33m  🏨 INSERTAR HOTELES DE PRUEBA EN SQLITE - BOOKING APP  \x1B[0m');
  print('\x1B[36m==========================================================\x1B[0m');

  const packageName = 'com.example.booking_app';
  final sqlFile = File('tool/seed_hotels.sql');

  if (!sqlFile.existsSync()) {
    print('\x1B[31m[ERROR] No se encontró tool/seed_hotels.sql\x1B[0m');
    exit(1);
  }

  // 1. Verificar si hay dispositivo Android conectado por ADB
  try {
    final adbCheck = await Process.run('adb', ['devices']);
    final adbOutput = adbCheck.stdout.toString();
    final hasDevice = adbOutput.split('\n').any((line) => line.trim().endsWith('device'));

    if (hasDevice) {
      print('\x1B[32m[1/3] Dispositivo Android detectado mediante ADB.\x1B[0m');
      print('\x1B[36m[2/3] Verificando base de datos en la app...\x1B[0m');

      // Intentar ejecutar directamente con sqlite3 en el dispositivo
      final pushSql = await Process.run('adb', ['push', 'tool/seed_hotels.sql', '/data/local/tmp/seed_hotels.sql']);
      if (pushSql.exitCode != 0) {
        print('\x1B[31m[ERROR] No se pudo enviar el archivo SQL al dispositivo.\x1B[0m');
        exit(1);
      }

      final insertDirect = await Process.run('adb', [
        'shell',
        'cat /data/local/tmp/seed_hotels.sql | run-as $packageName sqlite3 databases/booking_app.db'
      ]);

      if (insertDirect.exitCode == 0 && !insertDirect.stderr.toString().contains('not found')) {
        print('\x1B[32m[3/3] ¡Hoteles insertados directamente en Android!\x1B[0m');
      } else {
        // Método puente seguro usando el sqlite3 local de la PC
        print('\x1B[36m[INFO] Usando sqlite3 de tu PC mediante puente seguro...\x1B[0m');
        final tempDb = File('tool/temp_booking_app.db');

        final pullResult = await Process.run('adb', [
          'exec-out',
          'run-as',
          packageName,
          'cat',
          'databases/booking_app.db'
        ], stdoutEncoding: null);

        if (pullResult.exitCode == 0 && (pullResult.stdout as List<int>).isNotEmpty) {
          await tempDb.writeAsBytes(pullResult.stdout as List<int>);

          // Ejecutar SQL localmente
          final sqlContent = await sqlFile.readAsString();
          final sqliteProcess = await Process.start('sqlite3', [tempDb.path]);
          sqliteProcess.stdin.write(sqlContent);
          await sqliteProcess.stdin.close();
          await sqliteProcess.exitCode;

          // Subir base de datos actualizada
          await Process.run('adb', ['push', tempDb.path, '/data/local/tmp/temp_booking.db']);
          await Process.run('adb', [
            'shell',
            'run-as $packageName cp /data/local/tmp/temp_booking.db databases/booking_app.db'
          ]);
          await Process.run('adb', ['shell', 'rm -f /data/local/tmp/temp_booking.db /data/local/tmp/seed_hotels.sql']);

          if (tempDb.existsSync()) tempDb.deleteSync();
          print('\x1B[32m[3/3] ¡Base de datos SQLite actualizada correctamente!\x1B[0m');
        } else {
          print('\x1B[31m[ERROR] No se pudo acceder a databases/booking_app.db. Asegúrate de abrir la app al menos una vez.\x1B[0m');
          exit(1);
        }
      }
    } else {
      print('\x1B[33m[INFO] No se detectó dispositivo Android por ADB.\x1B[0m');
      print('\x1B[36mBuscando base de datos SQLite en Windows...\x1B[0m');

      // Buscar base de datos en AppData local de Windows
      final localAppData = Platform.environment['LOCALAPPDATA'] ?? '';
      final appData = Platform.environment['APPDATA'] ?? '';
      
      File? foundDb;
      for (final dirPath in [localAppData, appData]) {
        if (dirPath.isEmpty) continue;
        final dir = Directory(dirPath);
        if (dir.existsSync()) {
          try {
            final files = dir.listSync(recursive: true, followLinks: false);
            for (final f in files) {
              if (f is File && f.path.endsWith('booking_app.db')) {
                foundDb = f;
                break;
              }
            }
          } catch (_) {}
        }
        if (foundDb != null) break;
      }

      if (foundDb != null) {
        print('\x1B[32mBase de datos encontrada en: ${foundDb.path}\x1B[0m');
        final sqlContent = await sqlFile.readAsString();
        final sqliteProcess = await Process.start('sqlite3', [foundDb.path]);
        sqliteProcess.stdin.write(sqlContent);
        await sqliteProcess.stdin.close();
        await sqliteProcess.exitCode;
        print('\x1B[32m[OK] ¡Hoteles insertados con éxito en la base de datos de Windows!\x1B[0m');
      } else {
        print('\x1B[33m[AVISO] No se encontró "booking_app.db". Conecta tu celular o emulador por ADB y vuelve a ejecutar.\x1B[0m');
        exit(1);
      }
    }
  } catch (e) {
    print('\x1B[31m[ERROR] Ocurrió una excepción: $e\x1B[0m');
    exit(1);
  }

  print('');
  print('\x1B[32m==========================================================\x1B[0m');
  print('\x1B[32m  ✅ ¡HOTELES Y HABITACIONES INSERTADOS CON ÉXITO!        \x1B[0m');
  print('\x1B[32m==========================================================\x1B[0m');
  print('\x1B[36m👉 En tu app: Desliza hacia abajo (Pull-to-refresh) o pulsa "Buscar" para ver las tarjetas en vivo.\x1B[0m\n');
}
