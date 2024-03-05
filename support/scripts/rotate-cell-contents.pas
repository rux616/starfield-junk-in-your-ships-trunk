{
  TODO: add GUI
  TODO: add option to clamp to a multiple of 90 degrees
  TODO: add rounding to nearest 0.0001 degree (more precise?)
  Starfield uses right-hand rule coordinates (https://en.wikipedia.org/wiki/Right-hand_rule#Coordinates) and rotations are clockwise positive (left-hand grip rule - thumb represents positive direction of axis of rotation and the fingers curl in the direction of a positive rotation), done in a ZYX sequence. Facing the front of a ship:
    +x is left (starboard)
    -x is right (port)
    +y is towards you (fore)
    -y is away from you (aft)
    +z is up
    -z is down


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
  DEBUG = True;
  DRY_RUN = True;

  // possible rotation sequences for Tait-Bryan angles
  // see https://en.wikipedia.org/wiki/Euler_angles#Chained_rotations_equivalence for more information
  SEQUENCE_XYZ = 0; SEQUENCE_MIN = 0;
  SEQUENCE_XZY = 1;
  SEQUENCE_YXZ = 2;
  SEQUENCE_YZX = 3;
  SEQUENCE_ZXY = 4;
  SEQUENCE_ZYX = 5; SEQUENCE_MAX = 5;

  ROTATION_SEQUENCE_DEFAULT = SEQUENCE_ZYX;
  ROTATION_SEQUENCE_DEFAULT_INVERSE = SEQUENCE_XYZ;

  // epsilon to use for CompareValue calls
  EPSILON = 0.000001;

var
  global_rotation_sequence: integer;


procedure debug_print(message: string);
begin
  if DEBUG then AddMessage('debug: ' + message);
end;


// rotate a position via quaternion math
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

  // everything i've read says this should be (q * v * q'), but only (q' * (v * q)) gives the correct
  // results ¯\_(ツ)_/¯
  quaternion_multiply(
    0, vx, vy, vz,
    qw, qx, qy, qz,
    qwv, qxv, qyv, qzv
  );
  quaternion_inverse(
    qw, qx, qy, qz,
    qwi, qxi, qyi, qzi
  );
  quaternion_multiply(
    qwi, qxi, qyi, qzi,
    qwv, qxv, qyv, qzv,
    qw, return_vx, return_vy, return_vz  // the returned w component is irrelevant and so is discarded
  );
end;


// rotate a rotation via quaternion math
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
  euler_to_quaternion(
    rx, ry, rz,
    rotation_sequence,
    qw2, qx2, qy2, qz2
  );

  // everything i've read says this should be (q2 * q1), but only (q1 * q2) gives the correct results
  // ¯\_(ツ)_/¯
  quaternion_multiply(
    qw1, qx1, qy1, qz1,
    qw2, qx2, qy2, qz2,
    qw3, qx3, qy3, qz3
  );

  quaternion_to_euler(
    qw3, qx3, qy3, qz3,
    rotation_sequence,
    return_x, return_y, return_z
  );
end;


// normalize an angle (in degrees) to [0.0, 360.0)
function normalize_angle(angle: double): double;
const
  NORMALIZER = 360.0;
begin
  // FMod(a,b) returns a value between -Abs(b) and Abs(b) exclusive, so need to add b and do it again
  // to fully catch negative angles
  Result := FMod(FMod(angle, NORMALIZER) + NORMALIZER, NORMALIZER);
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

  // assign quaternion components to generic p-variables, and set the sign
  p0 := qw;
  case (rotation_sequence) of
    SEQUENCE_XYZ: begin p1 := qx; p2 := qy; p3 := qz; e := -1; end;
    SEQUENCE_XZY: begin p1 := qx; p2 := qz; p3 := qy; e :=  1; end;
    SEQUENCE_YXZ: begin p1 := qy; p2 := qx; p3 := qz; e :=  1; end;
    SEQUENCE_YZX: begin p1 := qy; p2 := qz; p3 := qx; e := -1; end;
    SEQUENCE_ZXY: begin p1 := qz; p2 := qx; p3 := qy; e := -1; end;
    SEQUENCE_ZYX: begin p1 := qz; p2 := qy; p3 := qx; e :=  1; end;
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

  // calculate the value to be used to check for singularities
  singularity_check := 2.0 * (p0 * p2 - e * p1 * p3);

  // calculate second rotation angle, clamping it to prevent ArcSin from erroring
  euler_angle[euler_order[1]] := ArcSin(clamp(singularity_check, -1.0, 1.0));

  // a singularity exists when the second angle in a rotation sequence is at +/-90 degrees
  if (CompareValue(Abs(singularity_check), 1.0, EPSILON) = LessThanValue) then begin
    euler_angle[euler_order[0]] := ArcTan2(2.0 * (p0 * p1 + e * p2 * p3), 1.0 - 2.0 * (p1 * p1 + p2 * p2));
    euler_angle[euler_order[2]] := ArcTan2(2.0 * (p0 * p3 + e * p1 * p2), 1.0 - 2.0 * (p2 * p2 + p3 * p3));
  end else begin
    // when a singularity is detected, the third angle basically loses all meaning so is set to 0
    euler_angle[euler_order[0]] := ArcTan2(2.0 * (p0 * p1 - e * p2 * p3), 1.0 - 2.0 * (p1 * p1 + p3 * p3));
    euler_angle[euler_order[2]] := 0.0;
  end;

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


// multiply two quaternions together
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


// validate the given rotation sequence and throws an error if said validation fails
procedure validate_rotation_sequence(rotation_sequence: integer);
begin
  if (rotation_sequence < SEQUENCE_MIN) or (rotation_sequence > SEQUENCE_MAX) then
    raise Exception.Create('rotation sequence is ' + rotation_sequence_to_str(rotation_sequence));
end;


// return a stringified quaternion
function quaternion_to_str(w, x, y, z: double): string;
begin
  Result := '[w:' + float_to_str(w)
         + ', x:' + float_to_str(x)
         + ', y:' + float_to_str(y)
         + ', z:' + float_to_str(z)
         + ']';
end;


// return a stringified vector
function vector_to_str(x, y, z: double): string;
begin
  Result := '[x:' + float_to_str(x)
         + ', y:' + float_to_str(y)
         + ', z:' + float_to_str(z)
         + ']';
end;


// return a stringified vector composed of whole numbers
function vector_whole_to_str(x, y, z: double): string;
begin
  Result := '[x:' + IntToStr(Round(x))
         + ', y:' + IntToStr(Round(y))
         + ', z:' + IntToStr(Round(z))
         + ']';
end;


// return a stringified float to 16 digit precision
function float_to_str(d: double): string;
begin
  Result := FloatToStrF(d, 2, 9999, 16);
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


// return a stringified boolean
function bool_to_str(b: boolean): string;
begin
  if b then
    Result := 'true';
  else
    Result := 'false';
end;


// clamp given value d between min and max (inclusive)
function clamp(d, min, max: double): double;
begin
  if (CompareValue(d, min, EPSILON) = LessThanValue) then
    Result := min
  else if (CompareValue(d, max, EPSILON) = GreaterThanValue) then
    Result := max
  else
    Result := d;
end;


// function Initialize(): integer;
// // var
// // const
// begin
//   // Result := 1;
// end;


function Process(e: IInterface): integer;
var
  x, y, z, to_rotate_x, to_rotate_y, to_rotate_z: double;
  e2: IInterface;
begin
  if Signature(e) <> 'REFR' then exit;

  to_rotate_x := 90.0; to_rotate_y := 0.0; to_rotate_z := 90.0;

  AddMessage(FullPath(e));

  AddMessage('Rotating by: ' + vector_to_str(to_rotate_x, to_rotate_y, to_rotate_z));

  // NAME - Base entries that should be ignored
  //  IS "OutpostGroupPackinDummy" [STAT:00015804]
  //  IS "PrefabPackinPivotDummy" [STAT:0003F808]
  //  STARTS WITH "SMOD_Snap" -> make this a string to be asked for?
  //  others?
  AddMessage(
    'Initial Position'
    + ': X = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\X')
    + ', Y = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\Y')
    + ', Z = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\Z')
  );
  rotate_position(
    GetElementNativeValues(e, 'DATA - Position/Rotation\Position\X'),  // initial x position
    GetElementNativeValues(e, 'DATA - Position/Rotation\Position\Y'),  // initial y position
    GetElementNativeValues(e, 'DATA - Position/Rotation\Position\Z'),  // initial z position
    to_rotate_x, to_rotate_y, to_rotate_z,                             // rotation to apply
    ROTATION_SEQUENCE_DEFAULT,                                         // rotation sequence to use
    x, y, z                                                            // (output) final position
  );
  debug_print('rotate_position returned values: ' + vector_to_str(x, y, z));

  if not DRY_RUN then begin
    SetElementNativeValues(e, 'DATA - Position/Rotation\Position\X', x);
    SetElementNativeValues(e, 'DATA - Position/Rotation\Position\Y', y);
    SetElementNativeValues(e, 'DATA - Position/Rotation\Position\Z', z);
    AddMessage(
      'Final Position'
      + ': X = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\X')
      + ', Y = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\Y')
      + ', Z = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\Z')
    );
  end
  else begin
    AddMessage(
      'DRY RUN: Final Position'
      + ': X = ' + float_to_str(x)
      + ', Y = ' + float_to_str(y)
      + ', Z = ' + float_to_str(z)
    );
  end;

  AddMessage(
    'Initial Rotation'
    + ': X = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\X')
    + ', Y = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\Y')
    + ', Z = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\Z')
  );
  rotate_rotation(
    GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\X'),  // initial x rotation
    GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Y'),  // initial y rotation
    GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Z'),  // initial z rotation
    to_rotate_x, to_rotate_y, to_rotate_z,                             // rotation to apply
    ROTATION_SEQUENCE_DEFAULT,                                         // rotation sequence to use
    x, y, z                                                            // (output) final rotation
  );
  debug_print('rotate_rotation returned values: ' + vector_to_str(x, y, z));

  if not DRY_RUN then begin
    SetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\X', x);
    SetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Y', y);
    SetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Z', z);
    AddMessage(
      'Final Rotation'
      + ': X = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\X')
      + ', Y = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\Y')
      + ', Z = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\Z')
    );
  end
  else begin
    AddMessage(
      'DRY RUN: Final Rotation'
      + ': X = ' + float_to_str(x)
      + ', Y = ' + float_to_str(y)
      + ', Z = ' + float_to_str(z)
    );
  end;
end;

// function Finalize(): integer;
// // var
// // const
// begin
// end;

end.
