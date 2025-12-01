// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'raylib_const.g.dart' as consts;

extension type const ConfigFlags(int value) {
  static const vsyncHint = ConfigFlags(64);
  static const fullscreenMode = ConfigFlags(2);
  static const windowResizable = ConfigFlags(4);
  static const windowUndecorated = ConfigFlags(8);
  static const windowHidden = ConfigFlags(128);
  static const windowMinimized = ConfigFlags(512);
  static const windowMaximized = ConfigFlags(1024);
  static const windowUnfocused = ConfigFlags(2048);
  static const windowTopmost = ConfigFlags(4096);
  static const windowAlwaysRun = ConfigFlags(256);
  static const windowTransparent = ConfigFlags(16);
  static const windowHighdpi = ConfigFlags(8192);
  static const windowMousePassthrough = ConfigFlags(16384);
  static const borderlessWindowedMode = ConfigFlags(32768);
  static const msaa4xHint = ConfigFlags(32);
  static const interlacedHint = ConfigFlags(65536);

  ConfigFlags operator |(ConfigFlags other) => ConfigFlags(value | other.value);
  ConfigFlags operator &(ConfigFlags other) => ConfigFlags(value & other.value);
}

@Deprecated('Use .vsyncHint instead')
const ConfigFlags FLAG_VSYNC_HINT = .vsyncHint;

@Deprecated('Use .fullscreenMode instead')
const ConfigFlags FLAG_FULLSCREEN_MODE = .fullscreenMode;

@Deprecated('Use .windowResizable instead')
const ConfigFlags FLAG_WINDOW_RESIZABLE = .windowResizable;

@Deprecated('Use .windowUndecorated instead')
const ConfigFlags FLAG_WINDOW_UNDECORATED = .windowUndecorated;

@Deprecated('Use .windowHidden instead')
const ConfigFlags FLAG_WINDOW_HIDDEN = .windowHidden;

@Deprecated('Use .windowMinimized instead')
const ConfigFlags FLAG_WINDOW_MINIMIZED = .windowMinimized;

@Deprecated('Use .windowMaximized instead')
const ConfigFlags FLAG_WINDOW_MAXIMIZED = .windowMaximized;

@Deprecated('Use .windowUnfocused instead')
const ConfigFlags FLAG_WINDOW_UNFOCUSED = .windowUnfocused;

@Deprecated('Use .windowTopmost instead')
const ConfigFlags FLAG_WINDOW_TOPMOST = .windowTopmost;

@Deprecated('Use .windowAlwaysRun instead')
const ConfigFlags FLAG_WINDOW_ALWAYS_RUN = .windowAlwaysRun;

@Deprecated('Use .windowTransparent instead')
const ConfigFlags FLAG_WINDOW_TRANSPARENT = .windowTransparent;

@Deprecated('Use .windowHighdpi instead')
const ConfigFlags FLAG_WINDOW_HIGHDPI = .windowHighdpi;

@Deprecated('Use .windowMousePassthrough instead')
const ConfigFlags FLAG_WINDOW_MOUSE_PASSTHROUGH = .windowMousePassthrough;

@Deprecated('Use .borderlessWindowedMode instead')
const ConfigFlags FLAG_BORDERLESS_WINDOWED_MODE = .borderlessWindowedMode;

@Deprecated('Use .msaa4xHint instead')
const ConfigFlags FLAG_MSAA_4X_HINT = .msaa4xHint;

@Deprecated('Use .interlacedHint instead')
const ConfigFlags FLAG_INTERLACED_HINT = .interlacedHint;

enum TraceLogLevel {
  all(.LOG_ALL),
  trace(.LOG_TRACE),
  debug(.LOG_DEBUG),
  info(.LOG_INFO),
  warning(.LOG_WARNING),
  error(.LOG_ERROR),
  fatal(.LOG_FATAL),
  none(.LOG_NONE);

  final consts.TraceLogLevel code;
  const TraceLogLevel(this.code);
  int get value => code.value;

  static TraceLogLevel fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown TraceLogLevel value: $value'),
  );

  bool operator <=(TraceLogLevel other) => value <= other.value;
  bool operator >=(TraceLogLevel other) => value >= other.value;
  bool operator <(TraceLogLevel other) => value < other.value;
  bool operator >(TraceLogLevel other) => value > other.value;
}

@Deprecated('Use .all instead')
const TraceLogLevel LOG_ALL = .all;

@Deprecated('Use .trace instead')
const TraceLogLevel LOG_TRACE = .trace;

@Deprecated('Use .debug instead')
const TraceLogLevel LOG_DEBUG = .debug;

@Deprecated('Use .info instead')
const TraceLogLevel LOG_INFO = .info;

@Deprecated('Use .warning instead')
const TraceLogLevel LOG_WARNING = .warning;

@Deprecated('Use .error instead')
const TraceLogLevel LOG_ERROR = .error;

@Deprecated('Use .fatal instead')
const TraceLogLevel LOG_FATAL = .fatal;

@Deprecated('Use .none instead')
const TraceLogLevel LOG_NONE = .none;

enum KeyboardKey {
  null_(.KEY_NULL),
  apostrophe(.KEY_APOSTROPHE),
  comma(.KEY_COMMA),
  minus(.KEY_MINUS),
  period(.KEY_PERIOD),
  slash(.KEY_SLASH),
  zero(.KEY_ZERO),
  one(.KEY_ONE),
  two(.KEY_TWO),
  three(.KEY_THREE),
  four(.KEY_FOUR),
  five(.KEY_FIVE),
  six(.KEY_SIX),
  seven(.KEY_SEVEN),
  eight(.KEY_EIGHT),
  nine(.KEY_NINE),
  semicolon(.KEY_SEMICOLON),
  equal(.KEY_EQUAL),
  a(.KEY_A),
  b(.KEY_B),
  c(.KEY_C),
  d(.KEY_D),
  e(.KEY_E),
  f(.KEY_F),
  g(.KEY_G),
  h(.KEY_H),
  i(.KEY_I),
  j(.KEY_J),
  k(.KEY_K),
  l(.KEY_L),
  m(.KEY_M),
  n(.KEY_N),
  o(.KEY_O),
  p(.KEY_P),
  q(.KEY_Q),
  r(.KEY_R),
  s(.KEY_S),
  t(.KEY_T),
  u(.KEY_U),
  v(.KEY_V),
  w(.KEY_W),
  x(.KEY_X),
  y(.KEY_Y),
  z(.KEY_Z),
  leftBracket(.KEY_LEFT_BRACKET),
  backslash(.KEY_BACKSLASH),
  rightBracket(.KEY_RIGHT_BRACKET),
  grave(.KEY_GRAVE),
  space(.KEY_SPACE),
  escape(.KEY_ESCAPE),
  enter(.KEY_ENTER),
  tab(.KEY_TAB),
  backspace(.KEY_BACKSPACE),
  insert(.KEY_INSERT),
  delete(.KEY_DELETE),
  right(.KEY_RIGHT),
  left(.KEY_LEFT),
  down(.KEY_DOWN),
  up(.KEY_UP),
  pageUp(.KEY_PAGE_UP),
  pageDown(.KEY_PAGE_DOWN),
  home(.KEY_HOME),
  end(.KEY_END),
  capsLock(.KEY_CAPS_LOCK),
  scrollLock(.KEY_SCROLL_LOCK),
  numLock(.KEY_NUM_LOCK),
  printScreen(.KEY_PRINT_SCREEN),
  pause(.KEY_PAUSE),
  f1(.KEY_F1),
  f2(.KEY_F2),
  f3(.KEY_F3),
  f4(.KEY_F4),
  f5(.KEY_F5),
  f6(.KEY_F6),
  f7(.KEY_F7),
  f8(.KEY_F8),
  f9(.KEY_F9),
  f10(.KEY_F10),
  f11(.KEY_F11),
  f12(.KEY_F12),
  leftShift(.KEY_LEFT_SHIFT),
  leftControl(.KEY_LEFT_CONTROL),
  leftAlt(.KEY_LEFT_ALT),
  leftSuper(.KEY_LEFT_SUPER),
  rightShift(.KEY_RIGHT_SHIFT),
  rightControl(.KEY_RIGHT_CONTROL),
  rightAlt(.KEY_RIGHT_ALT),
  rightSuper(.KEY_RIGHT_SUPER),
  kbMenu(.KEY_KB_MENU),
  kp0(.KEY_KP_0),
  kp1(.KEY_KP_1),
  kp2(.KEY_KP_2),
  kp3(.KEY_KP_3),
  kp4(.KEY_KP_4),
  kp5(.KEY_KP_5),
  kp6(.KEY_KP_6),
  kp7(.KEY_KP_7),
  kp8(.KEY_KP_8),
  kp9(.KEY_KP_9),
  kpDecimal(.KEY_KP_DECIMAL),
  kpDivide(.KEY_KP_DIVIDE),
  kpMultiply(.KEY_KP_MULTIPLY),
  kpSubtract(.KEY_KP_SUBTRACT),
  kpAdd(.KEY_KP_ADD),
  kpEnter(.KEY_KP_ENTER),
  kpEqual(.KEY_KP_EQUAL),
  back(.KEY_BACK),
  menu(.KEY_MENU),
  volumeUp(.KEY_VOLUME_UP),
  volumeDown(.KEY_VOLUME_DOWN);

  final consts.KeyboardKey code;
  const KeyboardKey(this.code);
  int get value => code.value;

  static KeyboardKey fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown KeyboardKey value: $value'),
  );
}

@Deprecated('Use .null_ instead')
const KeyboardKey KEY_NULL = .null_;

@Deprecated('Use .apostrophe instead')
const KeyboardKey KEY_APOSTROPHE = .apostrophe;

@Deprecated('Use .comma instead')
const KeyboardKey KEY_COMMA = .comma;

@Deprecated('Use .minus instead')
const KeyboardKey KEY_MINUS = .minus;

@Deprecated('Use .period instead')
const KeyboardKey KEY_PERIOD = .period;

@Deprecated('Use .slash instead')
const KeyboardKey KEY_SLASH = .slash;

@Deprecated('Use .zero instead')
const KeyboardKey KEY_ZERO = .zero;

@Deprecated('Use .one instead')
const KeyboardKey KEY_ONE = .one;

@Deprecated('Use .two instead')
const KeyboardKey KEY_TWO = .two;

@Deprecated('Use .three instead')
const KeyboardKey KEY_THREE = .three;

@Deprecated('Use .four instead')
const KeyboardKey KEY_FOUR = .four;

@Deprecated('Use .five instead')
const KeyboardKey KEY_FIVE = .five;

@Deprecated('Use .six instead')
const KeyboardKey KEY_SIX = .six;

@Deprecated('Use .seven instead')
const KeyboardKey KEY_SEVEN = .seven;

@Deprecated('Use .eight instead')
const KeyboardKey KEY_EIGHT = .eight;

