############################################################################
#   PREPARA��O, ORGANIZA��O E ESTRUTURA��O DOS DADOS (PR�-PROCESSAMENTO)   #
############################################################################

# BAIXAR PACOTES
install.packages("dplyr") # Manipula��o de Dados

# OU

# BAIXAR PACOTES, CASO ELES AINDA N�O ESTEJAM BAIXADOS
if(!require(dplyr)) install.packages("dplyr") 

# CARREGAR PACOTES
library(dplyr)

# BUSCAR DIRET�RIO (PASTA COM OS ARQUIVOS)
setwd("C:/Users/joyce/Documents/microdados_enem_2019/DADOS")

#ABRIR ARQUIVO
enem2019 <- read.csv('enem_rj_2019.csv')

View(enem2019)

# EXCLUIR UMA COLUNA
enem2019$NU_ANO <- NULL

# EXCLUIR V�RIAS COLUNAS
excluir <- c("TP_ESTADO_CIVIL", "SG_UF_RESIDENCIA")
View (excluir)

enem2019 <- enem2019[  , !(names(enem2019) %in% excluir)]

View(names(enem2019))
# %in% verifica a intersec��o em duas listas ou vetores.


#RENOMEAR UMA COLUNA
enem2019 <- rename(enem2019, NOTA_COMP1 = NU_NOTA_COMP1)
#RENOMEAR V�RIAS COLUNAS
enem2019 <- rename(enem2019, NOTA_COMP2 = NU_NOTA_COMP2, NOTA_COMP3 = NU_NOTA_COMP3,
                   NOTA_COMP4 = NU_NOTA_COMP4,NOTA_COMP5 = NU_NOTA_COMP5,
                   NOTA_REDACAO = NU_NOTA_REDACAO, NOTA_CN = NU_NOTA_CN,
                   NOTA_CH = NU_NOTA_CH, NOTA_LC = NU_NOTA_LC, NOTA_MT = NU_NOTA_MT)












#VERIFICA��O DA TIPAGEM DOS ATRIBUTOS
# EXISTEM 6 TIPOS B�SICOS:
# character (caracteres)
# numeric (n�meros reais)
# integer (n�meros inteiros)
# logical (falso ou verdadeiro)
# complex (n�meros complexos)
# factor (fator: ordenar strings)
str(enem2019)
# OU
glimpse(enem2019)

#Transformando a vari�vel C�digo escola em fator
enem2019$CO_ESCOLA <- as.factor(enem2019$CO_ESCOLA)

# Verificando valores missing (Ausentes)
# NA = valores ausentes
# NAN = not a number(valor indefinido)
sapply(enem2019, function(x) sum(is.na(x)))
sapply(enem2019, function(x) sum(is.nan(x)))












#TREINEIROS
treineiros <- enem2019 %>% filter(IN_TREINEIRO==1)# 37581 treineiros

#RETIRAR TREINEIROS
vestibulandos <- enem2019 %>% filter(IN_TREINEIRO==0)

# EXCLUIR UMA COLUNA
vestibulandos$IN_TREINEIRO <- NULL

#Exportando o arquivo treineiros
write.table(treineiros, file ="treineiros.csv", sep = ",")

#CRIANDO COLUNA PARA CLASSIFICAR AS PRESEN�AS
vestibulandos["presenca"] <- vestibulandos$TP_PRESENCA_CN + vestibulandos$TP_PRESENCA_CH +
                        vestibulandos$TP_PRESENCA_LC + vestibulandos$TP_PRESENCA_MT


falta_2dias <- vestibulandos %>% filter(presenca==0) #75649 n�o compareceram nos dois dias
falta_1dia <- vestibulandos %>% filter(presenca==2) #12382 n�o compareceram em um dos dias
desclas <- vestibulandos %>% filter(presenca==6) # 119 desclassificados em um dos dias
desclas_2vezes <- vestibulandos %>% filter(presenca==8) # nenhum desclassificado nos dois dias

#SELECIONANDO APENAS OS QUE COMPARECERAM NOS DOIS DIAS.
vestibulandos_presentes <- vestibulandos %>% filter(presenca==4)


## Baixando pacote Tidyverse ##
install.packages("tidyverse")

library(tidyverse)



#Verificando valores missing
sapply(vestibulandos_presentes, function(x) sum(is.na(x)))

## Excluindo esses registros com valores ausentes ##
## Como o n�mero de valores ausentes est� igual em todas as notas
## podemos tentar dropar uma �nica nota para vermos se todas s�o exclu�das ##

vestibulandos_presentes <-drop_na(vestibulandos_presentes, NOTA_MT)

## Verificando se valores das notas ausentes foram exclu�das ##

sapply(vestibulandos_presentes, function(x) sum(is.na(x)))


## Verificando notas zero ##

nota_zero <- vestibulandos_presentes %>% filter(NOTA_REDACAO==0) #4846 notas zeros
nota_zero <- vestibulandos_presentes %>% filter(NOTA_COMP1==0) #4847 notas zeros
nota_zero <- vestibulandos_presentes %>% filter(NOTA_COMP2==0) #4846 notas zeros
nota_zero <- vestibulandos_presentes %>% filter(NOTA_COMP3==0) #4856 notas zeros
nota_zero <- vestibulandos_presentes %>% filter(NOTA_COMP4==0) #4851 notas zeros
nota_zero <- vestibulandos_presentes %>% filter(NOTA_COMP5==0) #29099 notas zeros


nota_zero <- vestibulandos_presentes %>% filter(NOTA_MT==0) #34 notas zeros
nota_zero <- vestibulandos_presentes %>% filter(NOTA_CH==0) #120 notas zeros
nota_zero <- vestibulandos_presentes %>% filter(NOTA_CN==0) #25 notas zeros
nota_zero <- vestibulandos_presentes %>% filter(NOTA_LC==0) #57 notas zeros

redacao_sem_prob <- vestibulandos_presentes %>% filter(TP_STATUS_REDACAO==1) # reda��es sem problemas


## Excluindo coluna presenca pois todos valores = 4 ##

vestibulandos_presentes$presenca <- NULL

## Exportando arquivo tratado ##

write.table(vestibulandos_presentes, file = "enem2019_tratado.csv", sep = ",")

## Finalizado em 12/07 ##

#VERIFICA��O DA TIPAGEM DOS ATRIBUTOS
str(enem2019)

#SUBSTITUINDO NA POR 0 PARA N�O DAR PROBLEMAS NA AN�LISE ESTAT�STICA
vestibulandos_presentes$NOTA_COMP1[which(is.na(vestibulandos_presentes$NOTA_COMP1))] <- 0
vestibulandos_presentes$NOTA_COMP2[which(is.na(vestibulandos_presentes$NOTA_COMP2))] <- 0
vestibulandos_presentes$NOTA_COMP3[which(is.na(vestibulandos_presentes$NOTA_COMP3))] <- 0
vestibulandos_presentes$NOTA_COMP4[which(is.na(vestibulandos_presentes$NOTA_COMP4))] <- 0
vestibulandos_presentes$NOTA_COMP5[which(is.na(vestibulandos_presentes$NOTA_COMP5))] <- 0
vestibulandos_presentes$NOTA_REDACAO[which(is.na(vestibulandos_presentes$NOTA_REDACAO))] <- 0

#Verificando valores missing
sapply(vestibulandos_presentes, function(x) sum(is.na(x)))

# EXCLUIR A COLUNA PRESEN�A
vestibulandos_presentes$presenca <- NULL

#EXPORTAR ARQUIVO TRATADO
write.table(vestibulandos_presentes, file ="enem2019_tratado.csv", sep = ",")

