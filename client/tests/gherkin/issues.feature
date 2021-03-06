Feature: Fonctionnalités liées aux issues
    Fonctionnalités diverses et variées liées à la gestion des issues

    Scenario: L'utilisateur va sur la page backlog
        Given L'utilisateur est sur la page d'acceuil
        When Il clique sur le bouton "Backlog" de la barre de navigation
        Then Le bouton "Backlog" est coloré
        And Il est dirigé vers la page Backlog

    Scenario: L'utilisateur crée une nouvelle issue
        Given L'utilisateur est sur la page backlog d'un projet
        When Il clique sur le bouton "Mode édition"
        Then Un bouton "+" est affiché
        And Il clique sur une le bouton "+"
        Then Un formulaire s'affiche
        Then Il remplit chacun des champs
        And Il clique sur valider
        Then Le formulaire se ferme
        And La nouvelle issue est affichée

    Scenario: L'utilisateur modifie une issue
        Given L'utilisateur est sur la page backlog d'un projet
        When Il clique sur le bouton "Mode édition"
        And Il clique sur une issue
        Then Un formulaire s'affiche
        Then Il remplit chacun des champs
        And Il clique sur valider
        Then Le formulaire se ferme
        And L'issue est modifiée

    Scenario: L'utilisateur supprime une issue
        Given L'utilisateur est sur la page backlog d'un projet
        When Il clique sur le bouton "Mode édition"
        And Il clique sur une issue
        Then Un formulaire s'affiche
        Then Il clique sur supprimer
        Then Une popup s'affiche
        Then Il clique sur confirmer
        Then L'issue n'est plus affichée

    Scenario: L'utilisateur visualise les informations d'une issue
        Given L'utilisateur est sur la page backlog d'un projet
        And Il y a au moins une issue sur la page
        Then Il doit pouvoir voir l'ID, le titre, la description, la difficulté et l'importance
