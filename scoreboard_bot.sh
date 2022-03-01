#/bin/ksh
##Potaje6
##Script to post a link to the scoreboard of each game after it ends
##curl -s "https://server.comunidadhll.es/api/get_scoreboard_maps" | jq '.result .maps[0] | {long_name, id}'


EXEC_DIR=$(dirname $0)
EXEC_NAME=$(basename $0)
#TEMP_DIR=$EXEC_DIR/tmp
SERVER_URL="https://url.to.your.rcon"
SERVER_NAME=Server1
HIST_FILE=$EXEC_DIR/history_${SERVER_NAME}
#TEMP_FILE=$TEMP_DIR/${SERVER_NAME}.tmp
TEMP_FILE=$EXEC_DIR/${SERVER_NAME}.tmp
#Add here the webhook of the discord channel
WEBHOOK=https://discord.com/api/webhooks/HERE_GOES_THE_WEBHOOK
#https://github.com/ChaoticWeg/discord.sh
DISCORD=$EXEC_DIR/discord.sh/discord.sh


print_uso(){
cat <<EOF
        Usage:
        ./$EXEC_NAME [ -u rcon url (something like https://my.cool.rcon.com) -s server name to display in discord ]

EOF
exit
}


#if [ $# -eq 0 ];then
#	print_uso
#fi

while [ $# -gt 0 ];
do
	case $1 in
		-h|--help)     
		print_uso
		;;
		-u) SERVER_URL=$2
		shift
		shift
		;;
		-s) SERVER_NAME=$2
		HIST_FILE=$EXEC_DIR/history_${SERVER_NAME}
		TEMP_FILE=$EXEC_DIR/${SERVER_NAME}.tmp
		shift
		shift
		;;
		*) break
		;;
	esac
done


#Get list of played games
curl -s "$SERVER_URL/api/get_scoreboard_maps" -o $TEMP_FILE
#parse it and get the last game id and map (yes, its ugly as fuck, but it works)
jq -c '.result .maps[] | {map_name, id, just_name, "end"}' $TEMP_FILE | sed 's/{"map_name":"//; s/","id":/ /; s/,"just_name":"/ /; s/","end":"/ /; s/"}//' | while read MAP_ID GAME_ID IMG_ID END_TIME
do
	grep $(echo ${END_TIME} | tr -d \- | tr -d \. | tr -d \:) $HIST_FILE >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		##some images dont match the just_name field, so i spaghuetti coded it. No need to thank me
		case ${IMG_ID} in
			carentan) IMG_ID=carentan
			;;
			foy) IMG_ID=foy
			;;
			hill400) IMG_ID=hill400
			;;
			hurtgenforest) IMG_ID=hurtgen
			;;
			kursk) IMG_ID=kursk
			;;
			omahabeach) IMG_ID=omaha
			;;
			purpleheartlane) IMG_ID=phl
			;;
			stalingrad) IMG_ID=stalingrad
			;;
			stmariedumont) IMG_ID=smdm
			;;
			stmereeglise) IMG_ID=sme
			;;
			utahbeach) IMG_ID=utah
			;;
		*) break
		;;
		esac
		END_TIME_MESSAGE=$(echo $END_TIME | cut -f 1 -d \.)
		$DISCORD --username $SERVER_NAME --webhook-url $WEBHOOK --text "Match in ${MAP_ID} over at ${END_TIME_MESSAGE}UTC\n${SERVER_URL}/#/gamescoreboard/${GAME_ID}" --thumbnail ${SERVER_URL}/maps/${IMG_ID}.webp
		echo ${END_TIME} | tr -d \- | tr -d \. | tr -d \: >> $HIST_FILE
	fi
done
rm $TEMP_FILE


