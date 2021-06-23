# Performance : Piaf Search plus fort que Google

### Domaine de l'étude : service-public.fr
La plupart des utilisateurs de service public.fr arrivent via Google. Il était donc important pour nous de mesurer la pertinence des résultats de Piaf Search, par rapport à ceux de Google.
Nous avons donc évalué les performances d'une pipeline de recherche qui inclu une recherche google comme point de départ, à celle faite maison en utilisant l'algorithme BM25. Nous avons aussi posé les questions directement dans le moteur de recherche de [service-public.fr](https://service-public.fr) à titre de comparaison.
 

### Détail de l'évaluation
Dans un premier temps, les 4 personnnes de l'équipe Piaf ont annoté à la main la centaine de texte les plus consultés sur le site de service-public.fr. Notre dataset d'évaluation (disponible sur demande) est donc un ensemble de triplet: questions, réponses, texte de service-public.fr.   
Une fois cette étape d'annotation finie, nous avons lancé nos tests: pour chaque question, nous avons lancé une recherche google afin de récupérer les premiers liens qui pointaient vers service-public.fr et fait la même chose avec notre moteur de recherche basé sur BM25.


### Résultats 
Les performances sont légèrement à l'avantage de Piaf Search:

#### Si on ne considère que le premier résultat
| Retriever type | Accuracy |
| -------- | -------- |
| Google | 0.87|
| Piaf (BM25)     | 0.90     |
| Service-public  | 0.02     |

#### Si on considère les trois premiers résultats  
| Retriever type | Accuracy |
| -------- | -------- |
| Google|     0.91|
| Piaf (BM25)     | 0.93     |
| Service-public  | 0.10     |

Plus d'information [ici](https://github.com/etalab-ia/piaf-ml/pull/102)
  
  ## Conclusion
Si on cherche à résumer ces résultats, on peut dire que pour l'indexation de service-public.fr :
- environ 9 fois sur 10, le bon texte est retrouvé
- Piaf Search est légèrement plus performant que Google
- Service-public est incapable aujourd'hui de traiter les questions en langague naturel
