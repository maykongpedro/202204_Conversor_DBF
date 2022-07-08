
#' Transformar colunas do shape MP-LP do PR para os tipos corretos necessarios 
#' para correta conversao em DBF.
#'
#' @param database base de dados em tibble ou dataframe
#'
#' @return retorna a base de dados com as mesmas colunas porem com os tipos alterados
#' @export
#'
#' @examples
transformar_shp_pr <- function(database) {
    
    db <- database |>
        dplyr::mutate(
            REMSOFT_ID = as.integer(REMSOFT_ID),
            ACTION = as.integer(ACTION),
            CUT_PERIOD = as.integer(CUT_PERIOD),
            IDADE = as.integer(IDADE),
            THEME11 = as.character(THEME11),
            THEME13 = as.character(THEME13),
            REASONCODE = as.integer(REASONCODE),
            PREBLOCK = as.character(PREBLOCK),
            TREATMENTS = as.character(TREATMENTS)
        ) |> 
        as.data.frame()
    
    return(db)
}