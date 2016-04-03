##########################################################################
### Función enfriamiento simulado
###     Para un data frame devuelve para el clasificador 3-knn el conjunto
###     de características que se obtienen de aplicar enfriamiento simulado
###
##########################################################################

ES <- function(data){
  n <- ncol(data)
  n <- n-1
  mask <- sample(0:1, n, replace=TRUE)
  mask.best <- mask
  tasa.best <- tasa.clas(data, mask.best)
  
  # Parámetros del enfriamiento simulado
  max.eval <- 15000
  max.vecinos <- 10*n
  max.exitos <- 0.1*max.vecinos
  mu <- 0.3
  phi <- 0.3
  # Nota: los mejores valores probados para estos parámetros han sido 0.05 y 0.05
  
  
  t.actual <- mu*tasa.best/-log(phi, base=exp(1))
  t.final <- 1e-3
  
  # Comprobamos que la temperatura final sea menor que la inicial
  # y la ajustamos en caso contrario
  while (t.final >= t.actual){
    t.final <- t.final * 1e-3
  }
  
  beta <- (t.actual - t.final)/((max.eval/max.vecinos)*t.actual*t.final)
  
  n.eval <- 0
  n.vecinos <- 0
  n.exitos <- 1
  
  # Nueva iteración
  # print ("Nueva iteración")
  
  while(n.eval < max.eval & n.exitos>0 & t.actual > t.final){
    n.vecinos <- 0
    n.exitos <- 0
    
    # Un enfriamiento
    while(n.vecinos < max.vecinos
          & n.exitos < max.exitos
          & n.eval < max.eval){
      
      m <- mask
      
      # Generamos un vecino
      j <- sample(1:n,1)
      m[j] <- (m[j]+1)%%2
      
      tasa.actual <- tasa.clas(data, m)
      delta <- tasa.actual - tasa.best
      u <- runif(1, 0.0, 1.0)
      
      if (delta > 0 || u <= exp(delta/t.actual)){
        mask <- m
        tasa.best <- tasa.actual
        n.exitos <- n.exitos + 1
        
        if (delta > 0){
          mask.best <- m
        }
        
      }
      
      n.vecinos <- n.vecinos + 1
      n.eval <- n.eval + 1
    }
    t.actual <- t.actual/(1 + beta*t.actual)
    # Depuración
    #cat("\n Temperatura actual: ", t.actual)
    #cat("\n Número de éxitos: ", n.exitos)
    #cat("\n Número de vecinos generados ", n.vecinos)
  }
  mask.best
}
