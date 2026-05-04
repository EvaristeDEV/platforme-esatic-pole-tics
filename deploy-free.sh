#!/bin/bash

# 🆓 Script de Déploiement Gratuit - ESATIC POLE DES TICS
echo "🚀 Déploiement gratuit de la plateforme ESATIC POLE DES TICS"

# Vérifier les prérequis
echo "📋 Vérification des prérequis..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js n'est pas installé"
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm n'est pas installé"
    exit 1
fi

# Installation des CLI
echo "📦 Installation des outils de déploiement..."
npm install -g vercel @railway/cli

# Configuration du frontend pour Vercel
echo "🎨 Configuration du frontend pour Vercel..."
cd frontend

# Créer vercel.json
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

# Mettre à jour environment.prod.ts
cat > src/environments/environment.prod.ts << EOF
export const environment = {
  production: true,
  apiUrl: 'https://votre-backend.railway.app',
  title: 'ESATIC POLE DES TICS'
};
EOF

echo "🌐 Déploiement du frontend sur Vercel..."
vercel --prod

echo "🐳 Configuration du backend pour Railway..."
cd ../backend

# Créer railway.json
cat > railway.json << EOF
{
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "startCommand": "uvicorn main:app --host 0.0.0.0 --port 8000",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
EOF

echo "🔧 Connexion à Railway..."
railway login

echo "📦 Initialisation du projet Railway..."
railway init

echo "🔧 Configuration des variables d'environnement..."
railway variables set DATABASE_URL=postgresql+asyncpg://postgres:mohamed123@postgres:5432/auth_db
railway variables set SECRET_KEY=your-secret-key-change-this-in-production
railway variables set DEBUG=false

echo "🚀 Déploiement du backend sur Railway..."
railway up

echo ""
echo "✅ Déploiement terminé avec succès !"
echo ""
echo "📱 URLs d'accès :"
echo "   Frontend (Vercel): https://votre-app.vercel.app"
echo "   Backend (Railway): https://votre-backend.railway.app"
echo "   API Documentation: https://votre-backend.railway.app/docs"
echo ""
echo "🔑 Comptes de test :"
echo "   Étudiant: student1@example.com / Student123!"
echo "   Admin: chef1@gmail.com / Password123!"
echo ""
echo "📊 Pour monitorer :"
echo "   Vercel: https://vercel.com/dashboard"
echo "   Railway: https://railway.app/dashboard"
echo ""
echo "🎉 Votre plateforme ESATIC POLE DES TICS est en ligne !"
