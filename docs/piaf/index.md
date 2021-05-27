# PIAF

Cette partie contient toutes les informations concernant le projet Piaf.


## Qu'est que PIAF ?
PIAF signifie "Pour une IA francophone" et désigne la solution de Questions/Réponses proposée par la DINUM, et les porduits qui l'entoure. Elle s'appuie sur différentes briques technologiques :

* [PiafAnno](https://github.com/etalab/piaf) : la plateforme d'annotation collaborative permettant de recueillir des questions-réponses pour constituer un dataset d'entrainement.  
* [Le dataset de Piaf](https://www.data.gouv.fr/fr/datasets/piaf-le-dataset-francophone-de-questions-reponses/) : un dataset contenant de multiples exemples de Questions/Réponses (QR) provenant de wikipédia. Cette annotation est issue d'une annotation citoyenne. Ce dataset suit la méthodologie et le format du dataset QR anglophone [SQuAD](https://rajpurkar.github.io/SQuAD-explorer/). Vous trouverez plus de renseignements [ici](https://piaf.etalab.studio/).
* [camembert-base-squadFR-fquad-piaf](https://huggingface.co/etalab-ia/camembert-base-squadFR-fquad-piaf) : un modèle français de Questions/Réponses basé sur CamemBERT et fine-tuné sur une combinaison de trois datasets français de Questions/Réponses :
    * PIAFv1.1
    * FQuADv1.0
    * SQuAD-FR (SQuAD automatically translated to French)
* [Haystack](https://github.com/deepset-ai/haystack) : une brique open source à laquelle nous contribuons activement permettant de faire du Questions/Réponses sur une base documentaire. Elle intègre une partie "retriever" qui retrouve les meilleurs documents candidat et une brique "reader" dans laquelle le modèle piaf est intégré et qui permet de trouver la bonne réponse.
* [Piaf Agent](https://piaf.datascience.etalab.studio/piafagent/) :  C'est une barre de recherche, une interface graphique permettant d'interroger l'API de haystack afin de laisser un utilisateur poser une question et obtenir une réponse.
* [Piaf Bot](https://piafbot.chatbot.fabnum.fr/) : C'est un chatbot facile à mettre en place car il se base sur un excel. Il peut se brancher sur l'API de haystack afin d'aller plus loin que les bot classiques.


## Historique

Piaf est né en 2019 et a évolué au fil des mois. En voici donc un petit résumé :  
- Début 2019  
Début du projet : l'objectif est de créer un jeu de données en open-source pour entrainer des modèles de question-answering en français
- Été 2019  
Développement d'une plateforme collaborative afin de recueillir les contributions : [PiafAnno](https://github.com/etalab/piaf). Et création du site de présentation du projet : [Piaf](https://piaf.etalab.studio/)
- Novembre 2019  
Début de la campagne d'annotation collaborative
- Février 2020  
Publication du [Dataset 1.0](https://github.com/etalab-ia/piaf-code/raw/master/piaf-v1.0.json)
- Mai 2020   
Publication de [cet article](https://arxiv.org/abs/2007.00968) à la conférence LREC2020
- Juin 2020  
Publication du premier [Piaf QA modèle](https://huggingface.co/etalab-ia/camembert-base-squadFR-fquad-piaf) francophone sur hugginface  

- Avril 2021   
Début de l'[application Piaf](https://piaf.etalab.studio/application-piaf/), en tant que moteur de recherche d'information

## Contact
Pour toute requête, veuillez nous écrire :  
=> piaf@data.gouv.fr