@Deprecated('Use .nine instead')
const KeyboardKey KEY_NINE = .nine;

@Deprecated('Use .semicolon instead')
const KeyboardKey KEY_SEMICOLON = .semicolon;

@Deprecated('Use .equal instead')
const KeyboardKey KEY_EQUAL = .equal;

@Deprecated('Use .a instead')
const KeyboardKey KEY_A = .a;

@Deprecated('Use .b instead')
const KeyboardKey KEY_B = .b;

@Deprecated('Use .c instead')
const KeyboardKey KEY_C = .c;

@Deprecated('Use .d instead')
const KeyboardKey KEY_D = .d;

@Deprecated('Use .e instead')
const KeyboardKey KEY_E = .e;

@Deprecated('Use .f instead')
const KeyboardKey KEY_F = .f;

@Deprecated('Use .g instead')
const KeyboardKey KEY_G = .g;

@Deprecated('Use .h instead')
const KeyboardKey KEY_H = .h;

@Deprecated('Use .i instead')
const KeyboardKey KEY_I = .i;

@Deprecated('Use .j instead')
const KeyboardKey KEY_J = .j;

@Deprecated('Use .k instead')
const KeyboardKey KEY_K = .k;

@Deprecated('Use .l instead')
const KeyboardKey KEY_L = .l;

@Deprecated('Use .m instead')
const KeyboardKey KEY_M = .m;

@Deprecated('Use .n instead')
const KeyboardKey KEY_N = .n;

@Deprecated('Use .o instead')
const KeyboardKey KEY_O = .o;

@Deprecated('Use .p instead')
const KeyboardKey KEY_P = .p;

@Deprecated('Use .q instead')
const KeyboardKey KEY_Q = .q;

@Deprecated('Use .r instead')
const KeyboardKey KEY_R = .r;

@Deprecated('Use .s instead')
const KeyboardKey KEY_S = .s;

@Deprecated('Use .t instead')
const KeyboardKey KEY_T = .t;

@Deprecated('Use .u instead')
const KeyboardKey KEY_U = .u;

@Deprecated('Use .v instead')
const KeyboardKey KEY_V = .v;

@Deprecated('Use .w instead')
const KeyboardKey KEY_W = .w;

@Deprecated('Use .x instead')
const KeyboardKey KEY_X = .x;

@Deprecated('Use .y instead')
const KeyboardKey KEY_Y = .y;

@Deprecated('Use .z instead')
const KeyboardKey KEY_Z = .z;

@Deprecated('Use .leftBracket instead')
const KeyboardKey KEY_LEFT_BRACKET = .leftBracket;

@Deprecated('Use .backslash instead')
const KeyboardKey KEY_BACKSLASH = .backslash;

@Deprecated('Use .rightBracket instead')
const KeyboardKey KEY_RIGHT_BRACKET = .rightBracket;

@Deprecated('Use .grave instead')
const KeyboardKey KEY_GRAVE = .grave;

@Deprecated('Use .space instead')
const KeyboardKey KEY_SPACE = .space;

@Deprecated('Use .escape instead')
const KeyboardKey KEY_ESCAPE = .escape;

@Deprecated('Use .enter instead')
const KeyboardKey KEY_ENTER = .enter;

@Deprecated('Use .tab instead')
const KeyboardKey KEY_TAB = .tab;

@Deprecated('Use .backspace instead')
const KeyboardKey KEY_BACKSPACE = .backspace;

@Deprecated('Use .insert instead')
const KeyboardKey KEY_INSERT = .insert;

@Deprecated('Use .delete instead')
const KeyboardKey KEY_DELETE = .delete;

@Deprecated('Use .right instead')
const KeyboardKey KEY_RIGHT = .right;

@Deprecated('Use .left instead')
const KeyboardKey KEY_LEFT = .left;

@Deprecated('Use .down instead')
const KeyboardKey KEY_DOWN = .down;

@Deprecated('Use .up instead')
const KeyboardKey KEY_UP = .up;

@Deprecated('Use .pageUp instead')
const KeyboardKey KEY_PAGE_UP = .pageUp;

@Deprecated('Use .pageDown instead')
const KeyboardKey KEY_PAGE_DOWN = .pageDown;

@Deprecated('Use .home instead')
const KeyboardKey KEY_HOME = .home;

@Deprecated('Use .end instead')
const KeyboardKey KEY_END = .end;

@Deprecated('Use .capsLock instead')
const KeyboardKey KEY_CAPS_LOCK = .capsLock;

@Deprecated('Use .scrollLock instead')
const KeyboardKey KEY_SCROLL_LOCK = .scrollLock;

@Deprecated('Use .numLock instead')
const KeyboardKey KEY_NUM_LOCK = .numLock;

@Deprecated('Use .printScreen instead')
const KeyboardKey KEY_PRINT_SCREEN = .printScreen;

@Deprecated('Use .pause instead')
const KeyboardKey KEY_PAUSE = .pause;

@Deprecated('Use .f1 instead')
const KeyboardKey KEY_F1 = .f1;

@Deprecated('Use .f2 instead')
const KeyboardKey KEY_F2 = .f2;

@Deprecated('Use .f3 instead')
const KeyboardKey KEY_F3 = .f3;

@Deprecated('Use .f4 instead')
const KeyboardKey KEY_F4 = .f4;

@Deprecated('Use .f5 instead')
const KeyboardKey KEY_F5 = .f5;

@Deprecated('Use .f6 instead')
const KeyboardKey KEY_F6 = .f6;

@Deprecated('Use .f7 instead')
const KeyboardKey KEY_F7 = .f7;

@Deprecated('Use .f8 instead')
const KeyboardKey KEY_F8 = .f8;

@Deprecated('Use .f9 instead')
const KeyboardKey KEY_F9 = .f9;

@Deprecated('Use .f10 instead')
const KeyboardKey KEY_F10 = .f10;

@Deprecated('Use .f11 instead')
const KeyboardKey KEY_F11 = .f11;

@Deprecated('Use .f12 instead')
const KeyboardKey KEY_F12 = .f12;

@Deprecated('Use .leftShift instead')
const KeyboardKey KEY_LEFT_SHIFT = .leftShift;

@Deprecated('Use .leftControl instead')
const KeyboardKey KEY_LEFT_CONTROL = .leftControl;

@Deprecated('Use .leftAlt instead')
const KeyboardKey KEY_LEFT_ALT = .leftAlt;

@Deprecated('Use .leftSuper instead')
const KeyboardKey KEY_LEFT_SUPER = .leftSuper;

@Deprecated('Use .rightShift instead')
const KeyboardKey KEY_RIGHT_SHIFT = .rightShift;

@Deprecated('Use .rightControl instead')
const KeyboardKey KEY_RIGHT_CONTROL = .rightControl;

@Deprecated('Use .rightAlt instead')
const KeyboardKey KEY_RIGHT_ALT = .rightAlt;

@Deprecated('Use .rightSuper instead')
const KeyboardKey KEY_RIGHT_SUPER = .rightSuper;

@Deprecated('Use .kbMenu instead')
const KeyboardKey KEY_KB_MENU = .kbMenu;

@Deprecated('Use .kp0 instead')
const KeyboardKey KEY_KP_0 = .kp0;

@Deprecated('Use .kp1 instead')
const KeyboardKey KEY_KP_1 = .kp1;

@Deprecated('Use .kp2 instead')
const KeyboardKey KEY_KP_2 = .kp2;

@Deprecated('Use .kp3 instead')
const KeyboardKey KEY_KP_3 = .kp3;

@Deprecated('Use .kp4 instead')
const KeyboardKey KEY_KP_4 = .kp4;

@Deprecated('Use .kp5 instead')
const KeyboardKey KEY_KP_5 = .kp5;

@Deprecated('Use .kp6 instead')
const KeyboardKey KEY_KP_6 = .kp6;

@Deprecated('Use .kp7 instead')
const KeyboardKey KEY_KP_7 = .kp7;

@Deprecated('Use .kp8 instead')
const KeyboardKey KEY_KP_8 = .kp8;

@Deprecated('Use .kp9 instead')
const KeyboardKey KEY_KP_9 = .kp9;

@Deprecated('Use .kpDecimal instead')
const KeyboardKey KEY_KP_DECIMAL = .kpDecimal;

@Deprecated('Use .kpDivide instead')
const KeyboardKey KEY_KP_DIVIDE = .kpDivide;

@Deprecated('Use .kpMultiply instead')
const KeyboardKey KEY_KP_MULTIPLY = .kpMultiply;

@Deprecated('Use .kpSubtract instead')
const KeyboardKey KEY_KP_SUBTRACT = .kpSubtract;

@Deprecated('Use .kpAdd instead')
const KeyboardKey KEY_KP_ADD = .kpAdd;

@Deprecated('Use .kpEnter instead')
const KeyboardKey KEY_KP_ENTER = .kpEnter;

@Deprecated('Use .kpEqual instead')
const KeyboardKey KEY_KP_EQUAL = .kpEqual;

@Deprecated('Use .back instead')
const KeyboardKey KEY_BACK = .back;

@Deprecated('Use .menu instead')
const KeyboardKey KEY_MENU = .menu;

@Deprecated('Use .volumeUp instead')
const KeyboardKey KEY_VOLUME_UP = .volumeUp;

@Deprecated('Use .volumeDown instead')
const KeyboardKey KEY_VOLUME_DOWN = .volumeDown;

enum MouseButton {
  left(.MOUSE_BUTTON_LEFT),
  right(.MOUSE_BUTTON_RIGHT),
  middle(.MOUSE_BUTTON_MIDDLE),
  side(.MOUSE_BUTTON_SIDE),
  extra(.MOUSE_BUTTON_EXTRA),
  forward(.MOUSE_BUTTON_FORWARD),
  back(.MOUSE_BUTTON_BACK);

  final consts.MouseButton code;
  const MouseButton(this.code);
  int get value => code.value;

  static MouseButton fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown MouseButton value: $value'),
  );
}

@Deprecated('Use .left instead')
const MouseButton MOUSE_BUTTON_LEFT = .left;

@Deprecated('Use .right instead')
const MouseButton MOUSE_BUTTON_RIGHT = .right;

@Deprecated('Use .middle instead')
const MouseButton MOUSE_BUTTON_MIDDLE = .middle;

@Deprecated('Use .side instead')
const MouseButton MOUSE_BUTTON_SIDE = .side;

@Deprecated('Use .extra instead')
const MouseButton MOUSE_BUTTON_EXTRA = .extra;

@Deprecated('Use .forward instead')
const MouseButton MOUSE_BUTTON_FORWARD = .forward;

@Deprecated('Use .back instead')
const MouseButton MOUSE_BUTTON_BACK = .back;

