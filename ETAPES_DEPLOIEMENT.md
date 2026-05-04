# 📋 Étapes Détaillées - Hébergement Gratuit ESATIC POLE DES TICS

## 🎯 Option Recommandée : Vercel + Railway

---

## 📦 ÉTAPE 1 : Préparation du Frontend pour Vercel

### 1.1 Installer Vercel CLI
```bash
npm install -g vercel
```

### 1.2 Créer le fichier de configuration Vercel
```bash
cd frontend
```

Créer le fichier `vercel.json` :
```json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "dist"
      }
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ],
  "env": {
    "API_BASE_URL": "@api_base_url"
  }
}
```

### 1.3 Configurer l'environnement de production
Éditer `src/environments/environment.prod.ts` :
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://votre-backend.railway.app',
  title: 'ESATIC POLE DES TICS'
};
```

### 1.4 Builder le frontend
```bash
npm run build
```

---

## 🐳 ÉTAPE 2 : Déploiement du Frontend sur Vercel

### 2.1 Se connecter à Vercel
```bash
vercel login
```

### 2.2 Déployer le projet
```bash
vercel --prod
```

### 2.3 Noter l'URL obtenue
Exemple : `https://esatic-pole-tics.vercel.app`

---

## 🚂 ÉTAPE 3 : Préparation du Backend pour Railway

### 3.1 Installer Railway CLI
```bash
npm install -g @railway/cli
```

### 3.2 Créer le fichier de configuration Railway
```bash
cd ../backend
```

Créer le fichier `railway.json` :
```json
{
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "cd api-gateway && uvicorn main:app --host 0.0.0.0 --port $PORT",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### 3.3 Créer les requirements pour Railway
Créer `requirements.txt` à la racine du backend :
```txt
fastapi
uvicorn[standard]
sqlalchemy
psycopg2-binary
pydantic
pydantic-settings
python-jose
passlib[bcrypt]
httpx
python-dotenv
asyncpg
email-validator
python-multipart
```

---

## 🚂 ÉTAPE 4 : Déploiement du Backend sur Railway

### 4.1 Se connecter à Railway
```bash
railway login
```

### 4.2 Initialiser le projet Railway
```bash
railway init
```

### 4.3 Configurer les variables d'environnement
```bash
railway variables set DATABASE_URL=postgresql+asyncpg://postgres:mohamed123@containers-us-west-1.railway.app:5432/railway
railway variables set SECRET_KEY=your-super-secret-key-change-this-in-production-please
railway variables set DEBUG=false
railway variables set ENVIRONMENT=production
```

### 4.4 Déployer le backend
```bash
railway up
```

### 4.5 Noter l'URL obtenue
Exemple : `https://esatic-backend-production.up.railway.app`

---

## 🗄️ ÉTAPE 5 : Configuration de la Base de Données

### 5.1 Créer la base de données sur Railway
```bash
# Ajouter un service PostgreSQL
railway add postgresql
```

### 5.2 Obtenir l'URL de la base de données
```bash
railway variables get DATABASE_URL
```

### 5.3 Initialiser la base de données
```bash
# Se connecter à la base de données
psql $DATABASE_URL

# Créer les tables
\i backend/services/referentiel_service/insert_data.sql
```

---

## 🔗 ÉTAPE 6 : Configuration des Services Backend

### 6.1 Mettre à jour les URLs des services
Dans Railway, configurer les variables pour chaque service :

```bash
# Service Auth (port 8001)
railway variables set PORT=8001

# Service Admin (port 8002)  
railway variables set PORT=8002

# Service Student (port 8003)
railway variables set PORT=8003

# Service Teacher (port 8004)
railway variables set PORT=8004
```

### 6.2 Déployer tous les services
```bash
# Pour chaque service
cd services/auth_service
railway up

cd ../referentiel_service  
railway up

# ... etc pour les autres services
```

---

## 🔄 ÉTAPE 7 : Mise à Jour du Frontend

### 7.1 Mettre à jour l'URL de l'API
Éditer `src/environments/environment.prod.ts` avec l'URL Railway :
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://votre-backend-railway.app',
  title: 'ESATIC POLE DES TICS'
};
```

### 7.2 Redéployer le frontend
```bash
cd frontend
vercel --prod
```

---

## ✅ ÉTAPE 8 : Test Final

### 8.1 Vérifier l'application
- **Frontend** : https://votre-app.vercel.app
- **API Gateway** : https://votre-backend.railway.app/docs
- **Auth Service** : https://auth-service.railway.app/docs

### 8.2 Tester les comptes
- **Étudiant** : student1@example.com / Student123!
- **Admin** : chef1@gmail.com / Password123!

### 8.3 Vérifier les fonctionnalités
- ✅ Inscription
- ✅ Connexion  
- ✅ Tableau de bord
- ✅ Gestion des cours

---

## 📊 ÉTAPE 9 : Monitoring

### 9.1 Dashboard Vercel
Visiter : https://vercel.com/dashboard

### 9.2 Dashboard Railway  
Visiter : https://railway.app/dashboard

### 9.3 Logs et erreurs
```bash
# Logs Vercel
vercel logs

# Logs Railway
railway logs
```

---

## 🚨 ÉTAPE 10 : Dépannage

### 10.1 Erreur CORS sur Vercel
Ajouter dans `vercel.json` :
```json
{
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        { "key": "Access-Control-Allow-Origin", "value": "*" },
        { "key": "Access-Control-Allow-Methods", "value": "GET,POST,PUT,DELETE,OPTIONS" },
        { "key": "Access-Control-Allow-Headers", "value": "Content-Type, Authorization" }
      ]
    }
  ]
}
```

### 10.2 Erreur de connexion base de données
Vérifier les variables Railway :
```bash
railway variables list
```

### 10.3 Build failed sur Vercel
Vérifier `package.json` et `angular.json` :
```bash
npm install
npm run build
```

---

## 💰 COÛTS ET LIMITES

### Vercel (Gratuit)
- ✅ 100GB bande passante/mois
- ✅ Déploiements illimités
- ✅ HTTPS automatique
- ❌ Pas de backend

### Railway (Gratuit)
- ✅ $5 crédit/mois
- ✅ 500MB RAM
- ✅ 1GB stockage
- ✅ Base de données PostgreSQL

---

## 🎉 RÉSULTAT FINAL

Votre plateforme ESATIC POLE DES TICS sera accessible :

**URL Frontend** : https://votre-app.vercel.app  
**URL Backend** : https://votre-backend.railway.app  
**Documentation API** : https://votre-backend.railway.app/docs

---

## 🔄 MAINTENANCE

### Mises à jour
```bash
# Mettre à jour le code
git pull origin main

# Redéployer
cd frontend && vercel --prod
cd backend && railway up
```

### Sauvegardes
Les bases de données Railway sont sauvegardées automatiquement.

---

*Félicitations ! Votre plateforme ESATIC POLE DES TICS est maintenant hébergée gratuitement !* 🎓
