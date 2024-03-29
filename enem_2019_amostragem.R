######################
###   AMOSTRAGEM   ###
######################

#BAIXAR PACOTES, CASO ELES AINDA NÃO ESTEJAM BAIXADOS
if(!require(dplyr)) install.packages("dplyr") 
if(!require(sampling)) install.packages("sampling")
if(!require(TeachingSampling)) install.packages("TeachingSampling")


#CARREGAR PACOTES
library(dplyr)
library(sampling)
library(TeachingSampling)


# BUSCAR DIRETÓRIO (PASTA COM OS ARQUIVOS)
setwd("~/microdados_enem_2019/DADOS")

# ABRIR ARQUIVO
enem2019_tratado <- read.csv('enem2019_tratado.csv', sep = ",")

View(enem2019_tratado)








# AMOSTRAGEM ALEATÓRIA SIMPLES EM Niterói
enem_niteroi <- enem2019_tratado %>% filter(NO_MUNICIPIO_RESIDENCIA=="Niterói")

# CRIANDO AMOSTRAS ALEATÓRIAS #8728 num vestibulandos niteroi
set.seed(1) # comando permite não alterar a aleatoriedade qdo processar mais de uma vez.
amostra <- sample(c(0,1), 8728, replace = TRUE, prob=c(0.8,0.2))
summary(as.factor(amostra))
prop.table(table(amostra))


## Escolhendo 20% da amostra do enem_niteroi
## O comando abaixo puxará todas as linhas do enem_niterói mas que 
## possuam amostra = 1 (referente aos 20%) ##
amostraniteroi <- enem_niteroi[amostra==1,  ]
dim(amostraniteroi)








###  AMOSTRAGEM SISTEMÁTICA  ###
#Criando o vetor
set.seed(2)
amostra <- S.SY(8728, 100)
amostra
dim(amostra)

# AMOSTRAGEM EM CAMPINAS
enem_niteroi <- enem2019_tratado %>% filter(NO_MUNICIPIO_RESIDENCIA=="Niterói")

#Relacionando com enem_niteroi
amostraniteroi2 <- enem_niteroi[amostra,]






#### AMOSTRAGEM ESTRATIFICADA ######

# AMOSTRAGEM EM CAMPINAS
enem_niteroi <- enem2019_tratado %>% filter(NO_MUNICIPIO_RESIDENCIA=="Niterói")


#AMOSTRAGEM ESTRATIFICADA EM Niterói POR RAÇA
summary(as.factor(enem_campinas$TP_COR_RACA))
prop.table(table(enem_campinas$TP_COR_RACA))

#ALTERANDO NÚMERO PELA RAÇA
enem_campinas$TP_COR_RACA[enem_campinas$TP_COR_RACA==0] <- "Não definido"
enem_campinas$TP_COR_RACA[enem_campinas$TP_COR_RACA==1] <- "Branca"
enem_campinas$TP_COR_RACA[enem_campinas$TP_COR_RACA==2] <- "Preta"
enem_campinas$TP_COR_RACA[enem_campinas$TP_COR_RACA==3] <- "Parda"
enem_campinas$TP_COR_RACA[enem_campinas$TP_COR_RACA==4] <- "Amarela"
enem_campinas$TP_COR_RACA[enem_campinas$TP_COR_RACA==5] <- "Indígena"

summary(as.factor(enem_campinas$TP_COR_RACA))
prop.table(table(enem_campinas$TP_COR_RACA))

#UTILIZANDO APROXIMADAMENTE 10% DE CADA COR/RAÇA (ESTRATO)
#Cuidado com a ordem! Fazer a análise antes.
ordem_amostras <- strata(data=enem_campinas,
                           stratanames=c("TP_COR_RACA"),size=c(1, 2, 3, 4, 5, 6), method="srswor")

summary(as.factor(ordem_amostras$TP_COR_RACA))
summary(as.factor(enem_campinas$TP_COR_RACA))


amostracampinas3 <- strata(data=enem_campinas,
               stratanames=c("TP_COR_RACA"),size=c(751, 365, 151, 21, 5, 28), method="srswor")
#srswor: amostra simples sem reposição
#srswr: com reposição
summary(as.factor(amostracampinas3$TP_COR_RACA))











###  AMOSTRAGEM POR CONGLOMERADO (AGRUPAMENTO)  ###

enem_campinas <- enem2019_tratado %>% filter(NO_MUNICIPIO_RESIDENCIA=="Campinas")
escolas_publicas <- enem_campinas %>% filter(TP_ESCOLA==2)

# 187 escolas públicas de Campinas
set.seed(3)
amostracampinas4 <- cluster(escolas_publicas, clustername = c("CO_ESCOLA"), size=19, method=c("srswor" ))
summary(as.factor(amostracampinas4$CO_ESCOLA))

# Testando os resultados
teste <- enem_campinas %>% filter(CO_ESCOLA==35903875)












