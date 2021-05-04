# Quels sont les outils simlaires ?

Il existe une mulititude de solutions aujourd'hui, que nous pouvons classer en deux catégories :
- les moteurs de recherche simple-composant
- les moteurs de recherche multi-composants  

La différence entre les deux peut se résumer ainsi: les multi-composants peuvent utiliser les moteurs simple-composant pour construire des systèmes plus complexe. Les multi-composants sont naturellement moins nombreux et beaucoup plus récent.

Un dernière remarque, d'après nos recherches, la plupart des moteurs simple sont basés sur la meme technologie: [Lucene](https://lucene.apache.org/). Ils diffèrent donc par leur implementation et les features développées autour de cette brique fondamentale.

Certains moteurs intègrent de l'IA (on les qualifera de dense) tandis que d'autre ne font que de l'indexation (on les qualifera de clairsemé). La différence visible qui en découle, c'est une compréhension "profonde" de la syntaxe, comme les synonymes.


Voici donc une liste des principaux moteurs que nous avons identifiés.

#### 1. simple-composant
- Apache Solr  
[lien](https://solr.apache.org/)  
clairsemé  
open-source  
_blazing-fast, open source enterprise search platform_  

- Elasticsearch  
[lien](https://www.elastic.co/)
clairsemé (mais la nouvelle version semble aller vers le dense)  
open-source  
integration possible  
_Most popular for enterprise after Solr_    
- MeiliSearch  
[lien](https://www.meilisearch.com/)  
clairsemé  
open-source  
_Next generation search API. blazingly fast and hyper relevant search-engine that will improve your search experience._

- Algolia  
[lien](https://www.algolia.com/)  
dense (AI search) + clairsemé (search API)  
pas open-source  
connu pour simplifier le travail des développeurs  
Tarifs: 1.5$ pour 1,000 requests & INDEX up to 1,000 records  

- AWS Kendra  
[lien](https://aws.amazon.com/kendra/)  
clairsemé et dense (y compris QA)  
pas open-source  
Tarifs: 5000€/mois pour 40k requests/jour et 500k documents.

- Coveo  
[lien](https://www.coveo.com/en/products/platform)  
dense ?  
pas open-source  
Avantage: integrations a d'autre source de contenus des entreprises comme Salesforce...   
Tarifs: 1100$/mois pour 100k requests  

- Google Cloud Search  
[lien](https://workspace.google.com/products/cloud-search/)  
pas open-source  
pour de la recherche dans la galaxie google uniquement *Gmail and Drive to Docs, Sheets, Slides, Calendar, and more*  

il existe aussi ces solutions que je n'ai pas integré.
- Yext  
- You.com  

#### 2. multi-composants  

- Haystack
