{
  TODO: add option to clamp to a multiple of 90 degrees
  TODO: add rounding to nearest 0.0001 degree
  TODO: fix rotation of positions (seems to be right hand rule-based at the moment)
}
unit rotate_cell_contents;

type
  quaternion = record
    w, x, y, z: double;
end;

type
  vector = record
    x, y, z: double;
end;

const
  DEBUG = True;
  DRY_RUN = True;

  ROTATION_SEQUENCE_XYZ = 0;
  ROTATION_SEQUENCE_XZY = 1;
  ROTATION_SEQUENCE_YXZ = 2;
  ROTATION_SEQUENCE_YZX = 3;
  ROTATION_SEQUENCE_ZXY = 4;
  ROTATION_SEQUENCE_ZYX = 5;
  ROTATION_SEQUENCE_ALL = 99;
  ROTATION_SEQUENCE_DEFAULT = ROTATION_SEQUENCE_ZYX;
  ROTATION_SEQUENCE_DEFAULT_INVERSE = ROTATION_SEQUENCE_XYZ;

  ROTATION_DIRECTION_CLOCKWISE = 0;
  ROTATION_DIRECTION_COUNTERCLOCKWISE = 1;
  ROTATION_DIRECTION_DEFAULT = ROTATION_DIRECTION_CLOCKWISE;
  ROTATION_DIRECTION_DEFAULT_INVERSE = ROTATION_DIRECTION_COUNTERCLOCKWISE; // TODO is this even needed?

var
  q: array[0..9] of quaternion;
  v: array[0..9] of vector;


procedure debug_print(message: string);
begin
  if DEBUG then AddMessage(message);
end;


// x, y, z: point
// rx, ry, rz: rotation in degrees
// return_x, return_y, return_z: point
procedure rotate_position(
  x, y, z, rx, ry, rz: double;
  rotation_sequence: integer;
  rotation_direction: integer;
  var return_x, return_y, return_z: double
);
var
  qx, qy, qz, qw: double;
  idx, i, max_i: integer;
  temp_x, temp_y, temp_z: double;
  angle_order: array[0..2] of vector;
