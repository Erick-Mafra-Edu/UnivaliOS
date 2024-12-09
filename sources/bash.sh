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
tempo_estimado=$(echo "$SBU * 0.2"|bc)
echo "Este processo demora 0.2 SBU ou seja $tempo_estimado segundos"
sleep 3 
tar -xvf bash-5.2.32.tar.gz
cd bash-5.2.32
echo "Preparando a configuração"
sleep 1
./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc              \
            bash_cv_strtold_broken=no
echo "Compilando"
sleep 2 
make
echo "Instalando"
sleep 1
make DESTDIR=$LFS install
echo "Criando link simbolico para o shell"
ln -sv bash $LFS/bin/sh