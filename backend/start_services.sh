#!/bin/bash

# Script pour démarrer tous les services backend
# Usage: ./start_services.sh

echo "Démarrage des services backend de la plateforme ESATIC..."

# Activer l'environnement virtuel
source venv/bin/activate

# Démarrer l'API Gateway sur le port 8000
echo "Démarrage de l'API Gateway sur le port 8000..."
cd api-gateway
uvicorn main:app --host 127.0.0.1 --port 8000 &
API_GATEWAY_PID=$!
cd ..

# Attendre un peu que l'API Gateway démarre
sleep 2

# Démarrer le service d'authentification sur le port 8001
echo "Démarrage du service authentification sur le port 8001..."
cd services/auth_service
uvicorn run:app --host 127.0.0.1 --port 8001 &
AUTH_SERVICE_PID=$!
cd ../..

# Attendre un peu que le service auth démarre
sleep 2

# Démarrer le service référentiel sur le port 8003
echo "Démarrage du service référentiel sur le port 8003..."
cd services/referentiel_service
python run.py &
REFERENTIEL_SERVICE_PID=$!
cd ../..

# Attendre un peu que le service référentiel démarre
sleep 2

# Démarrer le service emploi du temps sur le port 8004
echo "Démarrage du service emploi du temps sur le port 8004..."
cd services/emploi_service
uvicorn run:app --host 127.0.0.1 --port 8004 &
EMPLOI_SERVICE_PID=$!
cd ../..

echo ""
echo "✅ Tous les services backend sont démarrés !"
echo ""
echo "Services disponibles :"
echo "- API Gateway: http://127.0.0.1:8000"
echo "- Auth Service: http://127.0.0.1:8001"
echo "- Référentiel Service: http://127.0.0.1:8003"
echo "- Emploi Service: http://127.0.0.1:8004"
echo ""
echo "Pour arrêter les services, utilisez :"
echo "kill $API_GATEWAY_PID $AUTH_SERVICE_PID $REFERENTIEL_SERVICE_PID $EMPLOI_SERVICE_PID"
echo ""
echo "Ou utilisez Ctrl+C pour arrêter ce script et tous les processus"

# Attendre que l'utilisateur veuille arrêter
trap "echo 'Arrêt de tous les services...'; kill $API_GATEWAY_PID $AUTH_SERVICE_PID $REFERENTIEL_SERVICE_PID $EMPLOI_SERVICE_PID 2>/dev/null; exit" INT

echo "Appuyez sur Ctrl+C pour arrêter tous les services"
wait
