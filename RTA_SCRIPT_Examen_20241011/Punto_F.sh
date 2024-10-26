#! /bin/bash

echo "Mi IP publica es: $(curl -s ifconfig.me;echo)" > Filtro_Avanzado.txt
echo "Mi usuario es: $(whoami)" >> Filtro_Avanzado.txt
echo "El Hash de mi Usuario es:$(sudo cat /etc/shadow | grep $(whoami) | awk -F":" '{print $2}')" >> Filtro_Avanzado.txt
echo "La URL de mi repositorio es: $(git config --get remote.origin.url)" >> Filtro_Avanzado.txt

