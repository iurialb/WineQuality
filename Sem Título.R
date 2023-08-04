
# Tornando os resultados reproduzíveis
set.seed(0)

# Lendo a nossa base de dados

data <- read.csv(file = "winequality-red.csv")

# Alterando a escala dos dados para melhor processamento
# Isso porque redes neurais são menos performáticas com altos valores
# Com isso, alteramos os dados, mas utilizando o 'scale' novamente no final fará com que os dados retornem ao parâmetro inicial

data <- scale(data)

# Criando a base de treino
# Pra isso, utilizaremos 80% da nossa base original para realizar os testes e observar se o teste possui uma boa previsão dos outros 20%.

train_test_split_index <- nrow(data)*0.8

# Incluindo apenas a parcela de treino em um objeto
train <- data.frame(data[1:train_test_split_index,])

# Incluindo o total junto com a base de treinamento
test <- data.frame(data[(train_test_split_index+1): nrow(data),])
