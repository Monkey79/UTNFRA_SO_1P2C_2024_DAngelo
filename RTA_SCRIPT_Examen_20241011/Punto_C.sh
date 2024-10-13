#!/bin/bash

# Creating secondary groups
sudo groupadd p1c2_2024_gAlumno
sudo groupadd p1c2_2024_gProfesores

sudo groupadd p1c2_2024_A1
sudo groupadd p1c2_2024_A2
sudo groupadd p1c2_2024_A3
sudo groupadd p1c2_2024_P1

# Creating users (I assume the primary group is grou with the same name that users)
sudo useradd -d /home/p1c2_2024_A1 -m -s /bin/bash -g p1c2_2024_A1 -G p1c2_2024_gAlumno p1c2_2024_A1 
sudo useradd -d /home/p1c2_2024_A2 -m -s /bin/bash -g p1c2_2024_A2 -G p1c2_2024_gAlumno p1c2_2024_A2 
sudo useradd -d /home/p1c2_2024_A3 -m -s /bin/bash -g p1c2_2024_A3 -G p1c2_2024_gAlumno p1c2_2024_A3
sudo useradd -d /home/p1c2_2024_P1 -m -s /bin/bash -g p1c2_2024_P1 -G p1c2_2024_gProfesores p1c2_2024_P1

# Function to copy the hash of the user "vagrant" to each previously created user
CopyPasteHash() {
    local user=$1   
    
    # ^ means the beginning of the line
    vagrant_hash=$(sudo grep '^vagrant:' /etc/shadow | awk -F: '{print $2}')
    
    # s means sustitution
    sudo sed -i "s|^${user}:!|${user}:${vagrant_hash}|" /etc/shadow    

    echo "Usuario ${user} creado y configurado con la misma contraseña que vagrant."
}

# calling function
CopyPasteHash "p1c2_2024_A1" 
CopyPasteHash "p1c2_2024_A2"
CopyPasteHash "p1c2_2024_A3"
CopyPasteHash "p1c2_2024_P1"

# I add 2 groups with permissions (recursively) to /Examenes-UTN/ 
# so that it allows me to do the "PointC" since if I still change the group 
# to "p1c2_2024_gAlumno" from /Examnes-UTN the users of the group "p1c2_2024_gProfesores" 
# will not be able to access
sudo setfacl -R -m g:p1c2_2024_gAlumno:rwx /Examenes-UTN/
sudo setfacl -R -m g:p1c2_2024_gProfesores:rwx /Examenes-UTN/

# change owner and group of subfolder 
sudo chown p1c2_2024_A1:p1c2_2024_A1 /Examenes-UTN/alumno_1
sudo chown p1c2_2024_A2:p1c2_2024_A2 /Examenes-UTN/alumno_2
sudo chown p1c2_2024_A3:p1c2_2024_A3 /Examenes-UTN/alumno_3
sudo chown p1c2_2024_P1:p1c2_2024_gProfesores /Examenes-UTN/profesores

# change permissions of folders
sudo chmod 750 /Examenes-UTN/alumno_1 # owner=everything|group=read&execute|other=nothing
sudo chmod 760 /Examenes-UTN/alumno_2 # owner=rwx|group=rw-|other=---
sudo chmod 700 /Examenes-UTN/alumno_3 # owner=everything|group=nothing|other=nothing
sudo chmod 775 /Examenes-UTN/profesores # owner=everything|group=everything|other=read&execute


# Create validate.txt
# [sudo -u p1c2_2024_A1] specifies that the command should be run as the p1c2_2024_A1
sudo -u p1c2_2024_A1 bash -c "whoami > /Examenes-UTN/alumno_1/validar.txt" 
sudo -u p1c2_2024_A2 bash -c "whoami > /Examenes-UTN/alumno_2/validar.txt"
sudo -u p1c2_2024_A3 bash -c "whoami > /Examenes-UTN/alumno_3/validar.txt"
sudo -u p1c2_2024_P1 bash -c "whoami > /Examenes-UTN/profesores/validar.txt"

