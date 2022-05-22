

# seleção de coluna
nome_col <- "mpg"

# gera um vetor
db <- mtcars[, nome_col] 

# gera um dataframe
df <- mtcars[nome_col]

# converte
as.character(mtcars[, nome_col])

# Transformação -----------------------------------------------------------

# obter dados
database <- mtcars

# converter tipo de coluna
database$mpg <- as.character(database$mpg)

# captura apenas a convers?o da coluna
coluna_alterada <- database |> 
    purrr::pluck(nome_col) |> 
    as.character()

database[, nome_col] <- coluna_alterada


# If statement ------------------------------------------------------------

# escolher a coluna
nome_col <- "carb"

# escolher o tipo
tipo_desejado <- c(
    "character",
    "integer",
    "factor",
    "numeric"
)

escolha <- tipo_desejado[3]

# fazer o check
if (escolha=="character") {
    database[, nome_col] <- as.character(database[, nome_col])
} else if (escolha == "integer") {
    database[, nome_col] <- as.integer(database[, nome_col])
} else if(escolha == "factor") {
    database[, nome_col] <- as.factor(database[, nome_col])
} else if(escolha == "numeric"){
    database[, nome_col] <- as.integer(database[, nome_col])
} else{
    database[, nome_col] <- database[, nome_col]
}

database |> dplyr::glimpse()

    
    