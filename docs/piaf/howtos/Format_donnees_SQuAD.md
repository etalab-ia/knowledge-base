# Format données SQuAD

## Qu'est que PIAF ? 
PIAF désigne la solution de Question Réponse proposée par la DINUM. Elle s'appuie sur différentes briques technologiques : 

* [Le dataset de Piaf](https://www.data.gouv.fr/fr/datasets/piaf-le-dataset-francophone-de-questions-reponses/) : un dataset contenant de multiples exemples de Questions Réponses (QR) provenant de wikipédia. Cette annotation est issue d'une annotation citoyenne. Ce dataset suive la methodologie et le format du dataset QR anglophone [SQuAD](https://rajpurkar.github.io/SQuAD-explorer/). Vous trouverez plus de renseignements [ici](https://piaf.etalab.studio/).
* [camembert-base-squadFR-fquad-piaf](https://huggingface.co/etalab-ia/camembert-base-squadFR-fquad-piaf) : un modèle français de Question Réponses basé sur CamemBERT et fine-tuné sur une combinaison de trois datasets français de Question Réponse:
    * PIAFv1.1
    * FQuADv1.0
    * SQuAD-FR (SQuAD automatically translated to French)
* [Haystack](https://github.com/deepset-ai/haystack) : une brique open source à laquelle nous contribuons activement permettant de faire du question réponse sur une base documentaire. Elle intègre une partie retriever qui retrouve les meilleurs documents candidat et une brique reader dans laquelle le modèle piaf est intégré et qui permet de trouver la bonne réponse. 
* [Piaf Agent](https://piaf.datascience.etalab.studio/piafagent/) et [Piaf Bot](https://piafbot.chatbot.fabnum.fr/) : des interfaces graphique permettant d'interroger l'API de haystack et de permettre à l'utilisateur de poser une question et d'obtenir une réponse. 

## Comment nous utilisons PIAF ? 
Pour utiliser PIAF, il n'y a pas besoin d'entrainer un modèle sur vos données. Nous récupérons vos données et ajustons les paramètres des différents composants du système pour votre cas d'usage. 

Si vous avez une quantité de pairs Question-Réponse conséquente, nous pourrons envisager le fine-tuning de notre modèle avec vos données. Cette procedure pourrait améliorer la performance du système.

## Quelles données envoyer pour proposer un cas d'usage ? 
Vos données doivent comporter les informations suivantes: 
- Une liste de contextes : C'est votre base de connaissance. Les contextes sont des textes. Il n'y a pas de contrainte sur la longueur du texte, PIAF se charge d'optimiser sa longueur pour votre cas d'usage.  
- Des questions et des réponses pour effectuer l'évaluation. 100 minimum. Il peut y avoir plusieurs questions par contexte et plusieurs réponses par questions.  

![schema](../../assets/piaf/work_with_piaf_onboarding.png)

## Sous quel format envoyer les données ? 
 Idéalement vos données sont envoyées sous la forme d'un json structuré de la manière suivante (en suivant le format SQuAD v2.0) :
 ```json
 {
  "version": "v1.0",
  "data": [{
    'title': 'Immatriculer un véhicule d'occasion', #OBLIGATOIRE : titre de votre chapitre (un chapitre peut contenir plusieurs contextes)
    'theme': 'Véhicule', #FACULTATIF : Metadonnées d'arborescence. Si ces données sont disponibles, elles peuvent améliorer les performances de PIAF en permettant à l'utilisateur de restreindre le champ de sa demande 
    'Dossier': "Carte grise (certificat d'immatriculation)", #FACULTATIF : Metadonnées d'arborescence. #FACULTATIF : Metadonnées d'arborescence.
    'id': 'F1050', #FACULTATIF : Metadonnées d'arborescence.
    'paragraphs': [{
        'context': "Carte grise:..." #C'est le contenu de votre base de connaissance 
        'qas': [ #Si vous n'avez pas d'annotation, laissez une liste vide
            {'question':"J'ai acheté ...?"
             'answers': [ #Si vous n'avez pas de réponse annotée, laissez une liste vide
                    {
                  "text": "100 000", #La réponse à la question. La réponse se trouve dans le context. C'est un ensemble de mots continu 
                  "answer_start": 472 #FACULTATIF Le token du début de la réponse. 
                }
             ]
             "is_impossible": False #True s'il n'y a pas de réponse possible, ou pas de réponse annoté. False dans les autres cas. 
            }]
        }]
    }]
 ```
 
Vous pouvez aussi nous envoyer vos données sous une autre forme (.csv par exemple) et nous nous occupons de les convertir pour vous. 

## Retour de l'évaluation
Nous allons faire lire vos textes à notre application. Ensuite, nous allons lui poser les 100 questions que vous nous avez fourni et comparer les réponses qui vont en sortir avec celles que vous nous aurez fourni. Nous serons alors capable de vous dire à quel taux de réponse notre application est capable de répondre a votre cas s'usage.
