##########################################################################
### Funcion busqueda local del primer mejor
###     Para un data frame devuelve para el clasificador 3-knn el conjunto
###     de caracteristicas que se obtienen de aplicar la busqueda local del
###     primer mejor
###
###
###     get.init      Es el generador de soluciones iniciales (por defecto
###                   aleatorias, pero puede pasarsele un GRASP p.e.)
##########################################################################

SCH.BL <- function(data, gen.init = random.init){
  n <- ncol(data)
  n <- n-1
  class <- unique(data$class)
  num.class <- length(class)
  num.ants <- OCH.num.ants
  alpha <- OCH.alpha
  beta <- OCH.beta
  global.evap <- OCH.evaporation
  
  # q0
  prob.trans <- SCH.BL.trans.prob
  # phi
  local.evap <- 0.2
  mask.best <- rep(0,n)
  tasa.best <- 0
  
  # Inicializacion de parametros
  trail.features <- rep(1e-6, n)
  trail.num.features <- rep(1.0/n, n)
  # Completar
  heuristic.info <- c()
  
  next.feature <- function(path){
    values <- lapply(1:length(path), function(x){
      value <- 0
      if (path[x] == 0){
        value <- trail.features[x]**alpha * heuristic.info[x]**beta
      }
    })
    
    which.max(values)
  }
  
  for(i in 1:max.eval){
    # Inicializacion de los caminos seguidos por cada hormiga
    paths <- lapply(1:num.ants, sample(c(1,rep(0,n-1))))
    # Numero de caracteristicas que escogera cada hormiga
    num.features <- lapply(runif(num.ants), function(x){
      index <- whichtrail.num.features <= x
      
      if (any(index)){
        num.f <- max(index)
      }
      else{
        num.f <- n
      }
      
      num.f
    })
    
    # Ya he escogido la caracteristica inicial
    num.features <- num.features - 1
    
    for(k in 1:num.ants){
      if (num.features[k] > 0){  
        selected <- next.feature(paths[[i]])
        
        paths[[i]][selected] <- 1

        # Actualizacion local de feromona
        
        num.features[k] <- num.features[k] - 1
      }
    }
    
    # Buscamos la mejor solucion de todas las encontradas por las hormigas
    paths.score <- lapply(paths, function(p){tasa.clas(data, p)})
    where.max <- which.max(paths.score)
    
    if(paths.score[where.max] > tasa.best){
      mask.best <- paths[where.max]
    }
    
    # Actualizacion global de feromona
       
  }
  mask.best
}