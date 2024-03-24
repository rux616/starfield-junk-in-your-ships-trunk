{
  Rotates contents of cells. Supports additional filtering by record signature, REFR NAME signature,
  and REFR NAME EDIDs.

  Note: Starfield uses right-hand rule coordinates (https://en.wikipedia.org/wiki/Right-hand_rule#Coordinates)
  and rotations are clockwise positive (left-hand grip rule - thumb represents positive direction
  of axis of rotation and the fingers curl in the direction of a positive rotation), done in a ZYX
  sequence. Facing the front of a ship:
    +x is left (starboard)
    -x is right (port)
    +y is towards you (fore)
    -y is away from you (aft)
    +z is up
    -z is down
  --------------------
  Hotkey: Ctrl+Shift+R
  --------------------
  Copyright 2024 Dan Cassidy

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.

  SPDX-License-Identifier: GPL-3.0-or-later
}
unit rotate_cell_contents;

const
  // possible rotation sequences for Tait-Bryan angles
  // see https://en.wikipedia.org/wiki/Euler_angles#Chained_rotations_equivalence for more information
  SEQUENCE_XYZ = 0; SEQUENCE_MIN = 0;
  SEQUENCE_XZY = 1;
  SEQUENCE_YXZ = 2;
  SEQUENCE_YZX = 3;
  SEQUENCE_ZXY = 4;
  SEQUENCE_ZYX = 5; SEQUENCE_MAX = 5;

  SEQUENCE_XYZ_INVERSE = SEQUENCE_ZYX;
  SEQUENCE_XZY_INVERSE = SEQUENCE_YZX;
  SEQUENCE_YXZ_INVERSE = SEQUENCE_ZXY;
  SEQUENCE_YZX_INVERSE = SEQUENCE_XZY;
  SEQUENCE_ZXY_INVERSE = SEQUENCE_YXZ;
  SEQUENCE_ZYX_INVERSE = SEQUENCE_XYZ;

  // helper constants for rotation operation modes
  OPERATION_MODE_SET = True;
  OPERATION_MODE_ROTATE = False;

  // helper constants for filter modes
  FILTER_MODE_INCLUDE = True;
  FILTER_MODE_EXCLUDE = False;

  // helper constants for filter types
  FILTER_TYPE_RECORD_SIGNATURE = 0;
  FILTER_TYPE_REFR_NAME_SIGNATURE = 1;
  FILTER_TYPE_EDID_STARTS_WITH = 2;
  FILTER_TYPE_EDID_ENDS_WITH = 3;
  FILTER_TYPE_EDID_CONTAINS = 4;
  FILTER_TYPE_EDID_EQUALS = 5;

  // helper constants for clamp modes
  CLAMP_MODE_05 = 0;  CLAMP_MODE_MIN = 0;
  CLAMP_MODE_10 = 1;
  CLAMP_MODE_15 = 2;
  CLAMP_MODE_30 = 3;
  CLAMP_MODE_45 = 4;
  CLAMP_MODE_90 = 5;  CLAMP_MODE_MAX = 5;

  // helper constants for position/rotation precision
  PRECISION_POSITION = -6;
  PRECISION_ROTATION = -4;
  PRECISION_MIN = 0;
  PRECISION_MAX = -6;

  // global defaults
  GLOBAL_DEBUG_DEFAULT = True;  // TODO set to False for release

  GLOBAL_RECORD_SIGNATURE_USE_DEFAULT = True;
  GLOBAL_RECORD_SIGNATURE_MODE_DEFAULT = FILTER_MODE_INCLUDE;
  GLOBAL_RECORD_SIGNATURE_LIST_DEFAULT = 'ACHR,REFR';
  GLOBAL_REFR_NAME_SIGNATURE_USE_DEFAULT = True;
  GLOBAL_REFR_NAME_SIGNATURE_MODE_DEFAULT = FILTER_MODE_INCLUDE;
  GLOBAL_REFR_NAME_SIGNATURE_LIST_DEFAULT =
    'ACTI,ALCH,ASPC,BOOK,CONT,DOOR,FURN,IDLM,LIGH,MISC,MSTT,PDCL,PKIN,SOUN,STAT,TERM';
  GLOBAL_EDID_STARTS_WITH_USE_DEFAULT = True;
  GLOBAL_EDID_STARTS_WITH_MODE_DEFAULT = FILTER_MODE_EXCLUDE;
  GLOBAL_EDID_STARTS_WITH_LIST_DEFAULT = 'SMOD_Snap_';
  GLOBAL_EDID_ENDS_WITH_USE_DEFAULT = False;
  GLOBAL_EDID_ENDS_WITH_MODE_DEFAULT = FILTER_MODE_INCLUDE;
  GLOBAL_EDID_ENDS_WITH_LIST_DEFAULT = '';
  GLOBAL_EDID_CONTAINS_USE_DEFAULT = False;
  GLOBAL_EDID_CONTAINS_MODE_DEFAULT = FILTER_MODE_INCLUDE;
  GLOBAL_EDID_CONTAINS_LIST_DEFAULT = '';
  GLOBAL_EDID_EQUALS_USE_DEFAULT = True;
  GLOBAL_EDID_EQUALS_MODE_DEFAULT = FILTER_MODE_EXCLUDE;
  GLOBAL_EDID_EQUALS_LIST_DEFAULT = 'OutpostGroupPackinDummy,PrefabPackinPivotDummy';

  GLOBAL_ROTATION_X_DEFAULT = 0.0;
  GLOBAL_ROTATION_Y_DEFAULT = 0.0;
  GLOBAL_ROTATION_Z_DEFAULT = 0.0;

  GLOBAL_OPERATION_MODE_DEFAULT = OPERATION_MODE_ROTATE;
  GLOBAL_ROTATION_SEQUENCE_DEFAULT = SEQUENCE_ZYX;
  GLOBAL_APPLY_TO_POSITION_DEFAULT = True;
  GLOBAL_APPLY_TO_ROTATION_DEFAULT = True;

  GLOBAL_CLAMP_USE_DEFAULT = False;
  GLOBAL_CLAMP_MODE_DEFAULT = CLAMP_MODE_90;
  GLOBAL_POSITION_PRECISION_DEFAULT = -6;  // precision to nearest 0.000001
  GLOBAL_ROTATION_PRECISION_DEFAULT = -4;  // precision to nearest 0.0001

  GLOBAL_DRY_RUN_DEFAULT = True;
  GLOBAL_USE_SAME_SETTINGS_FOR_ALL_DEFAULT = True;

  // UI constants
  MARGIN_TOP = 5;
  MARGIN_BOTTOM = 5;
  MARGIN_LEFT = 5;
  MARGIN_RIGHT = 5;
  PANEL_BEVEL = 2;
  CONTROL_HEIGHT = 22;
  CHECKBOX_PADDING = 21;
  RADIO_PADDING = 21;
  COMBO_PADDING = 24;
  BUTTON_PADDING = 20;

  // epsilon to use for CompareValue calls
  // between positions and rotations, positions have more significant decimals (6), so this is set
  // to compliment that
  EPSILON = 0.000001;

  // declare constants to replace contents of TFloatFormat enum, since it's not available in xEdit scripts
  // https://docwiki.embarcadero.com/Libraries/Alexandria/en/System.SysUtils.TFloatFormat
  ffGeneral = 0;
  ffExponent = 1;
  ffFixed = 2;
  ffNumber = 3;
  ffCurrency = 4;

  // precision of stringified floats
  PRECISION_SINGLE = 7;
  PRECISION_DOUBLE = 15;
  PRECISION_EXTENDED = 18;

  // number of decimal places to use in stringified floats
  DIGITS_NONE = 0;
  DIGITS_ANGLE = 4;
  DIGITS_POSITION = 6;
  DIGITS_FULL = 15;

  // compared against wbVersionNumber, which is a hex-encoded integer, 0xAABBCCDD, where AA is the
  // major version, BB is the minor version, CC is the patch, and DD is the revision (shown as an
  // ASCII character, starting with 'a' at 1, 'b' at 2, etc.)
  MINIMUM_REQUIRED_XEDIT_VERSION = $04010503;
  // version 4.1.5c                  │ │ │ │
  // major:    4 ────────────────────┘ │ │ │
  // minor:    1 ──────────────────────┘ │ │
  // patch:    5 ────────────────────────┘ │
  // revision: c (3) ──────────────────────┘

var
  // global configuration options
  global_debug: boolean;

  global_record_signature_use: boolean;
  global_record_signature_mode: boolean;     // true = include, false = exclude
  global_record_signature_list: string;
  global_refr_name_signature_use: boolean;
  global_refr_name_signature_mode: boolean;  // true = include, false = exclude
  global_refr_name_signature_list: string;
  global_edid_starts_with_use: boolean;
  global_edid_starts_with_mode: boolean;     // true = include, false = exclude
  global_edid_starts_with_list: string;
  global_edid_ends_with_use: boolean;
  global_edid_ends_with_mode: boolean;       // true = include, false = exclude
  global_edid_ends_with_list: string;
  global_edid_contains_use: boolean;
  global_edid_contains_mode: boolean;        // true = include, false = exclude
  global_edid_contains_list: string;
  global_edid_equals_use: boolean;
  global_edid_equals_mode: boolean;          // true = include, false = exclude
  global_edid_equals_list: string;

  global_rotate_x: double;
  global_rotate_y: double;
  global_rotate_z: double;

  global_operation_mode: boolean;  // true = set, false = rotate
  global_rotation_sequence: integer;
  global_apply_to_position: boolean;
  global_apply_to_rotation: boolean;

  global_clamp_use: boolean;
  global_clamp_mode: integer;
  global_position_precision: integer;
  global_rotation_precision: integer;

  global_dry_run: boolean;
  global_use_same_settings_for_all: boolean;

  // global scale factor for GUI elements
  global_scale_factor: double;

  // whether the options dialog has been shown before
  global_options_dialog_shown: boolean;


//
// UTILITY FUNCTIONS
//


// return a stringified boolean
function bool_to_str(b: boolean): string;
begin
  if b then
    Result := 'true'
  else
    Result := 'false';
end;


// return a string representing whether a boolean would represent a checked box or not
function bool_to_checked_str(b: boolean): string;
begin
  if b then Result := 'checked' else Result := 'unchecked';
end;


// return a string representing whether a boolean would represent a selected radio button or not
function bool_to_selected_str(b: boolean): string;
begin
  if b then Result := 'selected' else Result := 'not selected';
end;


// return the width of a control's caption
function caption_width(control: TControl): integer;
begin
  Result := string_width(control.Caption, control.Font);
end;


// clamp given value d between min and max (inclusive)
function clamp(d, min, max: double): double;
begin
  if (CompareValue(d, min, EPSILON) = LessThanValue) then begin
    debug_print('clamp: clamping to min (' + float_to_str(min, DIGITS_FULL, false) + ')');
    Result := min;
  end else if (CompareValue(d, max, EPSILON) = GreaterThanValue) then begin
    debug_print('clamp: clamping to max (' + float_to_str(max, DIGITS_FULL, false) + ')');
    Result := max;
  end else begin
    debug_print('clamp: no clamping needed');
    Result := d;
  end;
end;


// return the angle of the given clamp mode
function clamp_mode_to_angle(clamp_mode: integer): double;
begin
  case (clamp_mode) of
    CLAMP_MODE_05: Result := 5.0;
    CLAMP_MODE_10: Result := 10.0;
    CLAMP_MODE_15: Result := 15.0;
    CLAMP_MODE_30: Result := 30.0;
    CLAMP_MODE_45: Result := 45.0;
    CLAMP_MODE_90: Result := 90.0;
  else
    raise Exception.Create('unknown clamp mode: ' + IntToStr(clamp_mode));
  end;
end;


// return the stringified clamp mode
function clamp_mode_to_str(clamp_mode: integer): string;
begin
  Result := float_to_str(clamp_mode_to_angle(clamp_mode), DIGITS_NONE, false) + Chr($B0) {degree symbol};
end;


// print a message to the xEdit log if debug mode is active
procedure debug_print(message: string);
begin
  if global_debug then AddMessage('    debug: ' + message);
end;


// borrowed from https://github.com/fre-sch/starfield-toolbox/blob/13de7c6e1d1b13a859ad1675df68ccbae0988eb1/xedit-scripts/Create%20new%20part.pas#L462-L474
procedure do_panel_layout(panel: TPanel; bevel: integer);
begin
  panel.AutoSize := true;
  panel.BevelOuter := bevel;  // BevelOuter defaults to 2
  if (bevel = 2) then set_margins_layout(panel, 5, 5, 5, 5, alTop);
end;


// check if a given record should be filtered out, returning True if it should be kept
// rule evaluation order, first to last:
// record signature, REFR NAME signature, EDID starts with, EDID ends with, EDID contains, EDID equals
function filter_record(r: IInterface): boolean;
begin
  debug_print('filter_record: filtering record ' + ShortName(r));

  // special case: if no filters are active, return true
  if (not global_record_signature_use) and (not global_refr_name_signature_use) and
    (not global_edid_starts_with_use) and (not global_edid_ends_with_use) and
    (not global_edid_contains_use) and (not global_edid_equals_use) then begin
    debug_print('filter_record: no filters active, returning true');
    Result := True;
    exit;
  end;

  // apply filters, with short circuiting if a filter returns false (Result is False by default)
  if not check_filter(r, FILTER_TYPE_RECORD_SIGNATURE, 'record signature', global_record_signature_use,
    global_record_signature_mode, global_record_signature_list) then exit;
  if not check_filter(r, FILTER_TYPE_REFR_NAME_SIGNATURE, 'refr name signature', global_refr_name_signature_use,
    global_refr_name_signature_mode, global_refr_name_signature_list) then exit;
  if not check_filter(r, FILTER_TYPE_EDID_STARTS_WITH, 'edid starts with', global_edid_starts_with_use,
    global_edid_starts_with_mode, global_edid_starts_with_list) then exit;
  if not check_filter(r, FILTER_TYPE_EDID_ENDS_WITH, 'edid ends with', global_edid_ends_with_use,
    global_edid_ends_with_mode, global_edid_ends_with_list) then exit;
  if not check_filter(r, FILTER_TYPE_EDID_CONTAINS, 'edid contains', global_edid_contains_use,
    global_edid_contains_mode, global_edid_contains_list) then exit;
  if not check_filter(r, FILTER_TYPE_EDID_EQUALS, 'edid equals', global_edid_equals_use,
    global_edid_equals_mode, global_edid_equals_list) then exit;

  // if all filters pass, return true
  Result := True;
end;


// check a record against a given filter, returning True if the record passes the filter
function check_filter(
  r: IInterface;
  filter_type: integer;
  filter_type_text: string;
  filter_use, filter_mode: boolean;
  filter_list: string;
): boolean;
var
  str_to_test, match_text: string;
  list: TStringDynArray;
  i: integer;
  match: boolean;
begin
  if (not filter_use) then begin
    debug_print('filter_record: ' + filter_type_text + ': filter not active');
    Result := True;
  end else begin
    // TODO need to verify the file that LinksTo returns a record from
    case (filter_type) of
      FILTER_TYPE_RECORD_SIGNATURE:
        str_to_test := Signature(r);
      FILTER_TYPE_REFR_NAME_SIGNATURE:
        str_to_test := Signature(LinksTo(ElementBySignature(r, 'NAME')));
      FILTER_TYPE_EDID_STARTS_WITH, FILTER_TYPE_EDID_ENDS_WITH, FILTER_TYPE_EDID_CONTAINS, FILTER_TYPE_EDID_EQUALS:
        str_to_test := EditorID(LinksTo(ElementBySignature(r, 'NAME')));
    else
      raise Exception.Create('unknown filter type: ' + filter_type_text);
    end;

    if (str_to_test = '') then begin
      debug_print('filter_record: ' + filter_type_text + ': string to test is empty');
    end else begin
      debug_print('filter_record: ' + filter_type_text + ': string to test is "' + str_to_test + '"');
      list := SplitString(filter_list, ',');
      debug_print('filter_record: ' + filter_type_text + ': list length: ' + IntToStr(Length(list)));
      debug_print('filter_record: ' + filter_type_text + ': list: [' + concat_string_array(list, '", "', '"') + ']');

      for i := 0 to Pred(Length(list)) do begin
        case (filter_type) of
          FILTER_TYPE_RECORD_SIGNATURE, FILTER_TYPE_REFR_NAME_SIGNATURE, FILTER_TYPE_EDID_EQUALS:
            match := (str_to_test = list[i]);
          FILTER_TYPE_EDID_STARTS_WITH:
            match := (Pos(list[i], str_to_test) = 1);
          FILTER_TYPE_EDID_ENDS_WITH:
            match := (Pos(list[i], str_to_test) = Length(str_to_test) - Length(list[i]) + 1);
          FILTER_TYPE_EDID_CONTAINS:
            match := (Pos(list[i], str_to_test) <> 0);
        end;
        if (match) then match_text := 'match' else match_text := 'no match';
        debug_print('filter_record: ' + filter_type_text + ': checking "' + str_to_test + '" against "' + list[i]
          + '": ' + match_text);
        if (match) then break;
      end;
      if (match) then match_text := '' else match_text := ' not';
      debug_print('filter_record: ' + filter_type_text + ': "' + str_to_test + '"' + match_text + ' in list');
    end;

    if (filter_mode = FILTER_MODE_INCLUDE) then
      Result := match
    else if (filter_mode = FILTER_MODE_EXCLUDE) then
      Result := not match;
  end;
  debug_print('filter_record: ' + filter_type_text + ': include: ' + bool_to_str(Result));
end;


// return a stringified float to a given decimal place, optionally padded
function float_to_str(d: double; digits: integer; pad: boolean): string;
begin
  Result := FloatToStrF(d, ffFixed, PRECISION_DOUBLE, digits);
  if (pad) then begin
    debug_print('float_to_str: padding active');
    if (Length(Result) = digits + 2) then begin
      debug_print('float_to_str: padding with 2 spaces');
      Result := '  ' + Result;
    end else if (Length(Result) = digits + 3) then begin
      debug_print('float_to_str: padding with 1 space');
      Result := ' ' + Result;
    end;
  end;
end;


// return the full height of a control, defined as height + top margin + bottom margin
function full_control_height(control: TControl): integer;
begin
  Result := control.Height + control.Margins.Top + control.Margins.Bottom;
end;


// return the full width of a control, defined as width + left margin + right margin
function full_control_width(control: TControl): integer;
begin
  Result := control.Width + control.Margins.Left + control.Margins.Right;
end;


// concatenate an array of strings into a single string, with a delimiter between each element and
// an end cap on both sides
function concat_string_array(arr: TStringDynArray; delimiter, end_cap: string): string;
var
  i: integer;
begin
  for i := 0 to Pred(Length(arr)) do begin
    Result := Result + arr[i];
    if (i < Pred(Length(arr))) then Result := Result + delimiter;
  end;
  // if the concatenation is not empty, add the end cap string on both sides
  if (Result <> '') then Result := end_cap + Result + end_cap;
end;


// return the max width of a control's Items property
function max_item_width(control: TControl): integer;
var
  i, width: integer;
begin
  Result := 0;
  for i := 0 to control.Items.Count - 1 do begin
    width := string_width(control.Items[i], control.Font);
    if (width > Result) then
      Result := width;
  end;
end;


// returns a stringified modal result
function modal_result_to_str(modal_result: integer): string;
begin
  case (modal_result) of
    mrNone: Result := 'None';
    mrOk: Result := 'OK';
    mrCancel: Result := 'Cancel';
    mrAbort: Result := 'Abort';
    mrRetry: Result := 'Retry';
    mrIgnore: Result := 'Ignore';
    mrYes: Result := 'Yes';
    mrNo: Result := 'No';
    mrAll: Result := 'All';
    mrNoToAll: Result := 'No to All';
    mrYesToAll: Result := 'Yes to All';
  else
    Result := 'unknown (' + IntToStr(modal_result) + ')';
  end;
end;


// normalize an angle (in degrees) to [0.0, 360.0)
function normalize_angle(angle: double): double;
const
  NORMALIZER = 360.0;
begin
  // FMod(a,b) returns a value between -Abs(b) and Abs(b) exclusive, so need to add b and do it again
  // to fully catch negative angles
  Result := FMod(FMod(angle, NORMALIZER) + NORMALIZER, NORMALIZER);
  if (CompareValue(angle, Result, EPSILON) <> EqualsValue) then
    debug_print('normalize_angle: ' + float_to_str(angle, DIGITS_ANGLE, false)
      + ' -> ' + float_to_str(Result, DIGITS_ANGLE, false));
end;


// return the example string for a given precision
function precision_to_str(precision: integer): string;
begin
  Result := float_to_str(Power(10.0, precision), -precision, false);
end;


// return a stringified quaternion or vector to a given number of decimal places, with options to
// pad, show brackets, and use specified delimiters between labels and components
function qv_to_str(
  w, x, y, z: double;
  is_quaternion, pad, show_brackets: boolean;
  label_delimiter, component_delimiter: string;
  digits: integer
): string;
begin
  if (component_delimiter = '') then component_delimiter := ', ';
  if (label_delimiter = '') then label_delimiter := ': ';

  Result := '';
  if (show_brackets) then
    Result := '[';
  if (is_quaternion) then
    Result := Result + 'W' + label_delimiter + float_to_str(w, digits, pad) + component_delimiter;
  Result := Result + 'X' + label_delimiter + float_to_str(x, digits, pad) + component_delimiter;
  Result := Result + 'Y' + label_delimiter + float_to_str(y, digits, pad) + component_delimiter;
  Result := Result + 'Z' + label_delimiter + float_to_str(z, digits, pad);
  if (show_brackets) then Result := Result + ']';
end;


// return a stringified quaternion
function quaternion_to_str(qw, qx, qy, qz: double): string;
begin
  Result := qv_to_str(qw, qx, qy, qz, true, false, true, '', '', DIGITS_FULL);
end;


// return the stringified rotation sequence
function rotation_sequence_to_str(rotation_order: integer): string;
begin
  case (rotation_order) of
    SEQUENCE_XYZ: Result := 'XYZ';
    SEQUENCE_XZY: Result := 'XZY';
    SEQUENCE_YXZ: Result := 'YXZ';
    SEQUENCE_YZX: Result := 'YZX';
    SEQUENCE_ZXY: Result := 'ZXY';
    SEQUENCE_ZYX: Result := 'ZYX';
  else
    Result := 'unknown (' + IntToStr(rotation_order) + ')';
  end;
end;


// borrowed from https://github.com/fre-sch/starfield-toolbox/blob/13de7c6e1d1b13a859ad1675df68ccbae0988eb1/xedit-scripts/Create%20new%20part.pas#L448-L459
procedure set_margins_layout(
  control: TControl;
  margin_top, margin_bottom, margin_left, margin_right: integer;
  align: integer
);
begin
  control.Margins.Top := margin_top;
  control.Margins.Bottom := margin_bottom;
  control.Margins.Left := margin_left;
  control.Margins.Right := margin_right;
  control.AlignWithMargins := true;
  control.Align := align;
end;


// return the width of a string using the given font
// https://stackoverflow.com/a/2548178
function string_width(s: string; font: TFont): integer;
var
  bitmap: TBitmap;
begin
  bitmap := TBitmap.Create;
  try
    bitmap.Canvas.Font.Assign(font);
    Result := bitmap.Canvas.TextWidth(s);
  finally
    bitmap.Free;
  end;
end;


// ord function that works in the context of xedit scripts
function utf_ord(s: string): integer;
begin
  Result := Ord(varAsType(s, varString));
end;


// validate the given rotation sequence and throws an error if said validation fails
procedure validate_rotation_sequence(rotation_sequence: integer);
begin
  if (rotation_sequence < SEQUENCE_MIN) or (rotation_sequence > SEQUENCE_MAX) then
    raise Exception.Create('rotation sequence is ' + rotation_sequence_to_str(rotation_sequence));
end;


// return a stringified vector, optionally padded, to a given number of decimal places
function vector_to_str(vx, vy, vz: double; pad: boolean; digits: integer): string;
begin
  Result := qv_to_str(0, vx, vy, vz, false, pad, true, '', '', digits);
end;


// returns the decoded and stringified version number
// based off https://github.com/matortheeternal/TES5EditScripts/blob/abe8a57fd6f73c9ad4e1f734800f0b519f176fd3/Edit%20Scripts/mteFunctions.pas#L164-L184
function version_number_to_str(v: integer): string;
var
  version_major, version_minor, version_patch, version_revision: integer;
begin
  version_major := v Shr 24;
  version_minor := (v Shr 16) and $FF;
  version_patch := (v Shr 8) and $FF;
  version_revision := v and $FF;
  Result := Format('%d.%d.%d', [version_major, version_minor, version_patch]);
  if (version_revision > 0) then
    Result := Result + Chr(version_revision + utf_ord('a') - 1);
end;


//
// ROTATION AND POSITION FUNCTIONS
//


// rotate a position (duh) via quaternion math (vs matrix math)
procedure rotate_position(
  vx, vy, vz: double;                           // initial position vector (x, y, z coordinates)
  rx, ry, rz: double;                           // rotation to apply (euler angle)
  rotation_sequence: integer;                   // see SEQUENCE_* constants and validate_rotation_sequence procedure
  var return_vx, return_vy, return_vz: double;  // final position vector (x, y, z coordinates)
);
var
  qx, qy, qz, qw: double;      // quaternion representing rotation to be applied
  qwv, qxv, qyv, qzv: double;  // quaternion representing the result of the vector/quaternion multiplication
  qwi, qxi, qyi, qzi: double;  // quaternion representing the inverted input quaternion
begin
  euler_to_quaternion(
    rx, ry, rz,
    rotation_sequence,
    qw, qx, qy, qz
  );
  debug_print('rotate_position: q: ' + quaternion_to_str(qw, qx, qy, qz));

  // everything i've read says this should be (q * v * q'), but only (q' * (v * q)) gives the correct
  // results ¯\_(ツ)_/¯
  quaternion_multiply(  // calculate (v * q)
    0, vx, vy, vz,
    qw, qx, qy, qz,
    qwv, qxv, qyv, qzv
  );
  debug_print('rotate_position: v * q: ' + quaternion_to_str(qwv, qxv, qyv, qzv));
  quaternion_inverse(  // calculate (q')
    qw, qx, qy, qz,
    qwi, qxi, qyi, qzi
  );
  debug_print('rotate_position: q'': ' + quaternion_to_str(qwi, qxi, qyi, qzi));
  quaternion_multiply(  // calculate (q' * (v * q))
    qwi, qxi, qyi, qzi,
    qwv, qxv, qyv, qzv,
    qw, return_vx, return_vy, return_vz  // the returned w component is irrelevant and so is discarded
  );
  debug_print('rotate_position: q'' * (v * q): ' + quaternion_to_str(qw, return_vx, return_vy, return_vz));
end;


// rotate a rotation (duh) via quaternion math (vs matrix math)
procedure rotate_rotation(
  x, y, z: double;                          // initial rotation (euler angle)
  rx, ry, rz: double;                       // rotation to apply (euler angle)
  rotation_sequence: integer;               // see SEQUENCE_* constants and validate_rotation_sequence procedure
  var return_x, return_y, return_z: double  // final rotation (euler angle)
);
var
  qw1, qx1, qy1, qz1: double;  // quaternion representing initial rotation
  qw2, qx2, qy2, qz2: double;  // quaternion representing rotation to be applied
  qw3, qx3, qy3, qz3: double;  // quaternion representing final rotation
begin
  euler_to_quaternion(
    x, y, z,
    rotation_sequence,
    qw1, qx1, qy1, qz1
  );
  debug_print('rotate_rotation: q1: ' + quaternion_to_str(qw1, qx1, qy1, qz1));
  euler_to_quaternion(
    rx, ry, rz,
    rotation_sequence,
    qw2, qx2, qy2, qz2
  );
  debug_print('rotate_rotation: q2: ' + quaternion_to_str(qw2, qx2, qy2, qz2));

  // everything i've read says this should be (q2 * q1), but only (q1 * q2) gives the correct results
  // ¯\_(ツ)_/¯
  quaternion_multiply(  // calculate (q1 * q2)
    qw1, qx1, qy1, qz1,
    qw2, qx2, qy2, qz2,
    qw3, qx3, qy3, qz3
  );
  debug_print('rotate_rotation: q1 * q2: ' + quaternion_to_str(qw3, qx3, qy3, qz3));

  quaternion_to_euler(
    qw3, qx3, qy3, qz3,
    rotation_sequence,
    return_x, return_y, return_z
  );
end;


// takes an euler angle and converts it to a quaternion
// partially inspired by three.js's Quaternion.setFromEuler function
// (https://github.com/mrdoob/three.js/blob/e29ce31828e85a3ecf533984417911e2304f4320/src/math/Quaternion.js#L201) (MIT license)
procedure euler_to_quaternion(
  x, y, z: double;                                         // euler angle in degrees
  rotation_sequence: integer;                              // see SEQUENCE_* constants and validate_rotation_sequence procedure
  var return_qw, return_qx, return_qy, return_qz: double;  // quaternion components
);
var
  cos_x, cos_y, cos_z, sin_x, sin_y, sin_z: double;
  sign_w, sign_x, sign_y, sign_z: integer;
begin
  validate_rotation_sequence(rotation_sequence);

  // normalize angles and convert them to radians
  x := DegToRad(normalize_angle(x));
  y := DegToRad(normalize_angle(y));
  z := DegToRad(normalize_angle(z));
  debug_print('euler_to_quaternion: radian vector: ' + vector_to_str(x, y, z, false, DIGITS_FULL));

  // calculate cosine and sine of the various angles once instead of multiple times
  cos_x := Cos(x / 2.0); cos_y := Cos(y / 2.0); cos_z := Cos(z / 2.0);
  sin_x := Sin(x / 2.0); sin_y := Sin(y / 2.0); sin_z := Sin(z / 2.0);

  // use the rotation sequence to determine what signs are used when calculating quaternion components
  case (rotation_sequence) of
    SEQUENCE_XYZ: begin sign_w := -1; sign_x :=  1; sign_y := -1; sign_z :=  1; end;
    SEQUENCE_XZY: begin sign_w :=  1; sign_x := -1; sign_y := -1; sign_z :=  1; end;
    SEQUENCE_YXZ: begin sign_w :=  1; sign_x :=  1; sign_y := -1; sign_z := -1; end;
    SEQUENCE_YZX: begin sign_w := -1; sign_x :=  1; sign_y :=  1; sign_z := -1; end;
    SEQUENCE_ZXY: begin sign_w := -1; sign_x := -1; sign_y :=  1; sign_z :=  1; end;
    SEQUENCE_ZYX: begin sign_w :=  1; sign_x := -1; sign_y :=  1; sign_z := -1; end;
  end;
  debug_print(
    'euler_to_quaternion: quaternion calculation signs'
    + ': sign_w: ' + IntToStr(sign_w)
    + ', sign_x: ' + IntToStr(sign_x)
    + ', sign_y: ' + IntToStr(sign_y)
    + ', sign_z: ' + IntToStr(sign_z)
  );

  // calculate the quaternion components
  return_qw := cos_x * cos_y * cos_z + sign_w * sin_x * sin_y * sin_z;
  return_qx := sin_x * cos_y * cos_z + sign_x * cos_x * sin_y * sin_z;
  return_qy := cos_x * sin_y * cos_z + sign_y * sin_x * cos_y * sin_z;
  return_qz := cos_x * cos_y * sin_z + sign_z * sin_x * sin_y * cos_z;
end;


// takes a quaternion and converts it to an euler angle
// partially inspired by three.js's Euler.fromQuaternion function
// (https://github.com/mrdoob/three.js/blob/cd0ff25e3c3938ec82500047ccb43500d242505c/src/math/Euler.js#L238) (MIT License)
// partially inspired by the contents of Quaternions.pdf
// https://github.com/rux616/starfield-junk-in-your-ships-trunk/blob/adc55559b38e2fb71c31ee2ca92c7dbced12c35d/support/docs/Quaternions.pdf
procedure quaternion_to_euler(
  qw, qx, qy, qz: double;                    // input quaternion
  rotation_sequence: integer;                // see SEQUENCE_* constants and validate_rotation_sequence procedure
  var return_x, return_y, return_z: double;  // euler angle (in degrees)
);
var
  p0, p1, p2, p3: double;              // variables representing dynamically-ordered quaternion components
  singularity_check: double;           // contains value used for the singularity check
  e: integer;                          // variable representing sign used in angle calculations
  euler_order: array[0..2] of double;  // holds mapping between rotation sequence angles and output angles
  euler_angle: array[0..2] of double;  // output angles
begin
  validate_rotation_sequence(rotation_sequence);

  // map quaternion components to generic p-variables, and set the sign
  p0 := qw;
  case (rotation_sequence) of
    SEQUENCE_XYZ: begin
      p1 := qx; p2 := qy; p3 := qz; e := -1;
      debug_print('quaternion_to_euler: mapping qx to p1, qy to p2, qz to p3, e to -1');
    end;
    SEQUENCE_XZY: begin
      p1 := qx; p2 := qz; p3 := qy; e :=  1;
      debug_print('quaternion_to_euler: mapping qx to p1, qz to p2, qy to p3, e to 1');
    end;
    SEQUENCE_YXZ: begin
      p1 := qy; p2 := qx; p3 := qz; e :=  1;
      debug_print('quaternion_to_euler: mapping qy to p1, qx to p2, qz to p3, e to 1');
    end;
    SEQUENCE_YZX: begin
      p1 := qy; p2 := qz; p3 := qx; e := -1;
      debug_print('quaternion_to_euler: mapping qy to p1, qz to p2, qx to p3, e to -1');
    end;
    SEQUENCE_ZXY: begin
      p1 := qz; p2 := qx; p3 := qy; e := -1;
      debug_print('quaternion_to_euler: mapping qz to p1, qx to p2, qy to p3, e to -1');
    end;
    SEQUENCE_ZYX: begin
      p1 := qz; p2 := qy; p3 := qx; e :=  1;
      debug_print('quaternion_to_euler: mapping qz to p1, qy to p2, qx to p3, e to 1');
    end;
  end;

  // create mapping between the euler angle and the rotation sequence
  case (rotation_sequence) of
    SEQUENCE_XYZ: begin euler_order[0] := 0; euler_order[1] := 1; euler_order[2] := 2; end;
    SEQUENCE_XZY: begin euler_order[0] := 0; euler_order[1] := 2; euler_order[2] := 1; end;
    SEQUENCE_YXZ: begin euler_order[0] := 1; euler_order[1] := 0; euler_order[2] := 2; end;
    SEQUENCE_YZX: begin euler_order[0] := 1; euler_order[1] := 2; euler_order[2] := 0; end;
    SEQUENCE_ZXY: begin euler_order[0] := 2; euler_order[1] := 0; euler_order[2] := 1; end;
    SEQUENCE_ZYX: begin euler_order[0] := 2; euler_order[1] := 1; euler_order[2] := 0; end;
  end;
  debug_print(
    'quaternion_to_euler: euler order'
    + ': ' + IntToStr(euler_order[0])
    + ', ' + IntToStr(euler_order[1])
    + ', ' + IntToStr(euler_order[2])
  );

  // calculate the value to be used to check for singularities
  singularity_check := 2.0 * (p0 * p2 - e * p1 * p3);
  debug_print('quaternion_to_euler: singularity check: '
    + float_to_str(singularity_check, DIGITS_FULL, false));

  // calculate second rotation angle, clamping it to prevent ArcSin from erroring
  euler_angle[euler_order[1]] := ArcSin(clamp(singularity_check, -1.0, 1.0));

  // a singularity exists when the second angle in a rotation sequence is at +/-90 degrees
  if (CompareValue(Abs(singularity_check), 1.0, EPSILON) = LessThanValue) then begin
    debug_print('quaternion_to_euler: no singularity detected');
    euler_angle[euler_order[0]] := ArcTan2(2.0 * (p0 * p1 + e * p2 * p3), 1.0 - 2.0 * (p1 * p1 + p2 * p2));
    euler_angle[euler_order[2]] := ArcTan2(2.0 * (p0 * p3 + e * p1 * p2), 1.0 - 2.0 * (p2 * p2 + p3 * p3));
  end else begin
    debug_print('quaternion_to_euler: singularity detected');
    // when a singularity is detected, the third angle basically loses all meaning so is set to 0
    euler_angle[euler_order[0]] := ArcTan2(2.0 * (p0 * p1 - e * p2 * p3), 1.0 - 2.0 * (p1 * p1 + p3 * p3));
    euler_angle[euler_order[2]] := 0.0;
  end;

  debug_print('quaternion_to_euler: resultant vector: '
    + vector_to_str(euler_angle[0], euler_angle[1], euler_angle[2], false, DIGITS_FULL));

  // convert results to degrees and then normalize them
  return_x := normalize_angle(RadToDeg(euler_angle[0]));
  return_y := normalize_angle(RadToDeg(euler_angle[1]));
  return_z := normalize_angle(RadToDeg(euler_angle[2]));
end;


// get the inverse of a quaternion
procedure quaternion_inverse(
  qw, qx, qy, qz: double;                                  // input quaternion
  var return_qw, return_qx, return_qy, return_qz: double;  // inverted quaternion
);
begin
  return_qw := qw;
  return_qx := -qx;
  return_qy := -qy;
  return_qz := -qz;
end;


// multiply two quaternions together - note that quaternion multiplication is NOT commutative, so
// (q1 * q2) != (q2 * q1)
procedure quaternion_multiply(
  qw1, qx1, qy1, qz1: double;                              // input quaternion 1
  qw2, qx2, qy2, qz2: double;                              // input quaternion 2
  var return_qw, return_qx, return_qy, return_qz: double;  // result quaternion
);
begin
  return_qw := qw1 * qw2 - qx1 * qx2 - qy1 * qy2 - qz1 * qz2;
  return_qx := qw1 * qx2 + qx1 * qw2 + qy1 * qz2 - qz1 * qy2;
  return_qy := qw1 * qy2 - qx1 * qz2 + qy1 * qw2 + qz1 * qx2;
  return_qz := qw1 * qz2 + qx1 * qy2 - qy1 * qx2 + qz1 * qw2;
end;


//
// UI FUNCTIONS
//


// create a button panel with ok and cancel buttons, and a debug checkbox
function create_button_panel(owner, parent: TControl; var debug_checkbox: TCheckBox;): TPanel;
var
  panel, button_subpanel: TPanel;
  ok_button, cancel_button: TButton;
begin
    if (parent = nil) then parent := owner;

    panel := TPanel.Create(owner);
    panel.Parent := parent;
    do_panel_layout(panel, 0);
    set_margins_layout(panel, 0, 0, 0, 0, alTop);

    debug_checkbox := TCheckBox.Create(owner);
    debug_checkbox.Parent := panel;
    debug_checkbox.Caption := 'Debug Mode';
    debug_checkbox.Alignment := taLeftJustify;
    set_margins_layout(debug_checkbox, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    debug_checkbox.Height := CONTROL_HEIGHT * global_scale_factor;
    debug_checkbox.Width := caption_width(debug_checkbox) + (CHECKBOX_PADDING * global_scale_factor);

    button_subpanel := TPanel.Create(owner);
    button_subpanel.Parent := panel;
    do_panel_layout(button_subpanel, 0);
    set_margins_layout(button_subpanel, 0, 0, 0, 0, alRight);

    ok_button := TButton.Create(owner);
    ok_button.Parent := button_subpanel;
    ok_button.Caption := 'OK';
    ok_button.Default := True;
    ok_button.ModalResult := mrOk;
    set_margins_layout(ok_button, MARGIN_TOP, MARGIN_BOTTOM, MARGIN_LEFT, MARGIN_RIGHT, alRight);

    cancel_button := TButton.Create(owner);
    cancel_button.Parent := button_subpanel;
    cancel_button.Caption := 'Cancel';
    cancel_button.Cancel := True;
    cancel_button.ModalResult := mrCancel;
    set_margins_layout(cancel_button, MARGIN_TOP, MARGIN_BOTTOM, MARGIN_LEFT, MARGIN_RIGHT, alRight);

    Result := panel;
end;


// create a filter panel with a checkbox, radio buttons, and an edit box
function create_filter_panel(
  owner, parent: TControl;
  title, edit_hint: string;
  var use_checkbox: TCheckBox;
  var include_radio, exclude_radio: TRadioButton;
  var list_edit: TEdit;
): TPanel;
var
  panel: TPanel;
  show_edit_hint: boolean;
begin
    if (parent = nil) then parent := owner;
    if (edit_hint = '') then show_edit_hint := False else show_edit_hint := True;

    panel := TPanel.Create(owner);
    panel.Parent := parent;
    do_panel_layout(panel, PANEL_BEVEL);

    use_checkbox := TCheckBox.Create(owner);
    use_checkbox.Parent := panel;
    use_checkbox.Caption := 'Filter by ' + title;
    set_margins_layout(use_checkbox, MARGIN_TOP, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    use_checkbox.Height := CONTROL_HEIGHT * global_scale_factor;
    use_checkbox.Width := caption_width(use_checkbox) + (CHECKBOX_PADDING * global_scale_factor);

    include_radio := TRadioButton.Create(owner);
    include_radio.Parent := panel;
    include_radio.Alignment := taLeftJustify;
    include_radio.Caption := 'Include';
    set_margins_layout(include_radio, MARGIN_TOP, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    include_radio.Height := CONTROL_HEIGHT * global_scale_factor;
    include_radio.Width := caption_width(include_radio) + (RADIO_PADDING * global_scale_factor);

    exclude_radio := TRadioButton.Create(owner);
    exclude_radio.Parent := panel;
    exclude_radio.Alignment := taLeftJustify;
    exclude_radio.Caption := 'Exclude';
    set_margins_layout(exclude_radio, MARGIN_TOP, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    exclude_radio.Height := CONTROL_HEIGHT * global_scale_factor;
    exclude_radio.Width := caption_width(exclude_radio) + (RADIO_PADDING * global_scale_factor);

    list_edit := TEdit.Create(owner);
    list_edit.Parent := panel;
    list_edit.Hint := edit_hint;
    list_edit.ShowHint := show_edit_hint;
    set_margins_layout(list_edit, 0, MARGIN_BOTTOM, MARGIN_LEFT, MARGIN_RIGHT, alBottom);
    list_edit.Height := CONTROL_HEIGHT * global_scale_factor;

    panel.Height := full_control_height(use_checkbox) + full_control_height(list_edit);

    Result := panel;
end;


// build and display the dialog used for including/excluding records
function show_record_filter_dialog(): integer;
var
  frm: TForm;

  record_signature_use: TCheckBox;
  record_signature_mode_include, record_signature_mode_exclude: TRadioButton;
  record_signature_list: TEdit;

  refr_name_signature_use: TCheckBox;
  refr_name_signature_mode_include, refr_name_signature_mode_exclude: TRadioButton;
  refr_name_signature_list: TEdit;

  edid_starts_with_use: TCheckBox;
  edid_starts_with_mode_include, edid_starts_with_mode_exclude: TRadioButton;
  edid_starts_with_list: TEdit;

  edid_ends_with_use: TCheckBox;
  edid_ends_with_mode_include, edid_ends_with_mode_exclude: TRadioButton;
  edid_ends_with_list: TEdit;

  edid_contains_use: TCheckBox;
  edid_contains_mode_include, edid_contains_mode_exclude: TRadioButton;
  edid_contains_list: TEdit;

  edid_equals_use: TCheckBox;
  edid_equals_mode_include, edid_equals_mode_exclude: TRadioButton;
  edid_equals_list: TEdit;

  button_panel: TPanel;
  include_all_button: TButton;

  debug_checkbox: TCheckBox;
const
  SIGNATURE_HINT = 'Comma-separated list of record signatures, e.g. "ACHR,REFR"';
  EDID_HINT_FULL = 'Comma-separated list of full editor IDs';
  EDID_HINT_FULL_OR_PARTIAL = 'Comma-separated list of full or partial editor IDs';
begin
  try
    frm := TForm.Create(nil);
    frm.Caption := 'Rotate Cell Contents: Include/Exclude Records';
    frm.AutoSize := True;
    frm.BorderStyle := bsSingle;
    frm.BorderIcons := [biSystemMenu];
    frm.Width := 600 * global_scale_factor;

    // filter panels

    create_filter_panel(frm, frm, 'Record Signature', SIGNATURE_HINT, record_signature_use,
      record_signature_mode_include, record_signature_mode_exclude, record_signature_list);
    create_filter_panel(frm, frm, 'REFR NAME Signature', SIGNATURE_HINT, refr_name_signature_use,
      refr_name_signature_mode_include, refr_name_signature_mode_exclude, refr_name_signature_list);
    create_filter_panel(frm, frm, 'EDID of REFR NAME (Starts With)', EDID_HINT_FULL_OR_PARTIAL, edid_starts_with_use,
      edid_starts_with_mode_include, edid_starts_with_mode_exclude, edid_starts_with_list);
    create_filter_panel(frm, frm, 'EDID of REFR NAME (Ends With)', EDID_HINT_FULL_OR_PARTIAL, edid_ends_with_use,
      edid_ends_with_mode_include, edid_ends_with_mode_exclude, edid_ends_with_list);
    create_filter_panel(frm, frm, 'EDID of REFR NAME (Contains)', EDID_HINT_FULL_OR_PARTIAL, edid_contains_use,
      edid_contains_mode_include, edid_contains_mode_exclude, edid_contains_list);
    create_filter_panel(frm, frm, 'EDID of REFR NAME (Equals)', EDID_HINT_FULL, edid_equals_use,
      edid_equals_mode_include, edid_equals_mode_exclude, edid_equals_list);

    // button panel

    button_panel := create_button_panel(frm, frm, debug_checkbox);

    include_all_button := TButton.Create(frm);
    include_all_button.Parent := button_panel;
    include_all_button.Caption := 'Include All';
    include_all_button.ModalResult := mrYesToAll;
    include_all_button.ShowHint := True;
    include_all_button.Hint := 'Include all records - this will close the dialog and ignore all other settings';
    set_margins_layout(include_all_button, MARGIN_TOP, MARGIN_BOTTOM, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    include_all_button.Width := caption_width(include_all_button) + (BUTTON_PADDING * global_scale_factor);

    // set the values on the various controls

    record_signature_use.Checked := global_record_signature_use;
    record_signature_mode_include.Checked := (global_record_signature_mode = FILTER_MODE_INCLUDE);
    record_signature_mode_exclude.Checked := (global_record_signature_mode = FILTER_MODE_EXCLUDE);
    record_signature_list.Text := global_record_signature_list;
    refr_name_signature_use.Checked := global_refr_name_signature_use;
    refr_name_signature_mode_include.Checked := (global_refr_name_signature_mode = FILTER_MODE_INCLUDE);
    refr_name_signature_mode_exclude.Checked := (global_refr_name_signature_mode = FILTER_MODE_EXCLUDE);
    refr_name_signature_list.Text := global_refr_name_signature_list;
    edid_starts_with_use.Checked := global_edid_starts_with_use;
    edid_starts_with_mode_include.Checked := (global_edid_starts_with_mode = FILTER_MODE_INCLUDE);
    edid_starts_with_mode_exclude.Checked := (global_edid_starts_with_mode = FILTER_MODE_EXCLUDE);
    edid_starts_with_list.Text := global_edid_starts_with_list;
    edid_ends_with_use.Checked := global_edid_ends_with_use;
    edid_ends_with_mode_include.Checked := (global_edid_ends_with_mode = FILTER_MODE_INCLUDE);
    edid_ends_with_mode_exclude.Checked := (global_edid_ends_with_mode = FILTER_MODE_EXCLUDE);
    edid_ends_with_list.Text := global_edid_ends_with_list;
    edid_contains_use.Checked := global_edid_contains_use;
    edid_contains_mode_include.Checked := (global_edid_contains_mode = FILTER_MODE_INCLUDE);
    edid_contains_mode_exclude.Checked := (global_edid_contains_mode = FILTER_MODE_EXCLUDE);
    edid_contains_list.Text := global_edid_contains_list;
    edid_equals_use.Checked := global_edid_equals_use;
    edid_equals_mode_include.Checked := (global_edid_equals_mode = FILTER_MODE_INCLUDE);
    edid_equals_mode_exclude.Checked := (global_edid_equals_mode = FILTER_MODE_EXCLUDE);
    edid_equals_list.Text := global_edid_equals_list;
    debug_checkbox.Checked := global_debug;

    // show the form (duh)

    Result := frm.ShowModal;

    // get the values from the various controls

    if (Result = mrOk) then begin  // ok button
      global_record_signature_use := record_signature_use.Checked;
      global_record_signature_mode := record_signature_mode_include.Checked;
      global_record_signature_list := UpperCase(record_signature_list.Text);
      global_refr_name_signature_use := refr_name_signature_use.Checked;
      global_refr_name_signature_mode := refr_name_signature_mode_include.Checked;
      global_refr_name_signature_list := UpperCase(refr_name_signature_list.Text);
      global_edid_starts_with_use := edid_starts_with_use.Checked;
      global_edid_starts_with_mode := edid_starts_with_mode_include.Checked;
      global_edid_starts_with_list := edid_starts_with_list.Text;
      global_edid_ends_with_use := edid_ends_with_use.Checked;
      global_edid_ends_with_mode := edid_ends_with_mode_include.Checked;
      global_edid_ends_with_list := edid_ends_with_list.Text;
      global_edid_contains_use := edid_contains_use.Checked;
      global_edid_contains_mode := edid_contains_mode_include.Checked;
      global_edid_contains_list := edid_contains_list.Text;
      global_edid_equals_use := edid_equals_use.Checked;
      global_edid_equals_mode := edid_equals_mode_include.Checked;
      global_edid_equals_list := edid_equals_list.Text;
      global_debug := debug_checkbox.Checked;
    end else if (Result = mrYesToAll) then begin  // include all button
      global_record_signature_use := False;
      global_refr_name_signature_use := False;
      global_edid_starts_with_use := False;
      global_edid_ends_with_use := False;
      global_edid_contains_use := False;
      global_edid_equals_use := False;
      global_debug := debug_checkbox.Checked;
    end;
  finally
    frm.Free;
  end;
end;


// build and display the dialog used to set the rotation options
function show_options_dialog(): integer;
var
  frm: TForm;

  angle_panel, rotation_x_subpanel, rotation_y_subpanel, rotation_z_subpanel: TPanel;
  angle_label, rotation_x_label, rotation_y_label, rotation_z_label: TLabel;
  rotation_x, rotation_y, rotation_z: TEdit;

  rotation_options_panel, rotation_mode_subpanel, rotation_sequence_subpanel, apply_to_subpanel: TPanel;
  rotation_mode_label, rotation_sequence_label, apply_to_label: TLabel;
  mode_rotate, mode_set, apply_to_both, apply_to_position, apply_to_rotation: TRadioButton;
  rotation_sequence: TComboBox;

  secondary_options_panel, clamp_subpanel, position_precision_subpanel, rotation_precision_subpanel: TPanel;
  clamp_use_checkbox: TCheckBox;
  clamp_label, position_precision_label, rotation_precision_label: TLabel;
  clamp_combo, position_precision_combo, rotation_precision_combo: TComboBox;

  meta_panel, dry_run_subpanel, use_same_settings_for_all_subpanel: TPanel;
  dry_run, use_same_settings_for_all: TCheckBox;

  debug_checkbox: TCheckBox;

  i: integer;
begin
  frm := TForm.Create(nil);
  try
    frm.Caption := 'Rotate Cell Contents: Options';
    frm.AutoSize := True;
    frm.BorderStyle := bsSingle;
    frm.BorderIcons := [biSystemMenu];
    frm.Width := 425 * global_scale_factor;

    // angle panel

    angle_panel := TPanel.Create(frm);
    angle_panel.Parent := frm;
    do_panel_layout(angle_panel, 0);
    set_margins_layout(angle_panel, MARGIN_TOP, MARGIN_BOTTOM, 0, 0, alTop);
    angle_panel.Height := CONTROL_HEIGHT * global_scale_factor;

    angle_label := TLabel.Create(frm);
    angle_label.Parent := angle_panel;
    angle_label.Layout := tlCenter;
    angle_label.Caption := 'Rotation Angle:';
    set_margins_layout(angle_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    angle_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_x_subpanel := TPanel.Create(frm);
    rotation_x_subpanel.Parent := angle_panel;
    do_panel_layout(rotation_x_subpanel, 0);
    set_margins_layout(rotation_x_subpanel, 0, 0, 0, 0, alRight);
    rotation_x_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_x_subpanel.Width := 100 * global_scale_factor;

    rotation_x_label := TLabel.Create(frm);
    rotation_x_label.Parent := rotation_x_subpanel;
    rotation_x_label.Layout := tlCenter;
    rotation_x_label.Caption := 'X:';
    set_margins_layout(rotation_x_label, 0, 0, MARGIN_LEFT, 0, alRight);
    rotation_x_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_x := TEdit.Create(frm);
    rotation_x.Parent := rotation_x_subpanel;
    rotation_x.Alignment := taRightJustify;
    rotation_x.ShowHint := True;
    rotation_x.Hint := 'The X component of the rotation angle in degrees. Defaults to "'
      + float_to_str(GLOBAL_ROTATION_X_DEFAULT, DIGITS_ANGLE, false) + '"';
    set_margins_layout(rotation_x, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    rotation_x.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_x.Width := 62 * global_scale_factor;

    rotation_y_subpanel := TPanel.Create(frm);
    rotation_y_subpanel.Parent := angle_panel;
    do_panel_layout(rotation_y_subpanel, 0);
    set_margins_layout(rotation_y_subpanel, 0, 0, 0, 0, alRight);
    rotation_y_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_y_subpanel.Width := 100 * global_scale_factor;

    rotation_y_label := TLabel.Create(frm);
    rotation_y_label.Parent := rotation_y_subpanel;
    rotation_y_label.Layout := tlCenter;
    rotation_y_label.Caption := 'Y:';
    set_margins_layout(rotation_y_label, 0, 0, MARGIN_LEFT, 0, alRight);
    rotation_y_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_y := TEdit.Create(frm);
    rotation_y.Parent := rotation_y_subpanel;
    rotation_y.Alignment := taRightJustify;
    rotation_y.ShowHint := True;
    rotation_y.Hint := 'The Y component of the rotation angle in degrees. Defaults to "'
      + float_to_str(GLOBAL_ROTATION_Y_DEFAULT, DIGITS_ANGLE, false) + '"';
    set_margins_layout(rotation_y, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    rotation_y.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_y.Width := 62 * global_scale_factor;

    rotation_z_subpanel := TPanel.Create(frm);
    rotation_z_subpanel.Parent := angle_panel;
    do_panel_layout(rotation_z_subpanel, 0);
    set_margins_layout(rotation_z_subpanel, 0, 0, 0, 0, alRight);
    rotation_z_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_z_subpanel.Width := 100 * global_scale_factor;

    rotation_z_label := TLabel.Create(frm);
    rotation_z_label.Parent := rotation_z_subpanel;
    rotation_z_label.Layout := tlCenter;
    rotation_z_label.Caption := 'Z:';
    set_margins_layout(rotation_z_label, 0, 0, MARGIN_LEFT, 0, alRight);
    rotation_z_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_z := TEdit.Create(frm);
    rotation_z.Parent := rotation_z_subpanel;
    rotation_z.Alignment := taRightJustify;
    rotation_z.ShowHint := True;
    rotation_z.Hint := 'The Z component of the rotation angle in degrees. Defaults to "'
      + float_to_str(GLOBAL_ROTATION_Z_DEFAULT, DIGITS_ANGLE, false) + '"';
    set_margins_layout(rotation_z, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    rotation_z.Height := CONTROL_HEIGHT * global_scale_factor;
    rotation_z.Width := 62 * global_scale_factor;

    // rotation options panel

    rotation_options_panel := TPanel.Create(frm);
    rotation_options_panel.Parent := frm;
    do_panel_layout(rotation_options_panel, PANEL_BEVEL);

    // rotation mode subpanel

    rotation_mode_subpanel := TPanel.Create(frm);
    rotation_mode_subpanel.Parent := rotation_options_panel;
    do_panel_layout(rotation_mode_subpanel, 0);
    set_margins_layout(rotation_mode_subpanel, MARGIN_TOP, 0, 0, 0, alTop);
    rotation_mode_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_mode_label := TLabel.Create(frm);
    rotation_mode_label.Parent := rotation_mode_subpanel;
    rotation_mode_label.Layout := tlCenter;
    rotation_mode_label.Caption := 'Rotation Mode:';
    set_margins_layout(rotation_mode_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    rotation_mode_label.Height := CONTROL_HEIGHT * global_scale_factor;

    mode_set := TRadioButton.Create(frm);
    mode_set.Parent := rotation_mode_subpanel;
    mode_set.Alignment := taLeftJustify;
    mode_set.Caption := 'Set';
    mode_set.ShowHint := True;
    mode_set.Hint := 'Rotate the record TO the specified rotation. Defaults to "'
      + bool_to_selected_str(GLOBAL_OPERATION_MODE_DEFAULT = OPERATION_MODE_SET) + '"';
    set_margins_layout(mode_set, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    mode_set.Height := CONTROL_HEIGHT * global_scale_factor;
    mode_set.Width := caption_width(mode_set) + (RADIO_PADDING * global_scale_factor);

    mode_rotate := TRadioButton.Create(frm);
    mode_rotate.Parent := rotation_mode_subpanel;
    mode_rotate.Alignment := taLeftJustify;
    mode_rotate.Caption := 'Rotate';
    mode_rotate.ShowHint := True;
    mode_rotate.Hint := 'Rotate the record BY the specified rotation. Defaults to "'
      + bool_to_selected_str(GLOBAL_OPERATION_MODE_DEFAULT = OPERATION_MODE_ROTATE) + '"';
    set_margins_layout(mode_rotate, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    mode_rotate.Height := CONTROL_HEIGHT * global_scale_factor;
    mode_rotate.Width := caption_width(mode_rotate) + (RADIO_PADDING * global_scale_factor);

    // rotation sequence subpanel

    rotation_sequence_subpanel := TPanel.Create(frm);
    rotation_sequence_subpanel.Parent := rotation_options_panel;
    do_panel_layout(rotation_sequence_subpanel, 0);
    set_margins_layout(rotation_sequence_subpanel, MARGIN_TOP, 0, 0, 0, alTop);
    rotation_sequence_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_sequence_label := TLabel.Create(frm);
    rotation_sequence_label.Parent := rotation_sequence_subpanel;
    rotation_sequence_label.Layout := tlCenter;
    rotation_sequence_label.Caption := 'Rotation Sequence:';
    set_margins_layout(rotation_sequence_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    rotation_sequence_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_sequence := TComboBox.Create(frm);
    rotation_sequence.Parent := rotation_sequence_subpanel;
    rotation_sequence.Style := csDropDownList;
    rotation_sequence.ShowHint := True;
    rotation_sequence.Hint := 'The order in which the proposed rotation would be applied. Defaults to "'
      + rotation_sequence_to_str(GLOBAL_ROTATION_SEQUENCE_DEFAULT) + '"';
    set_margins_layout(rotation_sequence, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    rotation_sequence.Height := CONTROL_HEIGHT * global_scale_factor;

    // apply to subpanel

    apply_to_subpanel := TPanel.Create(frm);
    apply_to_subpanel.Parent := rotation_options_panel;
    do_panel_layout(apply_to_subpanel, 0);
    set_margins_layout(apply_to_subpanel, MARGIN_TOP, MARGIN_BOTTOM, 0, 0, alTop);
    apply_to_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    apply_to_label := TLabel.Create(frm);
    apply_to_label.Parent := apply_to_subpanel;
    apply_to_label.Layout := tlCenter;
    apply_to_label.Caption := 'Apply To:';
    set_margins_layout(apply_to_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    apply_to_label.Height := CONTROL_HEIGHT * global_scale_factor;

    apply_to_both := TRadioButton.Create(frm);
    apply_to_both.Parent := apply_to_subpanel;
    apply_to_both.Alignment := taLeftJustify;
    apply_to_both.Caption := 'Both';
    apply_to_both.ShowHint := True;
    apply_to_both.Hint := 'Apply the proposed rotation to both the record''s position and rotation. '
      + 'Defaults to "' + bool_to_selected_str(GLOBAL_APPLY_TO_POSITION_DEFAULT and
      GLOBAL_APPLY_TO_ROTATION_DEFAULT) + '"';
    set_margins_layout(apply_to_both, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    apply_to_both.Height := CONTROL_HEIGHT * global_scale_factor;
    apply_to_both.Width := caption_width(apply_to_both) + (RADIO_PADDING * global_scale_factor);

    apply_to_position := TRadioButton.Create(frm);
    apply_to_position.Parent := apply_to_subpanel;
    apply_to_position.Alignment := taLeftJustify;
    apply_to_position.Caption := 'Position';
    apply_to_position.ShowHint := True;
    apply_to_position.Hint := 'Apply the proposed rotation to the record''s position only. Defaults to "'
      + bool_to_selected_str(GLOBAL_APPLY_TO_POSITION_DEFAULT and not GLOBAL_APPLY_TO_ROTATION_DEFAULT) + '"';
    set_margins_layout(apply_to_position, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    apply_to_position.Height := CONTROL_HEIGHT * global_scale_factor;
    apply_to_position.Width := caption_width(apply_to_position) + (RADIO_PADDING * global_scale_factor);

    apply_to_rotation := TRadioButton.Create(frm);
    apply_to_rotation.Parent := apply_to_subpanel;
    apply_to_rotation.Alignment := taLeftJustify;
    apply_to_rotation.Caption := 'Rotation';
    apply_to_rotation.ShowHint := True;
    apply_to_rotation.Hint := 'Apply the proposed rotation to the record''s rotation only. Defaults to "'
      + bool_to_selected_str(GLOBAL_APPLY_TO_ROTATION_DEFAULT and not GLOBAL_APPLY_TO_POSITION_DEFAULT) + '"';
    set_margins_layout(apply_to_rotation, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    apply_to_rotation.Height := CONTROL_HEIGHT * global_scale_factor;
    apply_to_rotation.Width := caption_width(apply_to_rotation) + (RADIO_PADDING * global_scale_factor);

    // secondary options panel

    secondary_options_panel := TPanel.Create(frm);
    secondary_options_panel.Parent := frm;
    do_panel_layout(secondary_options_panel, PANEL_BEVEL);

    // clamp subpanel

    clamp_subpanel := TPanel.Create(frm);
    clamp_subpanel.Parent := secondary_options_panel;
    do_panel_layout(clamp_subpanel, 0);
    set_margins_layout(clamp_subpanel, MARGIN_TOP, 0, 0, 0, alTop);
    clamp_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    clamp_label := TLabel.Create(frm);
    clamp_label.Parent := clamp_subpanel;
    clamp_label.Layout := tlCenter;
    clamp_label.Caption := 'Clamp to Multiples of:';
    set_margins_layout(clamp_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    clamp_label.Height := CONTROL_HEIGHT * global_scale_factor;

    clamp_use_checkbox := TCheckBox.Create(frm);
    clamp_use_checkbox.Parent := clamp_subpanel;
    clamp_use_checkbox.Alignment := taLeftJustify;
    clamp_use_checkbox.Caption := 'Clamp';
    clamp_use_checkbox.ShowHint := True;
    clamp_use_checkbox.Hint := 'Clamp the rotation to multiples of the specified angle. Defaults to "'
      + bool_to_checked_str(GLOBAL_CLAMP_USE_DEFAULT) + '"';
    set_margins_layout(clamp_use_checkbox, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    clamp_use_checkbox.Height := CONTROL_HEIGHT * global_scale_factor;
    clamp_use_checkbox.Width := caption_width(clamp_use_checkbox) + (CHECKBOX_PADDING * global_scale_factor);

    clamp_combo := TComboBox.Create(frm);
    clamp_combo.Parent := clamp_subpanel;
    clamp_combo.Style := csDropDownList;
    clamp_combo.ShowHint := True;
    clamp_combo.Hint := 'The angle to clamp to multiples of. Defaults to "'
      + clamp_mode_to_str(GLOBAL_CLAMP_MODE_DEFAULT) + '"';
    set_margins_layout(clamp_combo, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    clamp_combo.Height := CONTROL_HEIGHT * global_scale_factor;

    // position precision subpanel

    position_precision_subpanel := TPanel.Create(frm);
    position_precision_subpanel.Parent := secondary_options_panel;
    do_panel_layout(position_precision_subpanel, 0);
    set_margins_layout(position_precision_subpanel, MARGIN_TOP, 0, 0, 0, alTop);
    position_precision_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    position_precision_label := TLabel.Create(frm);
    position_precision_label.Parent := position_precision_subpanel;
    position_precision_label.Layout := tlCenter;
    position_precision_label.Caption := 'Position Precision:';
    set_margins_layout(position_precision_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    position_precision_label.Height := CONTROL_HEIGHT * global_scale_factor;

    position_precision_combo := TComboBox.Create(frm);
    position_precision_combo.Parent := position_precision_subpanel;
    position_precision_combo.Style := csDropDownList;
    position_precision_combo.ShowHint := True;
    position_precision_combo.Hint := 'The number of decimal places to round positions to. '
      + 'Defaults to "' + precision_to_str(GLOBAL_POSITION_PRECISION_DEFAULT) + '"';
    set_margins_layout(position_precision_combo, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    position_precision_combo.Height := CONTROL_HEIGHT * global_scale_factor;

    // rotation precision subpanel

    rotation_precision_subpanel := TPanel.Create(frm);
    rotation_precision_subpanel.Parent := secondary_options_panel;
    do_panel_layout(rotation_precision_subpanel, 0);
    set_margins_layout(rotation_precision_subpanel, MARGIN_TOP, MARGIN_BOTTOM, 0, 0, alTop);
    rotation_precision_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_precision_label := TLabel.Create(frm);
    rotation_precision_label.Parent := rotation_precision_subpanel;
    rotation_precision_label.Layout := tlCenter;
    rotation_precision_label.Caption := 'Rotation Precision:';
    set_margins_layout(rotation_precision_label, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    rotation_precision_label.Height := CONTROL_HEIGHT * global_scale_factor;

    rotation_precision_combo := TComboBox.Create(frm);
    rotation_precision_combo.Parent := rotation_precision_subpanel;
    rotation_precision_combo.Style := csDropDownList;
    rotation_precision_combo.ShowHint := True;
    rotation_precision_combo.Hint := 'The number of decimal places to round rotations to. '
      + 'Defaults to "' + precision_to_str(GLOBAL_ROTATION_PRECISION_DEFAULT) + '"';
    set_margins_layout(rotation_precision_combo, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alRight);
    rotation_precision_combo.Height := CONTROL_HEIGHT * global_scale_factor;

    // meta panel

    meta_panel := TPanel.Create(frm);
    meta_panel.Parent := frm;
    do_panel_layout(meta_panel, PANEL_BEVEL);

    dry_run_subpanel := TPanel.Create(frm);
    dry_run_subpanel.Parent := meta_panel;
    do_panel_layout(dry_run_subpanel, 0);
    set_margins_layout(dry_run_subpanel, MARGIN_TOP, 0, 0, 0, alTop);
    dry_run_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    dry_run := TCheckBox.Create(frm);
    dry_run.Parent := dry_run_subpanel;
    dry_run.Caption := 'Dry Run';
    dry_run.ShowHint := True;
    dry_run.Hint := 'Do not actually perform the rotation, just show what would be done. Defaults to "'
      + bool_to_checked_str(GLOBAL_DRY_RUN_DEFAULT) + '"';
    set_margins_layout(dry_run, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    dry_run.Height := CONTROL_HEIGHT * global_scale_factor;
    dry_run.Width := caption_width(dry_run) + (CHECKBOX_PADDING * global_scale_factor);

    use_same_settings_for_all_subpanel := TPanel.Create(frm);
    use_same_settings_for_all_subpanel.Parent := meta_panel;
    do_panel_layout(use_same_settings_for_all_subpanel, 0);
    set_margins_layout(use_same_settings_for_all_subpanel, MARGIN_TOP, MARGIN_BOTTOM, 0, 0, alTop);
    use_same_settings_for_all_subpanel.Height := CONTROL_HEIGHT * global_scale_factor;

    use_same_settings_for_all := TCheckBox.Create(frm);
    use_same_settings_for_all.Parent := use_same_settings_for_all_subpanel;
    use_same_settings_for_all.Caption := 'Use Same Settings for All';
    use_same_settings_for_all.ShowHint := True;
    use_same_settings_for_all.Hint := 'Use the same settings for all records. Defaults to "'
      + bool_to_checked_str(GLOBAL_USE_SAME_SETTINGS_FOR_ALL_DEFAULT) + '"';
    set_margins_layout(use_same_settings_for_all, 0, 0, MARGIN_LEFT, MARGIN_RIGHT, alLeft);
    use_same_settings_for_all.Height := CONTROL_HEIGHT * global_scale_factor;
    use_same_settings_for_all.Width := caption_width(use_same_settings_for_all) + (CHECKBOX_PADDING
      * global_scale_factor);

    // button panel

    create_button_panel(frm, frm, debug_checkbox);

    // set the values on the various controls

    rotation_x.Text := float_to_str(global_rotate_x, DIGITS_ANGLE, false);
    rotation_y.Text := float_to_str(global_rotate_y, DIGITS_ANGLE, false);
    rotation_z.Text := float_to_str(global_rotate_z, DIGITS_ANGLE, false);
    mode_set.Checked := (global_operation_mode = OPERATION_MODE_SET);
    mode_rotate.Checked := (global_operation_mode = OPERATION_MODE_ROTATE);
    for i := SEQUENCE_MIN to SEQUENCE_MAX do
      rotation_sequence.Items.Add(rotation_sequence_to_str(i));
    rotation_sequence.ItemIndex := global_rotation_sequence;
    apply_to_both.Checked := global_apply_to_position and global_apply_to_rotation;
    apply_to_position.Checked := global_apply_to_position and not global_apply_to_rotation;
    apply_to_rotation.Checked := global_apply_to_rotation and not global_apply_to_position;
    clamp_use_checkbox.Checked := global_clamp_use;
    for i := CLAMP_MODE_MIN to CLAMP_MODE_MAX do
      clamp_combo.Items.Add(clamp_mode_to_str(i));
    clamp_combo.ItemIndex := global_clamp_mode;
    for i := PRECISION_MIN downto PRECISION_POSITION do
      position_precision_combo.Items.Add(precision_to_str(i));
    position_precision_combo.ItemIndex := -global_position_precision;
    for i := PRECISION_MIN downto PRECISION_ROTATION do
      rotation_precision_combo.Items.Add(precision_to_str(i));
    rotation_precision_combo.ItemIndex := -global_rotation_precision;
    dry_run.Checked := global_dry_run;
    use_same_settings_for_all.Checked := global_use_same_settings_for_all;
    debug_checkbox.Checked := global_debug;

    // set the widths of combo boxes to the width of their widest item

    rotation_sequence.Width := max_item_width(rotation_sequence) + (COMBO_PADDING * global_scale_factor);
    clamp_combo.Width := max_item_width(clamp_combo) + (COMBO_PADDING * global_scale_factor);
    position_precision_combo.Width := max_item_width(position_precision_combo) + (COMBO_PADDING
      * global_scale_factor);
    rotation_precision_combo.Width := max_item_width(rotation_precision_combo) + (COMBO_PADDING
      * global_scale_factor);

    // show the form (duh)

    Result := frm.ShowModal;

    // get the values from the various controls and store them in their respective global variables

    if (Result = mrOk) then begin
      global_rotate_x := StrToFloat(rotation_x.Text);
      global_rotate_y := StrToFloat(rotation_y.Text);
      global_rotate_z := StrToFloat(rotation_z.Text);
      global_operation_mode := mode_set.Checked;
      global_rotation_sequence := rotation_sequence.ItemIndex;
      global_apply_to_position := apply_to_both.Checked or apply_to_position.Checked;
      global_apply_to_rotation := apply_to_both.Checked or apply_to_rotation.Checked;
      global_clamp_use := clamp_use_checkbox.Checked;
      global_clamp_mode := clamp_combo.ItemIndex;
      global_position_precision := -position_precision_combo.ItemIndex;
      global_rotation_precision := -rotation_precision_combo.ItemIndex;
      global_dry_run := dry_run.Checked;
      global_use_same_settings_for_all := use_same_settings_for_all.Checked;
      global_debug := debug_checkbox.Checked;
    end;
  finally
    frm.Free;
  end;
end;


//
// XEDIT SCRIPT FUNCTIONS
//


// initialize the script (ran once at the beginning)
function Initialize(): integer;
// var
// const
begin
  if (wbVersionNumber < MINIMUM_REQUIRED_XEDIT_VERSION) then begin
    AddMessage('You need to update xEdit to version ' + version_number_to_str(MINIMUM_REQUIRED_XEDIT_VERSION)
      + ' or higher to use this script');
    Result := 1;
    exit;
  end;

  // initialize global variables
  global_debug := GLOBAL_DEBUG_DEFAULT;

  global_record_signature_use := GLOBAL_RECORD_SIGNATURE_USE_DEFAULT;
  global_record_signature_mode := GLOBAL_RECORD_SIGNATURE_MODE_DEFAULT;
  global_record_signature_list := GLOBAL_RECORD_SIGNATURE_LIST_DEFAULT;
  global_refr_name_signature_use := GLOBAL_REFR_NAME_SIGNATURE_USE_DEFAULT;
  global_refr_name_signature_mode := GLOBAL_REFR_NAME_SIGNATURE_MODE_DEFAULT;
  global_refr_name_signature_list := GLOBAL_REFR_NAME_SIGNATURE_LIST_DEFAULT;
  global_edid_starts_with_use := GLOBAL_EDID_STARTS_WITH_USE_DEFAULT;
  global_edid_starts_with_mode := GLOBAL_EDID_STARTS_WITH_MODE_DEFAULT;
  global_edid_starts_with_list := GLOBAL_EDID_STARTS_WITH_LIST_DEFAULT;
  global_edid_ends_with_use := GLOBAL_EDID_ENDS_WITH_USE_DEFAULT;
  global_edid_ends_with_mode := GLOBAL_EDID_ENDS_WITH_MODE_DEFAULT;
  global_edid_ends_with_list := GLOBAL_EDID_ENDS_WITH_LIST_DEFAULT;
  global_edid_contains_use := GLOBAL_EDID_CONTAINS_USE_DEFAULT;
  global_edid_contains_mode := GLOBAL_EDID_CONTAINS_MODE_DEFAULT;
  global_edid_contains_list := GLOBAL_EDID_CONTAINS_LIST_DEFAULT;
  global_edid_equals_use := GLOBAL_EDID_EQUALS_USE_DEFAULT;
  global_edid_equals_mode := GLOBAL_EDID_EQUALS_MODE_DEFAULT;
  global_edid_equals_list := GLOBAL_EDID_EQUALS_LIST_DEFAULT;

  global_rotate_x := GLOBAL_ROTATION_X_DEFAULT;
  global_rotate_y := GLOBAL_ROTATION_Y_DEFAULT;
  global_rotate_z := GLOBAL_ROTATION_Z_DEFAULT;

  global_operation_mode := GLOBAL_OPERATION_MODE_DEFAULT;
  global_rotation_sequence := GLOBAL_ROTATION_SEQUENCE_DEFAULT;
  global_apply_to_position := GLOBAL_APPLY_TO_POSITION_DEFAULT;
  global_apply_to_rotation := GLOBAL_APPLY_TO_ROTATION_DEFAULT;

  global_clamp_use := GLOBAL_CLAMP_USE_DEFAULT;
  global_clamp_mode := GLOBAL_CLAMP_MODE_DEFAULT;
  global_position_precision := GLOBAL_POSITION_PRECISION_DEFAULT;
  global_rotation_precision := GLOBAL_ROTATION_PRECISION_DEFAULT;

  global_dry_run := GLOBAL_DRY_RUN_DEFAULT;
  global_use_same_settings_for_all := GLOBAL_USE_SAME_SETTINGS_FOR_ALL_DEFAULT;

  // calculate the global scale factor to ensure that the UI looks good on all systems
  global_scale_factor := Screen.PixelsPerInch / 96.0;

  // allow the user to make a choice about which records will be processed
  Result := show_record_filter_dialog();
  debug_print('Initialize: dialog returned ' + IntToStr(Result) + ': ' + modal_result_to_str(Result));
  if (Result = mrOk) or (Result = mrYesToAll) then begin
    Result := 0;
  end else begin
    AddMessage('User cancelled the operation');
    exit;
  end;
end;


// process record (ran for each record)
function Process(e: IInterface): integer;
var
  x, y, z: double;
  operation_mode_text, dry_run_text: string;
begin
  // show the rotation options if they haven't been shown yet or if the user has chosen to not use
  // the same settings for all records
  if (not global_use_same_settings_for_all) or (not global_options_dialog_shown) then begin
    Result := show_options_dialog();
    debug_print('Process: dialog returned ' + IntToStr(Result) + ': ' + modal_result_to_str(Result));
    global_options_dialog_shown := True;
    if (Result = mrOk) then begin
      Result := 0;
    end else begin
      AddMessage('User cancelled the operation');
      exit;
    end;
  end;

  if (not filter_record(e)) then begin
    debug_print('Process: filter_record returned false, skipping record ' + ShortName(e));
    exit;
  end;

  AddMessage(FullPath(e));

  if (global_operation_mode = OPERATION_MODE_SET) then begin
    operation_mode_text := 'Setting to ';
  end else begin
    operation_mode_text := 'Rotating by ';
  end;
  if (global_dry_run) then begin
    dry_run_text := '[DRY RUN] '
  end;
  AddMessage(dry_run_text + operation_mode_text + qv_to_str(0, global_rotate_x, global_rotate_y,
    global_rotate_z, false, false, false, ' = ', '', DIGITS_ANGLE) + ' using rotation sequence '
    + rotation_sequence_to_str(global_rotation_sequence));

  if (global_apply_to_position) then begin
    x := GetElementEditValues(e,'DATA - Position/Rotation\Position\X');
    y := GetElementEditValues(e,'DATA - Position/Rotation\Position\Y');
    z := GetElementEditValues(e,'DATA - Position/Rotation\Position\Z');
    AddMessage(dry_run_text + 'Initial position: ' + vector_to_str(x, y, z, true, DIGITS_POSITION));
    rotate_position(
      GetElementNativeValues(e, 'DATA - Position/Rotation\Position\X'),  // initial x position
      GetElementNativeValues(e, 'DATA - Position/Rotation\Position\Y'),  // initial y position
      GetElementNativeValues(e, 'DATA - Position/Rotation\Position\Z'),  // initial z position
      global_rotate_x, global_rotate_y, global_rotate_z,                 // rotation to apply
      global_rotation_sequence,                                          // rotation sequence to use
      x, y, z                                                            // (output) final position
    );
    debug_print('Process: rotate_position returned values: '
      + vector_to_str(x, y, z, false, DIGITS_FULL));

    if not global_dry_run then begin
      SetElementNativeValues(e, 'DATA - Position/Rotation\Position\X', x);
      SetElementNativeValues(e, 'DATA - Position/Rotation\Position\Y', y);
      SetElementNativeValues(e, 'DATA - Position/Rotation\Position\Z', z);
      x := GetElementNativeValues(e,'DATA - Position/Rotation\Position\X');
      y := GetElementNativeValues(e,'DATA - Position/Rotation\Position\Y');
      z := GetElementNativeValues(e,'DATA - Position/Rotation\Position\Z');
    end;
    AddMessage(dry_run_text + 'Final position:   ' + vector_to_str(x, y, z, true, DIGITS_POSITION));
  end;

  if (global_apply_to_rotation) then begin
    x := GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\X');
    y := GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\Y');
    z := GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\Z');
    AddMessage(dry_run_text + 'Initial rotation: ' + vector_to_str(x, y, z, true, DIGITS_ANGLE));
    rotate_rotation(
      GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\X'),  // initial x rotation
      GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Y'),  // initial y rotation
      GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Z'),  // initial z rotation
      global_rotate_x, global_rotate_y, global_rotate_z,                 // rotation to apply
      global_rotation_sequence,                                          // rotation sequence to use
      x, y, z                                                            // (output) final rotation
    );
    debug_print('Process: rotate_rotation returned values: '
      + vector_to_str(x, y, z, false, DIGITS_FULL));

    if not global_dry_run then begin
      SetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\X', x);
      SetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Y', y);
      SetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Z', z);
      x := GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\X');
      y := GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Y');
      z := GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Z');
    end;
    AddMessage(dry_run_text + 'Final rotation:   ' + vector_to_str(x, y, z, true, DIGITS_ANGLE));
  end;
end;


// clean up the script (ran once at the end)
// function Finalize(): integer;
// var
// const
// begin
// end;


end.
