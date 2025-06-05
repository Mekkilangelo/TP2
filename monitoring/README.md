# Monitoring Stack - Grafana + Loki + Promtail

## Démarrage complet (app + monitoring)

```bash
# Démarrer toute la stack
docker-compose up -d

# Vérifier le statut
docker-compose ps

# Voir les logs
docker-compose logs -f
```

## Accès aux services

- **Grafana**: http://localhost:3002
  - Login: `admin`
  - Password: `admin`

- **Loki API**: http://localhost:3100

## Monitoring de votre application TP2

Le stack monitoring surveille automatiquement tous les containers du projet `tp2`:
- `tp2-webapp-blue-1`
- `tp2-webapp-green-1` 
- `tp2-nginx-1`
- `tp2-sqlserver-1`

## Commandes utiles

```bash
# Arrêter le monitoring
docker-compose -f docker-compose.monitoring.yml down

# Redémarrer un service
docker-compose -f docker-compose.monitoring.yml restart grafana

# Voir les logs de Promtail
docker-compose -f docker-compose.monitoring.yml logs -f promtail

# Nettoyer les volumes (attention: perte de données)
docker-compose -f docker-compose.monitoring.yml down -v
```

## Dashboards dans Grafana

Après connexion à Grafana (http://localhost:3002), vous aurez accès à 4 dashboards pré-configurés :

### 🏠 **Home Dashboard** 
- **Vue d'ensemble** du statut global
- **Navigation rapide** vers les autres dashboards
- **Métriques clés** : Statut, environnement actif, erreurs, trafic
- **Liens directs** vers l'application et les APIs

### 🔄 **Blue/Green Deployment Dashboard**
- **Graphique en camembert** : Répartition Blue vs Green
- **Courbes en temps réel** : Trafic par environnement
- **Monitoring nginx** : Trafic du reverse proxy
- **Logs live** : Déploiements en temps réel

### 📈 **Application Monitoring Dashboard**  
- **Statuts instantanés** : Instances actives, requêtes/sec, environnement actif
- **Détection d'erreurs** : Compteur d'erreurs sur 5 minutes
- **Graphiques temporels** : Activité par container
- **Logs filtrés** : Erreurs et avertissements uniquement

### ⏱️ **Deployment Timeline Dashboard**
- **Historique des déploiements** : Graphique en barres par environnement  
- **Métriques de performance** : Temps de switch Blue/Green
- **Guide intégré** : Instructions de monitoring
- **Timeline complète** : Tous les événements de déploiement

## Guide d'utilisation visuelle

### Pour suivre un déploiement en temps réel :
1. **Ouvrir le Dashboard Blue/Green**
2. **Cliquer sur l'icône ⏸️/▶️** en haut à droite pour activer le live streaming
3. **Observer les panels** :
   - Le camembert montre la répartition actuelle
   - Les courbes montrent le trafic en temps réel
   - Les logs défilent automatiquement
4. **Lancer votre déploiement** via GitHub Actions  
5. **Voir en direct** :
   - 🔵 L'environnement Blue qui se prépare
   - 🔄 Le switch du trafic  
   - 🟢 L'environnement Green qui devient actif
   - 📜 Les logs de déploiement qui défilent

### Requêtes Loki utiles :
```logql
# Tous les logs du projet TP2
{project="tp2"}

# Logs des webapps uniquement  
{service=~"webapp-.*"}

# Logs du reverse proxy nginx
{service="nginx"}

# Logs d'erreurs uniquement
{container=~".*"} |~ "(?i)error|exception|fail"

# Logs de déploiement
{container=~".*"} |~ "(?i)deploy|start|stop|switch|reload"

# Activité par environnement Blue/Green
{environment=~"blue|green"}
```

## Surveillance du Blue/Green deployment

Pour suivre un déploiement en temps réel:
1. Ouvrir Grafana: http://localhost:3002
2. Aller dans "Explore"
3. Utiliser la requête: `{project="tp2", service=~"webapp-.*"}`
4. Activer "Live streaming"
5. Lancer votre déploiement via GitHub Actions

Vous verrez en temps réel les logs du déploiement Blue/Green !
