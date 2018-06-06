#!/bin/bash

	echo ""
	echo -e "███╗   ██╗ █████╗ ███╗   ███╗███████╗ ██████╗██╗  ██╗██╗  ██╗   ███████╗██╗  ██╗
████╗  ██║██╔══██╗████╗ ████║██╔════╝██╔════╝██║  ██║██║ ██╔╝   ██╔════╝██║  ██║
██╔██╗ ██║███████║██╔████╔██║█████╗  ██║     ███████║█████╔╝    ███████╗███████║
██║╚██╗██║██╔══██║██║╚██╔╝██║██╔══╝  ██║     ██╔══██║██╔═██╗    ╚════██║██╔══██║
██║ ╚████║██║  ██║██║ ╚═╝ ██║███████╗╚██████╗██║  ██║██║  ██╗██╗███████║██║  ██║
╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝╚═╝  ╚═╝"  
	echo ""

gettoken(){
        curl -s -d "q=$1" "https://namechk.com/" | sed -e 's/[{}"]/''/g' | cut -d : -f 2 > token
        token=$(cat token)
}

rmm()
{
	touch token
	touch verify
	rm token
	rm verify
	exit
}

invp(){
	echo ""
	echo " [-] Invalid parameter"
	echo ""
	echo "How to:"
	echo ""
	echo "	 	- Search available username:	./namechk.sh <username> -au"
	echo "		- Search available username on specifics websites:		./namechk.sh  <username> -au -co"
	echo "	 	- Search available username list:		./namechk.sh -l -fu"
	echo "	 	- Search used username:		./namechk.sh <username> -fu"
	echo "	 	- Search used username on specifics websites:		./namechk.sh <username> -fu -co"
	echo "	 	- Search used username list:		./namechk.sh -l -fu"
}

found(){
	if [ $verify == 0 ];then
		profile=$(cat verify | sed -e 's/[{}"]/''/g' | cut -d , -f 5 | cut -d ":" -f 2,3)
		echo -e "\e[1m-------------------------------------------------------------\e[0m"
		echo -e " [+] Username found on:    \e[1;32m${service[$cont]}\e[0m"
		echo -e " [+] Profile url:          \e[1;36m$profile\e[0m"
	fi
}

available(){
	
	if [ $verify != 0 ];then
		profile=$(cat verify | sed -e 's/[{}"]/''/g' | cut -d , -f 5 | cut -d ":" -f 2,3)
		echo -e "\e[1m-------------------------------------------------------------\e[0m"
		echo -e " [+] Username available on: \e[1;32m${service[$cont]}\e[0m"
	fi
}

verify(){
	curl -s -d "service=${service[$cont]}&token=$token&fat=xwSgxU58x1nAwVbP6+mYSFLsa8zkcl2q6NcKwc8uFm+TvFbN8LaOzmLOBDKza0ShvREINUhbwwljVe30LbKcQw==" "https://namechk.com/services/check" > verify 
	verify=$(cat verify | sed -e 's/[{}"]/''/g' | cut -d , -f 2 | grep -c true)
}

websinput(){
	echo ""
	echo " [#] Enter webs for check:"
	echo ""
	read -p " " -a webs
	echo ""
	webslong=$(echo ${#webs[@]})
}

listinput(){
	echo ""
	echo " [#] Enter username list:"
	echo ""
	read -p " " -e list
	echo ""
}

#------------------------------------------------------------------------------------------------START------------------------------------------------------------------------------------------------

service=(Facebook YouTube Twitter Instagram Blogger GooglePlus Twitch Reddit Ebay Wordpress Pinterest Yelp Slack Github Basecamp Tumblr Flickr Pandora ProductHunt Steam MySpace Foursquare OkCupid Vimeo UStream Etsy SoundCloud BitBucket Meetup CashMe DailyMotion Aboutme Disqus Medium Behance Photobucket Bitly CafeMom coderwall Fanpop deviantART GoodReads Instructables Keybase Kongregate LiveJournal StumbleUpon AngelList LastFM Slideshare Tripit Fotolog Vine PayPal Dribbble Imgur Tracky Flipboard Vk kik Codecademy Roblox Gravatar Trip Pastebin Coinbase BlipFM Wikipedia Ello StreamMe IFTTT WebCredit CodeMentor Soupio Fiverr Trakt Hackernews five00px Spotify POF Houzz Contently BuzzFeed TripAdvisor HubPages Scribd Venmo Canva CreativeMarket Bandcamp Wikia ReverbNation foodspotting Wattpad Designspiration ColourLovers eyeem Miiverse KanoWorld AskFM Smashcast Badoo Newgrounds younow Patreon Mixcloud Gumroad Quora)
arrlong=$(echo ${#service[@]})
cont=0

if [[ $1 != "-l" ]];then

	if [[ -z $3 ]];then

		while [ $cont -lt $arrlong ]; do
			gettoken $1
			verify
			case $2 in
				"-au")
					available
				;;
				"-fu")
					found
				;;
				*)
					invp
					rmm
			esac
			((cont++))
		done
	else
		case $3 in
		-co)
			websinput
			while [ $cont -lt $webslong ]; do
				gettoken $1
				verify
				case $2 in
					"-au")
						available
					;;
					"-fu")
						found
					;;
					*)
						invp
						rmm
				esac
				((cont++))
			done
		;;
		*)
			invp
			rmm
		;;
		esac
	fi
else
	if [[ -z $3 ]];then
		listinput
		while read line;do
			while [ $cont -lt $arrlong ];do
				gettoken $line
				verify
				case $2 in
					"-au")
						available
					;;
					"-fu")
						found
					;;
					*)
						invp
						rmm
				esac
				((cont++))
			done
		done < $list
	else
		websinput
		listinput
		while read line;do
			while [ $cont -lt $webslong ]; do
				gettoken $line
				verify2
				case $2 in
					"-au")
						available
					;;
					"-fu")
						found
					;;
					*)
						invp
						rmm
				esac
				((cont++))
			done
			cont=0
		done < $list
	fi
fi
echo ""
rmm
exit