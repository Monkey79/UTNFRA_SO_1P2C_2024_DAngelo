#! /bin/bash
#sudo mkdir -p /Examenes-UTN/{alumno_{1/parcial_{1,2,3},2/parcial_{1,2,3},3/parcial_{1,2,3}},profesores}
sudo mkdir -p /Examenes-UTN/{alumno_{1..3}/parcial{1..3},profesores}
echo "-------------------------------puanto_a:status--------------------------------------------"
sudo tree /Examenes-UTN/
sudo ls -ld /Examenes-UTN/
echo "------------------------------------------------------------------------------------------"
