#!/bin/bash

# Função para exibir o prompt
function exibir_prompt() {
  echo -n "prefixo:$WINEARQUI $(pwd) $ "
}

# Função para exibir a ajuda
function exibir_ajuda() {
  echo "Bem-vindo ao console simulado."
  echo "Comandos disponíveis:"
  echo "  ajuda          Exibir esta mensagem de ajuda."
  echo "  limpar         Limpar a tela."
  echo "  sair           Sair do console."
  echo "  variaveis      Listar variaveis do prefixo wine atual."
  echo "  informacoes    <arquivo/diretorio>  Exibir informações sobre um arquivo ou diretório."
  echo "  importar       Importar um script .sh para estender o console."
  echo "  programas      Lista programas built-in do wine."
  echo "  dependencias   Instala dependencias usando winetricks"
}

# Função para listar arquivos e diretórios no diretório atual
function variaveis() {
  echo "O caminho para o prefixo é $WINEPREFIXO"
  echo "A arquitetura do prefixo wine é: $WINEARQUI"
  echo "O diretorio de commandos built-in é: $WINEARCHCOMMAND"
}

# Funcao para instalar as dependencias wine para maioria dos jogos
function dependencias(){
  WINEPREFIX=${WINEPREFIXO} WINEARCH=${WINEARQUI} winetricks --unattended dotnet20 dotnet35 dotnet40 dotnet452 dotnet46 dotnet461 dotnet462 dotnet471 dotnet472 dotnet48 d3dcompiler_43 d3dcompiler_47 d3dx9 d3dx10 d3dx11_42 d3dx11_43 xna40 directshow directplay faudio vcrun2003 vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013 vcrun2015
}

# Função programas()
programas() {
    echo "Escolha um programa para executar:"
    echo "1 - WineCFG configurações do prefixo"
    echo "2 - Gerenciador de Tarefas"
    echo "3 - Bloco de Notas"
    echo "4 - Editor de Registro"
    echo "5 - Prompt de Comando"
    echo "6 - Painel de Controle"
    echo "7 - Internet Explorer"

    read escolha

    case $escolha in
        1)
            WINEPREFIX=$WINEPREFIXO wine $WINEARCHCOMMAND/winecfg.exe &> /dev/null # executa configurações do prefixo
            ;;
        2)
            WINEPREFIX=$WINEPREFIXO wine $WINEARCHCOMMAND/taskmgr.exe &> /dev/null # gerenciador de tarefas
            ;;
        3)
            WINEPREFIX=$WINEPREFIXO wine $WINEARCHCOMMAND/notepad.exe &> /dev/null # bloco de notas
            ;;
        4)
            WINEPREFIX=$WINEPREFIXO wine $WINEARCHCOMMAND/regedit.exe &> /dev/null # editor de registro
            ;;
        5)
            WINEPREFIX=$WINEPREFIXO wine $WINEARCHCOMMAND/wineconsole.exe &> /dev/null # prompt de comando
            ;;
        6)
            WINEPREFIX=$WINEPREFIXO wine $WINEARCHCOMMAND/control.exe &> /dev/null # painel de controle
            ;;
        7)
            WINEPREFIX=$WINEPREFIXO wine $WINEARCHCOMMAND/iexplorer.exe &> /dev/null # internet explorer
            ;;
        8)
            WINEPREFIX=$WINEPREFIXO wine $WINEARCHCOMMAND/explorer.exe &> /dev/null # internet explorer
            ;;
        9)
            return
            ;;
        *)
            echo "Opção inválida. Por favor, escolha um número entre 1 e 8."
            ;;
    esac
}

# Função para exibir informações sobre um arquivo ou diretório
function informacoes() {
  if [ -e "$1" ]; then
    echo "Informações sobre: $1"
    echo "Tipo: $(file -b "$1")"
    echo "Tamanho: $(du -h "$1" | cut -f1)"
    echo "Permissões: $(stat -c %a "$1")"
    echo "Proprietário: $(stat -c %U "$1")"
    echo "Grupo: $(stat -c %G "$1")"
    echo "Último acesso: $(stat -c %x "$1")"
    echo "Última modificação: $(stat -c %y "$1")"
  else
    echo "Arquivo ou diretório não encontrado: $1"
  fi
}

# Função para importar um script .sh
function importar() {
  if [ -f "$1" ]; then
    source "$1"
    echo "Biblioteca $1 importada com sucesso."
  else
    echo "Arquivo não encontrado: $1"
  fi
}

# Função principal do console
function console() {
  while true; do
    exibir_prompt
    read -r comando args

    # Verificar o comando digitado pelo usuário
    case "$comando" in
      ajuda)
        exibir_ajuda
        ;;
      limpar)
        clear
        ;;
      sair)
        echo "Saindo do console."
        break
        ;;
      listar)
        listar
        ;;
      informacoes)
        informacoes "$args"
        ;;
      importar)
        importar "$args"
        ;;
      *)
        # Executar outros comandos diretamente no shell
        $comando $args
        ;;
    esac
  done
}

echo "Escolha a arquitetura do Wine:"
echo "1. Win32"
echo "2. Win64"

read -p "Digite o número da opção desejada: " option

case $option in
    1)
        WINEARQUI=win32
        WINEPREFIXO=$(pwd)/win32
        echo "Arquitetura selecionada: Win32"
        ;;
    2)
        WINEARQUI=win64
        WINEPREFIXO=$(pwd)/win64
        echo "Arquitetura selecionada: Win64"
        ;;
    *)
        echo "Opção inválida. Saindo."
        exit 1
        ;;
esac

# Verifica o valor de WINEARCH e define a variável WINEARCHCOMMAND de acordo
if [ "$WINEARQUI" = "win32" ]; then
    WINEARCHCOMMAND="$WINEPREFIXO/drive_c/windows/system32"
elif [ "$WINEARQUI" = "win64" ]; then
    WINEARCHCOMMAND="$WINEPREFIXO/drive_c/windows/syswow64"
else
    echo "Erro: Arquitetura não reconhecida."
    exit 1
fi

echo "A variável WINEARCHCOMMAND foi definida para: $WINEARCHCOMMAND"

# Verifica se o diretório WINEPREFIX existe
if [ ! -d "$WINEPREFIXO" ]; then
    echo "O diretório $WINEPREFIXO não existe. Executando winetricks para criá-lo..."
    WINEARCH=${WINEARQUI} WINEPREFIX=${WINEPREFIXO} winetricks lucida &> /dev/null
else
    echo "O diretório $WINEPREFIXO já existe. Continuando..."
fi

# Resto do código
# ...

# Iniciar o console
clear
echo "Bem-vindo ao console Prefixo-Wine ."
echo "Digite 'ajuda' para obter a lista de comandos disponíveis."

# Chamar a função para iniciar o console simulado após a escolha da arquitetura
console
