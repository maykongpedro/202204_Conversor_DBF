
#' Transformar colunas do shape MP-LP de SC para os tipos corretos necessarios 
#' para correta conversao em DBF.
#'
#' @param database base de dados em tibble ou dataframe
#'
#' @return retorna a base de dados com as mesmas colunas porem com os tipos alterados
#' @export
#'
#' @examples
transformar_shp_sc <- function(database) {
    
    db <- database |>
        dplyr::mutate(
            REMSOFT_ID = as.integer(REMSOFT_ID),
            ACTION = as.integer(ACTION),
            CUT_PERIOD = as.integer(CUT_PERIOD),
            THEME11 = as.character(THEME11),
            IDADE = as.integer(IDADE)
        ) |> 
        as.data.frame()
    
    return(db)
}