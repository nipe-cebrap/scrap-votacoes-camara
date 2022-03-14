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
    req_perform()

  # Extrai textos
  textos <- pag %>%
    resp_body_html() %>%
    html_nodes("#content a") %>%
    html_text2() %>%
    str_trim()

  # Extrai links
  links <- pag %>%
    resp_body_html() %>%
    html_nodes("#content a") %>%
    html_attr("href")

  # Monta um tibble e retorna
  tibble(textos = textos, links = links) %>%
    filter(str_detect(textos, "votantes por UF")) %>%
    mutate(links = paste0("https://www.camara.leg.br/internet/votacao/", links)) %>%
    mutate(data = data) %>%
    select(data, links)
}


