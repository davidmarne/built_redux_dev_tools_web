import 'package:wui_builder/wui_builder.dart';
import 'package:wui_builder/vhtml.dart';

class MapTreeProps {
  Object name;
  Map<Object, Object> map;
}

class MapTree extends Component<MapTreeProps, bool> {
  MapTree(MapTreeProps props) : super(props);

  Object get typeName => props.map['\$class'] ?? 'Map';

  bool get _expanded => state;

  @override
  bool getInitialState() => false;

  @override
  VNode render() => new Vli()
    ..children = [
      new Va()
        ..onClick = _onClick
        ..text = '${props.name}: ${typeName}',
      new Vul()
        ..className = 'menu-list'
        ..styleBuilder =
            ((builder) => builder.display = !_expanded ? 'none' : '')
        ..children = props.map.keys
            .where((k) => k != '\$class')
            .map((k) => _valueSwitch(k, props.map[k])),
    ];

  void _onClick(_) => setState((p, s) => !s);
}

class IterableTreeProps {
  Object name;
  Iterable<Object> values;
}

class IterableTree extends Component<IterableTreeProps, bool> {
  IterableTree(IterableTreeProps props) : super(props);

  bool get _expanded => state;

  @override
  bool getInitialState() => false;

  @override
  VNode render() => new Vli()
    ..children = [
      new Va()
        ..onClick = _onClick
        ..text = '${props.name}: Iterable',
      new Vul()
        ..className = 'menu-list'
        ..styleBuilder =
            ((builder) => builder.display = !_expanded ? 'none' : '')
        ..children = new Iterable.generate(props.values.length,
            (i) => _valueSwitch(i, props.values.elementAt(i))),
    ];

  void _onClick(_) => setStateOnIdle((p, s) => !s);
}

VNode _valueSwitch(Object k, Object v) {
  if (v is Map)
    return new MapTree(
      new MapTreeProps()
        ..name = k
        ..map = v,
    );
  else if (v is Iterable)
    return new IterableTree(
      new IterableTreeProps()
        ..name = k
        ..values = v,
    );
  return new Vli()
    ..children = [
      new Va()..text = '$k: $v',
    ];
}
