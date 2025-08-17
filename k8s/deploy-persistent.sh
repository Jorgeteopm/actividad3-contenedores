#!/bin/bash

echo "🚀 Desplegando Actividad 3 con ALMACENAMIENTO PERSISTENTE..."

# Aplicar todos los manifiestos en orden
echo "📦 Creando namespace..."
kubectl apply -f 01-namespace.yaml

echo "🔐 Creando secret..."
kubectl apply -f 02-secret.yaml

echo "⚙️  Creando configmap..."
kubectl apply -f 03-configmap.yaml

echo "🗂️  Creando StorageClass..."
kubectl apply -f 07-storage-class.yaml

echo "💾 Creando PersistentVolume..."
kubectl apply -f 08-redis-pv.yaml

echo "🔗 Creando PersistentVolumeClaim..."
kubectl apply -f 09-redis-pvc.yaml

echo "📊 Desplegando Redis con almacenamiento persistente..."
kubectl apply -f 04-redis-deployment.yaml

echo "🌐 Desplegando aplicación web..."
kubectl apply -f 05-app-deployment.yaml

echo "🌍 Configurando Ingress..."
kubectl apply -f 06-ingress.yaml

echo "⏳ Esperando que los recursos estén listos..."
kubectl wait --for=condition=ready pod -l app=redis -n actividad3 --timeout=120s
kubectl wait --for=condition=ready pod -l app=webapp -n actividad3 --timeout=120s

echo "✅ Despliegue con almacenamiento persistente completado!"
echo ""
echo "📊 Estado de los recursos:"
kubectl get all -n actividad3

echo ""
echo "💾 Estado del almacenamiento persistente:"
kubectl get pv
kubectl get pvc -n actividad3
kubectl get storageclass

echo ""
echo "🔍 Para ver los logs de la aplicación:"
echo "kubectl logs -f deployment/app-deployment -n actividad3"

echo ""
echo "🌐 Para acceder a la aplicación:"
echo "kubectl port-forward service/app-service 8080:80 -n actividad3"
echo "Luego abre http://localhost:8080 en tu navegador"

echo ""
echo "🧪 Para probar la persistencia:"
echo "1. Incrementa el contador en la aplicación"
echo "2. Reinicia Redis: kubectl rollout restart deployment/redis-deployment -n actividad3"
echo "3. Verifica que el contador mantenga su valor" 