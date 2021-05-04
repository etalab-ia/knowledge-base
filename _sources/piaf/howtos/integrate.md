# Intégrer Piaf dans mon site

Tout d'abord, si vous etes interessés, nous pouvons vous accompagner  pour intégrer Piaf sur votre plateforme (barre de recherche, chatbot...). Cependant, si vous etes à l'aise, vous pouvez l'installer sans notre accompagnement puisque tous nos codes sont open-sources et faciles à comprendre.


### Le déroulement se fait en 3 étapes:
1. **Extraire vos données** qui contiennent les informations détinées à vos utilisateurs, et les mettre au format SQuAD (voir plus loin)
1. **Nous envoyer ces données**. Nous allons ensuite **créer pour vous une application dédiée (une API)** et vous mettre à disposition ses points d'accès. Cela nous prend en général 1 semaine.
1. **Brancher votre produit à cette API**. Ce sont les développeurs de votre site qui devront se charger de brancher les points d'accès (endpoint) en suivant la documentation Swagger qui leur sera fournie. Cette étape prend en général moins d'une journée.

### Quelques remarques:
- Si vous n'avez pas encore de barre de recherche, il vous faudra peut-etre commencer par identifier les informations que vous souhaiter extraire. Vos responsables métiers seront les plus à meme de savoir ce que vos utilisateurs souhaitent chercher sur votre site.
- Si vous avez déjà un moteur de recherche, mais que vous voulez essayer celui de Piaf, rien de plus simple. Vous n'aurez qu'à changer les endpoints. Nous recommandons de  tester la satisfaction de vos usagers avec Piaf sur une partie de votre traffic. Cela vous permettra de savoir de combien Piaf améliore la recherche sur votre site
- En fonction de votre traffic, nous ne serons pas forcément en mesure de pouvoir tout héberger. Nous pourrons alors vous accompagner sur l'infrastructure à mettre en place.


## Faut-il que j'entraine mon propre modèle d'IA ?
Pour utiliser PIAF, il n'y a pas besoin d'entrainer un modèle sur vos données. Nous récupérons vos données et ajustons les paramètres des différents composants du système pour votre cas d'usage.  
![architecture](../../assets/piaf/archi_piaf.png)  
Si vous avez une quantité de pairs Question-Réponse conséquente, nous pourrons envisager le fine-tuning de notre modèle avec vos données. Cette procedure pourrait améliorer la performance du système, surtout quand vos données utilsent une syntaxe particulière (ex: données juridiques...).

## Quelles données envoyer pour proposer un cas d'usage ?
Vos données doivent comporter les informations suivantes:
- Une liste de contextes : C'est votre base de connaissance. Les contextes sont des textes. Il n'y a pas de contrainte sur la longueur du texte, PIAF se charge d'optimiser sa longueur pour votre cas d'usage.  
- Des questions et des réponses pour effectuer l'évaluation. 100 minimum. Il peut y avoir plusieurs questions par contexte et plusieurs réponses par questions.  

![schema](../../assets/piaf/work_with_piaf_onboarding.png)

## Quel format pour les données ?
 Idéalement vos données sont envoyées sous la forme d'un json structuré de la manière suivante (en suivant le format SQuAD v2.0) :
 ```json
 {
  "version": "v1.0",
  "data": [{
    'title': 'Immatriculer un véhicule d'occasion', #OBLIGATOIRE : titre de votre chapitre (un chapitre peut contenir plusieurs contextes)
    'theme': 'Véhicule', #FACULTATIF : Metadonnées d'arborescence. Si ces données sont disponibles, elles peuvent améliorer les performances de PIAF en permettant à l'utilisateur de restreindre le champ de sa demande
    'link': 'www.link_to_title.com',
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
