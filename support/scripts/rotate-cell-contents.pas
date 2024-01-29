{
  TODO: add option to clamp to a multiple of 90 degrees
  TODO: add rounding to nearest 0.000001 degree
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
  DEBUG = False;
  DRY_RUN = False;

  ORDER_XYZ = 1;
  ORDER_XZY = 2;
  ORDER_YXZ = 3;
  ORDER_YZX = 4;
  ORDER_ZXY = 5;
  ORDER_ZYX = 6;
  ORDER_ALL = 7;
  ORDER_DEFAULT = ORDER_ZYX;

var
  q: array[0..9] of quaternion;
  v: array[0..9] of vector;


procedure debug_print(message: string);
begin
  if DEBUG then AddMessage(message);
end;


procedure apply_rotation_global(x, y, z, rx, ry, rz: double; order: integer; var return_x, return_y, return_z: double);
var
  qx, qy, qz, qw: double;
begin
  // clamp euler angles [0, 360)
  rx := ((rx mod 360.0) + 360.0) mod 360.0;
  ry := ((ry mod 360.0) + 360.0) mod 360.0;
  rz := ((rz mod 360.0) + 360.0) mod 360.0;
  debug_print('debug: modulo rotations');
  debug_print('debug: rx: ' + prt_float(rx) + ', ry: ' + prt_float(ry) + ', rz: ' + prt_float(rz));

  rx := degrees_to_radians(rx);
  ry := degrees_to_radians(ry);
  rz := degrees_to_radians(rz);
  debug_print('debug: radians');
  debug_print('debug: rx: ' + prt_float(rx) + ', ry: ' + prt_float(ry) + ', rz: ' + prt_float(rz));

  euler_to_quaternion(rx, ry, rz, qw, qx, qy, qz);
  q[0].w := qw; q[0].x := qx; q[0].y := qy; q[0].z := qz;
  AddMessage('debug: base quaternion');
  quaternion_display(0,0);

  v[0].x := x; v[0].y := y; v[0].z := z;
  AddMessage('debug: start point');
  vector_display(0,0);

  quaternion_vector_multiply(0, 0, High(v));
  AddMessage('debug: result point');
  vector_display(High(v),High(v));

  return_x := v[High(v)].x; return_y := v[High(v)].y; return_z := v[High(v)].z;
end;


// x, y, z: point
// rx, ry, rz: rotation in degrees
// return_x, return_y, return_z: point
procedure rotate_position(x, y, z, rx, ry, rz: double{; order: integer}; var return_x, return_y, return_z: double);
var
  qx, qy, qz, qw: double;
  idx: integer;
  temp_x, temp_y, temp_z: double;
begin
  // clamp euler angles [0, 360)
  rx := normalize_angle(rx);
  ry := normalize_angle(ry);
  rz := normalize_angle(rz);
  debug_print('debug: normalized angles');
  debug_print('debug: rx: ' + prt_float(rx) + ', ry: ' + prt_float(ry) + ', rz: ' + prt_float(rz));

  // convert degrees to radians
  rx := degrees_to_radians(rx);
  ry := degrees_to_radians(ry);
  rz := degrees_to_radians(rz);
  debug_print('debug: radians');
  debug_print('debug: rx: ' + prt_float(rx) + ', ry: ' + prt_float(ry) + ', rz: ' + prt_float(rz));

  euler_to_quaternion(rx, ry, rz, qw, qx, qy, qz);
  idx := 0; q[idx].w := qw; q[idx].x := qx; q[idx].y := qy; q[idx].z := qz;
  debug_print('debug: base quaternion');
  debug_quaternion_display(0,0);

  idx := 0; v[idx].x := x; v[idx].y := y; v[idx].z := z;
  debug_print('debug: start point');
  debug_vector_display(0,0);


  // turn z component into quaternion
  euler_to_quaternion(0.0, 0.0, -1.0 * rz, qw, qx, qy, qz);
  idx := 0; q[idx].w := qw; q[idx].x := qx; q[idx].y := qy; q[idx].z := qz;
  debug_quaternion_display(0,0);
  // apply z quaternion to start point
  quaternion_vector_multiply(0, 0, High(v));
  vector_copy(High(v), 0);
  debug_vector_display(0,0);
  // turn y component into quaternion
  euler_to_quaternion(0.0, -1.0 * ry, 0.0, qw, qx, qy, qz);
  idx := 0; q[idx].w := qw; q[idx].x := qx; q[idx].y := qy; q[idx].z := qz;
  debug_quaternion_display(0,0);
  // apply y quaternion to start point + z quaternion
  quaternion_vector_multiply(0, 0, High(v));
  vector_copy(High(v), 0);
  debug_vector_display(0,0);
  // turn x component into quaternion
  euler_to_quaternion(-1.0 * rx, 0.0, 0.0, qw, qx, qy, qz);
  idx := 0; q[idx].w := qw; q[idx].x := qx; q[idx].y := qy; q[idx].z := qz;
  debug_quaternion_display(0,0);
  // apply x quaternion to start point + y quaternion + z quaternion
  quaternion_vector_multiply(0, 0, High(v));
  vector_copy(High(v), 0);
  debug_vector_display(0,0);


  // how to handle start points that are not 0,0,0?
  //   is it even necessary?
  //   undo x then y then z rotations?


  // quaternion_vector_multiply(0, 0, High(v));
  debug_print('debug: result point');
  debug_vector_display(High(v),High(v));

  idx := High(v); return_x := v[idx].x; return_y := v[idx].y; return_z := v[idx].z;
end;


// x, y, z: rotation in degrees
// rx, ry, rz: rotation in degrees
// return_x, return_y, return_z: rotation in degrees
procedure rotate_rotation(x, y, z, rx, ry, rz: double{; order: integer}; var return_x, return_y, return_z: double);
var
  qw, qx, qy, qz: double;
  idx: integer;
begin
  // clamp euler angles [0, 360)
  rx := normalize_angle(rx);
  ry := normalize_angle(ry);
  rz := normalize_angle(rz);
  debug_print('debug: normalized angles');
  debug_print('debug: rx: ' + prt_float(rx) + ', ry: ' + prt_float(ry) + ', rz: ' + prt_float(rz));

  // convert degrees to radians
  rx := degrees_to_radians(rx);
  ry := degrees_to_radians(ry);
  rz := degrees_to_radians(rz);
  debug_print('debug: radians');
  debug_print('debug: rx: ' + prt_float(rx) + ', ry: ' + prt_float(ry) + ', rz: ' + prt_float(rz));

  euler_to_quaternion(x, y, z, qw, qx, qy, qz);
  idx := 0; q[idx].w := qw; q[idx].x := qx; q[idx].y := qy; q[idx].z := qz;
  debug_print('debug: rotation quaternion');
  debug_quaternion_display(0,0);

  euler_to_quaternion(rx, ry, rz, qw, qx, qy, qz);
  idx := 1; q[idx].w := qw; q[idx].x := qx; q[idx].y := qy; q[idx].z := qz;
  debug_print('debug: quaternion rotation to apply');
  debug_quaternion_display(1,1);

  quaternion_multiply(0, 1, High(q));
  quaternion_to_euler(
    // input
    q[High(q)].w,
    q[High(q)].x,
    q[High(q)].y,
    q[High(q)].z,
    // output
    return_x,
    return_y,
    return_z
  );

  return_x := normalize_angle(radians_to_degrees(return_x));
  return_y := normalize_angle(radians_to_degrees(return_y));
  return_z := normalize_angle(radians_to_degrees(return_z));
end;


// normalize an angle to [0, 360)
function normalize_angle(angle: double): double;
var
  normalizer: double;
begin
  normalizer := 360.0;
  Result := FMod(FMod(angle, normalizer) + normalizer, normalizer);
end;


// convert degrees to radians
function degrees_to_radians(degrees: double): double;
begin
  Result := degrees * (Pi / 180.0);
end;


// convert radians to degrees
function radians_to_degrees(radians: double): double;
begin
  Result := radians * (180.0 / Pi);
end;


// takes an euler angle and converts it to a quaternion
// inputs (roll, pitch, yaw) in radians
// outputs [ref]: quaternion components
procedure euler_to_quaternion(roll, pitch, yaw: double; var qw, qx, qy, qz: double);
var
  c1, c2, c3, s1, s2, s3: double;
begin
  // calculate some intermediate values to reduce total number of calculations done
  c1 := Cos(roll / 2.0);
  c2 := Cos(pitch / 2.0);
  c3 := Cos(yaw / 2.0);
  s1 := Sin(roll / 2.0);
  s2 := Sin(pitch / 2.0);
  s3 := Sin(yaw / 2.0);

  // calculate the actual quaternion
  qw := c1 * c2 * c3 + s1 * s2 * s3;
  qx := s1 * c2 * c3 - c1 * s2 * s3;
  qy := c1 * s2 * c3 + s1 * c2 * s3;
  qz := c1 * c2 * s3 - s1 * s2 * c3;
end;


// takes a quaternion and converts it to an euler angle
// inputs (qw, qx, qy, qz): quaternion
// outputs [ref]: euler angles
procedure quaternion_to_euler(qw, qx, qy, qz: double; var roll, pitch, yaw: double);
var
  temp0,temp1: double;
begin
  temp0 := 2.0 * (qw * qx + qy * qz);
  temp1 := 1.0 - 2.0 * (qx * qx + qy * qy);
  roll := ArcTan2(temp0, temp1);

  temp0 := 2.0 * (qw * qy - qz * qx);
  if (temp0 > 1.0) then begin
    temp0 := 1.0;
  end else if (temp0 < -1.0) then begin
    temp0 := -1.0;
  end;
  pitch := ArcSin(temp0);

  temp0 := 2.0 * (qw * qz + qx * qy);
  temp1 := 1.0 - 2.0 * (qy * qy + qz * qz);
  yaw := ArcTan2(temp0, temp1);
end;


// return whether a quaternion address is in bounds
// input: quaternion address
// output: boolean
function q_in_bounds(i: integer): boolean;
begin
  Result := (i >= Low(q)) and (i <= High(q));
end;


// return whether a quaternion address is out of bounds
// input: quaternion address
// output: boolean
function q_out_of_bounds(i: integer): boolean;
begin
  Result := not q_in_bounds(i);
end;


// return whether a vector address is in bounds
// input: vector address
// output: boolean
function v_in_bounds(i: integer): boolean;
begin
  Result := (i >= Low(v)) and (i <= High(v));
end;


// return whether a vector address is out of bounds
// input: vector address
// output: boolean
function v_out_of_bounds(i: integer): boolean;
begin
  Result := not v_in_bounds(i);
end;


// copy quaternion from one location to another
// input: quaternion [address]
// output [ref]: quaternion [address]
procedure quaternion_copy(q_from, q_to: integer);
begin
  if q_out_of_bounds(q_from) or q_out_of_bounds(q_to) then
    raise Exception.Create('array index out of bounds');
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
  if v_out_of_bounds(v_from) or v_out_of_bounds(v_to) then
    raise Exception.Create('array index out of bounds');
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
  if q_out_of_bounds(q_1) or q_out_of_bounds(q_out) then
    raise Exception.Create('array index out of bounds');

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
  if q_out_of_bounds(q_1) or q_out_of_bounds(q_2) or q_out_of_bounds(q_out) then
    raise Exception.Create('array index out of bounds');

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
  if q_out_of_bounds(q_1) or v_out_of_bounds(v_1) or v_out_of_bounds(v_out) then
    raise Exception.Create('array index out of bounds');

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


// normalize a vector
// input type: vector [address]
// output type: vector [address]
procedure vector_normalize(v_1: integer; v_out: integer);
var
  i: integer;
  mag1, mag2: double;
const
  TOLERANCE = 0.00001;
begin
  if v_out_of_bounds(v_1) or v_out_of_bounds(v_out) then
    raise Exception.Create('array index out of bounds');

  v[v_out].x := v[v_1].x;
  v[v_out].y := v[v_1].y;
  v[v_out].z := v[v_1].z;
  mag2 := v[v_1].x * v[v_1].x + v[v_1].y * v[v_1].y + v[v_1].z * v[v_1].z;
  if (Abs(mag2 - 1.0) > TOLERANCE) then begin
    mag = Sqrt(mag2);
    v[v_out].x := v[v_out].x / mag;
    v[v_out].y := v[v_out].y / mag;
    v[v_out].z := v[v_out].z / mag;
  end
end;


// normalize and then convert an axis-angle to a quaternion
// input: vector [address], angle
// output: quaternion [address]
procedure axis_angle_to_quaternion(v_in: integer; theta: double; q_out: integer);
begin
  if v_out_of_bounds(v_in) or q_out_of_bounds(q_out) then
    raise Exception.Create('array index out of bounds');

  vector_normalize(v_in, v_in);
  theta := theta / 2.0;
  q[q_out].w := cos(theta);
  q[q_out].x := v[v_in].x * sin(theta);
  q[q_out].y := v[v_in].y * sin(theta);
  q[q_out].z := v[v_in].z * sin(theta);
end;


// convert a quaternion to a normalized axis-angle
// input: quaternion [address]
// output: angle, vector [address]
procedure quaternion_to_axis_angle(q_in: integer; var theta: double; v_out: integer);
begin
  if q_out_of_bounds(q_in) or v_out_of_bounds(v_out) then
    raise Exception.Create('array index out of bounds');

  theta := acos(q[q_in].w) * 2.0;
  v[v_out].x := q[q_in].x;
  v[v_out].y := q[q_in].y;
  v[v_out].z := q[q_in].z;
  vector_normalize(v_out, v_out);
end;


// print a quaternion
// input quaternions [addresses]
procedure quaternion_display(start, stop: integer);
var
  i: integer;
begin
  if q_out_of_bounds(start) or q_out_of_bounds(stop) then
    raise Exception.Create('array index out of bounds');

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
  if v_out_of_bounds(start) or v_out_of_bounds(stop) then
    raise Exception.Create('array index out of bounds');

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


function quaternion_example(): integer;
var
  x, y, z: double;
begin
  // test sequence as implemented here:
  // https://stackoverflow.com/questions/4870393/rotating-coordinate-system-via-a-quaternion
  v[0].x := 1; v[0].y := 0; v[0].z := 0;
  v[1].x := 0; v[1].y := 1; v[1].z := 0;
  v[2].x := 0; v[2].y := 0; v[2].z := 1;
  vector_display(0,2);

  axis_angle_to_quaternion(0, Pi / 2.0, 0);
  axis_angle_to_quaternion(1, Pi / 2.0, 1);
  axis_angle_to_quaternion(2, Pi / 2.0, 2);
  quaternion_display(0,2);

  AddMessage('part 1');
  quaternion_vector_multiply(0, 1, 3);
  quaternion_display(0,2);
  vector_display(0,3);

  AddMessage('part 2');
  quaternion_vector_multiply(1, 3, 3);
  quaternion_display(0,2);
  vector_display(0,3);

  AddMessage('part 3');
  quaternion_vector_multiply(2, 3, 3);
  quaternion_display(0,2);
  vector_display(0,3);
end;


function Initialize(): integer;
var
  x,y,z:double;
begin
  // rotate_position(
  //   // point
  //   0.0, 0.0, 1.0,
  //   // rotation
  //   90.0, 0.0, 90.0,
  //   // rotated point
  //   x, y, z
  // );
  // AddMessage('point: (x: ' + prt_float(x) + ', y: ' + prt_float(y) + ', z: ' + prt_float(z) + ')');

  // apply_rotation(
  //   0.0, 90.0, 0,
  //   90.0, 0.0, 90.0,
  //   x, y, z
  // );
  // AddMessage('rotation: (x: ' + prt_float(x) + ', y: ' + prt_float(y) + ', z: ' + prt_float(z) + ')');
end;


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
    // output
    x, y, z
  );

  debug_print('returned values: X = ' + prt_float(x) + ', Y = ' + prt_float(y) + ', Z = ' + prt_float(z));

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

  // check if rotation is 0,0,0, and if so, just apply the given rotation
  // if (GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\X') = 0.0) and
  //     (GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Y') = 0.0) and
  //     (GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Z') = 0.0) then begin
  //   x := to_rotate_x; y := to_rotate_y; z := to_rotate_z;
  // end
  // else begin
    rotate_rotation(
      // input
      degrees_to_radians(GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\X')),
      degrees_to_radians(GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Y')),
      degrees_to_radians(GetElementNativeValues(e, 'DATA - Position/Rotation\Rotation\Z')),
      // rotation
      to_rotate_x, to_rotate_y, to_rotate_z,
      // output
      x, y, z
    );
  // end;

  debug_print('returned values: X = ' + prt_float(x) + ', Y = ' + prt_float(y) + ', Z = ' + prt_float(z));

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

function Finalize(): integer;
var
  to_normalize: double;
begin
  to_normalize := -44.9999999998;
  // AddMessage(prt_float(to_normalize) + ' degrees normalized: ' + prt_float(normalize_angle(to_normalize)));
end;

end.
