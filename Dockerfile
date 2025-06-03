# ==================================================
# DOCKERFILE ÉDUCATIF SIMPLE - PROJET .NET 6.0 WebUi
# ==================================================

# Étape 1: Choisir l'image de base
# Nous utilisons l'image officielle Microsoft .NET 6.0 SDK
# Cette image contient tous les outils nécessaires pour compiler et tester
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Étape 2: Définir le répertoire de travail dans le conteneur
# Tous les fichiers seront copiés et toutes les commandes seront exécutées ici
WORKDIR /app

# Étape 3: Copier tout le projet
# On copie tout le contenu du répertoire courant dans le conteneur
COPY . ./

# Étape 4: Récupérer les packages NuGet
# Cette commande télécharge toutes les dépendances
RUN dotnet restore

# Étape 5: Compiler le projet WebUi
# Cette commande compile seulement le projet WebUi
RUN dotnet build Caltec.StudentInfoProject.WebUi/Caltec.StudentInfoProject.WebUi.csproj

# Étape 6: Lancer les tests
# Cette commande exécute tous les tests du projet
RUN dotnet test Caltec.StudentInfoProject.Business.Tests/Caltec.StudentInfoProject.Business.Tests.csproj

# Étape 7: Publier l'application WebUi
# Cette commande prépare l'application pour le déploiement
RUN dotnet publish Caltec.StudentInfoProject.WebUi/Caltec.StudentInfoProject.WebUi.csproj -o /out

# ==================================================
# ÉTAPE FINALE: IMAGE DE PRODUCTION
# ==================================================

# Utiliser une image plus légère pour l'exécution (runtime seulement)
# Cette image ne contient que l'environnement d'exécution .NET (pas les outils de développement)
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

# Définir le répertoire de travail pour l'application finale
WORKDIR /app

# Copier les fichiers publiés depuis l'étape de build
COPY --from=build /out ./

# Exposer le port 80 (port par défaut pour les applications web ASP.NET)
EXPOSE 80

# Définir la commande par défaut pour démarrer l'application
# Cette commande sera exécutée quand le conteneur démarre
ENTRYPOINT ["dotnet", "Caltec.StudentInfoProject.WebUi.dll"]
