# Gestionnaire de Tâches

![Liste des tâches](images/liste%20des%20taches%20.png)

## 📱 Fonctionnalités

- **Gestion complète des tâches** : création, visualisation, complétion et suppression
- **Interface utilisateur moderne et intuitive** avec thème personnalisé
- **Sauvegarde locale automatique** des tâches via SharedPreferences
- **Statistiques en temps réel** sur votre progression
- **Confirmation de suppression** pour éviter les erreurs

## 🏗️ Architecture du projet

Le projet suit une architecture claire et modulaire :

```
lib/
├── models/
│   └── task.dart          # Modèle de données Task
├── data/
│   └── task_data.dart     # Gestion d'état avec ChangeNotifier
├── services/
│   └── local_storage_service.dart  # Persistance avec SharedPreferences
├── screens/
│   ├── home_screen.dart   # Écran principal
│   └── add_task_screen.dart  # Écran d'ajout de tâche
├── widgets/
│   ├── task_list.dart     # Liste des tâches
│   └── task_tile.dart     # Élément de tâche individuel
├── utils/
│   └── constants.dart     # Constantes (couleurs, styles, etc.)
└── main.dart             # Point d'entrée de l'application
```

## 🖼️ Captures d'écran

### Liste vide

![Liste vide](images/Liste%20de%20tache%20vide.png)

### Ajout d'une tâche

![Ajout d'une tâche](images/ajouter%20une%20tache.png)

### Liste des tâches

![Liste des tâches](images/liste%20des%20taches%20.png)

### Après modification d'une tâche

![Liste après modification](images/Liste%20tache%20apres%20modification.png)

### Suppression d'une tâche

![Suppression d'une tâche](images/Suppression%20tache.png)

### Après suppression

![Liste après suppression](images/Liste%20des%20taches%20apres%20suppression%20.png)

## 🚀 Installation

1. Assurez-vous d'avoir Flutter installé sur votre machine
2. Clonez ce dépôt
3. Exécutez `flutter pub get` pour installer les dépendances
4. Lancez l'application avec `flutter run`

## 📦 Dépendances

- **provider:** ^6.0.5 - Gestion d'état
- **shared_preferences:** ^2.2.0 - Stockage local
- **uuid:** ^3.0.7 - Génération d'identifiants uniques
- **intl:** ^0.18.1 - Internationalisation

## ⚙️ Implémentation technique

### Modèle de données

Le modèle `Task` inclut :

- Un identifiant unique
- Un titre
- Un statut (terminé ou non)
- Des méthodes de sérialisation/désérialisation pour le stockage

### Gestion d'état

L'application utilise Provider (ChangeNotifier) pour la gestion d'état, permettant une mise à jour réactive de l'interface utilisateur à chaque modification des données.

### Stockage local

Les tâches sont automatiquement sauvegardées dans le stockage local de l'appareil grâce à SharedPreferences, assurant la persistance des données entre les sessions.
