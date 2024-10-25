#! /bin/bash
PATH_FILE=${HOME}/repogit/UTNFRA_SO_1P2C_2024_DAngelo/RTA_SCRIPT_Examen_20241011
sudo cat /proc/meminfo > ${PATH_FILE}/Filtro_Basico.txt
sudo dmidecode -t chassis >> ${PATH_FILE}/Filtro_Basico.txt

echo "--------------------punto_e status---------------------"
cat ${PATH_FILE}/Filtro_Basico.txt
echo "-------------------------------------------------------"
