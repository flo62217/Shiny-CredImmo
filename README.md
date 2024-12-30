# Shiny-CredImmo
Projet R Shiny simulation de crédit immobilier

Bonjour, Bienvenu dans notre projet. Pour pouvoir accéder au simulateur de crédit, il suffit juste de lancer l'application Rshiny nommé app.R.
Il est fortement recommandé d'utiliser l'application en plein écran, afin d'avoir la meilleur expérience.
Voici les consignes qui ont été donné, en vous souhaitant une joyeuse simulation. 

On construit un simulateur de crédit immobilier: les paramètres en entrée seront

    la durée du crédit en années

    le taux d’intérêt

    le taux d’assurance

    le montant du projet

    le montant de l’apport personnel

    les revenus de l’emprunteur 1 et de l’emprunteur 2 (mettre à zéro si un seul emprunteur): revenu mensuel net et nombre de mois.

    le montant des frais de dossiers et autres frais bancaires (qui entrent en compte dans le calcul du taeg)

Les outputs seront :

    le montant des mensualités et le taux d’endettement correspondant

    le cout total du crédit, le cout total des assurances, le cout total des intérêts.

    le tableau d’amortissement (dans un DataTableOutput)

    le taeg

On ajoutera un bouton de téléchargement permettant de télécharger le tableau d’amortissement
Détails techniques:

    Commencer par consruire une fonction calcule_mensualite qui calcule le montant des mensualités en fonction du montant à emprunter, du taux d’intérêt et de la durée du prêt (attention, le taux d’intérêt mensuel à considérer ici est le taux actuariel, c’est à dire le taux annuel divisé par 12 )

    Construire ensuite une fonction tableau_amortissement. Ce tableau devra se présenter sous l’une des deux formes évoquées ici:https://www.cbanque.com/credit/tableau-amortissement.php Pour le construire, on pourra procéder de manière itérative, en calculant pour chaque mois le capital restant dû, les intérêt et les assurances (sur le capital restant du). A la fin, on recalculera les mensualités de façon à ce qu’elles ne varient pas au cours du temps.

    A partir du tableau d’amortissement, on pourra déduire les coûts totaux du crédit, des assurances et des intérêts.