begin
  // store the starting point in a vector
  idx := 0; v[idx].x := x; v[idx].y := y; v[idx].z := z;
  debug_print('debug: start point');
  debug_vector_display(0,0);

  // set up the angle_order variable based on which order the rotations will be applied in
  for i := Low(angle_order) to High(angle_order)
    angle_order[i].x := 0.0; angle_order[i].y := 0.0; angle_order[i].z := 0.0;
  case (rotation_sequence) of
    ROTATION_SEQUENCE_XYZ: begin angle_order[0].x := rx; angle_order[1].y := ry; angle_order[2].z := rz; end;
    ROTATION_SEQUENCE_XZY: begin angle_order[0].x := rx; angle_order[1].z := rz; angle_order[2].y := ry; end;
    ROTATION_SEQUENCE_YXZ: begin angle_order[0].y := ry; angle_order[1].x := rx; angle_order[2].z := rz; end;
    ROTATION_SEQUENCE_YZX: begin angle_order[0].y := ry; angle_order[1].z := rz; angle_order[2].x := rx; end;
    ROTATION_SEQUENCE_ZXY: begin angle_order[0].z := rz; angle_order[1].x := rx; angle_order[2].y := ry; end;
    ROTATION_SEQUENCE_ZYX: begin angle_order[0].z := rz; angle_order[1].y := ry; angle_order[2].x := rx; end;
    // special case
    ROTATION_SEQUENCE_ALL: begin angle_order[0].x := rx; angle_order[0].y := ry; angle_order[0].z := rz; end;
  else
    raise Exception.Create('unknown rotation sequence ''' + IntToStr(rotation_sequence) + '''');
  end;

  case (rotation_sequence) of
    ROTATION_SEQUENCE_XYZ, ROTATION_SEQUENCE_XZY, ROTATION_SEQUENCE_YXZ, ROTATION_SEQUENCE_YZX, ROTATION_SEQUENCE_ZXY, ROTATION_SEQUENCE_ZYX, ROTATION_SEQUENCE_ALL:
      max_i := High(angle_order);
    ROTATION_SEQUENCE_ALL:
      max_i := Low(angle_order);
  end;

  for i := 0 to max_i do begin
    debug_print('debug: rotation sequence (' + IntToStr(rotation_sequence) + ') application ' + IntToStr(i + 1) + ' of ' + IntToStr(max_i + 1));
    // turn component into quaternion
    euler_to_quaternion(
      // input angles
      angle_order[i].x, angle_order[i].y, angle_order[i].z,
      // negate the values
      // NOTE: i don't think the rotation angles should need to be multiplied by -1, but this is what works currently
      True,
      // returned quaternion values
      qw, qx, qy, qz
    );
    idx := 0; q[idx].w := qw; q[idx].x := qx; q[idx].y := qy; q[idx].z := qz;
    debug_quaternion_display(0,0);

    // apply quaternion to point
    quaternion_vector_multiply(0, 0, High(v));
    vector_copy(High(v), 0);
    debug_vector_display(0,0);
  end;

  debug_print('debug: result point');
  debug_vector_display(0,0);

  idx := 0; return_x := v[idx].x; return_y := v[idx].y; return_z := v[idx].z;
end;


// x, y, z: rotation in degrees
// rx, ry, rz: rotation in degrees
// return_x, return_y, return_z: rotation in degrees
procedure rotate_rotation(
  x, y, z, rx, ry, rz: double;
  rotation_sequence: integer;
  rotation_direction: integer;
  var return_x, return_y, return_z: double);
var
  qw, qx, qy, qz: double;
  idx: integer;
begin
  debug_print('debug: calculating rotation quaternion');
  euler_to_quaternion(x, y, z, qw, qx, qy, qz);
  idx := 0; q[idx].w := qw; q[idx].x := qx; q[idx].y := qy; q[idx].z := qz;
  debug_quaternion_display(0,0);

  debug_print('debug: calculating quaternion rotation to apply');
  euler_to_quaternion(rx, ry, rz, qw, qx, qy, qz);
  idx := 1; q[idx].w := qw; q[idx].x := qx; q[idx].y := qy; q[idx].z := qz;
  debug_quaternion_display(1,1);

  quaternion_multiply(0, 1, High(q));
  quaternion_to_euler(
    // inputs
    q[High(q)].w, q[High(q)].x, q[High(q)].y, q[High(q)].z,
    // do no negate
    False,
    // outputs
    return_x, return_y, return_z
  );
end;


// normalize an angle (in degrees) to [0, 360)
function normalize_angle(angle: double): double;
var
  normalizer: double;
begin
  normalizer := 360.0;
  Result := FMod(FMod(angle, normalizer) + normalizer, normalizer);
end;


// takes an euler angle and converts it to a quaternion
// inputs (roll, pitch, yaw) in degrees, and choose wether to negate the angles
// outputs [ref]: quaternion components
//
// adapted from "Euler angles (in 3-2-1 sequence) to quaternion conversion" section of
// https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
procedure euler_to_quaternion(roll, pitch, yaw: double; negate: boolean; var qw, qx, qy, qz: double);
var
  cr, cp, cy, sr, sp, sy: double;
begin
  // normalize angles
  roll := normalize_angle(roll); pitch := normalize_angle(pitch); yaw := normalize_angle(yaw);
  debug_print('debug: normalized angles');
  debug_print('debug: roll: ' + prt_float(roll) + ', pitch: ' + prt_float(pitch) + ', yaw: ' + prt_float(yaw));

  // convert to radians
  roll := DegToRad(roll); pitch := DegToRad(pitch); yaw := DegToRad(yaw);
  debug_print('debug: radians');
  debug_print('debug: roll: ' + prt_float(roll) + ', pitch: ' + prt_float(pitch) + ', yaw: ' + prt_float(yaw));

  // negate the values as specified
  if (negate) then begin
    roll := roll * -1.0; pitch := pitch * -1.0; yaw := yaw * -1.0;
  end;

  // calculate some intermediate values to reduce total number of calculations done
  cr := Cos(roll * 0.5);  sr := Sin(roll * 0.5);
  cp := Cos(pitch * 0.5); sp := Sin(pitch * 0.5);
  cy := Cos(yaw * 0.5);   sy := Sin(yaw * 0.5);

  // calculate the actual quaternion
  qw := cr * cp * cy + sr * sp * sy;
  qx := sr * cp * cy - cr * sp * sy;
  qy := cr * sp * cy + sr * cp * sy;
  qz := cr * cp * sy - sr * sp * cy;
end;


// implementation of https://www.euclideanspace.com/maths/geometry/rotations/conversions/eulerToQuaternion/Euler%20to%20quat.pdf
procedure euler_to_quaternion2(x, y, z: double; rotation_sequence: integer; rotation_direction: integer; var qw, qx, qy, qz: double);
var
  q_temp1, q_temp2, q_temp3: quaternion;
  i: integer;
begin
  // normalize angles
  x := normalize_angle(x); y := normalize_angle(y); z := normalize_angle(z);
  debug_print('debug: normalized angles');
  debug_print('debug: x: ' + prt_float(x) + ', y: ' + prt_float(y) + ', z: ' + prt_float(z));

  // convert to radians
  x := DegToRad(x); y := DegToRad(y); z := DegToRad(z);
  debug_print('debug: radians');
  debug_print('debug: x: ' + prt_float(x) + ', y: ' + prt_float(y) + ', z: ' + prt_float(z));

  // counterclockwise or not
  if (rotation_direction = ROTATION_DIRECTION_CLOCKWISE) then begin
    x := -1.0 * x; y := -1.0 * y; z := -1.0 * z;
  end;

  // save existing quaternions
  q_temp1.w := q[0].w; q_temp1.x := q[0].x; q_temp1.y := q[0].y; q_temp1.z := q[0].z;
  q_temp2.w := q[1].w; q_temp2.x := q[1].x; q_temp2.y := q[1].y; q_temp2.z := q[1].z;
  q_temp3.w := q[2].w; q_temp3.x := q[2].x; q_temp3.y := q[2].y; q_temp3.z := q[2].z;


  for i := 0 to 2 do
    q[i].w := 0.0; q[i].x := 0.0; q[i].y := 0.0; q[i].z := 0.0;
  case (rotation_sequence) of
    ROTATION_SEQUENCE_XYZ: begin
      q[0].w := Cos(x * 0.5); q[0].x := Sin(x * 0.5);
      q[1].w := Cos(y * 0.5); q[1].y := Sin(y * 0.5);
      q[2].w := Cos(z * 0.5); q[2].z := Sin(z * 0.5);
    end;
    ROTATION_SEQUENCE_XZY: begin
      q[0].w := Cos(x * 0.5); q[0].x := Sin(x * 0.5);
      q[1].w := Cos(z * 0.5); q[1].z := Sin(z * 0.5);
      q[2].w := Cos(y * 0.5); q[2].y := Sin(y * 0.5);
    end;
    ROTATION_SEQUENCE_YXZ: begin
      q[0].w := Cos(y * 0.5); q[0].y := Sin(y * 0.5);
      q[1].w := Cos(x * 0.5); q[1].x := Sin(x * 0.5);
      q[2].w := Cos(z * 0.5); q[2].z := Sin(z * 0.5);
    end;
    ROTATION_SEQUENCE_YZX: begin
      q[0].w := Cos(y * 0.5); q[0].y := Sin(y * 0.5);
      q[1].w := Cos(z * 0.5); q[1].z := Sin(z * 0.5);
      q[2].w := Cos(x * 0.5); q[2].x := Sin(x * 0.5);
    end;
    ROTATION_SEQUENCE_ZXY: begin
      q[0].w := Cos(z * 0.5); q[0].z := Sin(z * 0.5);
      q[1].w := Cos(x * 0.5); q[1].x := Sin(x * 0.5);
      q[2].w := Cos(y * 0.5); q[2].y := Sin(y * 0.5);
    end;
    ROTATION_SEQUENCE_ZYX: begin
      q[0].w := Cos(z * 0.5); q[0].z := Sin(z * 0.5);
      q[1].w := Cos(y * 0.5); q[1].y := Sin(y * 0.5);
      q[2].w := Cos(x * 0.5); q[2].x := Sin(x * 0.5);
    end;
  else
    raise Exception.Create('unknown rotation sequence ''' + IntToStr(rotation_sequence) + '''');
  end;

  quaternion_multiply(0, 1, High(q));
  quaternion_multiply(High(q), 2, High(q));
  qw := q[High(q)].w; qx := q[High(q)].x; qy := q[High(q)].y; qz := q[High(q)].z;

  // restore quaternions
  q[0].w := q_temp1.w; q[0].x := q_temp1.x; q[0].y := q_temp1.y; q[0].z := q_temp1.z;
  q[1].w := q_temp2.w; q[1].x := q_temp2.x; q[1].y := q_temp2.y; q[1].z := q_temp2.z;
  q[2].w := q_temp3.w; q[2].x := q_temp3.x; q[2].y := q_temp3.y; q[2].z := q_temp3.z;
end;


// takes a quaternion and converts it to an euler angle
// inputs (qw, qx, qy, qz): quaternion
// outputs [ref]: euler angles
//
// adapted from https://automaticaddison.com/how-to-convert-a-quaternion-into-euler-angles-in-python/
procedure quaternion_to_euler(qw, qx, qy, qz: double; var roll, pitch, yaw: double);
var
  temp0, temp1: double;
begin
  temp0 := 2.0 * (qw * qx + qy * qz);
  temp1 := 1.0 - 2.0 * (qx * qx + qy * qy);
  roll := ArcTan2(temp0, temp1);

  temp0 := 2.0 * (qw * qy - qx * qz);
  if (temp0 > 1.0) then begin
    temp0 := 1.0;
  end else if (temp0 < -1.0) then begin
    temp0 := -1.0;
  end;
  pitch := ArcSin(temp0);

  temp0 := 2.0 * (qw * qz + qx * qy);
  temp1 := 1.0 - 2.0 * (qy * qy + qz * qz);
  yaw := ArcTan2(temp0, temp1);

  // convert to degrees and normalize the angles
  roll := normalize_angle(RadToDeg(roll));
  pitch := normalize_angle(RadToDeg(pitch));
  yaw := normalize_angle(RadToDeg(yaw));
end;


// takes a quaternion and converts it to an euler angle
// inputs (qw, qx, qy, qz): quaternion
// outputs [ref]: euler angles
//
// adapted from https://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToEuler/index.htm
procedure quaternion_to_euler2(qw, qx, qy, qz: double; var heading, attitude, bank: double);
var
  sqw, sqx, sqy, sqz, correction_factor, singularity_test: double;
begin
  // declare some squares
  sqw := qw * qw; sqx := qx * qx; sqy := qy * qy; sqz := qz * qz;
  // if quaternion is normalized, this is 1; otherwise serves as a correction factor
  correction_factor := sqw + sqx + sqy + sqz;
  singularity_test := qx * qy + qz * qw;

  if (singularity_test > 0.499 * correction_factor) then begin
    // singularity at north pole
    heading := 2.0 * ArcTan2(qx, qw);
    attitude := Pi * 0.5;
    bank := 0.0;
  end
  else if (singularity_test < -0.499 * correction_factor) then begin
    // singularity at south pole
    heading := -2.0 * ArcTan2(qx, qw);
    attitude := Pi * -0.5;
    bank := 0;
  end
  else
    heading := ArcTan2(2.0 * qy * qw - 2.0 * qx * qy, sqx - sqy - sqz + sqw);
    attitude := ArcSin(2.0 * singularity_test / correction_factor);
    bank := ArcTan2(2.0 * qx * qw - 2.0 * qy * qz, -1.0 * sqx + sqy - sqz + sqw);
  end;

  // convert to degrees and normalize the angles
  heading := normalize_angle(RadToDeg(heading));
  attitude := normalize_angle(RadToDeg(attitude));
  bank := normalize_angle(RadToDeg(bank));
end;


// takes a quaternion and converts it to an euler angle
// inputs (qw, qx, qy, qz): quaternion
// outputs [ref]: euler angles
//
// implementation of https://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToEuler/Quaternions.pdf
procedure quaternion_to_euler3(qw, qx, qy, qz: double; rotation_sequence: integer; var theta1, theta2, theta3: double);
var
  p0, p1, p2, p3: double;
  rotation_modifier: integer; // TODO figure out a better variable name, but not simply 'e'
begin
  // set up variables based on which order the rotations will be applied in
  p0 := qw;
  case (rotation_sequence) of
    ROTATION_SEQUENCE_XYZ: begin p1 := qx; p2 := qy; p3 := qz; end;
    ROTATION_SEQUENCE_XZY: begin p1 := qx; p2 := qz; p3 := qy; end;
    ROTATION_SEQUENCE_YXZ: begin p1 := qy; p2 := qx; p3 := qz; end;
    ROTATION_SEQUENCE_YZX: begin p1 := qy; p2 := qz; p3 := qx; end;
    ROTATION_SEQUENCE_ZXY: begin p1 := qz; p2 := qx; p3 := qy; end;
    ROTATION_SEQUENCE_ZYX: begin p1 := qz; p2 := qy; p3 := qx; end;
  else
    raise Exception.Create('unknown rotation sequence ''' + IntToStr(rotation_sequence) + '''');
  end;

  case (rotation_sequence) of
    ROTATION_SEQUENCE_XYZ, ROTATION_SEQUENCE_YZX, ROTATION_SEQUENCE_ZXY: rotation_modifier := -1.0;
    ROTATION_SEQUENCE_ZYX, ROTATION_SEQUENCE_XZY, ROTATION_SEQUENCE_YXZ: rotation_modifier := 1.0;
  end;

  theta2 := 2.0 * (p0 * p2 + rotation_modifier * p1 * p3);
  // singularity if theta2 = ±1.0
  // TODO convert this to use floating point compare value function
  if (Abs(theta2) > 0.9999) then begin
    theta1 := ArcTan2(p1, p0);
    theta3 := 0.0;
  end
  else begin
    theta1 := ArcTan2(
      2.0 * (p0 * p1 - rotation_modifier * p2 * p3),
      1.0 - 2.0 * (p1 * p1 + p2 * p2)
    );
    theta3 := ArcTan2(
      2.0 * (p0 * p3 - rotation_modifier * p1 * p2),
      1.0 - 2.0 * (p2 * p2 + p3 * p3)
    );
  end;
  theta2 := ArcSin(theta2);

  // convert to degrees and normalize the angles
  theta1 := normalize_angle(RadToDeg(theta1));
  theta2 := normalize_angle(RadToDeg(theta2));
  theta3 := normalize_angle(RadToDeg(theta3));
end;


// check whether an index for accessing the global array 'q' is valid
// input: quaternion index
procedure check_q_index(i: integer);
begin
  if (i < Low(q)) or (i > High(q)) then
    raise Exception.Create('global "q" array index "' + IntToStr(i) + '" out of bounds');
end;


// check whether an index for accessing the global array 'v' is valid
// input: vector index
procedure check_v_index(i: integer);
begin
  if (i < Low(v)) or (i > High(v)) then
    raise Exception.Create('global "v" array index "' + IntToStr(i) + '" out of bounds');
end;


// TODO decide whether to flesh out this procedure or not
// procedure check_rotation_sequence(rotation_sequence: integer);
// begin
//   if ()
// end;


// copy quaternion from one location to another
// input: quaternion [address]
// output [ref]: quaternion [address]
procedure quaternion_copy(q_from, q_to: integer);
begin
  check_q_index(q_from);
  check_q_index(q_to);

  if (q_from = q_to) then
    // copying not needed
    exit;

  q[q_to].w := q[q_from].w;
  q[q_to].x := q[q_from].x;
  q[q_to].y := q[q_from].y;
  q[q_to].z := q[q_from].z;
end;


// copy a vector from one location to another
// input: vector [address]
// output [ref]: vector [address]
procedure vector_copy(v_from, v_to: integer);
begin
  check_v_index(v_from);
  check_v_index(v_to);

  if (v_from = v_to) then
    // copying not needed
    exit;

  v[v_to].x := v[v_from].x;
  v[v_to].y := v[v_from].y;
  v[v_to].z := v[v_from].z;
end;


// get the conjugate (inverse) of a quaternion
// input type: quaternion [address]
// output type: quaternion [address]
procedure quaternion_conjugate(q_1, q_out: integer);
begin
  check_q_index(q_1);
  check_q_index(q_out);

  q[q_out].w := q[q_1].w;
  q[q_out].x := q[q_1].x * -1.0;
  q[q_out].y := q[q_1].y * -1.0;
  q[q_out].z := q[q_1].z * -1.0;
end;


// get the inverse of a quaternion (alias for quaternion_conjugate)
// input type: quaternion [address]
// output type: quaternion [address]
procedure quaternion_inverse(q_1, q_out: integer);
begin
  quaternion_conjugate(q_1, q_out);
end;


// multiply two quaternions together and store the result
// input type: quaternions [addresses]
// output type: quaternion [address]
procedure quaternion_multiply(q_1, q_2, q_out: integer);
var
  q_temp: quaternion;
begin
  check_q_index(q_1);
  check_q_index(q_2);
  check_q_index(q_out);

  // w = w1*w2 - x1*x2 - y1*y2 - z1*z2
  // x = w1*x2 + x1*w2 + y1*z2 - z1*y2
  // y = w1*y2 - x1*z2 + y1*w2 + z1*x2
  // z = w1*z2 + x1*y2 - y1*x2 + z1*w2
  q_temp.w := q[q_1].w * q[q_2].w - q[q_1].x * q[q_2].x - q[q_1].y * q[q_2].y - q[q_1].z * q[q_2].z;
  q_temp.x := q[q_1].w * q[q_2].x + q[q_1].x * q[q_2].w + q[q_1].y * q[q_2].z - q[q_1].z * q[q_2].y;
  q_temp.y := q[q_1].w * q[q_2].y - q[q_1].x * q[q_2].z + q[q_1].y * q[q_2].w + q[q_1].z * q[q_2].x;
  q_temp.z := q[q_1].w * q[q_2].z + q[q_1].x * q[q_2].y - q[q_1].y * q[q_2].x + q[q_1].z * q[q_2].w;

  q[q_out].w := q_temp.w;
  q[q_out].x := q_temp.x;
  q[q_out].y := q_temp.y;
  q[q_out].z := q_temp.z;
end;


// multiply a quaternion and a vector
// input type: quaternion [address], vector [address]
// output type: vector [address]
procedure quaternion_vector_multiply(q_1, v_1, v_out: integer);
var
  q_temp, q_temp2: quaternion;
begin
  check_q_index(q_1);
  check_v_index(v_1);
  check_v_index(v_out);

  // copy quaternions that will be overwritten for calculations
  q_temp.w := q[0].w;
  q_temp.x := q[0].x;
  q_temp.y := q[0].y;
  q_temp.z := q[0].z;
  q_temp2.w := q[1].w;
  q_temp2.x := q[1].x;
  q_temp2.y := q[1].y;
  q_temp2.z := q[1].z;

  // copy input quaternion to its temporary location
  quaternion_copy(q_1, 0);

  // convert input vector to a quaternion
  q[1].w := 0.0;
  q[1].x := v[v_1].x;
  q[1].y := v[v_1].y;
  q[1].z := v[v_1].z;

  // do the quaternion-vector multiplication
  quaternion_multiply(0, 1, High(q));
  quaternion_conjugate(0, 1);
  quaternion_copy(High(q), 0);
  quaternion_multiply(0, 1, High(q));
  debug_print('debug: quaternion_vector_multiply result:');
  debug_quaternion_display(High(q),High(q));

  // copy the resultant x,y,z to the return vector
  v[v_out].x := q[High(q)].x;
  v[v_out].y := q[High(q)].y;
  v[v_out].z := q[High(q)].z;

  // restore saved quaternions
  q[0].w := q_temp.w;
  q[0].x := q_temp.x;
  q[0].y := q_temp.y;
  q[0].z := q_temp.z;
  q[1].w := q_temp2.w;
  q[1].x := q_temp2.x;
  q[1].y := q_temp2.y;
  q[1].z := q_temp2.z;
end;


// print a quaternion
// input quaternions [addresses]
procedure quaternion_display(start, stop: integer);
var
  i: integer;
begin
  check_q_index(start);
  check_q_index(stop);

  for i := start to stop do begin
    AddMessage('q' + IntToStr(i) + ': [w: ' + prt_float(q[i].w) + ', x:' + prt_float(q[i].x) + ', y:' + prt_float(q[i].y) + ', z:' + prt_float(q[i].z) + ']');
  end;
end;


// print all quaternions
procedure quaternion_display_all();
begin
  quaternion_display(Low(q), High(q));
end;


// print a quaternion if debug flag is set
procedure debug_quaternion_display(start, stop: integer);
begin
  if DEBUG then quaternion_display(start, stop);
end;


// print a vector
// input: vectors [addresses]
procedure vector_display(start, stop: integer);
var
  i: integer;
begin
  check_v_index(start);
  check_v_index(stop);

  for i := start to stop do begin
    AddMessage('v' + IntToStr(i) + ': [x:' + prt_float(v[i].x) + ', y:' + prt_float(v[i].y) + ', z:' + prt_float(v[i].z) + ']');
  end;
end;


// print all vectors
procedure vector_display_all();
begin
  vector_display(Low(v), High(v));
end;


// print a vector if debug flag is set
procedure debug_vector_display(start, stop: integer);
begin
  if DEBUG then vector_display(start, stop);
end;


// return a float to 16 digit precision as a string
// input: float
// output: string
function prt_float(d: double): string;
begin
  Result := FloatToStrF(d, 2, 9999, 16);
end;


// function Initialize(): integer;
// begin
// end;


function Process(e: IInterface): integer;
var
  x, y, z, to_rotate_x, to_rotate_y, to_rotate_z: double;
  e2: IInterface;
begin
  // do stuff
  if Signature(e) <> 'REFR' then exit;

  to_rotate_x := 90.0; to_rotate_y := 0.0; to_rotate_z := 90.0;

  AddMessage(FullPath(e));

  // NAME - Base entries that should be ignored
  //  IS "OutpostGroupPackinDummy" [STAT:00015804]
  //  IS "PrefabPackinPivotDummy" [STAT:0003F808]
  //  STARTS WITH "SMOD_Snap" -> make this a string to be asked for?
  AddMessage(
    'Starting Position'
    + ': X = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\X')
    + ', Y = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\Y')
    + ', Z = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\Z')
  );
  rotate_position(
    // input
    GetElementNativeValues(e, 'DATA - Position/Rotation\Position\X'),
    GetElementNativeValues(e, 'DATA - Position/Rotation\Position\Y'),
    GetElementNativeValues(e, 'DATA - Position/Rotation\Position\Z'),
    // rotation
    to_rotate_x, to_rotate_y, to_rotate_z,
    // rotation sequence
    ROTATION_SEQUENCE_DEFAULT,
    // rotation direction
    ROTATION_DIRECTION_DEFAULT,
    // output
    x, y, z
  );
  debug_print('rotate_position returned values: X = ' + prt_float(x) + ', Y = ' + prt_float(y) + ', Z = ' + prt_float(z));

  if not DRY_RUN then begin
    SetElementNativeValues(e, 'DATA - Position/Rotation\Position\X', x);
    SetElementNativeValues(e, 'DATA - Position/Rotation\Position\Y', y);
    SetElementNativeValues(e, 'DATA - Position/Rotation\Position\Z', z);
    AddMessage(
      'Ending Position'
      + ': X = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\X')
      + ', Y = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\Y')
      + ', Z = ' + GetElementEditValues(e,'DATA - Position/Rotation\Position\Z')
    );
  end
  else begin
    AddMessage(
      'DRY RUN: Ending Position'
      + ': X = ' + prt_float(x)
      + ', Y = ' + prt_float(y)
      + ', Z = ' + prt_float(z)
    );
  end;

  AddMessage(
    'Starting Rotation'
    + ': X = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\X')
    + ', Y = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\Y')
    + ', Z = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\Z')
  );
  rotate_rotation(
    // input
    GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\X'),
    GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Y'),
    GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Z'),
    // rotation
    to_rotate_x, to_rotate_y, to_rotate_z,
    // rotation sequence
    ROTATION_SEQUENCE_DEFAULT,
    // rotation direction
    ROTATION_DIRECTION_DEFAULT,
    // output
    x, y, z
  );
  debug_print('rotate_rotation returned values: X = ' + prt_float(x) + ', Y = ' + prt_float(y) + ', Z = ' + prt_float(z));

  if not DRY_RUN then begin
    SetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\X', x);
    SetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Y', y);
    SetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Z', z);
    AddMessage(
      'Ending Rotation'
      + ': X = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\X')
      + ', Y = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\Y')
      + ', Z = ' + GetElementEditValues(e, 'DATA - Position/Rotation\Rotation\Z')
    );
  end
  else begin
    AddMessage(
      'DRY RUN: Ending Rotation'
      + ': X = ' + prt_float(x)
      + ', Y = ' + prt_float(y)
      + ', Z = ' + prt_float(z)
    );
  end;

end;

// function Finalize(): integer;
// begin
// end;

end.
