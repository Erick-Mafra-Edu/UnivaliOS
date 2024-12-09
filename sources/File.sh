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
tempo_estimado=$(echo "$SBU * 0.1"|bc)
echo "Este processo demora 0.1 SBU ou seja $tempo_estimado segundos"
echo "ou $(convert_time $tempo_estimado)"
sleep 3 
tar -xvf file-5.45.tar.gz
cd file-5.45
mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
echo "compilando..."
sleep 1
make FILE_COMPILE=$(pwd)/build/src/file
echo "Instalando..."
sleep 1
make DESTDIR=$LFS install
echo "Removendo o arquivo libtool porque é prejudicial para o cross compilação"
rm -v $LFS/usr/lib/libmagic.la