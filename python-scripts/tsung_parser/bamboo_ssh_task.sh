# First SSH task in bamboo

mkdir -p /home/tsung/${bamboo.tsung_config}/${bamboo.deploy.release}
sudo mkdir -p /var/www/html/tsung/${bamboo.tsung_config}/${bamboo.deploy.release}


# Second SSH task in bamboo
screen -dm bash -c "watch -n5 'cd /var/www/html/tsung/${bamboo.tsung_config}/${bamboo.deploy.release}/* && sudo /usr/lib/tsung/bin/tsung_stats.pl'"
sudo rm -rf /var/www/html/tsung/${bamboo.tsung_config}/${bamboo.deploy.release}/*
cd /home/tsung/${bamboo.tsung_config}/${bamboo.deploy.release}
tar xvzf config.tgz
sudo tsung -f config/${bamboo.tsung_config}.xml -l /var/www/html/tsung/${bamboo.tsung_config}/${bamboo.deploy.release} -n start
sudo chmod -R 777 /var/www/html/tsung
cd /var/www/html/tsung/${bamboo.tsung_config}/${bamboo.deploy.release}/*
pkill screen

# Check testing results
set -x 

# connect: Duration of the connection establishment.
connect_threshold='0.300'

# page: Response time for each set of requests (a page is a group of request not separated by a thinktime).
page_threshold=''

# request: Response time for each request.
request_threshold='0.700'

# session Duration of a user’s session.
session_threshold=''

results=$(/usr/local/sbin/parser.py | tr '\n' ';')
connect_mean=$(echo $results | cut -d';' -f1 | awk {'print $3'})
page_mean=$(echo $results | cut -d';' -f2 | awk {'print $3'})
request_mean=$(echo $results | cut -d';' -f3 | awk {'print $3'})
session_mean=$(echo $results | cut -d';' -f4 | awk {'print $3'})

echo 'connect threshold: '$connect_threshold';page threshold: '$page_threshold';request threshold :'$request_threshold';session_threshold: '$session_threshold';'
echo $results

# true 1, false 0
connect_pass=$(echo $connect_mean'>'$connect_threshold | bc -l )
request_pass=$(echo $request_mean'>'$request_threshold | bc -l )
#echo connect: $connect_pass
#echo request: $request_pass

if [ $connect_pass == "1"  ] || [ $request_pass == "1"  ]; then
	echo "Load testing failed due to results is greater than threshold"
	exit 1
fi

