#!/bin/bash
whiptail --title "Private Diary - Project - Emre Aslan" --msgbox "Hello $(whoami), Welcome to your privite diary.\nYou can write in the diary and keep it encrypted or just read it." 10 55


if (whiptail --title "Firstly.." --yes-button "Write a new diary" --no-button "Read previous diaries"  --yesno "What do you want to do?" 10 80) then

	date=$(whiptail --title "Date Input" --inputbox "Enter the date you want to write for:\n(day-mount-year: 04-05-2018)" 10 60 3>&1 1>&2 2>&3)
	datestatus=$?
	if [ $datestatus = 0 ]; then
		text=$(whiptail --title "Private Diary" --inputbox "$(whoami) - $date \nWrite your diary:" 10 60 3>&1 1>&2 2>&3)
		textstatus=$?
		PASSWORD=$(whiptail --title "Password" --passwordbox "Enter a password for your diary:" 10 60 3>&1 1>&2 2>&3)
		passstatus=$?
		if [ $passstatus = 0 ] && [ $textstatus = 0 ]; then
			zip
			zipstatus=$?
				if [ $zipstatus != 0 ]; then
					whiptail --msgbox "The required component zip is not installed.\nInstallation is starting.." 10 55
					sudo apt-get install zip
				fi
			echo "$text" > $date.txt
			zip -m --password $PASSWORD $date.zip $date.txt
			whiptail --msgbox "Your diary successfully created and encrypted." 10 55
		else
			whiptail --msgbox "It is cancelled. Text status: $textstatus Password status: $passstatus" 10 55
			exit
		fi
	else
		whiptail --msgbox "It is cancelled. Date status: $datestatus" 10 55
		exit
	fi

else
	date=$(whiptail --title "Date Selection" --inputbox "Enter the date you want to read:\n(day-mount-year: 04-05-2018)" 10 60 3>&1 1>&2 2>&3)
	datestatus=$?
		if [ $datestatus = 0 ]; then
		PASSWORD=$(whiptail --title "Password" --passwordbox "Enter the password for your diary:" 10 60 3>&1 1>&2 2>&3)
		passstatus=$?
			if [ $passstatus = 0 ]; then
				unzip -P $PASSWORD $date.zip
				unzipstatus=$?
					if [ $unzipstatus != 0 ]; then
						whiptail --msgbox "Your diary on $date not found or wrong password!" 10 55
						exit
					fi
				text=$(<$date.txt)
				whiptail --title "$whoami - $date" --msgbox "$text" 20 80
				rm $date.txt
			else
				whiptail --msgbox "It is cancelled. Password status: $passstatus" 10 55
				exit
			fi
		else
			whiptail --msgbox "It is cancelled. Date status: $datestatus" 10 55
			exit
		fi
fi
