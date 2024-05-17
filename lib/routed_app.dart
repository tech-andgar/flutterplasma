import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

import 'demo/demo_screen.dart';
import 'showroom/show_room.dart';
import 'widget_warmup.dart';

class RoutedApp extends StatefulWidget {
  const RoutedApp({super.key});

  @override
  State<RoutedApp>  createState() => _RoutedAppState();
}

class _RoutedAppState extends State<RoutedApp> {
  final _routerDelegate = AppRouterDelegate();
  final _routeInformationParser = AppRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Plasma',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class AppRoutePath {
  AppRoutePath.demo({bool credits = true})
      : _route = 'demo',
        demoShowCredits = credits;

  AppRoutePath.showroom(int index)
      : _route = 'showroom',
        showroomIndex = index;

  AppRoutePath.unknown() : _route = 'unknown';
  final String _route;
  int showroomIndex = 0;
  bool demoShowCredits = true;

  bool get isDemo => _route == 'demo';

  bool get isShowroom => _route == 'showroom';

  bool get isUnknown => _route == 'unknown';
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return AppRoutePath.demo();
    }

    if (uri.pathSegments[0] == 'nocredits') {
      return AppRoutePath.demo(credits: false);
    }

    if (uri.pathSegments[0] == 'showroom') {
      if (uri.pathSegments.length == 2) {
        final index = uri.pathSegments[1].toInt();
        if (index != null) {
          return AppRoutePath.showroom(index);
        }
      }

      return AppRoutePath.showroom(0);
    }

    return AppRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath configuration) {
    if (configuration.isDemo) {
      if (configuration.demoShowCredits) {
        return RouteInformation(uri: Uri.parse('/'));
      } else {
        return RouteInformation(uri: Uri.parse('/nocredits'));
      }
    }
    if (configuration.isShowroom) {
      if (configuration.showroomIndex > 0) {
        return RouteInformation(
          uri: Uri.parse('/showroom/${configuration.showroomIndex}'),
        );
      }
      return RouteInformation(uri: Uri.parse('/showroom'));
    }
    return RouteInformation(uri: Uri.parse('/unknown'));
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  bool showDemo = true;
  bool demoShowCredits = true;
  bool showShowroom = false;
  int showroomIndex = 0;
  bool showUnknown = false;

  @override
  AppRoutePath get currentConfiguration {
    if (showDemo) {
      return AppRoutePath.demo(credits: demoShowCredits);
    }
    if (showShowroom) {
      return AppRoutePath.showroom(showroomIndex);
    }
    return AppRoutePath.unknown();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetWarmup(
      child: Navigator(
        key: navigatorKey,
        pages: [
          if (showDemo)
            MaterialPage<DemoScreen>(
              key: const ValueKey('Demo'),
              child: DemoScreen(
                showCredits: demoShowCredits,
                onComplete: _handleDemoCompleted,
              ),
            ),
          if (showShowroom)
            MaterialPage<Scaffold>(
              key: const ValueKey('ShowRoom'),
              child: Scaffold(
                body: ShowRoom(
                  index: showroomIndex,
                  onIndexChange: _handleShowroomIndexChange,
                ),
              ),
            ),
          if (showUnknown)
            const MaterialPage<Scaffold>(
              key: ValueKey('Unknown'),
              child: Scaffold(body: Center(child: Text('404'))),
            ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }

          notifyListeners();
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    showDemo = configuration.isDemo;
    demoShowCredits = configuration.demoShowCredits;
    showShowroom = configuration.isShowroom;
    showUnknown = configuration.isUnknown;
    showroomIndex = configuration.showroomIndex;
  }

  void _handleDemoCompleted() {
    showDemo = false;
    showShowroom = true;
    notifyListeners();
  }

  void _handleShowroomIndexChange(int newIndex) {
    showroomIndex = newIndex;
    notifyListeners();
  }
}
