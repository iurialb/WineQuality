
# Tornando os resultados reproduzíveis
set.seed(0)

# Lendo a nossa base de dados

data <- read.csv(file = "winequality-red.csv")

# Alterando a escala dos dados para melhor processamento
# Isso porque redes neurais são menos performáticas com altos valores

data <- scale(data)