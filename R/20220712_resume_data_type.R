#' Gerar uma base resumo com os tipos de dados para cada coluna da base de input
#'
#' @param database base de dados 
#'
#' @return retorna uma base com uma coluna informando as variaveis e outra com o
#' respectivo tipo da variavel
#' @export
#'
#' @examples
resumir_tipos_de_dados <- function(database) {
    
    db_class <- database |>
        purrr::map_df(.f = class) |>
        tidyr::pivot_longer(
            cols = dplyr::everything(),
            names_to = "variavel",
            values_to = "tipo_de_dado"
        )
    
    return(db_class)
    
}

