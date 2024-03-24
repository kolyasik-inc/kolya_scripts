#!/bin/bash

# Verifica se a variável $diretorio_alvo já está preenchida
if [ -z "$diretorio_alvo" ]; then
  # Pergunta o diretório alvo
  read -p "Digite o diretório alvo: " diretorio_alvo

  # Verifica se o diretório alvo existe
  if [ ! -d "$diretorio_alvo" ]; then
    echo "O diretório alvo não existe."
    exit 1
  fi
fi

# Verifica se a variável $diretorio_destino já está preenchida
if [ -z "$diretorio_destino" ]; then
  # Pergunta o diretório destino
  read -p "Digite o diretório destino: " diretorio_destino

  # Verifica se o diretório destino existe ou cria caso não exista
  mkdir -p "$diretorio_destino"
fi

# Laço de repetição para cada arquivo ou pasta no diretório alvo
for item in "$diretorio_alvo"/*; do
  # Verifica se é um arquivo ou diretório
  if [ -f "$item" ] || [ -d "$item" ]; then
    _nome=$(basename "$item")
    # Faz o comando 7z para compactar o arquivo ou pasta
    xz -kfv --best --stdout "$item" > "$diretorio_destino/$_nome.xz" 
  fi
done

echo "Compactação concluída."
