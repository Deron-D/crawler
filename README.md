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

#GitLab CI
cd k8s/gitlab-ci
kubectl apply -f gitlab-admin-service-account.yaml
kubectl -n kube-system get secrets -o json | \
jq -r '.items[] | select(.metadata.name | startswith("gitlab-admin")) | .data.token' | base64 --decode > token.txt

helm install --namespace default gitlab-runner -f values.yaml gitlab/gitlab-runner
kubectl get pods -n default | grep gitlab-runner

yc managed-kubernetes cluster get k8s-otus --format=json \
| jq -r .master.master_auth.cluster_ca_certificate
-----BEGIN CERTIFICATE-----
MIIC5zCCAc+gAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl
cm5ldGVzMB4XDTIyMDUxODA3MzM1NFoXDTMyMDUxNTA3MzM1NFowFTETMBEGA1UE
AxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAM6u
yCYe90aKs3ZCMHO9A0qt/fGbCN2HU16xr0WH2wBAFwsg1dOCT0ZEs1OmLnBWbBuh
i5qqzXl+scf+yGG36b3hPmrwwp2p8e8850IIeh2MWQ6otd1BR4fgUu8kkqrIc6+J
a8a/RieuP0VFJJvpIrwFSzwqSvIJCoG1PUE6OXX+ci1piefsyE63+4Jhp5Q94gG6
068PMkOf3QPt4irgNaS4Z3GBwo0S6QBCX2CSDeo9jBtd2Kh0khryIliGiwhG1YjQ
7iulsKiMacRpuW86rq0mn5yaw1ci8MN0qTpQmXYfiZUV6zUV39AvyMS+CINpUhbK
gvnvYhjVuTbIfmRUJmECAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB
/wQFMAMBAf8wHQYDVR0OBBYEFCBRARo08mR4HLxLXCWH8WaHhXnCMA0GCSqGSIb3
DQEBCwUAA4IBAQClmGzB0Q92MGmymz7k4d3trDWWtvjsHw1oEZGvy479fOqqTz51
RrYXSwTop6kti41fjLLqI6xC1exn6zkeP4/X3GMwf0dE88NSAlJDV3hjTxte3SY2
Pm9poc+c9+FsPSq5FdVf0jHHg/A9o8M9q5AhXm0TvmoVOay4O1+6p4emiugB0Vgr
e4Lqb0hnRjQyUwH6+PAKqHdaMXe5w1HaeHBYtWiobxM4VJx5sl2DmcEvs0FHirKC
g4ZEw+0DMR7rmRdE9bMict9UK9BDvwS2ctKO9juJEHEMkhNSrASfr5kLRgO/h4jo
fF3B0Ik4uBX7DkzOTM1r+fxu/atEc2DvppQz
-----END CERTIFICATE-----


#Создайте GitLab Runner
helm repo add gitlab https://charts.gitlab.io
helm install --namespace default gitlab-runner -f values.yaml gitlab/gitlab-runner

kubectl --namespace default get services -o wide -w ingress-nginx-controller
~~~
