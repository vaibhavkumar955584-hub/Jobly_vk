import 'package:flutter_test/flutter_test.dart';
import 'package:job_listing_app/main.dart';

void main() {
  testWidgets('App smoke test — JobListingApp widget renders', (WidgetTester tester) async {
    await tester.pumpWidget(const JobListingApp());
    // The app should render without throwing
    expect(find.byType(JobListingApp), findsOneWidget);
  });
}
