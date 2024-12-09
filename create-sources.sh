#!/bin/sh
export LFS="/mnt/lfs"
tratamento_de_erro(){
	echo "Erro detectado!"
	echo "Comando: \"$BASH_COMMAND\""
	echo "Na linha: $LINENO"
	echo "Código de erro: $?"
	echo "No script $(basename $0)"
    	exit 1
}
trap tratamento_de_erro ERR
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
curl "https://www.linuxfromscratch.org/lfs/view/stable/wget-list-sysv" -o wget-list-sysv
curl "https://www.linuxfromscratch.org/lfs/view/stable/md5sums" -o md5sums
wget --input-file=wget-list-sysv --continue --directory-prefix=$LFS/sources
pushd $LFS/sources
  md5sum -c md5sums
popd
chown root:root $LFS/sources/*
