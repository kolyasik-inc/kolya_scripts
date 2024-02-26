#!/bin/bash

# Solicitar ao usuário que insira o diretório Apriori
read -p "Digite o caminho para o diretório Apriori: " diretorioApriori

# Verificar se o diretório Apriori existe
if [ ! -d "$diretorioApriori" ]; then
    echo "O diretório Apriori não existe. Saindo do script."
    exit 1
fi

# Solicitar ao usuário que insira o diretório Aposteriori
read -p "Digite o caminho para o diretório Aposteriori: " diretorioAposteriori

# Verificar se o diretório Aposteriori existe
if [ ! -d "$diretorioAposteriori" ]; then
    echo "O diretório Aposteriori não existe. Saindo do script."
    exit 1
fi

# Obter uma lista de pastas no diretório Apriori e ordená-las numericamente
bancoDados=($(ls "$diretorioApriori" -v))

# Criar pastas dentro do diretório Aposteriori com base nos elementos do array
for posicao in "${!bancoDados[@]}"; do
    mkdir "$diretorioAposteriori/$posicao"
done

echo "Pastas criadas com sucesso dentro do diretório Aposteriori!"
