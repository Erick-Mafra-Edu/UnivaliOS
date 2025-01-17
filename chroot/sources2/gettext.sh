tratamento_de_erro(){
	echo "Erro detectado!"
	echo "Comando: \"$BASH_COMMAND\""
	echo "Na linha: $LINENO"
	echo "Código de erro: $?"
	echo "No script $(basename $0)"
    	exit 1
}
trap tratamento_de_erro ERR
tar -xvf gettext-0.22.5.tar.xz
cd gettext-0.22.5
./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin