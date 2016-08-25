Select c.iucr_code_cd as IUCR, count(distinct a.case_id)
from incident_statuses a,
inv_iucr_codes c,
chris.cases d
where d.occurrence_date_from>=to_date('25-NOV-99:00:00', 'dd-mon-yy:hh24:mi') and
d.occurrence_date_from<=to_date('24-DEC-99:23:59', 'dd-mon-yy:hh24:mi')
and c.iucr_code_cd in ('041A', '041B') and
a.incident_status_code_id <> 78 and
a.id=(select max(b.id)
from incident_statuses b
where b.incident_status_code_id>0
and b.case_id=a.case_id)
and a.case_id=c.case_id
and a.case_id=d.id
group by c.iucr_code_cd
/
