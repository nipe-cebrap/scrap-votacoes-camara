# ---
# 0 COLETA LINKS DE VOTACOES
# ---


# Pacotes
library(tidyverse)
library(httr2)
library(rvest)
library(here)


# Cria dir para salvar dados
if(!dir.exists(here("outputs"))) dir.create(here("outputs"))


# Carrega o scraper
source(here("_funcoes.R"))


# Extrai os links
links <- seq.Date(as.Date("2020-01-01"), Sys.Date(), by = 1) %>%
  map_df(extrai_links)


# Salva os dados
write_csv2(links, file = here("outputs", "links_votacoes.csv"))
save(links, file = here("outputs", "links_votacoes.Rda"))