enum MouseCursor {
  default_(.MOUSE_CURSOR_DEFAULT),
  arrow(.MOUSE_CURSOR_ARROW),
  ibeam(.MOUSE_CURSOR_IBEAM),
  crosshair(.MOUSE_CURSOR_CROSSHAIR),
  pointingHand(.MOUSE_CURSOR_POINTING_HAND),
  resizeEw(.MOUSE_CURSOR_RESIZE_EW),
  resizeNs(.MOUSE_CURSOR_RESIZE_NS),
  resizeNwse(.MOUSE_CURSOR_RESIZE_NWSE),
  resizeNesw(.MOUSE_CURSOR_RESIZE_NESW),
  resizeAll(.MOUSE_CURSOR_RESIZE_ALL),
  notAllowed(.MOUSE_CURSOR_NOT_ALLOWED);

  final consts.MouseCursor code;
  const MouseCursor(this.code);
  int get value => code.value;

  static MouseCursor fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown MouseCursor value: $value'),
  );
}

@Deprecated('Use .default_ instead')
const MouseCursor MOUSE_CURSOR_DEFAULT = .default_;

@Deprecated('Use .arrow instead')
const MouseCursor MOUSE_CURSOR_ARROW = .arrow;

@Deprecated('Use .ibeam instead')
const MouseCursor MOUSE_CURSOR_IBEAM = .ibeam;

@Deprecated('Use .crosshair instead')
const MouseCursor MOUSE_CURSOR_CROSSHAIR = .crosshair;

@Deprecated('Use .pointingHand instead')
const MouseCursor MOUSE_CURSOR_POINTING_HAND = .pointingHand;

@Deprecated('Use .resizeEw instead')
const MouseCursor MOUSE_CURSOR_RESIZE_EW = .resizeEw;

@Deprecated('Use .resizeNs instead')
const MouseCursor MOUSE_CURSOR_RESIZE_NS = .resizeNs;

@Deprecated('Use .resizeNwse instead')
const MouseCursor MOUSE_CURSOR_RESIZE_NWSE = .resizeNwse;

@Deprecated('Use .resizeNesw instead')
const MouseCursor MOUSE_CURSOR_RESIZE_NESW = .resizeNesw;

@Deprecated('Use .resizeAll instead')
const MouseCursor MOUSE_CURSOR_RESIZE_ALL = .resizeAll;

@Deprecated('Use .notAllowed instead')
const MouseCursor MOUSE_CURSOR_NOT_ALLOWED = .notAllowed;

enum GamepadButton {
  unknown(.GAMEPAD_BUTTON_UNKNOWN),
  leftFaceUp(.GAMEPAD_BUTTON_LEFT_FACE_UP),
  leftFaceRight(.GAMEPAD_BUTTON_LEFT_FACE_RIGHT),
  leftFaceDown(.GAMEPAD_BUTTON_LEFT_FACE_DOWN),
  leftFaceLeft(.GAMEPAD_BUTTON_LEFT_FACE_LEFT),
  rightFaceUp(.GAMEPAD_BUTTON_RIGHT_FACE_UP),
  rightFaceRight(.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT),
  rightFaceDown(.GAMEPAD_BUTTON_RIGHT_FACE_DOWN),
  rightFaceLeft(.GAMEPAD_BUTTON_RIGHT_FACE_LEFT),
  leftTrigger1(.GAMEPAD_BUTTON_LEFT_TRIGGER_1),
  leftTrigger2(.GAMEPAD_BUTTON_LEFT_TRIGGER_2),
  rightTrigger1(.GAMEPAD_BUTTON_RIGHT_TRIGGER_1),
  rightTrigger2(.GAMEPAD_BUTTON_RIGHT_TRIGGER_2),
  middleLeft(.GAMEPAD_BUTTON_MIDDLE_LEFT),
  middle(.GAMEPAD_BUTTON_MIDDLE),
  middleRight(.GAMEPAD_BUTTON_MIDDLE_RIGHT),
  leftThumb(.GAMEPAD_BUTTON_LEFT_THUMB),
  rightThumb(.GAMEPAD_BUTTON_RIGHT_THUMB);

  final consts.GamepadButton code;
  const GamepadButton(this.code);
  int get value => code.value;

  static GamepadButton fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown GamepadButton value: $value'),
  );
}

@Deprecated('Use .unknown instead')
const GamepadButton GAMEPAD_BUTTON_UNKNOWN = .unknown;

@Deprecated('Use .leftFaceUp instead')
const GamepadButton GAMEPAD_BUTTON_LEFT_FACE_UP = .leftFaceUp;

@Deprecated('Use .leftFaceRight instead')
const GamepadButton GAMEPAD_BUTTON_LEFT_FACE_RIGHT = .leftFaceRight;

@Deprecated('Use .leftFaceDown instead')
const GamepadButton GAMEPAD_BUTTON_LEFT_FACE_DOWN = .leftFaceDown;

@Deprecated('Use .leftFaceLeft instead')
const GamepadButton GAMEPAD_BUTTON_LEFT_FACE_LEFT = .leftFaceLeft;

@Deprecated('Use .rightFaceUp instead')
const GamepadButton GAMEPAD_BUTTON_RIGHT_FACE_UP = .rightFaceUp;

@Deprecated('Use .rightFaceRight instead')
const GamepadButton GAMEPAD_BUTTON_RIGHT_FACE_RIGHT = .rightFaceRight;

@Deprecated('Use .rightFaceDown instead')
const GamepadButton GAMEPAD_BUTTON_RIGHT_FACE_DOWN = .rightFaceDown;

@Deprecated('Use .rightFaceLeft instead')
const GamepadButton GAMEPAD_BUTTON_RIGHT_FACE_LEFT = .rightFaceLeft;

@Deprecated('Use .leftTrigger1 instead')
const GamepadButton GAMEPAD_BUTTON_LEFT_TRIGGER_1 = .leftTrigger1;

@Deprecated('Use .leftTrigger2 instead')
const GamepadButton GAMEPAD_BUTTON_LEFT_TRIGGER_2 = .leftTrigger2;

@Deprecated('Use .rightTrigger1 instead')
const GamepadButton GAMEPAD_BUTTON_RIGHT_TRIGGER_1 = .rightTrigger1;

@Deprecated('Use .rightTrigger2 instead')
const GamepadButton GAMEPAD_BUTTON_RIGHT_TRIGGER_2 = .rightTrigger2;

@Deprecated('Use .middleLeft instead')
const GamepadButton GAMEPAD_BUTTON_MIDDLE_LEFT = .middleLeft;

@Deprecated('Use .middle instead')
const GamepadButton GAMEPAD_BUTTON_MIDDLE = .middle;

@Deprecated('Use .middleRight instead')
const GamepadButton GAMEPAD_BUTTON_MIDDLE_RIGHT = .middleRight;

@Deprecated('Use .leftThumb instead')
const GamepadButton GAMEPAD_BUTTON_LEFT_THUMB = .leftThumb;

@Deprecated('Use .rightThumb instead')
const GamepadButton GAMEPAD_BUTTON_RIGHT_THUMB = .rightThumb;

enum GamepadAxis {
  leftX(.GAMEPAD_AXIS_LEFT_X),
  leftY(.GAMEPAD_AXIS_LEFT_Y),
  rightX(.GAMEPAD_AXIS_RIGHT_X),
  rightY(.GAMEPAD_AXIS_RIGHT_Y),
  leftTrigger(.GAMEPAD_AXIS_LEFT_TRIGGER),
  rightTrigger(.GAMEPAD_AXIS_RIGHT_TRIGGER);

  final consts.GamepadAxis code;
  const GamepadAxis(this.code);
  int get value => code.value;

  static GamepadAxis fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown GamepadAxis value: $value'),
  );
}

@Deprecated('Use .leftX instead')
const GamepadAxis GAMEPAD_AXIS_LEFT_X = .leftX;

@Deprecated('Use .leftY instead')
const GamepadAxis GAMEPAD_AXIS_LEFT_Y = .leftY;

@Deprecated('Use .rightX instead')
const GamepadAxis GAMEPAD_AXIS_RIGHT_X = .rightX;

@Deprecated('Use .rightY instead')
const GamepadAxis GAMEPAD_AXIS_RIGHT_Y = .rightY;

@Deprecated('Use .leftTrigger instead')
const GamepadAxis GAMEPAD_AXIS_LEFT_TRIGGER = .leftTrigger;

@Deprecated('Use .rightTrigger instead')
const GamepadAxis GAMEPAD_AXIS_RIGHT_TRIGGER = .rightTrigger;

enum MaterialMapIndex {
  albedo(.MATERIAL_MAP_ALBEDO),
  metalness(.MATERIAL_MAP_METALNESS),
  normal(.MATERIAL_MAP_NORMAL),
  roughness(.MATERIAL_MAP_ROUGHNESS),
  occlusion(.MATERIAL_MAP_OCCLUSION),
  emission(.MATERIAL_MAP_EMISSION),
  height(.MATERIAL_MAP_HEIGHT),
  cubemap(.MATERIAL_MAP_CUBEMAP),
  irradiance(.MATERIAL_MAP_IRRADIANCE),
  prefilter(.MATERIAL_MAP_PREFILTER),
  brdf(.MATERIAL_MAP_BRDF);

  final consts.MaterialMapIndex code;
  const MaterialMapIndex(this.code);
  int get value => code.value;

  static MaterialMapIndex fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown MaterialMapIndex value: $value'),
  );
}

@Deprecated('Use .albedo instead')
const MaterialMapIndex MATERIAL_MAP_ALBEDO = .albedo;

@Deprecated('Use .metalness instead')
const MaterialMapIndex MATERIAL_MAP_METALNESS = .metalness;

@Deprecated('Use .normal instead')
const MaterialMapIndex MATERIAL_MAP_NORMAL = .normal;

@Deprecated('Use .roughness instead')
const MaterialMapIndex MATERIAL_MAP_ROUGHNESS = .roughness;

@Deprecated('Use .occlusion instead')
const MaterialMapIndex MATERIAL_MAP_OCCLUSION = .occlusion;

@Deprecated('Use .emission instead')
const MaterialMapIndex MATERIAL_MAP_EMISSION = .emission;

@Deprecated('Use .height instead')
const MaterialMapIndex MATERIAL_MAP_HEIGHT = .height;

@Deprecated('Use .cubemap instead')
const MaterialMapIndex MATERIAL_MAP_CUBEMAP = .cubemap;

@Deprecated('Use .irradiance instead')
const MaterialMapIndex MATERIAL_MAP_IRRADIANCE = .irradiance;

@Deprecated('Use .prefilter instead')
const MaterialMapIndex MATERIAL_MAP_PREFILTER = .prefilter;

@Deprecated('Use .brdf instead')
const MaterialMapIndex MATERIAL_MAP_BRDF = .brdf;

