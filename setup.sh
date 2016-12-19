blue='\e[0;34m'
NC='\e[0m' # No Color
red='\e[0;31m'
green='\e[0;32m' 

echo
echo  "This script will configure RoboFEI-HT software"
echo
read -p "Continue? (y/n) " -n 1 -r
echo 
if [[  $REPLY =~ ^[Nn]$ ]] 
then
    exit 1
fi

sudo echo "Will this setup be used for Simulation or Real robot (S/R)? "
read MODE

if [  $MODE == "S" ] || [  $MODE == "s" ];
then
    echo -e "${blue} ***** SIMULATION MODE ***** ${NC}"
	echo
	read -p "How many robots do you want to compile? "
	echo 
	if [ $REPLY == 1 ]; then
		echo -e "${blue} AI ${NC}"
		echo -e "${blue} Installing serial ${NC}"
	    cd AI/IMU/serial
	    mkdir build
	    cd build
	    cmake ../
	    make all
	    sudo make install
	    cd ../../..
		echo
		echo -e "${blue} Installing whole software ${NC}"
		cd AI
		mkdir build
		cd build
		cmake ../
		make all
		make install
		cd ..
		cd Control/Data
		sed -i -e 's/no_player_robofei = [0-30]*/no_player_robofei = 1 /' config.ini
		cd ../../..
	fi

	if [ $REPLY -gt 1 ]; then
		echo 'starting ' $REPLY ' robots'
		cd AI
		mkdir build
		cd build
		cmake ../
		make all
		make install
		cd ..
		cd Control/Data
		sed -i -e 's/no_player_robofei = [0-30]*/no_player_robofei = 1 /' config.ini
		cd ../../..
		for ((i = 2; i <= $REPLY; i++)); do
		    cp -ar AI AI$i
		    cd AI$i/Control/Data
		    sed -i -e 's/no_player_robofei = [0-30]*/no_player_robofei = '$i'/' config.ini
		    cd ../../..
		done
	fi

	for ((i = 1; i <= "$REPLY"; i++)); do
		if [ $i == 1 ]; then
		    cd AI
		else
		    cd AI$i
		fi	
		echo -e "${blue} Installing whole software ${NC}"
		mkdir build
		cd build
		cmake ../
		make all
		make install
		cd ../..
	done
else
	echo -e "${blue} ***** REAL MODE ***** ${NC}"
	sleep 1
	echo -e "${blue} Installing serial ${NC}"
	cd AI/IMU/serial
	mkdir build
	cd build
	cmake ../
	make all
	sudo make install
	cd ../../..

	echo -e "${blue} Installing whole software ${NC}"
	cd AI
	mkdir build
	cd build
	cmake ../
	make all
	make install
	cd ../../
	sudo echo  -e "Creating rules for recognizing device${red} IMU${NC}"
	cat <<EOF > 41-ftdi-imu.rules
	KERNEL=="ttyUSB?", SUBSYSTEMS=="usb", ATTRS{idVendor}=="067b",  ATTRS{idProduct}=="2303", MODE="0777", SYMLINK+="robot/imu"
EOF
	chmod +x 41-ftdi-imu.rules
	sudo echo  -e "Copying file${blue} 41-ftdi-imu.rules${NC} to ${green}/etc/udev/rules.d${NC}"
	sudo cp  41-ftdi-imu.rules  /etc/udev/rules.d
    rm 41-ftdi-imu.rules

	sudo echo  -e "Creating rules for recognizing devices${red} Servo${NC}"
    sudo python ./AI/Control/Linux/device/renamePort.py

	sudo echo  "Restarting udev"
	sudo service udev restart

	cd  AI/Control/Data/

	sudo echo "Starting robots configuration" 
	sudo echo "Insert robot number: "
	read NUM
	case $NUM in
	  1) sudo echo "Robot 1 ..."
		 sudo echo "Artificial Grass [Y/N]: "
		 read CONF
		 if [ "$CONF" = "y" ]
		 then
		    ln -sf ../../conf_robos/01/grama/* .
		    ln -sf ../../conf_robos/01/vision/* ../../Vision/Data
		    echo "grass files copied!"
		 elif [ "$CONF" = "n" ]
		 then
		    ln -sf ../../conf_robos/01/chao/* .
		    ln -sf ../../conf_robos/01/vision/* ../../Vision/Data
		    echo "flat floor files copied!"
		 else
		     echo "invalid choice"
		 fi;;

	  2) sudo echo "Robot 2 ..."
		 sudo echo "Artificial Grass [Y/N]: "
		 read CONF
		 if [ "$CONF" = "y" ]
		 then
		    ln -sf ../../conf_robos/02/grama/* .
		    ln -sf ../../conf_robos/02/vision/* ../../Vision/Data
		    echo "grass files copied!"
		 elif [ "$CONF" = "n" ]
		 then
		    ln -sf ../../conf_robos/02/chao/* .
		    ln -sf ../../conf_robos/02/vision/* ../../Vision/Data
		    echo "flat floor files copied!"
		 else
		     echo "invalid choice"
		 fi;;

	  3) sudo echo "Robot 3 ..."
		 sudo echo "Artificial Grass [Y/N]: "
		 read CONF
		 if [ "$CONF" = "y" ]
		 then
		    ln -sf ../../conf_robos/03/grama/* .
		    ln -sf ../../conf_robos/03/vision/* ../../Vision/Data
		    echo "grass files copied!"
		 elif [ "$CONF" = "n" ]
		 then
		    ln -sf ../../conf_robos/03/chao/* .
		    ln -sf ../../conf_robos/03/vision/* ../../Vision/Data
		    echo "flat floor files copied!"
		 else
		     echo "invalid choice"
		 fi;;

	  4) sudo echo "Robot 4 ..."
		 sudo echo " Artificial Grass [Y/N]: "
		 read CONF
		 if [ "$CONF" = "y" ]
		 then
		    ln -sf ../../conf_robos/04/grama/* .
		    ln -sf ../../conf_robos/04/vision/* ../../Vision/Data
		    echo "grass files copied!"
		 elif [ "$CONF" = "n" ]
		 then
		    ln -sf ../../conf_robos/04/chao/* .
		    ln -sf ../../conf_robos/04/vision/* ../../Vision/Data
		    echo "flat floor files copied!"
		 else
		     echo "invalid choice"
		 fi;;
	  
	  *) sudo echo "Invalid robot number!" ;;
	esac
fi

cd ../../..

echo -e "${blue} That's all folks! Have fun! ${NC}" 
