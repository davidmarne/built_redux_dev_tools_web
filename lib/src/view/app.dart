import 'dart:async';

import 'package:built_redux/built_redux.dart';
import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_redux_dev_tools/built_redux_dev_tools.dart';

import 'action_list.dart';
import 'state_tree.dart';

class DevToolsProps {
  Store<App, AppBuilder, AppActions> store;
}

class DevTools extends Component<DevToolsProps, Null> {
  StreamSubscription<StoreChange<App, AppBuilder, dynamic>> _subscription;

  DevTools(DevToolsProps props) : super(props);

  @override
  void componentWillMount() {
    _subscription = props.store.stream
        .listen((StoreChange<App, AppBuilder, dynamic> stateChange) {
      update();
    });
  }

  @override
  void componentWillUnmount() {
    _subscription.cancel();
  }

  @override
  VNode render() => new VDivElement()
    ..children = [
      _renderNav(),
      new VDivElement()
        ..className = 'columns'
        ..children = [
          new Vdiv()
            ..className = 'column'
            ..children = [
              new ActionList(
                new ActionListProps()
                  ..actions = props.store.actions
                  ..selectedChange = props.store.state.selectedChange
                  ..uncommitedChanges = props.store.state.uncommitedChanges,
              ),
            ],
          new Vdiv()
            ..className = 'column'
            ..children = [
              new Vaside()
                ..className = 'menu'
                ..children = [
                  new Vul()
                    ..className = 'menu-list'
                    ..children = [
                      new MapTree(
                        new MapTreeProps()
                          ..name = 'State'
                          ..map = props.store.state.currentStateMap,
                      ),
                    ],
                ],
            ],
        ],
    ];

  VNode _renderNav() => new Vnav()
    ..className = 'navbar is-primary is-fixed-top'
    ..children = [
      _renderBrand(),
      _renderIcons(),
    ];

  VNode _renderBrand() => new Vdiv()
    ..className = 'navbar-brand'
    ..children = [
      new Va()
        ..className = 'navbar-item'
        ..text = 'Dev Tools'
    ];

  VNode _renderIcons() => new Vdiv()
    ..className = 'navbar-menu'
    ..children = [
      new Vdiv()
        ..className = 'navbar-end'
        ..children = [
          new Va()
            ..className = 'navbar-item'
            ..children = [
              new Vspan()
                ..className = 'fa fa-refresh'
                ..title = 'refresh'
                ..onClick = ((_) => props.store.actions.reset())
            ],
          new Va()
            ..className = 'navbar-item'
            ..children = [
              new Vspan()
                ..className = 'fa fa-save'
                ..title = 'commit'
                ..onClick = ((_) => props.store.actions.commit())
            ],
          new Va()
            ..className = 'navbar-item'
            ..children = [
              new Vspan()
                ..className = 'fa fa-trash'
                ..title = 'revert'
                ..onClick = ((_) => props.store.actions.revert())
            ],
          new Va()
            ..className = 'navbar-item'
            ..children = [
              new Vspan()
                ..className = 'fa fa-repeat'
                ..title = 'redo'
                ..onClick = ((_) => props.store.actions.redo())
            ],
          new Va()
            ..className = 'navbar-item'
            ..children = [
              new Vspan()
                ..className = 'fa fa-undo'
                ..title = 'undo'
                ..onClick = ((_) => props.store.actions.undo())
            ],
        ],
    ];
}
