import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/theme.dart';
import '../../data/models/icon_info.dart';
import '../../main.dart';
import '../../states/search_state.dart';
import '../../states/theme_mode_state.dart';
import '../widgets/extended_fab.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeModeState theme = ref.watch(themeProvider);
    final SearchState search = ref.watch(searchProvider);
    final FocusNode node = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: search.show
            ? TextFormField(
                decoration: const InputDecoration(border: InputBorder.none),
                autofocus: true,
                onChanged: (String query) {
                  ref.watch(searchProvider.notifier).updateQuery(query);
                },
              )
            : Text(
                'flutter-ionicons v0.2.1',
                style: Theme.of(context).textTheme.subtitle1,
              ),
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 4,
        shadowColor: textSwatch.shade900.withOpacity(.2),
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
                  ? Brightness.light
                  : Brightness.dark,
        ),
      ),
      bottomNavigationBar: Card(
        elevation: 16,
        shadowColor: textSwatch.shade900.withOpacity(.2),
        margin: EdgeInsets.zero,
        color: Theme.of(context).bottomAppBarColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Ionicons.logo_github,
                    color: Theme.of(context).textTheme.subtitle1!.color,
                  ),
                  splashRadius: 24,
                  tooltip: 'Open GitHub',
                  onPressed: () {
                    _launchUrl(Uri.parse(
                        'https://github.com/ez-connect/flutter-ionicons'));
                  }),
              const Spacer(),
              const SizedBox(height: 48),
              const Spacer(),
              Row(children: <Widget>[
                IconButton(
                  onPressed: () {
                    if (theme.themeMode == ThemeMode.light) {
                      ref
                          .watch(themeProvider.notifier)
                          .setThemeMode(ThemeMode.dark);
                    } else {
                      ref
                          .watch(themeProvider.notifier)
                          .setThemeMode(ThemeMode.light);
                    }
                  },
                  splashRadius: 24,
                  tooltip: 'Change theme',
                  icon: Icon(
                    theme.themeMode == ThemeMode.light
                        ? Ionicons.sunny_outline
                        : Ionicons.moon_outline,
                    color: Theme.of(context).textTheme.subtitle1!.color,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ExtendedFab(
        text: search.show ? 'Reset' : 'Search',
        icon: search.show ? Ionicons.close_outline : Ionicons.search_outline,
        onPressed: () {
          if (search.show) {
            ref.watch(searchProvider.notifier).updateQuery(null);
          } else {
            node.requestFocus();
          }
          ref.watch(searchProvider.notifier).toggle();
        },
      ),
      body: Material(
        color: Theme.of(context).backgroundColor,
        child: ListView.builder(
          padding:
              const EdgeInsets.only(left: 12, top: 2, right: 12, bottom: 88),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: iconBox.keys
              .where((dynamic k) =>
                  k.toString().toLowerCase().contains(search.query ?? ''))
              .length,
          itemBuilder: (BuildContext context, int index) {
            final IconInfo iconInfo = iconBox.values
                .where((IconInfo v) =>
                    v.name.toLowerCase().contains(search.query ?? ''))
                .toList()
                .elementAt(index);
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 2),
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: ListTile(
                visualDensity: VisualDensity.compact,
                leading: Icon(
                  IoniconsData(iconInfo.value),
                  color: Theme.of(context).textTheme.subtitle1!.color,
                ),
                title: Text(
                  iconInfo.name.replaceAll('-', '_'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw PlatformException(code: '0', message: 'Could not launch $url');
    }
  }
}
