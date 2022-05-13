# ---
# _FUNCOES
# ---


# Funcao pra extrair links de uma pagina de data
extrai_links <- function(data){


  # Reformata a data
  data <- format(data, "%d/%m/%Y")
  cli::cli_alert(glue::glue("Links do dia {data}"))

  # Extrai pagina
  Sys.sleep(runif(1, 0, 0.1)) # Alivia o servidor da camara
  pag <- "https://www.camara.leg.br/internet/votacao/default.asp?datDia={data}" %>%
    glue::glue() %>%
    request() %>%
    req_perform() %>%
    resp_body_html() %>%
    html_nodes("#content a")

  # Extrai textos
  textos <- pag %>%
    html_text2() %>%
    str_trim()

  # Extrai links
  links <- pag %>%
    html_attr("href")

  # Monta um tibble e retorna
  tibble(textos = textos, links = links) %>%
    filter(str_detect(textos, "votantes por UF")) %>%
    filter(str_detect(links, ".pdf", negate = TRUE)) %>%
    mutate(links = paste0("https://www.camara.leg.br/internet/votacao/", links)) %>%
    mutate(data = data) %>%
    select(data, links)
}



# Funcao para coletar votacoes nominais
coleta_votos <- function(link){

  # Extrai a pagina
  Sys.sleep(runif(1, 0, 0.1)) # Alivia o servidor da camara
  pag <- link %>%
    request() %>%
    req_perform() %>%
    resp_body_html()

  # Extrai informacoes das proposicoes (DepF_Votacao_V2)
  data_votacao <- pag %>%
    html_nodes(".coluna1 .content > p:nth-child(1)") %>%
    html_text2() %>%
    str_match("\\r\\s*(.*?)\\s*\\n") %>%
    pluck(2) %>%
    lubridate::dmy_hm(tz = "America/Sao_Paulo")

  cli::cli_alert(glue::glue("Coletando dados de {data_votacao}"))

  proposicao <- pag %>%
    html_nodes("p~ p+ p") %>%
    html_text2() %>%
    str_remove("Proposição: ")

  prop_ano <- proposicao %>%
    str_extract("[^-]+") %>%
    str_remove("Nº ") %>%
    str_trim()

  assunto <- proposicao %>%
    str_extract("-.*") %>%
    str_remove("- ")

  sigla_prop <- prop_ano %>%
    str_sub(1, 3)

  tibble(Data = data_votacao,
         Projeto = sigla_prop,
         PROJ_ANO = prop_ano,
         Assunto = assunto) -> DepF_Votacao_V2


  # Extrai as indicacoes das liderancas
  partidos <- pag %>%
    html_nodes(".coluna2 th") %>%
    html_text2() %>%
    str_remove(":")

  indicacao <- pag %>%
    html_nodes(".coluna2 td") %>%
    html_text2()

  tibble(Data = data_votacao,
         PROJ_ANO = prop_ano,
         partidos = partidos,
         indicacao = indicacao) -> LideresPart_X_Votacao_v2


  # Extrai os votos individuais
  pag %>%
    html_nodes("#listagem") %>%
    html_table() %>%
    pluck(1) %>%
    # Cria uma variavel de UF
    mutate(uf = NA) %>%
    mutate(uf = ifelse(str_detect(Partido, " \\("), Partido, uf)) %>%
    fill(uf, .direction = "down") %>%
    # Remove entradas de estados
    filter(!str_detect(Partido, " \\(|Total ")) %>%
    # Remove duplicates
    distinct() %>%
    # Adiciona Data e PROJ_ANO
    mutate(Data = data_votacao, PROJ_ANO = prop_ano) %>%
    relocate(Data, PROJ_ANO, .before = Parlamentar) -> DepF_X_Votacao_v2


  # Retorna
  list(DepF_Votacao_V2 = DepF_Votacao_V2,
       LideresPart_X_Votacao_v2 = LideresPart_X_Votacao_v2,
       DepF_X_Votacao_v2 = DepF_X_Votacao_v2)
}


