/* Created by Charles Padgurskis */
drop table temp_ao;
create table temp_ao as
select
a.id as as_id,
a.arrest_id,
a.cpd_employee_id,
a.employee_role_cd,
b.arrest_date,
b.arr_beat,
b.arresting_beat,
b.ir_no,
b.cb_no,
b.last_nme as o_last,
b.first_nme as o_first,
b.street_no,
b.street_direction_cd,
b.street_nme,
b.statute,
b.stat_descr,
b.charge_class_cd,
b.charge_type_cd,
b.iucr_code_cd,
b.primary_class,
b.secondary_class,
b.case_type_cd
from	chris.arrest_statuses@CHRISC.WORLD a,
	arrest_01B b
where (b.ARREST_DATE>(select trunc(max(arrest_date)-1) from arr_officer_b)) and
	a.arrest_id=b.arrest_id and
	a.employee_role_cd in ('FAO','SAO');

drop table temp_ao1;
create table temp_ao1 
pctfree 0 tablespace data3
storage (initial 100m next 5m pctincrease 0)
NOLOGGING as
select
a.as_id,
a.arrest_id,
a.cpd_employee_id,
a.employee_role_cd,
b.user_id,
b.last_nme,
b.first_nme,
b.cpd_unit_id,
c.cpd_unit_no,
c.descr as unit_descr,
a.arrest_date,
a.arr_beat,
a.arresting_beat,
a.ir_no,
a.cb_no,
a.o_last,
a.o_first,
a.street_no,
a.street_direction_cd,
a.street_nme,
a.statute,
a.stat_descr,
a.charge_class_cd,
a.charge_type_cd,
a.iucr_code_cd,
a.primary_class,
a.secondary_class,
a.case_type_cd
from 	temp_ao a,
	CHRIS.cpd_employees@CHRISC.WORLD b,
	CHRIS.cpd_units@CHRISC.WORLD c
where a.cpd_employee_id=b.id and
	b.cpd_unit_id=c.id;
delete from arr_officer_b a
where a.arrest_id in (select b.arrest_id from temp_ao1 b);
INSERT INTO CHRIS_DWH.ARR_OFFICER_B
(as_id,
arrest_id,
cpd_employee_id,
employee_role_cd,
user_id,
last_nme,
first_nme,
cpd_unit_id,
cpd_unit_no,
unit_descr,
arrest_date,
arr_beat,
arresting_beat,
ir_no,
cb_no,
o_last,
o_first,
street_no,
street_direction_cd,
street_nme,
statute,
stat_descr,
charge_class_cd,
charge_type_cd,
iucr_code_cd,
primary_class,
secondary_class,
case_type_cd)
SELECT
as_id,
arrest_id,
cpd_employee_id,
employee_role_cd,
user_id,
last_nme,
first_nme,
cpd_unit_id,
cpd_unit_no,
unit_descr,
arrest_date,
arr_beat,
arresting_beat,
ir_no,
cb_no,
o_last,
o_first,
street_no,
street_direction_cd,
street_nme,
statute,
stat_descr,
charge_class_cd,
charge_type_cd,
iucr_code_cd,
primary_class,
secondary_class,
case_type_cd
FROM TEMP_AO1;
/*
CREATE OR REPLACE VIEW ARR_OFFICER_V AS	
SELECT * FROM ARR_OFFICER_B A
WHERE A.USER_ID IN 
	(SELECT B.USER_ID 
	FROM ARR_OFFICER_B B
	WHERE B.USER_ID=USER);
GRANT SELECT ON ARR_OFFICER_V TO PUBLIC;
CREATE OR REPLACE VIEW ARR_SUPV_V AS	
SELECT A.*
FROM ARR_OFFICER_B A
WHERE (A.CPD_UNIT_NO IN
	 	(SELECT PERS_UNIT_ASSGD_CD
		FROM PERS_VI
		WHERE PERS_USER_ID=USER AND
		PERS_PAY_TITLE_CD>='9171' AND
		PERS_STATUS_CD='A' AND
		PERS_PAY_VACATED_DT IS NULL)) OR
	(A.CPD_UNIT_NO IN
	 	(SELECT PERS_UNIT_DTL_CD
		FROM PERS_VI
		WHERE PERS_USER_ID=USER AND
		PERS_PAY_TITLE_CD>='9171' AND
		PERS_STATUS_CD='A' AND
		PERS_PAY_VACATED_DT IS NULL)) OR
	EXISTS
	(SELECT PERS_PAYGRADE_CD FROM PERS_VI
		WHERE PERS_USER_ID=USER AND
		(PERS_PAYGRADE_CD IN ('E01','E02','E03','E04','E06','E07','E16','P06','P07',
		'P08') OR PERS_USER_ID IN ('PC09102','PC09669','PC09146','DP01020','DP01008')
		 AND
		 PERS_PAY_VACATED_DT IS NULL));
GRANT SELECT ON ARR_SUPV_V TO PUBLIC;
*/


