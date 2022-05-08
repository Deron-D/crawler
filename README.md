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
cd ../terraform-k8s 
terraform init
terraform apply --auto-approve
yc managed-kubernetes cluster get-credentials k8s-dev --external --force
helm install ingress-nginx ingress-nginx/ingress-nginx
kubectl apply -f ../k8s/crawler/namespaces.yml
kubectl apply -f ../k8s/crawler/ -n dev  
~~~
