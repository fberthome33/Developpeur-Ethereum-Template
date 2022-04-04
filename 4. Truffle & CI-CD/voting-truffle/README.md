# Bienvenue sur le Projet - Système de vote 2!

Le but de ce projet est d'ajouter les tests unitaires sur le projet Voting.sol.


# Fichier

Pour ce projet un fichier de tests a été créé : voting-truffle/test/voting.test.js. 
Ce fichier est découpé par test de méthode.

## Méthodologie

Les tests testent :
- l'accessibilité  : si la méthode est accessible seulement par le owner du contrat ou un voter.
- les controles de condition (requirer) sont vérifiés
- les events générés sont testés

## Test des WorkflowStatusChange

Pour factoriser le code, le choix de créer un tableau de paramètre a été fait.
| Méthode  Testée | Status Before | Status Message | Status After | 
|----------------|-------------------------------|-----------------|------------|
| startProposalsRegistering | RegisteringVoters | `'Registering proposals cant be started now'` | ProposalsRegistrationStarted | 
| endProposalsRegistering | ProposalsRegistrationStarted | `'Registering proposals havent started yet'` | ProposalsRegistrationEnded | 
| startVotingSession | ProposalsRegistrationEnded | `'Registering proposals phase is not finished'` | VotingSessionStarted | 
| endVotingSession | VotingSessionStarted | `'Voting session havent started yet` | VotingSessionEnded | 

## Lancement des tests
Lancer la commande
```  
truffle test 
```

## Couverture des testsLancer la commande
```  
truffle test 
```