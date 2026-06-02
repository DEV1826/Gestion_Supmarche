# Guide De Design Complet

Ce document sert de reference visuelle et UX pour toute l'application `supermarche`.

L'objectif est simple :
- garder une interface cohérente
- rendre chaque page claire et rapide a utiliser
- avoir une base solide pour continuer le design sans casser l'ensemble

---

## 1. Vision Produit

L'application n'est pas un site vitrine.

C'est un outil de travail pour :
- caissiers
- gestionnaires de stock
- administrateurs
- responsables fournisseurs

Le design doit donc privilegier :
- la lisibilite
- la rapidite d'action
- la confiance
- la priorisation des informations importantes

Le ton visuel doit inspirer :
- rigueur
- calme
- controle
- simplicite

---

## 2. Identite Visuelle

### Style general

Le style retenu est :
- moderne
- premium
- professionnel
- doux mais structure

On evite :
- les interfaces trop flashy
- les couleurs agressives partout
- les pages surchargees
- les composants trop "startup generique"

### Intention graphique

L'univers visuel doit melanger :
- des surfaces claires
- des accents verts profonds
- une touche ambre/or pour la valeur, la caisse et l'action
- des alertes rouges uniquement pour les priorites reelles

---

## 3. Palette De Couleurs

### Couleurs principales

- `market-cream`: fond global doux
- `market-parchment`: surfaces secondaires
- `market-pine`: couleur principale, navigation, titres forts
- `market-moss`: accents, focus, liens secondaires
- `market-gold`: CTA importants, valeur financiere
- `market-ember`: alertes et actions critiques
- `market-mint`: badges positifs, fonds calmes

### Usage recommande

- fond page : `market-cream`
- header / navigation : `market-pine`
- CTA principal : `market-pine`
- CTA secondaire fort : `market-gold`
- succes : vert doux
- warning : ambre doux
- danger : rouge/ember doux

### Etats

- succes : `bg-emerald-50`, `text-emerald-700`
- warning : `bg-amber-50`, `text-amber-700`
- danger : `bg-red-50`, `text-red-700`
- neutre : `bg-slate-100`, `text-slate-700`

---

## 4. Typographie

### Polices

- Titres : `Fraunces`
- Texte interface : `Manrope`

### Hierarchie

- Titre page : `text-3xl` ou `text-4xl`, `font-display`, `font-extrabold`
- Titre section : `text-xl` ou `text-2xl`, `font-display`, `font-bold`
- Label UI : `text-xs`, uppercase, tracking large
- Texte principal : `text-sm` ou `text-base`
- Meta texte : `text-sm text-slate-500`

### Règles

- toujours une hiérarchie claire
- peu de texte long
- interligne confortable
- titres courts et fonctionnels

---

## 5. Grille Et Espacement

### Largeurs

- conteneur principal : `max-w-7xl`
- formulaires moyens : `max-w-4xl` a `max-w-5xl`
- panneaux étroits : `max-w-md` a `max-w-lg`

### Espacements

- entre sections : `gap-6`
- padding carte : `p-5`, `p-6`, `p-8`
- petits espacements internes : `gap-2`, `gap-3`
- espacements moyens : `gap-4`

### Coins

- composants principaux : `rounded-shell`
- cartes internes : `rounded-3xl`
- boutons / champs : `rounded-2xl`
- badges : `rounded-full`

---

## 6. Ombres Et Profondeur

### Types d'ombres

- `shadow-panel` : panneaux principaux
- `shadow-float` : cartes KPI et éléments importants

### Usage

- une ombre par grand bloc suffit
- éviter les ombres partout
- donner la profondeur surtout aux cartes, modales, panneaux KPI

---

## 7. Composants De Base

### 7.1 Navigation

La navigation doit :
- rester sticky
- être compacte
- être claire sur mobile
- afficher les modules principaux

Modules :
- Produits
- Fournisseurs
- Alertes
- Caisse
- Stats
- Deconnexion

### 7.2 Boutons

#### Bouton principal

Usage :
- enregistrer
- valider
- lancer une action importante

Style :
- fond `market-pine`
- texte blanc
- hover légèrement plus clair

#### Bouton accent

Usage :
- exporter
- télécharger PDF
- action commerciale

Style :
- fond `market-gold`
- texte sombre

#### Bouton secondaire

Usage :
- réinitialiser
- retour
- action neutre

Style :
- fond clair
- bordure légère

#### Bouton danger

Usage :
- supprimer
- annuler définitivement

Style :
- fond rouge
- texte blanc

### 7.3 Champs De Formulaire

Tous les champs doivent avoir :
- fond clair
- bordure légère
- radius moyen
- focus visible
- padding confortable

Règles :
- labels toujours visibles
- placeholders courts
- groupement logique des champs

### 7.4 Tableaux

Les tableaux sont centraux dans l’application.

Ils doivent :
- avoir un header contrasté
- rester lisibles en responsive
- conserver des actions visibles
- autoriser le scroll horizontal si nécessaire

Règles :
- toujours `overflow-x-auto`
- colonnes d’actions en fin de ligne
- badges d’état pour stock, statut, paiement, alertes

### 7.5 Badges

Utiliser les badges pour :
- statut stock
- statut commande
- mode de paiement
- état transaction
- nombre de catégories / points / alertes

---

## 8. Structure Des Pages

Chaque page doit suivre cette logique :

