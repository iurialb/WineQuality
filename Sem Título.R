
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

# Padronizando o data frame, onde o x será as features (variável independente) e o y a target (variável dependente)
train_x <- data.frame(train[1:11])
train_y <- data.frame(train[12])

# Fazer o mesmo para a base de teste
test_x <- data.frame(test[1:11])
test_y <- data.frame(test[12])

# Realizar a transposição da matriz para fins didáticos
train_x <- t(train_x)
train_y <- t(train_y)

test_x <- t(test_x )
test_y <- t(test_y)

# Desenvolvendo a Arquitetura de Rede

getLayerSize <- function(X, y, hidden_neurons) {
  n_x <- dim(X)[1] #quantidade de linhas de x = neurônios da camada de entrada
  n_h <- hidden_neurons #quantidade de neurônios na camada escondida
  n_y <- dim(y)[1] #quantidade de linhas de y = neurônios da camada de saída
  
  size <- list("n_x" = n_x,
               "n_h" = n_h,
               "n_y" = n_y)
  
  return(size)
}

# Aplicando a função de criação de arquitetura
# O valor de '4' para a camada escondida é escolhida de forma arbitrária

layer_size <- getLayerSize(train_x, train_y, hidden_neurons = 4)
layer_size

# Inicializando os Parâmetros
# Com base na arquitetura de rede montada iremos inicializar os parâmetros (pesos) randomicamente.


initializeParameters <- function(X, layer_size){
  
  n_x <- layer_size$n_x
  n_h <- layer_size$n_h
  n_y <- layer_size$n_y
  
  W1 <- matrix(runif(n_h * n_x), nrow = n_h, ncol = n_x, byrow = TRUE) * 0.01
  W2 <- matrix(runif(n_y * n_h), nrow = n_y, ncol = n_h, byrow = TRUE) * 0.01
  
  params <- list("W1" = W1,
                 "W2" = W2)
  
  return (params)
}








