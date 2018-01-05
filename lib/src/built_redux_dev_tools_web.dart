import 'dart:async';
import 'dart:html';

import 'package:wui_builder/wui_builder.dart';
import 'package:built_redux/built_redux.dart';
import 'package:built_redux_dev_tools/built_redux_dev_tools.dart';

import 'view/app.dart';
import 'cross_frame.dart';

class ReduxDevTools {
  StreamSubscription<StoreChange> _sub;
  Store<App, AppBuilder, AppActions> _devToolsStore;
  Store _store;
  Window externalWindow;

  ReduxDevTools(
    this._store, {
    Element mount,
    bool showImmediately: true,
    Iterable<int> showHide: const <int>[KeyCode.CTRL, KeyCode.D],
    // Iterable<Controls> controls: Controls.values,
  }) {
    _devToolsStore = new Store<App, AppBuilder, AppActions>(
      appReducer,
      new App(_store.state),
      new AppActions(),
      middleware: [stateReplacerMiddleware(_store)],
    );

    if (showImmediately) _openWindow();

    // listen for key codes
    final keyHeldDown = <int>[];

    window.onKeyDown.listen((e) {
      if (!showHide.contains(e.keyCode)) return;
      keyHeldDown.add(e.keyCode);
      if (showHide.every(keyHeldDown.contains)) _showHideWindow();
    });

    window.onKeyUp.listen((e) {
      if (keyHeldDown.contains(e.keyCode)) keyHeldDown.remove(e.keyCode);
    });
  }

  DevTools _setupDevTools() {
    final devtools = new DevTools(
      new DevToolsProps()..store = _devToolsStore,
    );

    _sub = _store.stream.listen(_onStateChange);
    return devtools;
  }

  void _showHideWindow() {
    if (externalWindow == null)
      _openWindow();
    else
      _closeWindow();
  }

  void _openWindow() {
    externalWindow = open('', '', 'width=1200,height=600,left=200,top=200');
    final head = externalWindow.document.documentElement.children[0];
    final mount = externalWindow.document.documentElement.children[1];

    // add bulma style
    head
      ..append(new LinkElement()
        ..rel = "stylesheet"
        ..href =
            "https://cdnjs.cloudflare.com/ajax/libs/bulma/0.5.3/css/bulma.min.css")
      ..append(new LinkElement()
        ..rel = "stylesheet"
        ..href =
            "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css");

    render(_setupDevTools(), mount);

    window.onUnload.listen((e) {
      _closeWindow();
    });
  }

  void _closeWindow() {
    externalWindow?.close();
    externalWindow = null;
  }

  void _onStateChange(StoreChange change) {
    _devToolsStore.actions.onChange(
      new Change(change.action, change.next),
    );
  }

  void dispose() {
    _sub.cancel();
    _devToolsStore.dispose();
    _closeWindow();
  }
}
