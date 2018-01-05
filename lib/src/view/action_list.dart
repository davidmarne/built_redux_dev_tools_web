import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_redux_dev_tools/built_redux_dev_tools.dart';

import 'action_list_item.dart';

class ActionListProps {
  AppActions actions;
  Iterable<Change> uncommitedChanges;
  Change selectedChange;
}

class ActionList extends PComponent<ActionListProps> {
  ActionList(ActionListProps props) : super(props);

  @override
  VNode render() => new Vaside()
    ..className = 'menu'
    ..children = [
      new Vul()
        ..className = 'menu-list'
        ..children = props.uncommitedChanges.map(_change),
    ];

  VNode _change(Change change) => new ActionListItem(
        new ActionListItemProps()
          ..actions = props.actions
          ..change = change
          ..isSelected = props.selectedChange == change,
      );
}
