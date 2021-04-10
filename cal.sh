IFS=$(echo -en "\n\b")

NOW=$((`echo "SELECT strftime('%s','now');" | sqlite3 ` - 978307200))
END=$((`echo "SELECT strftime('%s','now','+1 days', 'start of day');" | sqlite3` - 978307200))

for REZ in $(echo "select summary, description, start_date, end_date from CalendarItem where start_date > $NOW and start_date < $END;" | sqlite3 /private/var/mobile/Library/Calendar/Calendar.sqlitedb)
do
	TITLE=`echo $REZ | cut -f1 -d "|"`
	DESC=`echo $REZ | cut -f2 -d "|"`
	START=`echo $REZ | cut -f3 -d "|"`
	FIN=`echo $REZ | cut -f4 -d "|"`
	DUR=$((`echo $FIN|cut -f1 -d"."` - `echo $START|cut -f1 -d"."`))
	START1=$((`echo $START|cut -f1 -d"."` + 978307200))
	START=`echo "SELECT datetime($START1, 'unixepoch', 'localtime'); " | sqlite3`

	echo "Title: $TITLE"
	echo "Description: $DESC"
	echo "Start: $START"

	DUR1=$(($DUR / 3600))

	echo "Duration: $DUR1 hrs"
	echo "Launching sleeper shell"

	./sleeper.sh $START1 $DUR &
done
