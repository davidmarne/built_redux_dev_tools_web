import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/components.dart';
import 'package:wui_builder/vhtml.dart';
import 'package:built_redux_dev_tools/built_redux_dev_tools.dart';

class ActionListItemProps {
  AppActions actions;
  Change change;
  bool isSelected;
}

class ActionListItem extends PComponent<ActionListItemProps> {
  ActionListItem(ActionListItemProps props) : super(props);

  @override
  VNode render() => new Vli()
    ..onClick = _onActionClicked
    ..children = [
      new Va()
        ..className = _selectedClass
        ..text = props.change.action.name,
    ];

  String get _selectedClass => props.isSelected ? 'is-active' : '';

  _onActionClicked(_) {
    props.actions.selectChange(props.change);
  }
}