enum ShaderLocationIndex {
  vertexPosition(.SHADER_LOC_VERTEX_POSITION),
  vertexTexcoord01(.SHADER_LOC_VERTEX_TEXCOORD01),
  vertexTexcoord02(.SHADER_LOC_VERTEX_TEXCOORD02),
  vertexNormal(.SHADER_LOC_VERTEX_NORMAL),
  vertexTangent(.SHADER_LOC_VERTEX_TANGENT),
  vertexColor(.SHADER_LOC_VERTEX_COLOR),
  matrixMvp(.SHADER_LOC_MATRIX_MVP),
  matrixView(.SHADER_LOC_MATRIX_VIEW),
  matrixProjection(.SHADER_LOC_MATRIX_PROJECTION),
  matrixModel(.SHADER_LOC_MATRIX_MODEL),
  matrixNormal(.SHADER_LOC_MATRIX_NORMAL),
  vectorView(.SHADER_LOC_VECTOR_VIEW),
  colorDiffuse(.SHADER_LOC_COLOR_DIFFUSE),
  colorSpecular(.SHADER_LOC_COLOR_SPECULAR),
  colorAmbient(.SHADER_LOC_COLOR_AMBIENT),
  mapAlbedo(.SHADER_LOC_MAP_ALBEDO),
  mapMetalness(.SHADER_LOC_MAP_METALNESS),
  mapNormal(.SHADER_LOC_MAP_NORMAL),
  mapRoughness(.SHADER_LOC_MAP_ROUGHNESS),
  mapOcclusion(.SHADER_LOC_MAP_OCCLUSION),
  mapEmission(.SHADER_LOC_MAP_EMISSION),
  mapHeight(.SHADER_LOC_MAP_HEIGHT),
  mapCubemap(.SHADER_LOC_MAP_CUBEMAP),
  mapIrradiance(.SHADER_LOC_MAP_IRRADIANCE),
  mapPrefilter(.SHADER_LOC_MAP_PREFILTER),
  mapBrdf(.SHADER_LOC_MAP_BRDF),
  vertexBoneids(.SHADER_LOC_VERTEX_BONEIDS),
  vertexBoneweights(.SHADER_LOC_VERTEX_BONEWEIGHTS),
  boneMatrices(.SHADER_LOC_BONE_MATRICES);

  final consts.ShaderLocationIndex code;
  const ShaderLocationIndex(this.code);
  int get value => code.value;

  static ShaderLocationIndex fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () =>
        throw ArgumentError('Unknown ShaderLocationIndex value: $value'),
  );
}

@Deprecated('Use .vertexPosition instead')
const ShaderLocationIndex SHADER_LOC_VERTEX_POSITION = .vertexPosition;

@Deprecated('Use .vertexTexcoord01 instead')
const ShaderLocationIndex SHADER_LOC_VERTEX_TEXCOORD01 = .vertexTexcoord01;

@Deprecated('Use .vertexTexcoord02 instead')
const ShaderLocationIndex SHADER_LOC_VERTEX_TEXCOORD02 = .vertexTexcoord02;

@Deprecated('Use .vertexNormal instead')
const ShaderLocationIndex SHADER_LOC_VERTEX_NORMAL = .vertexNormal;

@Deprecated('Use .vertexTangent instead')
const ShaderLocationIndex SHADER_LOC_VERTEX_TANGENT = .vertexTangent;

@Deprecated('Use .vertexColor instead')
const ShaderLocationIndex SHADER_LOC_VERTEX_COLOR = .vertexColor;

@Deprecated('Use .matrixMvp instead')
const ShaderLocationIndex SHADER_LOC_MATRIX_MVP = .matrixMvp;

@Deprecated('Use .matrixView instead')
const ShaderLocationIndex SHADER_LOC_MATRIX_VIEW = .matrixView;

@Deprecated('Use .matrixProjection instead')
const ShaderLocationIndex SHADER_LOC_MATRIX_PROJECTION = .matrixProjection;

@Deprecated('Use .matrixModel instead')
const ShaderLocationIndex SHADER_LOC_MATRIX_MODEL = .matrixModel;

@Deprecated('Use .matrixNormal instead')
const ShaderLocationIndex SHADER_LOC_MATRIX_NORMAL = .matrixNormal;

@Deprecated('Use .vectorView instead')
const ShaderLocationIndex SHADER_LOC_VECTOR_VIEW = .vectorView;

@Deprecated('Use .colorDiffuse instead')
const ShaderLocationIndex SHADER_LOC_COLOR_DIFFUSE = .colorDiffuse;

@Deprecated('Use .colorSpecular instead')
const ShaderLocationIndex SHADER_LOC_COLOR_SPECULAR = .colorSpecular;

@Deprecated('Use .colorAmbient instead')
const ShaderLocationIndex SHADER_LOC_COLOR_AMBIENT = .colorAmbient;

@Deprecated('Use .mapAlbedo instead')
const ShaderLocationIndex SHADER_LOC_MAP_ALBEDO = .mapAlbedo;

@Deprecated('Use .mapMetalness instead')
const ShaderLocationIndex SHADER_LOC_MAP_METALNESS = .mapMetalness;

@Deprecated('Use .mapNormal instead')
const ShaderLocationIndex SHADER_LOC_MAP_NORMAL = .mapNormal;

@Deprecated('Use .mapRoughness instead')
const ShaderLocationIndex SHADER_LOC_MAP_ROUGHNESS = .mapRoughness;

@Deprecated('Use .mapOcclusion instead')
const ShaderLocationIndex SHADER_LOC_MAP_OCCLUSION = .mapOcclusion;

@Deprecated('Use .mapEmission instead')
const ShaderLocationIndex SHADER_LOC_MAP_EMISSION = .mapEmission;

@Deprecated('Use .mapHeight instead')
const ShaderLocationIndex SHADER_LOC_MAP_HEIGHT = .mapHeight;

@Deprecated('Use .mapCubemap instead')
const ShaderLocationIndex SHADER_LOC_MAP_CUBEMAP = .mapCubemap;

@Deprecated('Use .mapIrradiance instead')
const ShaderLocationIndex SHADER_LOC_MAP_IRRADIANCE = .mapIrradiance;

@Deprecated('Use .mapPrefilter instead')
const ShaderLocationIndex SHADER_LOC_MAP_PREFILTER = .mapPrefilter;

@Deprecated('Use .mapBrdf instead')
const ShaderLocationIndex SHADER_LOC_MAP_BRDF = .mapBrdf;

@Deprecated('Use .vertexBoneids instead')
const ShaderLocationIndex SHADER_LOC_VERTEX_BONEIDS = .vertexBoneids;

@Deprecated('Use .vertexBoneweights instead')
const ShaderLocationIndex SHADER_LOC_VERTEX_BONEWEIGHTS = .vertexBoneweights;

@Deprecated('Use .boneMatrices instead')
const ShaderLocationIndex SHADER_LOC_BONE_MATRICES = .boneMatrices;

enum ShaderUniformDataType {
  float_(.SHADER_UNIFORM_FLOAT),
  vec2(.SHADER_UNIFORM_VEC2),
  vec3(.SHADER_UNIFORM_VEC3),
  vec4(.SHADER_UNIFORM_VEC4),
  int_(.SHADER_UNIFORM_INT),
  ivec2(.SHADER_UNIFORM_IVEC2),
  ivec3(.SHADER_UNIFORM_IVEC3),
  ivec4(.SHADER_UNIFORM_IVEC4),
  sampler2d(.SHADER_UNIFORM_SAMPLER2D);

  final consts.ShaderUniformDataType code;
  const ShaderUniformDataType(this.code);
  int get value => code.value;

  static ShaderUniformDataType fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () =>
        throw ArgumentError('Unknown ShaderUniformDataType value: $value'),
  );
}

@Deprecated('Use .float_ instead')
const ShaderUniformDataType SHADER_UNIFORM_FLOAT = .float_;

@Deprecated('Use .vec2 instead')
const ShaderUniformDataType SHADER_UNIFORM_VEC2 = .vec2;

@Deprecated('Use .vec3 instead')
const ShaderUniformDataType SHADER_UNIFORM_VEC3 = .vec3;

@Deprecated('Use .vec4 instead')
const ShaderUniformDataType SHADER_UNIFORM_VEC4 = .vec4;

@Deprecated('Use .int_ instead')
const ShaderUniformDataType SHADER_UNIFORM_INT = .int_;

@Deprecated('Use .ivec2 instead')
const ShaderUniformDataType SHADER_UNIFORM_IVEC2 = .ivec2;

@Deprecated('Use .ivec3 instead')
const ShaderUniformDataType SHADER_UNIFORM_IVEC3 = .ivec3;

@Deprecated('Use .ivec4 instead')
const ShaderUniformDataType SHADER_UNIFORM_IVEC4 = .ivec4;

@Deprecated('Use .sampler2d instead')
const ShaderUniformDataType SHADER_UNIFORM_SAMPLER2D = .sampler2d;

enum ShaderAttributeDataType {
  float_(.SHADER_ATTRIB_FLOAT),
  vec2(.SHADER_ATTRIB_VEC2),
  vec3(.SHADER_ATTRIB_VEC3),
  vec4(.SHADER_ATTRIB_VEC4);

  final consts.ShaderAttributeDataType code;
  const ShaderAttributeDataType(this.code);
  int get value => code.value;

  static ShaderAttributeDataType fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () =>
        throw ArgumentError('Unknown ShaderAttributeDataType value: $value'),
  );
}

@Deprecated('Use .float_ instead')
const ShaderAttributeDataType SHADER_ATTRIB_FLOAT = .float_;

@Deprecated('Use .vec2 instead')
const ShaderAttributeDataType SHADER_ATTRIB_VEC2 = .vec2;

@Deprecated('Use .vec3 instead')
const ShaderAttributeDataType SHADER_ATTRIB_VEC3 = .vec3;

@Deprecated('Use .vec4 instead')
const ShaderAttributeDataType SHADER_ATTRIB_VEC4 = .vec4;

