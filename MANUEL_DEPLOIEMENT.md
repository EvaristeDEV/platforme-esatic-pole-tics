# 📚 Manuel de Déploiement - ESATIC POLE DES TICS

## 🎯 Vue d'ensemble

Ce manuel guide le déploiement de la plateforme de gestion universitaire ESATIC POLE DES TICS dans différents environnements.

---

## 📋 Prérequis

### Système requis
- **OS** : Linux (Ubuntu 20.04+) / macOS / Windows 10+
- **RAM** : 4GB minimum (8GB recommandé)
- **Stockage** : 20GB disponible
- **Réseau** : Accès internet

### Logiciels requis
```bash
# Vérifier les versions
docker --version      # >= 20.10
docker-compose --version # >= 2.0
node --version        # >= 18.0
python3 --version     # >= 3.11
psql --version        # >= 13.0
```

---

## 🚀 Méthodes de Déploiement

### 1️⃣ Déploiement Local avec Docker (Recommandé)

#### Étape 1: Cloner le projet
```bash
git clone https://github.com/EvaristeDEV/platforme-esatic-pole-tics.git
cd platforme-esatic-pole-tics
```

#### Étape 2: Configuration de l'environnement
```bash
# Copier le fichier d'environnement
cp .env.production .env

# Éditer les variables si nécessaire
nano .env
```

#### Étape 3: Lancer le déploiement
```bash
# Construire et démarrer tous les services
docker-compose up --build -d

# Vérifier le statut
docker-compose ps
```

#### Étape 4: Initialisation
```bash
# Attendre 30 secondes que les services démarrent
sleep 30

# Créer les utilisateurs de test
docker-compose exec auth-service python app/scripts/create_user.py
docker-compose exec auth-service python app/scripts/create_student.py
```

#### Accès à l'application
- **Frontend** : http://localhost
- **API Gateway** : http://localhost:8000
- **Documentation API** : http://localhost:8000/docs

---

### 2️⃣ Déploiement Manuel (Sans Docker)

#### Étape 1: Base de données PostgreSQL
```bash
# Installation PostgreSQL
sudo apt update
sudo apt install postgresql postgresql-contrib

# Configuration
sudo -u postgres psql
CREATE DATABASE auth_db;
CREATE DATABASE referentiel_db;
CREATE DATABASE student_db;
CREATE DATABASE teacher_db;
CREATE USER esatic_user WITH PASSWORD 'votre_mot_de_passe';
GRANT ALL PRIVILEGES ON DATABASE auth_db TO esatic_user;
GRANT ALL PRIVILEGES ON DATABASE referentiel_db TO esatic_user;
GRANT ALL PRIVILEGES ON DATABASE student_db TO esatic_user;
GRANT ALL PRIVILEGES ON DATABASE teacher_db TO esatic_user;
\q

# Importer les données
psql -U esatic_user -d referentiel_db -f backend/services/referentiel_service/insert_data.sql
```

#### Étape 2: Backend Services
```bash
# Installation Python
sudo apt install python3-pip python3-venv

# Auth Service
cd backend/services/auth_service
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --host 0.0.0.0 --port 8001 &

# Admin Service
cd ../referentiel_service
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --host 0.0.0.0 --port 8002 &

# API Gateway
cd ../../api-gateway
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8000 &
```

#### Étape 3: Frontend Angular
```bash
# Installation Node.js (via nvm recommandé)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18

# Build et déploiement
cd frontend
npm install
npm run build

# Servir avec nginx ou autre serveur web
sudo cp -r dist/* /var/www/html/
```

---

### 3️⃣ Déploiement Cloud (Vercel + Railway/Heroku)

#### Frontend sur Vercel
```bash
# Installer Vercel CLI
npm i -g vercel

# Déployer
cd frontend
vercel --prod
```

#### Backend sur Railway
```bash
# Installer Railway CLI
npm install -g @railway/cli

# Se connecter et déployer
railway login
railway init
railway up
```

---

## 🔧 Configuration Production

### Variables d'environnement
```bash
# .env
DATABASE_URL=postgresql+asyncpg://user:password@host:5432/dbname
SECRET_KEY=votre-clé-secrète-très-longue-et-complexe
DEBUG=false
ENVIRONMENT=production

# URLs des services
AUTH_SERVICE_URL=https://votre-domaine.com/api/auth
ADMIN_SERVICE_URL=https://votre-domaine.com/api/admin
STUDENT_SERVICE_URL=https://votre-domaine.com/api/student
TEACHER_SERVICE_URL=https://votre-domaine.com/api/teacher
```

### Configuration Nginx (Production)
```nginx
# /etc/nginx/sites-available/esatic-pole-tics
server {
    listen 80;
    server_name votre-domaine.com;
    
    # Redirection HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name votre-domaine.com;
    
    # Certificats SSL (Let's Encrypt recommandé)
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    # Frontend
    root /var/www/esatic-pole-tics;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # API proxy
    location /api/ {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## 🔐 Sécurité Production

### 1. Mots de passe forts
```bash
# Générer un secret key fort
python3 -c "import secrets; print(secrets.token_urlsafe(32))"
```

### 2. Configuration SSL/TLS
```bash
# Installation Certbot
sudo apt install certbot python3-certbot-nginx

# Obtention certificat
sudo certbot --nginx -d votre-domaine.com
```

### 3. Firewall
```bash
# UFW Configuration
sudo ufw allow ssh
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

---

## 📊 Monitoring et Maintenance

### Logs
```bash
# Docker
docker-compose logs -f

# Services système
sudo journalctl -u nginx -f
sudo journalctl -u postgresql -f
```

### Sauvegardes
```bash
# PostgreSQL
pg_dump -U esatic_user referentiel_db > backup_$(date +%Y%m%d).sql

# Automatisation avec cron
0 2 * * * pg_dump -U esatic_user auth_db > /backups/auth_$(date +\%Y\%m\%d).sql
```

### Mises à jour
```bash
# Mise à jour du code
git pull origin main
docker-compose down
docker-compose up --build -d
```

---

## 🚨 Dépannage

### Problèmes courants

#### Port déjà utilisé
```bash
# Vérifier les ports
sudo netstat -tulpn | grep :8000

# Tuer le processus
sudo kill -9 <PID>
```

#### Erreur de connexion base de données
```bash
# Vérifier PostgreSQL
sudo systemctl status postgresql

# Tester la connexion
psql -U esatic_user -d auth_db -h localhost
```

#### Frontend ne se charge pas
```bash
# Vérifier nginx
sudo nginx -t
sudo systemctl restart nginx

# Vérifier les permissions
sudo chown -R www-data:www-data /var/www/esatic-pole-tics
```

---

## 📞 Support

### Comptes de test
- **Étudiant** : student1@example.com / Student123!
- **Admin** : chef1@gmail.com / Password123!

### Documentation additionnelle
- [API Documentation](http://localhost:8000/docs)
- [GitHub Repository](https://github.com/EvaristeDEV/platforme-esatic-pole-tics)
- [Issues GitHub](https://github.com/EvaristeDEV/platforme-esatic-pole-tics/issues)

---

## 🎉 Félicitations !

Votre plateforme ESATIC POLE DES TICS est maintenant déployée !

**Prochaines étapes recommandées :**
1. Configurer les backups automatiques
2. Mettre en place le monitoring
3. Optimiser les performances
4. Former les utilisateurs

---

*Ce manuel est maintenu par l'équipe ESATIC POLE DES TICS*  
*Dernière mise à jour : $(date)*
