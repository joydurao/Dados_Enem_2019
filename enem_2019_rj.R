# Lendo arquivo csv do enem rj #

enem_2019 <- read.csv('enem_rj_2019.csv')
library(dplyr)
View(enem_2019)

# Excluindo uma coluna #

enem_2019$NU_ANO <- NULL

# Excluindo várias colunas #
excluir <- c("TP_ESTADO_CIVIL","SG_UF_RESIDENCIA")
View(excluir)
enem_2019<-enem_2019[ , !(names(enem_2019) %in% excluir)]

View(names(enem_2019))

# %in% verifica a intersecção enquanto ! é o complementar


# Renomeando algumas colunas #

enem_2019<-rename(enem_2019,NOTA_COMP2 = NU_NOTA_COMP2, 
                  NOTA_COMP3 = NU_NOTA_COMP3, NOTA_COMP4 = NU_NOTA_COMP4,
                  NOTA_COMP5 = NU_NOTA_COMP5, NOTA_REDACAO = NU_NOTA_REDACAO,
                  NOTA_CN = NU_NOTA_CN, NOTA_LC = NU_NOTA_LC, NOTA_MT = NU_NOTA_MT)

enem_2019<-rename(enem_2019, NOTA_COMP1 = NU_NOTA_COMP1)

# Vericando os tipos de variáveis

str(enem_2019)
glimpse(enem_2019)

# Transformando a variável Código escola em fator
enem_2019$CO_ESCOLA<-as.factor(enem_2019$CO_ESCOLA)

# Verificando valores ausentes
# NA = valores ausentes
# NAN = not a number (valor indefinido)

sapply(enem_2019, function(x) sum(is.na(x)))
sapply(enem_2019, function(x) sum(is.nan(x)))
?apply
