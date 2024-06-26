// ignore_for_file: use_key_in_widget_constructors, file_names, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigation_builder/navigation_builder.dart';

final _navigator = NavigationBuilder.create(routes: {
  '/': (data) {
    return Scaffold(
      body: Builder(
        builder: (ctx) {
          context = ctx;
          return Container();
        },
      ),
      drawer: Text('Drawer'),
      endDrawer: Text('EndDrawer'),
    );
  },
  '/page2': (data) {
    return Scaffold(
      body: Builder(
        builder: (ctx) {
          context = ctx;
          return Container();
        },
      ),
      drawer: Text('Drawer of page2'),
      endDrawer: Text('EndDrawer of page2'),
    );
  },
});
BuildContext? context;

void main() {
  setUp(() {
    context = null;
  });
  testWidgets('Throw exception no scaffold', (tester) async {
    final widget = MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (ctx) {
            context = ctx;
            return Container();
          },
        ),
      ),
    );

    await tester.pumpWidget(widget);
    expect(() => _navigator.scaffold.scaffoldState, throwsException);
    expect(
        () => _navigator.scaffold.scaffoldMessengerState, throwsAssertionError);

    _navigator.scaffold.context = context!;
    expect(_navigator.scaffold.scaffoldState, isNotNull);
    expect(_navigator.scaffold.scaffoldMessengerState, isNotNull);
  });

  testWidgets('showBottomSheet', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerDelegate: _navigator.routerDelegate,
        routeInformationParser: _navigator.routeInformationParser,
      ),
    );
    _navigator.scaffold.context = context!;
    _navigator.scaffold.showBottomSheet(
      Text('showBottomSheet'),
      backgroundColor: Colors.red,
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      shape: BorderDirectional(),
    );
    await tester.pumpAndSettle();
    expect(find.text('showBottomSheet'), findsOneWidget);
    _navigator.back();
    await tester.pumpAndSettle();
    expect(find.text('showBottomSheet'), findsNothing);
  });

  testWidgets('hideCurrentSnackBar', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerDelegate: _navigator.routerDelegate,
        routeInformationParser: _navigator.routeInformationParser,
      ),
    );
    _navigator.scaffold.showSnackBar(
        SnackBar(
          content: Text('showSnackBar'),
        ),
        hideCurrentSnackBar: false);
    await tester.pumpAndSettle();
    expect(find.text('showSnackBar'), findsOneWidget);
    _navigator.scaffold.hideCurrentSnackBar();
    await tester.pump();
    expect(find.text('showSnackBar'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('showSnackBar'), findsNothing);
  });

  testWidgets('removeCurrentSnackBarm', (tester) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerDelegate: _navigator.routerDelegate,
        routeInformationParser: _navigator.routeInformationParser,
      ),
    );
    _navigator.scaffold.showSnackBar(
        SnackBar(
          content: Text('showSnackBar'),
        ),
        hideCurrentSnackBar: false);
    await tester.pumpAndSettle();
    expect(find.text('showSnackBar'), findsOneWidget);
    _navigator.scaffold.removeCurrentSnackBar();
    await tester.pump();
    expect(find.text('showSnackBar'), findsNothing);
  });

  testWidgets('openDrawer and openEndDrawer', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routerDelegate: _navigator.routerDelegate,
      routeInformationParser: _navigator.routeInformationParser,
    ));
    await tester.pumpAndSettle();
    _navigator.scaffold.context = context!;
    _navigator.scaffold.openDrawer();
    await tester.pumpAndSettle();
    expect(find.text('Drawer'), findsOneWidget);
    _navigator.back();
    await tester.pumpAndSettle();
    expect(find.text('Drawer'), findsNothing);
    //
    _navigator.scaffold.context = context!;
    _navigator.scaffold.openEndDrawer();
    await tester.pumpAndSettle();
    expect(find.text('EndDrawer'), findsOneWidget);
    //
    _navigator.to('/page2');
    await tester.pumpAndSettle();
  });
}
