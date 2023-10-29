typedef VoidCallback = void Function();

class Size {
  final Unit width;
  final Unit height;

  const Size(this.width, this.height);

  Size copyWith({
    Unit? width,
    Unit? height,
  }) {
    return Size(
      width ?? this.width,
      height ?? this.height,
    );
  }
}

enum UnitType {
  px('px'),
  pt('pt'),
  em('em'),
  rem('rem'),
  vw('vw'),
  vh('vh'),
  percent('%');

  final String value;
  const UnitType(this.value);
}

class Unit {
  final double value;
  final UnitType type;

  const Unit(this.value, this.type);

  const Unit.px(this.value) : type = UnitType.px;
  const Unit.pt(this.value) : type = UnitType.pt;
  const Unit.em(this.value) : type = UnitType.em;
  const Unit.rem(this.value) : type = UnitType.rem;
  const Unit.vw(this.value) : type = UnitType.vw;
  const Unit.vh(this.value) : type = UnitType.vh;
  const Unit.percent(this.value) : type = UnitType.percent;

  @override
  String toString() {
    return '$value${type.value}';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Unit && other.value == value && other.type == type;
  }

  @override
  int get hashCode => Object.hash(runtimeType, value, type);
}
