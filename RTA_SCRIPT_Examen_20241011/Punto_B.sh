#!/bin/bash

createExtendedPartition() {
    local partitionNum=$1  # number_partition (arg)
    local device=$2        # device_to_partition (arg)
    local startSector=$3   # start_sector (arg)  
    local endSector=$4     # end_sector (arg)


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
        echo "$startSector"  
        echo "$endSector"  
        echo w  
    } | sudo fdisk $device

    # ---Forzar recarga de la tabla de particiones----
    sudo partprobe $device

    echo "[E-1]--->Partition $partitionNum created and successfully $device<-----"
}

createPartition() {
    local partitionNum=$1  # number_partition (arg)
    local device=$2        # device_to_partition (arg)
    local mountPoint=$3    # mount_point (arg)

    local startSector=$4   # start_sector (arg)  
    local endSector=$5     # end_sector (arg)
    local partType=$6      # part_type (arg)

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

# Define el punto de montaje base
mountBase="/Examenes-UTN"

# Llamadas a la función para crear 10 particiones de 1GB cada una
createPartition 1 /dev/sdd "$mountBase/profesores" 2048 2099199 p    
createPartition 2 /dev/sdd "$mountBase/alumno_1/parcial_1" 2099200 4196351 p
createPartition 3 /dev/sdd "$mountBase/alumno_1/parcial_2" 4196352 6293503 p

createExtendedPartition 4 /dev/sdd 6293504 20971519 # extended do not mount

createPartition 5 /dev/sdd "$mountBase/alumno_1/parcial_3" 6295552 8392703 p
createPartition 6 /dev/sdd "$mountBase/alumno_2/parcial_1" 8394752 10491903 p
createPartition 7 /dev/sdd "$mountBase/alumno_2/parcial_2" 10493952 12591103 p
createPartition 8 /dev/sdd "$mountBase/alumno_2/parcial_3" 12593152 14690303 p
createPartition 9 /dev/sdd "$mountBase/alumno_3/parcial_1" 14692352 16789503 p
createPartition 10 /dev/sdd "$mountBase/alumno_3/parcial_2" 16791552 18888703 p
createPartition 11 /dev/sdd "$mountBase/alumno_3/parcial_3" 18890752 20971518 p
