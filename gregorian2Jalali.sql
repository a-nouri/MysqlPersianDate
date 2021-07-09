CREATE FUNCTION `gregorian2Jalali`(
        `as_dt` VARCHAR(10)
    )
    RETURNS VARCHAR(10) CHARACTER SET latin1
    DETERMINISTIC
    SQL SECURITY DEFINER
    COMMENT ''
begin
  DECLARE gy2 INT;
  DECLARE days INT;
  DECLARE gy INT;
  DECLARE gm INT;
  DECLARE gd INT;
  DECLARE jy INT;
  DECLARE jm INT;
  DECLARE jd INT;
  DECLARE gdm INT;
  DECLARE g_d_m varchar(42);  
  set g_d_m := '0,31,59,90,120,151,181,212,243,273,304,334';
  if (length(as_dt) = 10) then
    set gy := left(as_dt,4);
    set gm := substr(as_dt,6,2);
    set gd := right(as_dt,2);
  elseif (length(as_dt) = 8) and (locate('/',as_dt) <> 0) then
    set gy := 1400 + left(as_dt,2);
    set gm := substr(as_dt,4,2);
    set gd := right(as_dt,2);
  elseif (length(as_dt) = 8) then
    set gy := left(as_dt,4);
    set gm := substr(as_dt,5,2);
    set gd := right(as_dt,2);
  elseif (length(as_dt) = 6) then
    set gy := 1400 + left(as_dt,2);
    set gm := substr(as_dt,3,2);
    set gd := right(as_dt,2);
  end if;
  If gm > 2 Then
    set gy2 := (gy + 1);
  Else
    set gy2 := gy;
  END IF;
  set gdm := substring_index(substring_index(g_d_m, ',', gm), ',', -1);
  set days := 355666 + (365 * gy) + ((gy2 + 3) Div 4) - ((gy2 + 99) Div 100);
  set days := days + ((gy2 + 399) Div 400) + gd + gdm;
  set jy := -1595 + (33 * (days Div 12053));
  set days := days Mod 12053;
  set jy := jy + (4 * (days Div 1461));
  set days := days Mod 1461;
  If days > 365 Then
    set jy := jy + ((days - 1) Div 365);
    set days := (days - 1) Mod 365;
  end if;
  If days < 186 Then
    set jm := 1 + (days Div 31);
    set jd := 1 + (days Mod 31); 
  Else
    set jm := 7 + ((days - 186) Div 30);
    set jd := 1 + ((days - 186) Mod 30);
  end if;
  Return  concat(jy,right(concat('0',jm),2),right(concat('0',jd),2));
End;