enum PixelFormat {
  uncompressedGrayscale(.PIXELFORMAT_UNCOMPRESSED_GRAYSCALE),
  uncompressedGrayAlpha(.PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA),
  uncompressedR5g6b5(.PIXELFORMAT_UNCOMPRESSED_R5G6B5),
  uncompressedR8g8b8(.PIXELFORMAT_UNCOMPRESSED_R8G8B8),
  uncompressedR5g5b5a1(.PIXELFORMAT_UNCOMPRESSED_R5G5B5A1),
  uncompressedR4g4b4a4(.PIXELFORMAT_UNCOMPRESSED_R4G4B4A4),
  uncompressedR8g8b8a8(.PIXELFORMAT_UNCOMPRESSED_R8G8B8A8),
  uncompressedR32(.PIXELFORMAT_UNCOMPRESSED_R32),
  uncompressedR32g32b32(.PIXELFORMAT_UNCOMPRESSED_R32G32B32),
  uncompressedR32g32b32a32(.PIXELFORMAT_UNCOMPRESSED_R32G32B32A32),
  uncompressedR16(.PIXELFORMAT_UNCOMPRESSED_R16),
  uncompressedR16g16b16(.PIXELFORMAT_UNCOMPRESSED_R16G16B16),
  uncompressedR16g16b16a16(.PIXELFORMAT_UNCOMPRESSED_R16G16B16A16),
  compressedDxt1Rgb(.PIXELFORMAT_COMPRESSED_DXT1_RGB),
  compressedDxt1Rgba(.PIXELFORMAT_COMPRESSED_DXT1_RGBA),
  compressedDxt3Rgba(.PIXELFORMAT_COMPRESSED_DXT3_RGBA),
  compressedDxt5Rgba(.PIXELFORMAT_COMPRESSED_DXT5_RGBA),
  compressedEtc1Rgb(.PIXELFORMAT_COMPRESSED_ETC1_RGB),
  compressedEtc2Rgb(.PIXELFORMAT_COMPRESSED_ETC2_RGB),
  compressedEtc2EacRgba(.PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA),
  compressedPvrtRgb(.PIXELFORMAT_COMPRESSED_PVRT_RGB),
  compressedPvrtRgba(.PIXELFORMAT_COMPRESSED_PVRT_RGBA),
  compressedAstc4x4Rgba(.PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA),
  compressedAstc8x8Rgba(.PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA);

  final consts.PixelFormat code;
  const PixelFormat(this.code);
  int get value => code.value;

  static PixelFormat fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown PixelFormat value: $value'),
  );
}

