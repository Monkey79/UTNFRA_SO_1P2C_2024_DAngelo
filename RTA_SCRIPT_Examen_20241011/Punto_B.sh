echo "--------------------------CreateExtendedPartitionFnct------------------------------------"
createExtendedPartition() {
    local partitionNum=$1  # number_partition (arg)
    local device=$2        # device_to_partition (arg)

    # ---validations------
    if [ -z "$partitionNum" ]; then
        echo "Error: Provide Partition_Number."
        return 1
    fi

    if [ -z "$device" ]; then
        echo "Error: Provide Device_Partition."
        return 1
    fi

    # ----------Creation Partition-----------------------    
    {
        echo n  
        echo e
        echo "$partitionNum" 
        echo ""  
        echo ""  
        echo w  
    } | sudo fdisk $device

    # ---Forzar recarga de la tabla de particiones----
    sudo partprobe $device

    echo "[E-1]--->Partition $partitionNum created and successfully $device<-----"
}

echo "--------------------------CreatePartitionFnct------------------------------------"
createPartition() {
    local partitionNum=$1  # number_partition (arg)
    local device=$2        # device_to_partition (arg)
    local mountPoint=$3    # mount_point (arg)
    local endSector=$4     # end_sector (arg)
    local partType=$5      # part_type (arg)

    # ---validations------
    if [ -z "$partitionNum" ]; then
        echo "Error: Provide Partition_Number."
        return 1
    fi

    if [ -z "$partType" ]; then
        echo "Error: Provide Partition_Type (p=primary e=extend l=logical)."
        return 1
    fi

    if [ -z "$device" ]; then
        echo "Error: Provide Device_Partition."
        return 1
    fi

    # ----------Creation Partition-----------------------    
    {
        echo n  
        echo p
        echo "$partitionNum" 
        echo "$startSector"  
        echo "$endSector"  
        echo w  
    } | sudo fdisk $device

    # ---Forzar recarga de la tabla de particiones----
    sudo partprobe $device

    # ---Format----
    echo "[1]--formateando--> ${device}${partitionNum}<----"
    sudo mkfs -t ext4 "${device}${partitionNum}"

    # ---Mount----
    echo "[2]--montando--> ${device}${partitionNum} en ${mountPoint}<----"
    sudo mount "${device}${partitionNum}" "$mountPoint"
    
    # ---Persist----
    echo "${device}${partitionNum} $mountPoint ext4 defaults 0 2" | sudo tee -a /etc/fstab > /dev/null

    echo "[3]--->Partition $partitionNum created and mounted successfully $mountPoint<-----"
}
echo "------------------------------------------------------------------------------"

# Define el punto de montaje base
hdd=$(sudo fdisk -l | grep "10.7 GB" | awk '{print $2}' | awk -F ':' '{print $1}')
mountBase="/Examenes-UTN"

# Llamadas a la función para crear 10 particiones de 1GB cada una
createPartition 1 "$hdd" "$mountBase/profesores" "+1G" "p"    
createPartition 2 "$hdd" "$mountBase/alumno_1/parcial_1" "+1G" "p"
createPartition 3 "$hdd" "$mountBase/alumno_1/parcial_2" "+1G" "p"

createExtendedPartition 4 "$hdd" # extended (by default all the remaining space)

createPartition 5 "$hdd" "$mountBase/alumno_1/parcial_3" "+1G" "p"
createPartition 6 "$hdd" "$mountBase/alumno_2/parcial_1" "+1G" "p"
createPartition 7 "$hdd" "$mountBase/alumno_2/parcial_2" "+1G" "p"
createPartition 8 "$hdd" "$mountBase/alumno_2/parcial_3" "+1G" "p"
createPartition 9 "$hdd" "$mountBase/alumno_3/parcial_1" "+1G" "p"
createPartition 10 "$hdd" "$mountBase/alumno_3/parcial_2" "+1G" "p"
createPartition 11 "$hdd" "$mountBase/alumno_3/parcial_3" "" "p"

# "lost+found" directory
#sudo rm -r /Examenes-UTN/alumno_1/parcial_1/lost+found/
#sudo rm -r /Examenes-UTN/alumno_1/parcial_2/lost+found/
#sudo rm -r /Examenes-UTN/alumno_1/parcial_3/lost+found/
#sudo rm -r /Examenes-UTN/alumno_2/parcial_1/lost+found/
#sudo rm -r /Examenes-UTN/alumno_2/parcial_2/lost+found/
#sudo rm -r /Examenes-UTN/alumno_2/parcial_3/lost+found/
#sudo rm -r /Examenes-UTN/alumno_3/parcial_1/lost+found/
#sudo rm -r /Examenes-UTN/alumno_3/parcial_2/lost+found/
#sudo rm -r /Examenes-UTN/alumno_3/parcial_3/lost+found/
#sudo rm -r /Examenes-UTN/profesores/lost+found/

echo "-------------------------punto-b.status-------------------------------------------"
sudo fdisk -l
echo "----------------------------------------------------------------------------------"
