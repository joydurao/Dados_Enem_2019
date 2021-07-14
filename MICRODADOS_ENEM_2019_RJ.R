# Instalando pacotes 
install.packages("dplyr")
library(dplyr)

library(data.table)

# Filtrando apenas os dados do Estado do Rio de Janeiro
enem_rj_2019 <- ENEM_2019 %>% filter(SG_UF_RESIDENCIA =="RJ")

# Selecionando as colunas de interesse
enem_rj_2019 <- select(enem_rj_2019, NU_INSCRICAO, NU_ANO, NO_MUNICIPIO_RESIDENCIA,
                       SG_UF_RESIDENCIA, NU_IDADE, TP_SEXO, TP_ESTADO_CIVIL, TP_COR_RACA,
                       TP_NACIONALIDADE, TP_ESCOLA, TP_ENSINO, IN_TREINEIRO, CO_ESCOLA,
                       TP_PRESENCA_CN, TP_PRESENCA_CH, TP_PRESENCA_LC, TP_PRESENCA_MT,
                       NU_NOTA_CN, NU_NOTA_CH, NU_NOTA_LC, NU_NOTA_MT, TP_LINGUA,
                       TP_STATUS_REDACAO, NU_NOTA_COMP1, NU_NOTA_COMP2, NU_NOTA_COMP3,
                       NU_NOTA_COMP4, NU_NOTA_COMP5, NU_NOTA_REDACAO)

View(enem_rj_2019)


#EXPORTAR ARQUIVO
write.table(enem_rj_2019, file ="enem_rj_2019.csv", sep = ",")
