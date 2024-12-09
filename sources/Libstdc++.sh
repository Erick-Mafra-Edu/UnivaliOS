if [ -z "$LFS"]||[ -z $LFS_TGT];then
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
cd gcc-14.2.0
mkdir -v libstdcpp
cd libstdcpp
tempo_estimado=$(echo "$SBU * 0.1"|bc)
echo "Este processo demora 0.1 SBU ou seja $tempo_estimado segundos"
sleep 3

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/14.2.0

echo "Começando a compilar.."
sleep 1
make
echo "Começando a instalação"
make DESTDIR=$LFS install
echo "Removendo os arquivos do arquivo libtool porque eles são prejudiciais para Compilação cruzada"
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la