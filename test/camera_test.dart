import 'package:logging/logging.dart';
import 'package:raylib_dart/src/structs.dart';
import 'package:test/test.dart';

void main() {
  test('Camera2D finalizer free', () async {
    Logger.root.level = Level.ALL;

    expectLater(
      Logger.root.onRecord,
      emitsThrough(
        predicate<LogRecord>(
          (rec) =>
              rec.loggerName == 'camera' &&
              rec.message.contains('Camera2D pointer freed at'),
        ),
      ),
    );

    // 产生很多 Camera2D，让 GC 有理由去回收
    for (var i = 0; i < 1000; i++) {
      Camera2D();
    }

    // 🧩 Step 1: 一个微任务先执行（让 Finalizer callback 排队）
    await Future<void>.delayed(Duration.zero);
    // 🧩 Step 2: 再等一点点，让 GC 有机会跑
    await Future<void>.delayed(const Duration(milliseconds: 300));
  });
}
