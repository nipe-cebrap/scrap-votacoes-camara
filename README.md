# Scrap de votações nominais da Câmara

Este repositório contém código para raspar URLs de votações das páginas em HTML do *website* da Câmara dos Deputados. Seu funcionamento é baseado nas datas de sessões na Câmara, para as quais há páginas individuais com links das votações. Ao fim do processo, URLs são armazenadas na pasta `outputs`.

## Como rodar

Para garantir compatibilidade das versões de pacotes usados, utilize o `renv` da seguinte forma (pode levar alguns minutos):

```r
if(!require(renv)) install.packages("renv")
renv::restore()
```

Isto deve instalar todos os pacotes necessários nas suas versões demandadas. Isto feito, execute o script `0_coleta_links.R`:

```r
source(here::here("0_coleta_links.R"))
```




