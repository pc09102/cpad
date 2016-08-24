select * from s911_events
where beat_of_occurence='932' AND OCCURENCE_STREET_NAME LIKE 'HERM%'
and call_completed_date>=to_date('01-MAR-2000:00:00', 'DD-MON-YYYY:HH24:MI') AND
	call_completed_date<=to_date('20-MAR-2000:23:59', 'DD-MON-YYYY:HH24:MI')
/* developed by Charles Padgurskis */