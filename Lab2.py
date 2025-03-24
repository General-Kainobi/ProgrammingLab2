import random
import numpy as np
import matplotlib.pyplot as plt

array= np.array([random.randint(1, 100) for i in range(10)])
print(array)
print(np.any(array > 50))#se qualche elemento è maggiore di 50
print(np.all(array > 50))# se TUTTI gli elementi sono maggiori di 50
print(array[array<50])#elementi minori di 50
print(np.mean(array))#media
print(np.cumsum(array))#somma cumulativa(a[0], a[0]+a[1], a[0]+a[1]+a[2], ...)
print(np.diff(array))#differenza tra elementi successivi
print(np.argmax(array))#indice dell'elemento più grande
"""
Esistono i valori NaN (Not a Number) e Inf (infinito) dove nan si può usare per
gestire i dati in modo oopportuno poiche non genera errori nei calcoli numerici
ad esempio: posso mettere uguale a nan i valori che voglio eliminare da un dataset

Numeri Float
 - In python le operazioni con i numeri float sono approssimate e non esatte
   infatti 0.1 + 0.2 non è uguale a 0.3 ma a 0.30000000000000004, per questo
    non si possono usare gli operatori di confronto per i numeri float ma si
    devono usare delle tolleranze
 - Per confrontare due numeri float si può usare la funzione np.isclose(a, b)
    che restituisce True se a e b sono vicini entro una tolleranza che si può 
    cambiare con il parametro rtol e atol
 - np.isclose(a, b, rtol=1e-05, atol=1e-08)
    - rtol = relative tolerance ossia la tolleranza relativa ad a e b

Vectorization
- Per velocizzare i calcoli si possono usare le operazioni vettoriali
- Si possono fare operazioni tra array di numpy e scalari
- Anche per operazione tra array di dimenisioni diverse




"""