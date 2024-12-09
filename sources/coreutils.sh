if [ -z "$LFS" ]||[ -z $LFS_TGT ];then
	echo "Alguma das variaveis não foi definida por favor verifique a variavel LFS e LFS_TGT"
	exit 1
fi
tratamento_de_erro(){
	echo "Erro detectado!"
	echo "Comando: \"$BASH_COMMAND\""
	echo "Na linha: $LINENO"
	echo "Código de erro: $?"
	echo "No script $(basename $0)"
    	exit 1
}
trap tratamento_de_erro ERR
sbu_time(){
	echo $(($SECONDS - $START_TIME))
}
convert_time(){
	local segundos=$1
	horas=$(($segundos/3600))
	local resto=$(($seconds%3600))
	minutos=$(($resto/60))
	segundos=$(($resto%60))
	echo "tempo convertido de $horas horas $minutos minutos e $segundos segundos"
}
tempo_estimado=$(echo "$SBU * 0.3"|bc)
echo "Este processo demora 0.3 SBU ou seja $tempo_estimado segundos"
sleep 3 
tar -xvf coreutils-9.5.tar.xz
cd coreutils-9.5
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
echo "Compilando"
sleep 1
make
echo "Instalando"
sleep 1
make DESTDIR=$LFS install

mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8