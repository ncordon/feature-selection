def random_greedy(){
    # n es el número de variables en la selección de características
    non_selected = {1,...n}
    mejor_mascara = {0,0...0}
    mejora = true

    do{
        mascaras = {}
        tasas = {}

        foreach j in non_selected{
            m = flip(mascara,j)
            mascaras.add(m)
            tasas.add(tasa(m))
        }

        umbral = alpha * (max(tasas) - min(tasas))
        mascaras.delete (which(max(tasas) - tasas > umbral))
        m = mascaras[ random{1..n} ]

        if (tasa(m) > tasa(mejor_mascara)){
            mejor_mascara = m
            non_selected.delete(j : flip(mascara,j)=m)
        }
        else{
            mejora=false
        }
    }while !non_selected.empty and mejora

    return mascara
}



def GRASP(){
    mascaras = [ random_greedy() from 1 to max_arranques ]
    mascaras = [ busqueda_local(m): m $\in$ mascaras ]
    tasas = [ tasa.clas(m): m $\in$ mascaras ]

    return mascaras [arg max tasas]
}
