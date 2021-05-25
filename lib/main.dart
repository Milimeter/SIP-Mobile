import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:void_sip/src/callscreen.dart';
import 'package:void_sip/src/dialpad.dart';
import 'package:void_sip/src/register.dart';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
}

typedef PageContentBuilder = Widget Function(
    [SIPUAHelper helper, Object arguments]);

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final SIPUAHelper _helper = SIPUAHelper();
  Map<String, PageContentBuilder> routes = {
    '/': ([SIPUAHelper helper, Object arguments]) => DialPadWidget(helper),
    '/register': ([SIPUAHelper helper, Object arguments]) =>
        RegisterWidget(helper),
    '/callscreen': ([SIPUAHelper helper, Object arguments]) =>
        CallScreenWidget(helper, arguments as Call),
    //'/about': ([SIPUAHelper helper, Object arguments]) => AboutWidget(),
  };

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final String name = settings.name;
    final PageContentBuilder pageContentBuilder = routes[name];
    if (pageContentBuilder != null) {
      if (settings.arguments != null) {
        final Route route = MaterialPageRoute<Widget>(
            builder: (context) =>
                pageContentBuilder(_helper, settings.arguments));
        return route;
      } else {
        final Route route = MaterialPageRoute<Widget>(
            builder: (context) => pageContentBuilder(_helper));
        return route;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SIP Call',
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }
}