1. Bandeau supérieur
- label section
- titre
- description courte

2. Bloc KPI ou contexte
- chiffres clés
- informations prioritaires

3. Zone d’action
- formulaire
- recherche
- filtres
- boutons

4. Zone principale
- tableau
- cartes
- ticket
- graphe

5. Pagination / actions secondaires

---

## 9. Règles Responsive

### Mobile first

Chaque écran doit d’abord rester utilisable sur téléphone.

### Mobile

Priorités :
- empiler les blocs
- éviter les largeurs figées
- garder les CTA visibles
- autoriser le scroll horizontal pour les grands tableaux

### Tablet

Priorités :
- passer en 2 colonnes quand utile
- garder un bon confort de lecture

### Desktop

Priorités :
- tirer parti de la largeur
- mettre les panneaux côte à côte
- valoriser les données importantes

### A éviter

- `w-[760px]` sans fallback
- contenu coupé
- texte collé aux bords
- boutons qui sortent de l’écran

---

## 10. Règles Par Module

### 10.1 Connexion

Objectif :
- rassurer
- guider
- aller vite

Doit contenir :
- grand titre
- bénéfices ou promesse
- formulaire simple
- message d’erreur très visible

### 10.2 Produits

Objectif :
- surveiller stock et prix
- filtrer rapidement
- modifier sans friction

Doit contenir :
- cartes KPI
- bloc ajout produit
- filtres avancés
- tableau principal

### 10.3 Fournisseurs

Objectif :
- suivre les partenaires
- accéder rapidement aux commandes
- voir les canaux de contact

Doit contenir :
- bloc ajout fournisseur
- filtres
- tableau clair avec actions :
  - modifier
  - supprimer
  - bon PDF
  - email
  - SMS

### 10.4 Alertes Stock

Objectif :
- prioriser les risques
- agir rapidement

Doit contenir :
- KPI alertes
- filtres
- sélection multiple
- actions bulk
- regroupement par fournisseur

### 10.5 Caisse

Objectif :
- vendre vite
- retrouver produit facilement
- réduire les erreurs

Doit contenir :
- recherche produit
- lignes dynamiques
- résumé temps réel
- bouton valider clair

### 10.6 Ticket / Reçu

Objectif :
- impression claire
- lecture immédiate
- cohérence avec PDF

Doit contenir :
- numéro ticket
- total
- mode paiement
- lignes détaillées
- net à payer

### 10.7 Stats

Objectif :
- aider à piloter
- pas juste "faire beau"

Doit contenir :
- KPI utiles
- 2 à 3 graphes maximum
- tableaux lisibles
- accent sur CA, catégories, ventes hebdo

---

## 11. Design Du Dashboard

Si une vraie page `Dashboard` séparée est créée plus tard, elle doit être différente de la page `Stats`.

### Dashboard

Le dashboard sert à :
- voir rapidement l’état général
- identifier les urgences
- accéder vite aux actions

Blocs conseillés :
- KPI du jour
- produits tendance
- fournisseurs à surveiller
- dernières transactions
- alertes critiques

### Stats

La page stats sert à :
- analyser
- comparer
- lire les tendances métier

Blocs conseillés :
- CA par catégorie
- évolution hebdo
- top produits
- panier moyen

---

## 12. Icônes Et Illustrations

Utiliser les icônes avec modération.

Bon usage :
- statut
- paiement
- recherche
- alertes
- catégories

Eviter :
- icônes décoratives inutiles partout

Si besoin :
- Heroicons
- Lucide

---

## 13. Langage UX

Le texte de l’interface doit être :
- court
- clair
- orienté action

### Exemples

Bon :
- `Valider la vente`
- `Ajouter une ligne`
- `Notifier fournisseurs`
- `Télécharger la facture PDF`

Moins bon :
- `Cliquez ici pour effectuer une action`

---

## 14. Etats Et Feedbacks

Chaque action importante doit donner un retour :

- succès
- erreur
- warning
- état vide

### Exemples

- `Produit ajouté avec succès`
- `Aucun produit critique sélectionné`
- `Stock insuffisant pour ce produit`
- `Aucune vente enregistrée pour cette période`

---

## 15. Accessibilite

Règles minimales :
- bon contraste
- focus visible clavier
- labels de formulaire explicites
- textes pas trop petits
- pas d’information uniquement portée par la couleur

---

## 16. Checklist Avant De Designer Une Nouvelle Page

Avant de valider une page, vérifier :

- le titre est-il clair ?
- l’action principale est-elle visible en moins de 3 secondes ?
- le mobile est-il utilisable ?
- le tableau est-il lisible ?
- les couleurs suivent-elles la palette ?
- les badges sont-ils cohérents ?
- les messages de feedback existent-ils ?
- la hiérarchie visuelle est-elle évidente ?

---

## 17. Priorites De Refonte

Ordre conseillé si on veut finaliser tout le design :

1. Navigation + thème global
2. Connexion
3. Produits
4. Fournisseurs
5. Alertes stock
6. Caisse
7. Ticket / facture
8. Stats
9. Pages erreur
10. Formulaires modifier

---

## 18. Decision Finale

Pour cette application, il faut retenir cette règle :

`dashboard = pilotage rapide`

`stats = analyse detaillee`

`caisse = vitesse`

`produits/fournisseurs = gestion`

`alertes = priorite`

Si cette logique est respectée, tout le design restera cohérent.

