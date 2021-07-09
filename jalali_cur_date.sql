CREATE FUNCTION `get_cur_date`()
    RETURNS CHAR(8) CHARACTER SET latin1
    DETERMINISTIC    
    SQL SECURITY DEFINER
BEGIN
  set @y := DATE_FORMAT(CURDATE(),'%Y%m%d');
  RETURN gregorian2Jalali(@y);
END;