@Deprecated('Use .uncompressedGrayscale instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = .uncompressedGrayscale;

@Deprecated('Use .uncompressedGrayAlpha instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA = .uncompressedGrayAlpha;

@Deprecated('Use .uncompressedR5g6b5 instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_R5G6B5 = .uncompressedR5g6b5;

@Deprecated('Use .uncompressedR8g8b8 instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_R8G8B8 = .uncompressedR8g8b8;

@Deprecated('Use .uncompressedR5g5b5a1 instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_R5G5B5A1 = .uncompressedR5g5b5a1;

@Deprecated('Use .uncompressedR4g4b4a4 instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_R4G4B4A4 = .uncompressedR4g4b4a4;

@Deprecated('Use .uncompressedR8g8b8a8 instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 = .uncompressedR8g8b8a8;

@Deprecated('Use .uncompressedR32 instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_R32 = .uncompressedR32;

@Deprecated('Use .uncompressedR32g32b32 instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_R32G32B32 = .uncompressedR32g32b32;

@Deprecated('Use .uncompressedR32g32b32a32 instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 =
    .uncompressedR32g32b32a32;

@Deprecated('Use .uncompressedR16 instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_R16 = .uncompressedR16;

@Deprecated('Use .uncompressedR16g16b16 instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_R16G16B16 = .uncompressedR16g16b16;

@Deprecated('Use .uncompressedR16g16b16a16 instead')
const PixelFormat PIXELFORMAT_UNCOMPRESSED_R16G16B16A16 =
    .uncompressedR16g16b16a16;

@Deprecated('Use .compressedDxt1Rgb instead')
const PixelFormat PIXELFORMAT_COMPRESSED_DXT1_RGB = .compressedDxt1Rgb;

@Deprecated('Use .compressedDxt1Rgba instead')
const PixelFormat PIXELFORMAT_COMPRESSED_DXT1_RGBA = .compressedDxt1Rgba;

@Deprecated('Use .compressedDxt3Rgba instead')
const PixelFormat PIXELFORMAT_COMPRESSED_DXT3_RGBA = .compressedDxt3Rgba;

@Deprecated('Use .compressedDxt5Rgba instead')
const PixelFormat PIXELFORMAT_COMPRESSED_DXT5_RGBA = .compressedDxt5Rgba;

@Deprecated('Use .compressedEtc1Rgb instead')
const PixelFormat PIXELFORMAT_COMPRESSED_ETC1_RGB = .compressedEtc1Rgb;

@Deprecated('Use .compressedEtc2Rgb instead')
const PixelFormat PIXELFORMAT_COMPRESSED_ETC2_RGB = .compressedEtc2Rgb;

@Deprecated('Use .compressedEtc2EacRgba instead')
const PixelFormat PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA = .compressedEtc2EacRgba;

@Deprecated('Use .compressedPvrtRgb instead')
const PixelFormat PIXELFORMAT_COMPRESSED_PVRT_RGB = .compressedPvrtRgb;

@Deprecated('Use .compressedPvrtRgba instead')
const PixelFormat PIXELFORMAT_COMPRESSED_PVRT_RGBA = .compressedPvrtRgba;

@Deprecated('Use .compressedAstc4x4Rgba instead')
const PixelFormat PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA = .compressedAstc4x4Rgba;

@Deprecated('Use .compressedAstc8x8Rgba instead')
const PixelFormat PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA = .compressedAstc8x8Rgba;

enum TextureFilter {
  point(.TEXTURE_FILTER_POINT),
  bilinear(.TEXTURE_FILTER_BILINEAR),
  trilinear(.TEXTURE_FILTER_TRILINEAR),
  anisotropic4x(.TEXTURE_FILTER_ANISOTROPIC_4X),
  anisotropic8x(.TEXTURE_FILTER_ANISOTROPIC_8X),
  anisotropic16x(.TEXTURE_FILTER_ANISOTROPIC_16X);

  final consts.TextureFilter code;
  const TextureFilter(this.code);
  int get value => code.value;

  static TextureFilter fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown TextureFilter value: $value'),
  );
}

@Deprecated('Use .point instead')
const TextureFilter TEXTURE_FILTER_POINT = .point;

@Deprecated('Use .bilinear instead')
const TextureFilter TEXTURE_FILTER_BILINEAR = .bilinear;

@Deprecated('Use .trilinear instead')
const TextureFilter TEXTURE_FILTER_TRILINEAR = .trilinear;

@Deprecated('Use .anisotropic4x instead')
const TextureFilter TEXTURE_FILTER_ANISOTROPIC_4X = .anisotropic4x;

@Deprecated('Use .anisotropic8x instead')
const TextureFilter TEXTURE_FILTER_ANISOTROPIC_8X = .anisotropic8x;

@Deprecated('Use .anisotropic16x instead')
const TextureFilter TEXTURE_FILTER_ANISOTROPIC_16X = .anisotropic16x;

enum TextureWrap {
  repeat(.TEXTURE_WRAP_REPEAT),
  clamp(.TEXTURE_WRAP_CLAMP),
  mirrorRepeat(.TEXTURE_WRAP_MIRROR_REPEAT),
  mirrorClamp(.TEXTURE_WRAP_MIRROR_CLAMP);

  final consts.TextureWrap code;
  const TextureWrap(this.code);
  int get value => code.value;

  static TextureWrap fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown TextureWrap value: $value'),
  );
}

@Deprecated('Use .repeat instead')
const TextureWrap TEXTURE_WRAP_REPEAT = .repeat;

@Deprecated('Use .clamp instead')
const TextureWrap TEXTURE_WRAP_CLAMP = .clamp;

@Deprecated('Use .mirrorRepeat instead')
const TextureWrap TEXTURE_WRAP_MIRROR_REPEAT = .mirrorRepeat;

@Deprecated('Use .mirrorClamp instead')
const TextureWrap TEXTURE_WRAP_MIRROR_CLAMP = .mirrorClamp;

enum CubemapLayout {
  autoDetect(.CUBEMAP_LAYOUT_AUTO_DETECT),
  lineVertical(.CUBEMAP_LAYOUT_LINE_VERTICAL),
  lineHorizontal(.CUBEMAP_LAYOUT_LINE_HORIZONTAL),
  crossThreeByFour(.CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR),
  crossFourByThree(.CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE);

  final consts.CubemapLayout code;
  const CubemapLayout(this.code);
  int get value => code.value;

  static CubemapLayout fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown CubemapLayout value: $value'),
  );
}

@Deprecated('Use .autoDetect instead')
const CubemapLayout CUBEMAP_LAYOUT_AUTO_DETECT = .autoDetect;

@Deprecated('Use .lineVertical instead')
const CubemapLayout CUBEMAP_LAYOUT_LINE_VERTICAL = .lineVertical;

@Deprecated('Use .lineHorizontal instead')
const CubemapLayout CUBEMAP_LAYOUT_LINE_HORIZONTAL = .lineHorizontal;

@Deprecated('Use .crossThreeByFour instead')
const CubemapLayout CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR = .crossThreeByFour;

@Deprecated('Use .crossFourByThree instead')
const CubemapLayout CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE = .crossFourByThree;

enum FontType {
  default_(.FONT_DEFAULT),
  bitmap(.FONT_BITMAP),
  sdf(.FONT_SDF);

  final consts.FontType code;
  const FontType(this.code);
  int get value => code.value;

  static FontType fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown FontType value: $value'),
  );
}

@Deprecated('Use .default_ instead')
const FontType FONT_DEFAULT = .default_;

@Deprecated('Use .bitmap instead')
const FontType FONT_BITMAP = .bitmap;

@Deprecated('Use .sdf instead')
const FontType FONT_SDF = .sdf;

enum BlendMode {
  alpha(.BLEND_ALPHA),
  additive(.BLEND_ADDITIVE),
  multiplied(.BLEND_MULTIPLIED),
  addColors(.BLEND_ADD_COLORS),
  subtractColors(.BLEND_SUBTRACT_COLORS),
  alphaPremultiply(.BLEND_ALPHA_PREMULTIPLY),
  custom(.BLEND_CUSTOM),
  customSeparate(.BLEND_CUSTOM_SEPARATE);

  final consts.BlendMode code;
  const BlendMode(this.code);
  int get value => code.value;

  static BlendMode fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown BlendMode value: $value'),
  );
}

@Deprecated('Use .alpha instead')
const BlendMode BLEND_ALPHA = .alpha;

@Deprecated('Use .additive instead')
const BlendMode BLEND_ADDITIVE = .additive;

@Deprecated('Use .multiplied instead')
const BlendMode BLEND_MULTIPLIED = .multiplied;

@Deprecated('Use .addColors instead')
const BlendMode BLEND_ADD_COLORS = .addColors;

@Deprecated('Use .subtractColors instead')
const BlendMode BLEND_SUBTRACT_COLORS = .subtractColors;

@Deprecated('Use .alphaPremultiply instead')
const BlendMode BLEND_ALPHA_PREMULTIPLY = .alphaPremultiply;

@Deprecated('Use .custom instead')
const BlendMode BLEND_CUSTOM = .custom;

@Deprecated('Use .customSeparate instead')
const BlendMode BLEND_CUSTOM_SEPARATE = .customSeparate;

enum Gesture {
  none(.GESTURE_NONE),
  tap(.GESTURE_TAP),
  doubletap(.GESTURE_DOUBLETAP),
  hold(.GESTURE_HOLD),
  drag(.GESTURE_DRAG),
  swipeRight(.GESTURE_SWIPE_RIGHT),
  swipeLeft(.GESTURE_SWIPE_LEFT),
  swipeUp(.GESTURE_SWIPE_UP),
  swipeDown(.GESTURE_SWIPE_DOWN),
  pinchIn(.GESTURE_PINCH_IN),
  pinchOut(.GESTURE_PINCH_OUT);

  final consts.Gesture code;
  const Gesture(this.code);
  int get value => code.value;

  static Gesture fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown Gesture value: $value'),
  );
}

@Deprecated('Use .none instead')
const Gesture GESTURE_NONE = .none;

@Deprecated('Use .tap instead')
const Gesture GESTURE_TAP = .tap;

@Deprecated('Use .doubletap instead')
const Gesture GESTURE_DOUBLETAP = .doubletap;

@Deprecated('Use .hold instead')
const Gesture GESTURE_HOLD = .hold;

@Deprecated('Use .drag instead')
const Gesture GESTURE_DRAG = .drag;

@Deprecated('Use .swipeRight instead')
const Gesture GESTURE_SWIPE_RIGHT = .swipeRight;

@Deprecated('Use .swipeLeft instead')
const Gesture GESTURE_SWIPE_LEFT = .swipeLeft;

@Deprecated('Use .swipeUp instead')
const Gesture GESTURE_SWIPE_UP = .swipeUp;

@Deprecated('Use .swipeDown instead')
const Gesture GESTURE_SWIPE_DOWN = .swipeDown;

@Deprecated('Use .pinchIn instead')
const Gesture GESTURE_PINCH_IN = .pinchIn;

@Deprecated('Use .pinchOut instead')
const Gesture GESTURE_PINCH_OUT = .pinchOut;

enum CameraMode {
  custom(.CAMERA_CUSTOM),
  free(.CAMERA_FREE),
  orbital(.CAMERA_ORBITAL),
  firstPerson(.CAMERA_FIRST_PERSON),
  thirdPerson(.CAMERA_THIRD_PERSON);

  final consts.CameraMode code;
  const CameraMode(this.code);
  int get value => code.value;

  static CameraMode fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown CameraMode value: $value'),
  );
}

@Deprecated('Use .custom instead')
const CameraMode CAMERA_CUSTOM = .custom;

@Deprecated('Use .free instead')
const CameraMode CAMERA_FREE = .free;

@Deprecated('Use .orbital instead')
const CameraMode CAMERA_ORBITAL = .orbital;

@Deprecated('Use .firstPerson instead')
const CameraMode CAMERA_FIRST_PERSON = .firstPerson;

@Deprecated('Use .thirdPerson instead')
const CameraMode CAMERA_THIRD_PERSON = .thirdPerson;

enum CameraProjection {
  perspective(.CAMERA_PERSPECTIVE),
  orthographic(.CAMERA_ORTHOGRAPHIC);

  final consts.CameraProjection code;
  const CameraProjection(this.code);
  int get value => code.value;

  static CameraProjection fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown CameraProjection value: $value'),
  );
}

@Deprecated('Use .perspective instead')
const CameraProjection CAMERA_PERSPECTIVE = .perspective;

@Deprecated('Use .orthographic instead')
const CameraProjection CAMERA_ORTHOGRAPHIC = .orthographic;

enum NPatchLayout {
  ninePatch(.NPATCH_NINE_PATCH),
  threePatchVertical(.NPATCH_THREE_PATCH_VERTICAL),
  threePatchHorizontal(.NPATCH_THREE_PATCH_HORIZONTAL);

  final consts.NPatchLayout code;
  const NPatchLayout(this.code);
  int get value => code.value;

  static NPatchLayout fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown NPatchLayout value: $value'),
  );
}

@Deprecated('Use .ninePatch instead')
const NPatchLayout NPATCH_NINE_PATCH = .ninePatch;

@Deprecated('Use .threePatchVertical instead')
const NPatchLayout NPATCH_THREE_PATCH_VERTICAL = .threePatchVertical;

@Deprecated('Use .threePatchHorizontal instead')
const NPatchLayout NPATCH_THREE_PATCH_HORIZONTAL = .threePatchHorizontal;

enum RlGlVersion {
  openGl11(.RL_OPENGL_11),
  openGl21(.RL_OPENGL_21),
  openGl33(.RL_OPENGL_33),
  openGl43(.RL_OPENGL_43),
  openGlEs20(.RL_OPENGL_ES_20),
  openGlEs30(.RL_OPENGL_ES_30);

  final consts.rlGlVersion code;
  const RlGlVersion(this.code);
  int get value => code.value;

  static RlGlVersion fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown RlGlVersion value: $value'),
  );
}

@Deprecated('Use .openGl11 instead')
const RlGlVersion RL_OPENGL_11 = .openGl11;

@Deprecated('Use .openGl21 instead')
const RlGlVersion RL_OPENGL_21 = .openGl21;

@Deprecated('Use .openGl33 instead')
const RlGlVersion RL_OPENGL_33 = .openGl33;

@Deprecated('Use .openGl43 instead')
const RlGlVersion RL_OPENGL_43 = .openGl43;

@Deprecated('Use .openGlEs20 instead')
const RlGlVersion RL_OPENGL_ES_20 = .openGlEs20;

@Deprecated('Use .openGlEs30 instead')
const RlGlVersion RL_OPENGL_ES_30 = .openGlEs30;

enum RlTraceLogLevel {
  all(.RL_LOG_ALL),
  trace(.RL_LOG_TRACE),
  debug(.RL_LOG_DEBUG),
  info(.RL_LOG_INFO),
  warning(.RL_LOG_WARNING),
  error(.RL_LOG_ERROR),
  fatal(.RL_LOG_FATAL),
  none(.RL_LOG_NONE);

  final consts.rlTraceLogLevel code;
  const RlTraceLogLevel(this.code);
  int get value => code.value;

  static RlTraceLogLevel fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown RlTraceLogLevel value: $value'),
  );
}

@Deprecated('Use .all instead')
const RlTraceLogLevel RL_LOG_ALL = .all;

@Deprecated('Use .trace instead')
const RlTraceLogLevel RL_LOG_TRACE = .trace;

@Deprecated('Use .debug instead')
const RlTraceLogLevel RL_LOG_DEBUG = .debug;

@Deprecated('Use .info instead')
const RlTraceLogLevel RL_LOG_INFO = .info;

@Deprecated('Use .warning instead')
const RlTraceLogLevel RL_LOG_WARNING = .warning;

@Deprecated('Use .error instead')
const RlTraceLogLevel RL_LOG_ERROR = .error;

@Deprecated('Use .fatal instead')
const RlTraceLogLevel RL_LOG_FATAL = .fatal;

@Deprecated('Use .none instead')
const RlTraceLogLevel RL_LOG_NONE = .none;

enum RlPixelFormat {
  uncompressedGrayscale(.RL_PIXELFORMAT_UNCOMPRESSED_GRAYSCALE),
  uncompressedGrayAlpha(.RL_PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA),
  uncompressedR5G6B5(.RL_PIXELFORMAT_UNCOMPRESSED_R5G6B5),
  uncompressedR8G8B8(.RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8),
  uncompressedR5G5B5A1(.RL_PIXELFORMAT_UNCOMPRESSED_R5G5B5A1),
  uncompressedR4G4B4A4(.RL_PIXELFORMAT_UNCOMPRESSED_R4G4B4A4),
  uncompressedR8G8B8A8(.RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8A8),
  uncompressedR32(.RL_PIXELFORMAT_UNCOMPRESSED_R32),
  uncompressedR32G32B32(.RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32),
  uncompressedR32G32B32A32(.RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32A32),
  uncompressedR16(.RL_PIXELFORMAT_UNCOMPRESSED_R16),
  uncompressedR16G16B16(.RL_PIXELFORMAT_UNCOMPRESSED_R16G16B16),
  uncompressedR16G16B16A16(.RL_PIXELFORMAT_UNCOMPRESSED_R16G16B16A16),
  compressedDxt1Rgb(.RL_PIXELFORMAT_COMPRESSED_DXT1_RGB),
  compressedDxt1Rgba(.RL_PIXELFORMAT_COMPRESSED_DXT1_RGBA),
  compressedDxt3Rgba(.RL_PIXELFORMAT_COMPRESSED_DXT3_RGBA),
  compressedDxt5Rgba(.RL_PIXELFORMAT_COMPRESSED_DXT5_RGBA),
  compressedEtc1Rgb(.RL_PIXELFORMAT_COMPRESSED_ETC1_RGB),
  compressedEtc2Rgb(.RL_PIXELFORMAT_COMPRESSED_ETC2_RGB),
  compressedEtc2EacRgba(.RL_PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA),
  compressedPvrtRgb(.RL_PIXELFORMAT_COMPRESSED_PVRT_RGB),
  compressedPvrtRgba(.RL_PIXELFORMAT_COMPRESSED_PVRT_RGBA),
  compressedAstc4x4Rgba(.RL_PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA),
  compressedAstc8x8Rgba(.RL_PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA);

  final consts.rlPixelFormat code;
  const RlPixelFormat(this.code);
  int get value => code.value;

  static RlPixelFormat fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown RlPixelFormat value: $value'),
  );
}

