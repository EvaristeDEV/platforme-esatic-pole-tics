# 🆓 Hébergement Gratuit - ESATIC POLE DES TICS

## 🎯 Options d'Hébergement Gratuit

Voici les meilleures options gratuites pour héberger votre plateforme universitaire :

---

## 1️⃣ Vercel + Railway (Recommandé)

### Frontend sur Vercel
**Avantages :**
- ✅ Gratuit pour projets personnels
- ✅ HTTPS automatique
- ✅ CDN mondial
- ✅ Déploiement automatique

**Limites :**
- 100GB bande passante/mois
- Fonctions serverless limitées

### Backend sur Railway
**Avantages :**
- ✅ $5 crédit/mois (suffisant pour petit projet)
- ✅ Base de données PostgreSQL gratuite
- ✅ Support Docker
- ✅ Déploiement automatique

---

## 2️⃣ GitHub Pages + Supabase

### Frontend sur GitHub Pages
**Avantages :**
- ✅ Totalement gratuit
- ✅ Intégration GitHub
- ✅ HTTPS automatique
- ✅ Jekyll support

**Limites :**
- Sites statiques uniquement
- Pas de backend

### Backend sur Supabase
**Avantages :**
- ✅ PostgreSQL gratuit
- ✅ API REST auto-générée
- ✅ Authentification intégrée
- ✅ Real-time subscriptions

---

## 3️⃣ Netlify + PlanetScale

### Frontend sur Netlify
**Avantages :**
- ✅ 100GB bande passante/mois
- ✅ 300 minutes build/mois
- ✅ Formulaires gratuits
- ✅ Edge functions

### Backend sur PlanetScale
**Avantages :**
- ✅ MySQL compatible
- ✅ Branching de base de données
- ✅ Analytics gratuits

---

## 🚀 Déploiement Étape par Étape

### Option 1: Vercel + Railway

#### Étape 1: Préparer le projet
```bash
# Créer vercel.json pour le frontend
cd frontend
cat > vercel.json << EOF
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
EOF
```

#### Étape 2: Déployer sur Vercel
```bash
# Installer Vercel CLI
npm i -g vercel

# Déployer
vercel --prod
```

#### Étape 3: Configurer Railway
```bash
# Installer Railway CLI
npm install -g @railway/cli

# Se connecter
railway login

# Initialiser le projet
cd backend
railway init

# Configurer les variables d'environnement
railway variables set DATABASE_URL=postgresql://user:pass@host:port/db
railway variables set SECRET_KEY=votre-secret-key

# Déployer
railway up
```

---

### Option 2: GitHub Pages + Supabase

#### Étape 1: Adapter pour GitHub Pages
```bash
# Créer gh-pages branch
cd frontend
npm run build

# Ajouter base href
sed -i 's/<base href="/">/<base href="\/platforme-esatic-pole-tics\/">/' dist/index.html

# Push vers GitHub
git checkout -b gh-pages
git add dist/
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages
```

#### Étape 2: Configurer Supabase
1. Allez sur [supabase.com](https://supabase.com)
2. Créez un nouveau projet
3. Importez le schéma SQL
4. Configurez l'authentification
5. Obtenez l'URL de l'API

#### Étape 3: Mettre à jour le frontend
```typescript
// src/environments/environment.prod.ts
export const environment = {
  production: true,
  apiUrl: 'https://votre-projet.supabase.co/rest/v1',
  supabaseUrl: 'https://votre-projet.supabase.co',
  supabaseKey: 'votre-cle-anon'
};
```

---

## 🔧 Configuration pour Hébergement Gratuit

### Variables d'environnement
```bash
# Railway
DATABASE_URL=postgresql://postgres:mohamed123@containers-us-west-1.railway.app:5432/railway
SECRET_KEY=votre-secret-key-32-caracteres
DEBUG=false

# Vercel
API_BASE_URL=https://votre-backend.railway.app
NODE_ENV=production
```

### Adapter le code pour le cloud
```typescript
// src/app/services/api.service.ts
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private baseUrl = environment.apiUrl;
  
  constructor(private http: HttpClient) {}
  
  // Utiliser l'URL de l'API distante
  getUsers() {
    return this.http.get(`${this.baseUrl}/users`);
  }
}
```

---

## 💰 Coûts et Limites

### Vercel (Gratuit)
- ✅ 100GB bande passante/mois
- ✅ Bande passante sortante illimitée
- ✅ 1 fonction serverless
- ❌ Pas de base de données

### Railway ($5 crédit/mois)
- ✅ 500MB RAM
- ✅ 1 vCPU
- ✅ 1GB stockage
- ✅ Base de données PostgreSQL

### Supabase (Gratuit)
- ✅ 500MB base de données
- ✅ 50,000 requêtes/mois
- ✅ 2GB bande passante
- ✅ 50 utilisateurs authentifiés

---

## 🚀 Déploiement Rapide

### Script de déploiement automatique
```bash
#!/bin/bash
# deploy-free.sh

echo "🚀 Déploiement gratuit ESATIC POLE DES TICS"

# Déployer frontend sur Vercel
cd frontend
echo "📦 Déploiement frontend sur Vercel..."
vercel --prod --confirm

# Déployer backend sur Railway
cd ../backend
echo "🐳 Déploiement backend sur Railway..."
railway up

echo "✅ Déploiement terminé !"
echo "🌐 Frontend: https://votre-app.vercel.app"
echo "🔧 Backend: https://votre-backend.railway.app"
```

---

## 🎯 Recommandation

**Pour commencer :** Utilisez **Vercel + Railway**
- Facile à configurer
- Bonnes performances
- Support Docker
- Évolutif vers des plans payants

**Pour petit budget :** Utilisez **GitHub Pages + Supabase**
- Totalement gratuit
- Bon pour prototyper
- Intégration facile

---

## 📞 Support et Aide

### Liens utiles
- [Vercel Documentation](https://vercel.com/docs)
- [Railway Documentation](https://docs.railway.app)
- [Supabase Documentation](https://supabase.com/docs)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)

### Problèmes courants
```bash
# Erreur CORS sur Vercel
# Ajouter dans vercel.json:
{
  "headers": [
    {
      "source": "/api/(.*)",
      "headers": [
        { "key": "Access-Control-Allow-Origin", "value": "*" }
      ]
    }
  ]
}

# Erreur de connexion Railway
# Vérifier les variables d'environnement:
railway variables list
```

---

## 🎉 Félicitations !

Votre plateforme ESATIC POLE DES TICS peut maintenant être hébergée gratuitement !

**Prochaines étapes :**
1. Choisir votre plateforme d'hébergement
2. Suivre le guide de déploiement
3. Configurer votre nom de domaine
4. Monitorer les performances

---

*Ce guide est maintenu par l'équipe ESATIC POLE DES TICS*  
*Dernière mise à jour : $(date)*
