
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

# Aplicando a função de inicializar os pesos

init_params <- initializeParameters(train_x, layer_size)

# Função de ativação
# Criamos a função com base na função sigmóide

sigmoid <- function(x){
  return(1 / (1 + exp(-x)))
}

# Forward Propagation
# Agora com todas as informações dos pesos e estrutura da rede, iniciamos o processo de geração de resultados. A multiplicação de matrizes será feita por meio do operador %*%. 

forwardPropagation <- function(X, params, layer_size){
  
  n_h <- layer_size$n_h
  n_y <- layer_size$n_y
  
  W1 <- params$W1
  W2 <- params$W2
  
  
  Z1 <- W1 %*% X
  A1 <- sigmoid(Z1)
  Z2 <- W2 %*% A1
  A2 <- sigmoid(Z2)
  
  cache <- list("Z1" = Z1,
                "A1" = A1, 
                "Z2" = Z2,
                "A2" = A2)
  
  return (cache)
}

# Aplicando de fato a função de Forward Propagation

fwd_prop <- forwardPropagation(train_x, init_params, layer_size)

# O modelo até o momento não possui métricas para calcular a previsibilidade dos resultados
# Isso ocorre, porque utilizamos valores aleatórios nos pesos para saber o quanto estamos errando
# Nesse sentido, vamos agora utilizar a função custo para realizar o processo de Back propagation com o Erro Quadrático Médio

computeCost <- function(y, cache) {
  
  m <- dim(y)[2]
  
  A2 <- cache$A2
  
  cost <- sum((y-A2)^2)/m
  
  return (cost)
}

cost <- computeCost(train_y, fwd_prop)

# Função de Back Propagation

backwardPropagation <- function(X, y, cache, params, layer_size){
  
  m <- dim(X)[2]
  
  n_x <- layer_size$n_x
  n_h <- layer_size$n_h
  n_y <- layer_size$n_y
  
  A2 <- cache$A2
  A1 <- cache$A1
  W2 <- params$W2
  
  
  dZ2 <- A2 - y
  dW2 <- 1/m * (dZ2 %*% t(A1)) 
  
  
  dZ1 <- (t(W2) %*% dZ2) * (1 - A1^2)
  dW1 <- 1/m * (dZ1 %*% t(X))
  
  
  grads <- list("dW1" = dW1, 
                "dW2" = dW2)
  
  return(grads)
}

# Atualização dos pesos
# A atualização de pesos é feita com base nos cálculos anteriores e na taxa de aprendizagem.

updateParameters <- function(grads, params, learning_rate){
  
  W1 <- params$W1
  W2 <- params$W2
  
  dW1 <- grads$dW1
  dW2 <- grads$dW2
  
  
  W1 <- W1 - learning_rate * dW1
  W2 <- W2 - learning_rate * dW2
  
  updated_params <- list("W1" = W1,
                         "W2" = W2)
  
  return (updated_params)
}

# Treina o modelo
## Quais as etapas?
# - Arquitetura da rede.
# - Inicializa um vetor de historia da função custo para guardar resultados.
# - Faz foward loop.
# - Calcula perda.
# - Atualiza parâmetros.
# - Usa os novos parâmetros.

# Entra o conceito de épocas (EPOCHS)
# Basicamente diz respeito ao modelo fazer um "vai e volta" para medida de treinamento até achar o valor mais próximo do real

trainModel <- function(X, y, num_iteration, hidden_neurons, lr){
  
  layer_size <- getLayerSize(X, y, hidden_neurons)
  init_params <- initializeParameters(X, layer_size)
  
  cost_history <- c()
  
  for (i in 1:num_iteration) {
    fwd_prop <- forwardPropagation(X, init_params, layer_size)
    cost <- computeCost(y, fwd_prop)
    back_prop <- backwardPropagation(X, y, fwd_prop, init_params, layer_size)
    update_params <- updateParameters(back_prop, init_params, learning_rate = lr)
    init_params <- update_params
    cost_history <- c(cost_history, cost)
    
  }
  
  model_out <- list("updated_params" = update_params,
                    "cost_hist" = cost_history)
  
  return (model_out)
}

# Aplica o treinamento

EPOCHS = 100
HIDDEN_NEURONS = 40
LEARNING_RATE = 0.01

train_model <- trainModel(train_x, train_y, hidden_neurons = HIDDEN_NEURONS, num_iteration = EPOCHS, lr = LEARNING_RATE)

# Testa os resultados

layer_size <- getLayerSize(test_x, test_y, HIDDEN_NEURONS)
params <- train_model$updated_params
fwd_prop <- forwardPropagation(test_x, params, layer_size)
y_pred <- fwd_prop$A2
compare <- rbind(y_pred,test_y)

# Verifica a função custo

plot(train_model$cost_hist)