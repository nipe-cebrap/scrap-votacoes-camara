# ---
# 1 EXTRAI OS DADOS DAS VOTACOES
# ---


# Pacotes
library(tidyverse)
library(httr2)
library(rvest)
library(here)


# Carrega os links
load(here("outputs", "links_votacoes.Rda"))


# Carrega o scraper
source(here("_funcoes.R"))


# Coleta as votacoes
dados <- links$links %>%
  map(coleta_votos)


# Separa os data.frames
DepF_Votacao_V2 <- dados %>%
  map_df(pluck, "DepF_Votacao_V2")

LideresPart_X_Votacao_v2 <- dados %>%
  map_df(pluck, "LideresPart_X_Votacao_v2")

DepF_X_Votacao_v2 <- dados %>%
  map_df(pluck, "DepF_X_Votacao_v2")


# Exporta os dados
write_csv2(DepF_Votacao_V2, file = here("outputs", "DepF_Votacao_V2"))
write_csv2(DepF_X_Votacao_v2, file = here("outputs", "DepF_X_Votacao_v2"))
write_csv2(LideresPart_X_Votacao_v2, file = here("outputs", "LideresPart_X_Votacao_v2"))







