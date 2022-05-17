# crawler
## Crawler CI/CD repository. OTUS DevOps graduation project

## Требования к проекту
- Автоматизированные процессы создания и управления платформой
  - Ресурсы Ya.cloud
  - Инфраструктура для CI/CD
  -Инфраструктура для сбора обратной связи
- Использование практики IaC (Infrastructure as Code) для управления конфигурацией и инфраструктурой
- Настроен процесс CI/CD
- Все, что имеет отношение к проекту хранится в Git
- Настроен процесс сбора обратной связи
  -Мониторинг (сбор метрик, алертинг, визуализация)
  - Логирование (опционально)
  - Трейсинг (опционально)
  - ChatOps (опционально)
- Документация
  - README по работе с репозиторием
  - Описание приложения и его архитектуры
  - How to start?
  - ScreenCast
- CHANGELOG с описанием выполненной работы

## План
- Создать makefile для сборки образов
- Создать docker-compose.yml для сборки приложения
- Подготовить инфру для поднятия кубера и развертывания приложения в нем
- Развернуть инфру и GitLab в ней для CI/CD 

## Выполнено:

1. Создан makefile для сборки образов
~~~bash
cd ./docker
make
~~~

2. Создан docker-compose.yml для сборки приложения
~~~bash
➜  docker git:(main) docker-compose up -d
➜  docker git:(main) curl http://localhost:8000
<!doctype html>
<html>
    <head>
        <title>Best search engine ever</title>
        <style type="text/css">
        body, html {

  ...
  ~~~

3. Деплой приложения в k8s
~~~bash
cd ./crawler/terraform-k8s/  
terraform init
terraform apply --auto-approve
helm install ingress-nginx ingress-nginx/ingress-nginx

helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true \
  --version v1.8.0 \
  --set prometheus.enabled=false \
  --set webhook.timeoutSeconds=4

kubectl apply -f ../k8s/crawler/namespaces.yml
kubectl apply -f ../k8s/crawler/ -n dev
kubectl --namespace default get services -o wide -w ingress-nginx-controller
cd ..  
helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm upgrade --install gitlab gitlab/gitlab --set certmanager-issuer.email=dmitriypnev@gmail.com
helm uninstall gitlab 

yc vpc address create --external-ipv4 zone=ru-central1-a


helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=51.250.86.100.nip.io \
  --set global.hosts.externalIP=51.250.86.100 \
  --set certmanager-issuer.email=dmitriypnev@gmail.com \
  --set certmanager.rbac.create=false \
  --set nginx-ingress.rbac.createRole=false \
  --set prometheus.rbac.create=false \
  --set gitlab-runner.rbac.create=false \
  --set postgresql.image.tag=13.6.0

#GitLab CI
cd k8s/gitlab-ci 
kubectl apply -f gitlab-admin-service-account.yaml
kubectl -n kube-system get secrets -o json | \
jq -r '.items[] | select(.metadata.name | startswith("gitlab-admin")) | .data.token' | \
base64 --decode
eyJhbGciOiJSUzI1NiIsImtpZCI6InFTaGZnVDVRdzQ0bHZHS0Rnd1BNUXpHdGYwczVwOVlGcnNEdUVtcThMVTAifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJnaXRsYWItYWRtaW4tdG9rZW4tMm1jNTUiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZ2l0bGFiLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiNTM0NWFmY2MtNjY0Yi00N2FmLTk1MmUtNTIxYTE0ZDJjM2QwIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmdpdGxhYi1hZG1pbiJ9.RXFvKk46hcB7m0OPLcROf-fQYJxBQ33UmSZRdiKaf8ulA73RZ35VShz1KY3YLYRctBeY1dZDjmGiguGpP9cvfGbAj_uy65vFDo02BtjOqIo-ueJ1T6k-ktT6E8O7BnmnGrD-QWqxG48FWLNkgj6ySlqWGoIX5Km7iqdslK18PNsFFzJSAYvai3-ZuDtbI9zhSANJxM-GMuwQY9X6uzso6dQ6aBwwEMzJvURy_Y6ibaukabThrkPusZKkN4b-67udvGg38jW7wwQuyLN8UrZrOSm1jrxWK3p5AWOwaq7HWkHD00oN3aWpTJkXpBBkKJTom4pf5JEHNPwpZijqlvxNQA% 
#Создайте GitLab Runner
helm repo add gitlab https://charts.gitlab.io
helm install --namespace default gitlab-runner -f values.yaml gitlab/gitlab-runner

kubectl --namespace default get services -o wide -w ingress-nginx-controller
~~~
