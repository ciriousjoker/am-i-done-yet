import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Tests:', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Check Login working', () async {
      await driver.waitFor(find.text("Sign in with Google"));

      // => Human interaction: Login

      await driver.waitFor(find.text("Am I Done Yet"));
    });

    test('Add list item', () async {
      String itemTitle = "This isn't working. Read app_test.dart.";
      final textfield = find.byType("TextField");
      await driver.waitFor(textfield);
      await driver.tap(textfield);
      await driver.enterText(itemTitle);
      await driver.waitFor(find.text(itemTitle));
      // await driver.enterText("\x0D"); // Enter key doesn't submit it

      // Here I want to submit the text, but there's no function for that.
      // Related StackOverflow post:  https://stackoverflow.com/questions/55101120/submit-textfield-in-flutter-integration-test
      // Related Github issue:        https://github.com/flutter/flutter/issues/29450
      // Basically, I'm missing something like driver.submitTextfield(textfield)

      await driver.waitFor(find.text("KEEP APP OPEN"));
    });
  });
}
