#!/bin/bash

echo "-----------------------------punto.c---------------------------------------------------"

# Creating secondary groups
sudo groupadd p1c2_2024_gAlumno
sudo groupadd p1c2_2024_gProfesores

# creation primary groups
sudo groupadd p1c2_2024_A1
sudo groupadd p1c2_2024_A2
sudo groupadd p1c2_2024_A3
sudo groupadd p1c2_2024_P1

# ^=search beginning line
vagrantHsh=$(sudo grep '^vagrant:' /etc/shadow | awk -F: '{print $2}')

sudo useradd -d /home/p1c2_2024_A1 -m -s /bin/bash -g p1c2_2024_A1 -G p1c2_2024_gAlumno p1c2_2024_A1 -p "${vagrantHsh}"
sudo useradd -d /home/p1c2_2024_A2 -m -s /bin/bash -g p1c2_2024_A2 -G p1c2_2024_gAlumno p1c2_2024_A2 -p "${vagrantHsh}"
sudo useradd -d /home/p1c2_2024_A3 -m -s /bin/bash -g p1c2_2024_A3 -G p1c2_2024_gAlumno p1c2_2024_A3 -p "${vagrantHsh}"
sudo useradd -d /home/p1c2_2024_P1 -m -s /bin/bash -g p1c2_2024_P1 -G p1c2_2024_gProfesores p1c2_2024_P1 -p "${vagrantHsh}"

# change owner and group of subfolder 
sudo chown -R p1c2_2024_A1:p1c2_2024_A1 /Examenes-UTN/alumno_1
sudo chown -R p1c2_2024_A2:p1c2_2024_A2 /Examenes-UTN/alumno_2
sudo chown -R p1c2_2024_A3:p1c2_2024_A3 /Examenes-UTN/alumno_3
sudo chown -R p1c2_2024_P1:p1c2_2024_gProfesores /Examenes-UTN/profesores

# change permissions of folders
#sudo chmod 755 /Examenes-UTN/
sudo chmod -R 750 /Examenes-UTN/alumno_1 # owner=rwx|group=r-x|other=--- [p1c2_2024_A1:p1c2_2024_A1]
sudo chmod -R 760 /Examenes-UTN/alumno_2 # owner=rwx|group=rw-|other=--- [p1c2_2024_A2:p1c2_2024_A2]
sudo chmod -R 700 /Examenes-UTN/alumno_3 # owner=rwx|group=---|other=--- [p1c2_2024_A3:p1c2_2024_A3]
sudo chmod -R 775 /Examenes-UTN/profesores # owner=rwx|group=rwx|other=r-x [p1c2_2024_P1:p1c2_2024_gProfesores]


# Create validate.txt
# [sudo -u p1c2_2024_A1] specifies that the command should be run as the p1c2_2024_A1
sudo -u p1c2_2024_A1 bash -c "whoami > /Examenes-UTN/alumno_1/validar.txt" 
sudo -u p1c2_2024_A2 bash -c "whoami > /Examenes-UTN/alumno_2/validar.txt"
sudo -u p1c2_2024_A3 bash -c "whoami > /Examenes-UTN/alumno_3/validar.txt"
sudo -u p1c2_2024_P1 bash -c "whoami > /Examenes-UTN/profesores/validar.txt"
sudo chmod 750 /Examenes-UTN/alumno_1/validar.txt
sudo chmod 760 /Examenes-UTN/alumno_2/validar.txt
sudo chmod 700 /Examenes-UTN/alumno_3/validar.txt
sudo chmod 775 /Examenes-UTN/profesores/validar.txt

echo "----------------------------punto.c.status---------------------------------------------------"
sudo cat /etc/passwd
echo "***grupos***"
sudo cat /etc/group
echo "************"
sudo ls -lt /Examenes-UTN/
echo "---------------------------------------------------------------------------------------------"

