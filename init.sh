IFS=$'\n';

STREAMING_KEYS=$(printenv | grep streamkey_)

PUSH_STATEMENTS="\t# -- LIVESTREAM ENDPOINTS : generated from docker-compose.yml --"

for key in ${STREAMING_KEYS[@]}; do
	stream_name=$(echo $key | awk '{split($0,a,"="); print a[1]}')
	stream_key=$(echo $key | awk '{split($0,a,"="); print a[2]}')
	push="\n\t\t#$stream_name\n\t\tpush $stream_key;"
	PUSH_STATEMENTS=$PUSH_STATEMENTS$push
done

PUSH_STATEMENTS=$(printf $PUSH_STATEMENTS | awk '{gsub(/&/,"\\\&"); print $0}')

awk -v PUSH="$PUSH_STATEMENTS" '{gsub("##PUSH STATEMENTS##",PUSH,$0);}1' /usr/local/nginx/conf/nginx.conf > tmp.txt

mv tmp.txt /usr/local/nginx/conf/nginx.conf

/usr/local/nginx/sbin/nginx