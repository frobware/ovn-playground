.PHONY: all

CONFIG_DRIVES :=				\
	ovn-vm-1-ds.iso			\
	ovn-vm-2-ds.iso			\
	ovn-vm-3-ds.iso

IMAGE_DIR := /var/lib/libvirt/images

all: install

config: $(CONFIG_DRIVES)

%.iso: user-data meta-data create-config-drive Makefile
	@echo generating $@
	@./create-config-drive -h $(patsubst %-ds.iso,%,$@) -k ~/.ssh/id_rsa.pub -u user-data $@

install: $(patsubst %,$(IMAGE_DIR)/%,$(CONFIG_DRIVES))

$(IMAGE_DIR)/%.iso: %.iso
	sudo cp $< $@

clean:
	$(RM) $(CONFIG_DRIVES)

redo-net: remove-net
	virsh net-define 10.127.0.0.xml
	virsh net-start 10.127.0.0

remove-net:
	-virsh net-undefine 10.127.0.0
	-virsh net-destroy 10.127.0.0
