#!/bin/bash

echo "🚀 Desplegando Actividad 3 en Kubernetes..."

# Aplicar todos los manifiestos
echo "📦 Creando namespace..."
kubectl apply -f 01-namespace.yaml

echo "🔐 Creando secret..."
kubectl apply -f 02-secret.yaml

echo "⚙️  Creando configmap..."
kubectl apply -f 03-configmap.yaml

echo "📊 Desplegando Redis..."
kubectl apply -f 04-redis-deployment.yaml

echo "🌐 Desplegando aplicación web..."
kubectl apply -f 05-app-deployment.yaml

echo "🌍 Configurando Ingress..."
kubectl apply -f 06-ingress.yaml

echo "⏳ Esperando que los pods estén listos..."
kubectl wait --for=condition=ready pod -l app=redis -n actividad3 --timeout=120s
kubectl wait --for=condition=ready pod -l app=webapp -n actividad3 --timeout=120s

echo "✅ Despliegue completado!"
echo ""
echo "📊 Estado de los recursos:"
kubectl get all -n actividad3

echo ""
echo "🔍 Para ver los logs de la aplicación:"
echo "kubectl logs -f deployment/app-deployment -n actividad3"

echo ""
echo "🌐 Para acceder a la aplicación:"
echo "kubectl port-forward service/app-service 8080:80 -n actividad3"
echo "Luego abre http://localhost:8080 en tu navegador" 