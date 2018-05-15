# Transformar CEP em latitude e longitude

A função `cep2coo()` transforma o  CEP em dados de latitude e longitude. A função usa recursos do Python para consultar a API dos Correios e R para consultar as coordenadas no [Open Street Map](https://www.openstreetmap.org) (OSM).

A consulta à API dos correios é feita pela função da biblioteca [pycep-correios](https://pypi.org/project/pycep-correios/) escrita em python.

Após obter informações de endereço e cidade é feita uma consulta da latitude e longitude no OSM com a função `geocode` do pacote [photon](https://github.com/rCarto/photon) escrito para o R.


## Exemplo

`cep2coo("20090003") # -22.90369 -43.1782`

O resultado da latitude e longitude apresentará *missing value* se o CEP for inválido.