@Deprecated('Use .uncompressedGrayscale instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_GRAYSCALE =
    .uncompressedGrayscale;

@Deprecated('Use .uncompressedGrayAlpha instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA =
    .uncompressedGrayAlpha;

@Deprecated('Use .uncompressedR5G6B5 instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_R5G6B5 = .uncompressedR5G6B5;

@Deprecated('Use .uncompressedR8G8B8 instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8 = .uncompressedR8G8B8;

@Deprecated('Use .uncompressedR5G5B5A1 instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_R5G5B5A1 =
    .uncompressedR5G5B5A1;

@Deprecated('Use .uncompressedR4G4B4A4 instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_R4G4B4A4 =
    .uncompressedR4G4B4A4;

@Deprecated('Use .uncompressedR8G8B8A8 instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8A8 =
    .uncompressedR8G8B8A8;

@Deprecated('Use .uncompressedR32 instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_R32 = .uncompressedR32;

@Deprecated('Use .uncompressedR32G32B32 instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32 =
    .uncompressedR32G32B32;

@Deprecated('Use .uncompressedR32G32B32A32 instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 =
    .uncompressedR32G32B32A32;

@Deprecated('Use .uncompressedR16 instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_R16 = .uncompressedR16;

@Deprecated('Use .uncompressedR16G16B16 instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_R16G16B16 =
    .uncompressedR16G16B16;

@Deprecated('Use .uncompressedR16G16B16A16 instead')
const RlPixelFormat RL_PIXELFORMAT_UNCOMPRESSED_R16G16B16A16 =
    .uncompressedR16G16B16A16;

@Deprecated('Use .compressedDxt1Rgb instead')
const RlPixelFormat RL_PIXELFORMAT_COMPRESSED_DXT1_RGB = .compressedDxt1Rgb;

@Deprecated('Use .compressedDxt1Rgba instead')
const RlPixelFormat RL_PIXELFORMAT_COMPRESSED_DXT1_RGBA = .compressedDxt1Rgba;

@Deprecated('Use .compressedDxt3Rgba instead')
const RlPixelFormat RL_PIXELFORMAT_COMPRESSED_DXT3_RGBA = .compressedDxt3Rgba;

@Deprecated('Use .compressedDxt5Rgba instead')
const RlPixelFormat RL_PIXELFORMAT_COMPRESSED_DXT5_RGBA = .compressedDxt5Rgba;

@Deprecated('Use .compressedEtc1Rgb instead')
const RlPixelFormat RL_PIXELFORMAT_COMPRESSED_ETC1_RGB = .compressedEtc1Rgb;

@Deprecated('Use .compressedEtc2Rgb instead')
const RlPixelFormat RL_PIXELFORMAT_COMPRESSED_ETC2_RGB = .compressedEtc2Rgb;

@Deprecated('Use .compressedEtc2EacRgba instead')
const RlPixelFormat RL_PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA =
    .compressedEtc2EacRgba;

@Deprecated('Use .compressedPvrtRgb instead')
const RlPixelFormat RL_PIXELFORMAT_COMPRESSED_PVRT_RGB = .compressedPvrtRgb;

@Deprecated('Use .compressedPvrtRgba instead')
const RlPixelFormat RL_PIXELFORMAT_COMPRESSED_PVRT_RGBA = .compressedPvrtRgba;

@Deprecated('Use .compressedAstc4x4Rgba instead')
const RlPixelFormat RL_PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA =
    .compressedAstc4x4Rgba;

@Deprecated('Use .compressedAstc8x8Rgba instead')
const RlPixelFormat RL_PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA =
    .compressedAstc8x8Rgba;

enum RlTextureFilter {
  point(.RL_TEXTURE_FILTER_POINT),
  bilinear(.RL_TEXTURE_FILTER_BILINEAR),
  trilinear(.RL_TEXTURE_FILTER_TRILINEAR),
  anisotropic4x(.RL_TEXTURE_FILTER_ANISOTROPIC_4X),
  anisotropic8x(.RL_TEXTURE_FILTER_ANISOTROPIC_8X),
  anisotropic16x(.RL_TEXTURE_FILTER_ANISOTROPIC_16X);

  final consts.rlTextureFilter code;
  const RlTextureFilter(this.code);
  int get value => code.value;

  static RlTextureFilter fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown RlTextureFilter value: $value'),
  );
}

@Deprecated('Use .point instead')
const RlTextureFilter RL_TEXTURE_FILTER_POINT = .point;

@Deprecated('Use .bilinear instead')
const RlTextureFilter RL_TEXTURE_FILTER_BILINEAR = .bilinear;

@Deprecated('Use .trilinear instead')
const RlTextureFilter RL_TEXTURE_FILTER_TRILINEAR = .trilinear;

@Deprecated('Use .anisotropic4x instead')
const RlTextureFilter RL_TEXTURE_FILTER_ANISOTROPIC_4X = .anisotropic4x;

@Deprecated('Use .anisotropic8x instead')
const RlTextureFilter RL_TEXTURE_FILTER_ANISOTROPIC_8X = .anisotropic8x;

@Deprecated('Use .anisotropic16x instead')
const RlTextureFilter RL_TEXTURE_FILTER_ANISOTROPIC_16X = .anisotropic16x;

enum RlBlendMode {
  alpha(.RL_BLEND_ALPHA),
  additive(.RL_BLEND_ADDITIVE),
  multiplied(.RL_BLEND_MULTIPLIED),
  addColors(.RL_BLEND_ADD_COLORS),
  subtractColors(.RL_BLEND_SUBTRACT_COLORS),
  alphaPremultiply(.RL_BLEND_ALPHA_PREMULTIPLY),
  custom(.RL_BLEND_CUSTOM),
  customSeparate(.RL_BLEND_CUSTOM_SEPARATE);

  final consts.rlBlendMode code;
  const RlBlendMode(this.code);
  int get value => code.value;

  static RlBlendMode fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown RlBlendMode value: $value'),
  );
}

@Deprecated('Use .alpha instead')
const RlBlendMode RL_BLEND_ALPHA = .alpha;

@Deprecated('Use .additive instead')
const RlBlendMode RL_BLEND_ADDITIVE = .additive;

@Deprecated('Use .multiplied instead')
const RlBlendMode RL_BLEND_MULTIPLIED = .multiplied;

@Deprecated('Use .addColors instead')
const RlBlendMode RL_BLEND_ADD_COLORS = .addColors;

@Deprecated('Use .subtractColors instead')
const RlBlendMode RL_BLEND_SUBTRACT_COLORS = .subtractColors;

@Deprecated('Use .alphaPremultiply instead')
const RlBlendMode RL_BLEND_ALPHA_PREMULTIPLY = .alphaPremultiply;

@Deprecated('Use .custom instead')
const RlBlendMode RL_BLEND_CUSTOM = .custom;

@Deprecated('Use .customSeparate instead')
const RlBlendMode RL_BLEND_CUSTOM_SEPARATE = .customSeparate;

enum RlShaderLocationIndex {
  vertexPosition(.RL_SHADER_LOC_VERTEX_POSITION),
  vertexTexcoord01(.RL_SHADER_LOC_VERTEX_TEXCOORD01),
  vertexTexcoord02(.RL_SHADER_LOC_VERTEX_TEXCOORD02),
  vertexNormal(.RL_SHADER_LOC_VERTEX_NORMAL),
  vertexTangent(.RL_SHADER_LOC_VERTEX_TANGENT),
  vertexColor(.RL_SHADER_LOC_VERTEX_COLOR),
  matrixMvp(.RL_SHADER_LOC_MATRIX_MVP),
  matrixView(.RL_SHADER_LOC_MATRIX_VIEW),
  matrixProjection(.RL_SHADER_LOC_MATRIX_PROJECTION),
  matrixModel(.RL_SHADER_LOC_MATRIX_MODEL),
  matrixNormal(.RL_SHADER_LOC_MATRIX_NORMAL),
  vectorView(.RL_SHADER_LOC_VECTOR_VIEW),
  colorDiffuse(.RL_SHADER_LOC_COLOR_DIFFUSE),
  colorSpecular(.RL_SHADER_LOC_COLOR_SPECULAR),
  colorAmbient(.RL_SHADER_LOC_COLOR_AMBIENT),
  mapAlbedo(.RL_SHADER_LOC_MAP_ALBEDO),
  mapMetalness(.RL_SHADER_LOC_MAP_METALNESS),
  mapNormal(.RL_SHADER_LOC_MAP_NORMAL),
  mapRoughness(.RL_SHADER_LOC_MAP_ROUGHNESS),
  mapOcclusion(.RL_SHADER_LOC_MAP_OCCLUSION),
  mapEmission(.RL_SHADER_LOC_MAP_EMISSION),
  mapHeight(.RL_SHADER_LOC_MAP_HEIGHT),
  mapCubemap(.RL_SHADER_LOC_MAP_CUBEMAP),
  mapIrradiance(.RL_SHADER_LOC_MAP_IRRADIANCE),
  mapPrefilter(.RL_SHADER_LOC_MAP_PREFILTER),
  mapBrdf(.RL_SHADER_LOC_MAP_BRDF);

  final consts.rlShaderLocationIndex code;
  const RlShaderLocationIndex(this.code);
  int get value => code.value;

  static RlShaderLocationIndex fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () =>
        throw ArgumentError('Unknown RlShaderLocationIndex value: $value'),
  );
}

@Deprecated('Use .vertexPosition instead')
const RlShaderLocationIndex RL_SHADER_LOC_VERTEX_POSITION = .vertexPosition;

@Deprecated('Use .vertexTexcoord01 instead')
const RlShaderLocationIndex RL_SHADER_LOC_VERTEX_TEXCOORD01 = .vertexTexcoord01;

@Deprecated('Use .vertexTexcoord02 instead')
const RlShaderLocationIndex RL_SHADER_LOC_VERTEX_TEXCOORD02 = .vertexTexcoord02;

@Deprecated('Use .vertexNormal instead')
const RlShaderLocationIndex RL_SHADER_LOC_VERTEX_NORMAL = .vertexNormal;

@Deprecated('Use .vertexTangent instead')
const RlShaderLocationIndex RL_SHADER_LOC_VERTEX_TANGENT = .vertexTangent;

@Deprecated('Use .vertexColor instead')
const RlShaderLocationIndex RL_SHADER_LOC_VERTEX_COLOR = .vertexColor;

@Deprecated('Use .matrixMvp instead')
const RlShaderLocationIndex RL_SHADER_LOC_MATRIX_MVP = .matrixMvp;

@Deprecated('Use .matrixView instead')
const RlShaderLocationIndex RL_SHADER_LOC_MATRIX_VIEW = .matrixView;

@Deprecated('Use .matrixProjection instead')
const RlShaderLocationIndex RL_SHADER_LOC_MATRIX_PROJECTION = .matrixProjection;

@Deprecated('Use .matrixModel instead')
const RlShaderLocationIndex RL_SHADER_LOC_MATRIX_MODEL = .matrixModel;

@Deprecated('Use .matrixNormal instead')
const RlShaderLocationIndex RL_SHADER_LOC_MATRIX_NORMAL = .matrixNormal;

@Deprecated('Use .vectorView instead')
const RlShaderLocationIndex RL_SHADER_LOC_VECTOR_VIEW = .vectorView;

@Deprecated('Use .colorDiffuse instead')
const RlShaderLocationIndex RL_SHADER_LOC_COLOR_DIFFUSE = .colorDiffuse;

@Deprecated('Use .colorSpecular instead')
const RlShaderLocationIndex RL_SHADER_LOC_COLOR_SPECULAR = .colorSpecular;

@Deprecated('Use .colorAmbient instead')
const RlShaderLocationIndex RL_SHADER_LOC_COLOR_AMBIENT = .colorAmbient;

@Deprecated('Use .mapAlbedo instead')
const RlShaderLocationIndex RL_SHADER_LOC_MAP_ALBEDO = .mapAlbedo;

@Deprecated('Use .mapMetalness instead')
const RlShaderLocationIndex RL_SHADER_LOC_MAP_METALNESS = .mapMetalness;

@Deprecated('Use .mapNormal instead')
const RlShaderLocationIndex RL_SHADER_LOC_MAP_NORMAL = .mapNormal;

@Deprecated('Use .mapRoughness instead')
const RlShaderLocationIndex RL_SHADER_LOC_MAP_ROUGHNESS = .mapRoughness;

@Deprecated('Use .mapOcclusion instead')
const RlShaderLocationIndex RL_SHADER_LOC_MAP_OCCLUSION = .mapOcclusion;

@Deprecated('Use .mapEmission instead')
const RlShaderLocationIndex RL_SHADER_LOC_MAP_EMISSION = .mapEmission;

@Deprecated('Use .mapHeight instead')
const RlShaderLocationIndex RL_SHADER_LOC_MAP_HEIGHT = .mapHeight;

@Deprecated('Use .mapCubemap instead')
const RlShaderLocationIndex RL_SHADER_LOC_MAP_CUBEMAP = .mapCubemap;

@Deprecated('Use .mapIrradiance instead')
const RlShaderLocationIndex RL_SHADER_LOC_MAP_IRRADIANCE = .mapIrradiance;

@Deprecated('Use .mapPrefilter instead')
const RlShaderLocationIndex RL_SHADER_LOC_MAP_PREFILTER = .mapPrefilter;

@Deprecated('Use .mapBrdf instead')
const RlShaderLocationIndex RL_SHADER_LOC_MAP_BRDF = .mapBrdf;

enum RlShaderUniformDataType {
  floatType(.RL_SHADER_UNIFORM_FLOAT),
  vec2(.RL_SHADER_UNIFORM_VEC2),
  vec3(.RL_SHADER_UNIFORM_VEC3),
  vec4(.RL_SHADER_UNIFORM_VEC4),
  intType(.RL_SHADER_UNIFORM_INT),
  ivec2(.RL_SHADER_UNIFORM_IVEC2),
  ivec3(.RL_SHADER_UNIFORM_IVEC3),
  ivec4(.RL_SHADER_UNIFORM_IVEC4),
  uintType(.RL_SHADER_UNIFORM_UINT),
  uvec2(.RL_SHADER_UNIFORM_UIVEC2),
  uvec3(.RL_SHADER_UNIFORM_UIVEC3),
  uvec4(.RL_SHADER_UNIFORM_UIVEC4),
  sampler2d(.RL_SHADER_UNIFORM_SAMPLER2D);

  final consts.rlShaderUniformDataType code;
  const RlShaderUniformDataType(this.code);
  int get value => code.value;

  static RlShaderUniformDataType fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () =>
        throw ArgumentError('Unknown RlShaderUniformDataType value: $value'),
  );
}

@Deprecated('Use .floatType instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_FLOAT = .floatType;

@Deprecated('Use .vec2 instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_VEC2 = .vec2;

@Deprecated('Use .vec3 instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_VEC3 = .vec3;

@Deprecated('Use .vec4 instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_VEC4 = .vec4;

@Deprecated('Use .intType instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_INT = .intType;

@Deprecated('Use .ivec2 instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_IVEC2 = .ivec2;

@Deprecated('Use .ivec3 instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_IVEC3 = .ivec3;

@Deprecated('Use .ivec4 instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_IVEC4 = .ivec4;

@Deprecated('Use .uintType instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_UINT = .uintType;

@Deprecated('Use .uvec2 instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_UIVEC2 = .uvec2;

@Deprecated('Use .uvec3 instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_UIVEC3 = .uvec3;

@Deprecated('Use .uvec4 instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_UIVEC4 = .uvec4;

@Deprecated('Use .sampler2d instead')
const RlShaderUniformDataType RL_SHADER_UNIFORM_SAMPLER2D = .sampler2d;

enum RlShaderAttributeDataType {
  floatType(.RL_SHADER_ATTRIB_FLOAT),
  vec2(.RL_SHADER_ATTRIB_VEC2),
  vec3(.RL_SHADER_ATTRIB_VEC3),
  vec4(.RL_SHADER_ATTRIB_VEC4);

  final consts.rlShaderAttributeDataType code;
  const RlShaderAttributeDataType(this.code);
  int get value => code.value;

  static RlShaderAttributeDataType fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () =>
        throw ArgumentError('Unknown RlShaderAttributeDataType value: $value'),
  );
}

@Deprecated('Use .floatType instead')
const RlShaderAttributeDataType RL_SHADER_ATTRIB_FLOAT = .floatType;

@Deprecated('Use .vec2 instead')
const RlShaderAttributeDataType RL_SHADER_ATTRIB_VEC2 = .vec2;

@Deprecated('Use .vec3 instead')
const RlShaderAttributeDataType RL_SHADER_ATTRIB_VEC3 = .vec3;

@Deprecated('Use .vec4 instead')
const RlShaderAttributeDataType RL_SHADER_ATTRIB_VEC4 = .vec4;

enum RlFramebufferAttachType {
  colorChannel0(.RL_ATTACHMENT_COLOR_CHANNEL0),
  colorChannel1(.RL_ATTACHMENT_COLOR_CHANNEL1),
  colorChannel2(.RL_ATTACHMENT_COLOR_CHANNEL2),
  colorChannel3(.RL_ATTACHMENT_COLOR_CHANNEL3),
  colorChannel4(.RL_ATTACHMENT_COLOR_CHANNEL4),
  colorChannel5(.RL_ATTACHMENT_COLOR_CHANNEL5),
  colorChannel6(.RL_ATTACHMENT_COLOR_CHANNEL6),
  colorChannel7(.RL_ATTACHMENT_COLOR_CHANNEL7),
  depth(.RL_ATTACHMENT_DEPTH),
  stencil(.RL_ATTACHMENT_STENCIL);

  final consts.rlFramebufferAttachType code;
  const RlFramebufferAttachType(this.code);
  int get value => code.value;

  static RlFramebufferAttachType fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () =>
        throw ArgumentError('Unknown RlFramebufferAttachType value: $value'),
  );
}

@Deprecated('Use .colorChannel0 instead')
const RlFramebufferAttachType RL_ATTACHMENT_COLOR_CHANNEL0 = .colorChannel0;

@Deprecated('Use .colorChannel1 instead')
const RlFramebufferAttachType RL_ATTACHMENT_COLOR_CHANNEL1 = .colorChannel1;

@Deprecated('Use .colorChannel2 instead')
const RlFramebufferAttachType RL_ATTACHMENT_COLOR_CHANNEL2 = .colorChannel2;

@Deprecated('Use .colorChannel3 instead')
const RlFramebufferAttachType RL_ATTACHMENT_COLOR_CHANNEL3 = .colorChannel3;

@Deprecated('Use .colorChannel4 instead')
const RlFramebufferAttachType RL_ATTACHMENT_COLOR_CHANNEL4 = .colorChannel4;

@Deprecated('Use .colorChannel5 instead')
const RlFramebufferAttachType RL_ATTACHMENT_COLOR_CHANNEL5 = .colorChannel5;

@Deprecated('Use .colorChannel6 instead')
const RlFramebufferAttachType RL_ATTACHMENT_COLOR_CHANNEL6 = .colorChannel6;

@Deprecated('Use .colorChannel7 instead')
const RlFramebufferAttachType RL_ATTACHMENT_COLOR_CHANNEL7 = .colorChannel7;

@Deprecated('Use .depth instead')
const RlFramebufferAttachType RL_ATTACHMENT_DEPTH = .depth;

@Deprecated('Use .stencil instead')
const RlFramebufferAttachType RL_ATTACHMENT_STENCIL = .stencil;

enum RlFramebufferAttachTextureType {
  cubemapPositiveX(.RL_ATTACHMENT_CUBEMAP_POSITIVE_X),
  cubemapNegativeX(.RL_ATTACHMENT_CUBEMAP_NEGATIVE_X),
  cubemapPositiveY(.RL_ATTACHMENT_CUBEMAP_POSITIVE_Y),
  cubemapNegativeY(.RL_ATTACHMENT_CUBEMAP_NEGATIVE_Y),
  cubemapPositiveZ(.RL_ATTACHMENT_CUBEMAP_POSITIVE_Z),
  cubemapNegativeZ(.RL_ATTACHMENT_CUBEMAP_NEGATIVE_Z),
  texture2D(.RL_ATTACHMENT_TEXTURE2D),
  renderbuffer(.RL_ATTACHMENT_RENDERBUFFER);

  final consts.rlFramebufferAttachTextureType code;
  const RlFramebufferAttachTextureType(this.code);
  int get value => code.value;

  static RlFramebufferAttachTextureType fromValue(int value) =>
      values.firstWhere(
        (e) => e.value == value,
        orElse: () => throw ArgumentError(
          'Unknown RlFramebufferAttachTextureType value: $value',
        ),
      );
}

@Deprecated('Use .cubemapPositiveX instead')
const RlFramebufferAttachTextureType RL_ATTACHMENT_CUBEMAP_POSITIVE_X =
    .cubemapPositiveX;

@Deprecated('Use .cubemapNegativeX instead')
const RlFramebufferAttachTextureType RL_ATTACHMENT_CUBEMAP_NEGATIVE_X =
    .cubemapNegativeX;

@Deprecated('Use .cubemapPositiveY instead')
const RlFramebufferAttachTextureType RL_ATTACHMENT_CUBEMAP_POSITIVE_Y =
    .cubemapPositiveY;

@Deprecated('Use .cubemapNegativeY instead')
const RlFramebufferAttachTextureType RL_ATTACHMENT_CUBEMAP_NEGATIVE_Y =
    .cubemapNegativeY;

@Deprecated('Use .cubemapPositiveZ instead')
const RlFramebufferAttachTextureType RL_ATTACHMENT_CUBEMAP_POSITIVE_Z =
    .cubemapPositiveZ;

@Deprecated('Use .cubemapNegativeZ instead')
const RlFramebufferAttachTextureType RL_ATTACHMENT_CUBEMAP_NEGATIVE_Z =
    .cubemapNegativeZ;

@Deprecated('Use .texture2D instead')
const RlFramebufferAttachTextureType RL_ATTACHMENT_TEXTURE2D = .texture2D;

@Deprecated('Use .renderbuffer instead')
const RlFramebufferAttachTextureType RL_ATTACHMENT_RENDERBUFFER = .renderbuffer;

enum RlCullMode {
  front(.RL_CULL_FACE_FRONT),
  back(.RL_CULL_FACE_BACK);

  final consts.rlCullMode code;
  const RlCullMode(this.code);
  int get value => code.value;

  static RlCullMode fromValue(int value) => values.firstWhere(
    (e) => e.value == value,
    orElse: () => throw ArgumentError('Unknown RlCullMode value: $value'),
  );
}

@Deprecated('Use .front instead')
const RlCullMode RL_CULL_FACE_FRONT = .front;

@Deprecated('Use .back instead')
const RlCullMode RL_CULL_FACE_BACK = .back;
