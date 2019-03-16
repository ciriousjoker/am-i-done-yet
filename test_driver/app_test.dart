// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Tests:', () {
    // First, define the Finders. We can use these to locate Widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    // final counterTextFinder = find.byValueKey('counter');
    // final buttonFinder = find.byValueKey('Sign in with Google');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Check Login working', () async {
      await driver.waitFor(find.text("Sign in with Google"));

      // => Human interaction: Login

      await driver.waitFor(find.text("Am I Done Yet"));
      // driver.tap(find.text("Sign in with Google"));
      // expect(await driver.getText(find.text("Sign in with Google")), );
    });

    test('Add list item', () async {
      String itemTitle = "Some Item";
      final textfield = find.byType("TextField");
      await driver.waitFor(textfield);
      await driver.tap(textfield);
      await driver.enterText(itemTitle);
      await driver.waitFor(find.text(itemTitle));
      await driver.enterText("\x0D"); // Enter key
      await driver.waitFor(find.text("adfgadfgadfg"));
    });
  });
}
