#!/bin/bash

for i in "$@"; do
    name=ovn-vm-${i}
    virsh pool-refresh default
    virsh vol-clone --pool default ${CLOUD_IMG:-xenial-server-cloudimg-amd64-disk1.img} ${name}.img
    virsh vol-resize --pool default ${name}.img +10G
    virsh pool-refresh default
    virt-install -r 1024 \
		 -n $name \
		 --vcpus=1 \
		 --autostart \
		 --noautoconsole \
		 --memballoon virtio \
		 --boot hd \
		 --disk vol=default/${name}.img,format=qcow2,bus=virtio,cache=writeback,size=${DISK_SIZE:-10} \
		 --disk vol=default/${name}-ds.iso,bus=virtio \
		 --network network=10.127.0.0,model=virtio \
		 --network network=br-enp1s0f0,model=virtio \

done
