#!/bin/bash
CRTDIR=$(pwd)
base=$1
profile=$2
ui=$3
echo $base
if [ ! -e "$base" ]; then
	echo "Please enter base folder"
	exit 1
else
	if [ ! -d $base ]; then
		echo "Openwrt base folder not exist"
		exit 1
	fi
fi

if [ ! -n "$profile" ]; then
	profile=target_mt7981_gl-mt2500
fi

if [ ! -n "$ui" ]; then
        ui=false
fi
echo "Start..."

#clone source tree
git clone https://github.com/gl-inet/gl-infra-builder.git $base/gl-infra-builder
cd $base/gl-infra-builder

function copy_file(){
	patch=$1
	mkdir ~/firmware
	mkdir ~/packages
	cd $patch
	rm -rf packages
	cp -rf ./* ~/firmware
}

python3 setup.py -c configs/config-mt798x-7.6.6.1.yml
cd $base/gl-infra-builder/mt7981
./scripts/gen_config.py target_mt7981_gl-mt2500 luci
make -j$(expr $(nproc) + 1)  V=s
copy_file ~/openwrt/bin/targets/*/*
