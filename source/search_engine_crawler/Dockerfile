FROM python:3.6-alpine

ADD . /

RUN pip install -r requirements.txt -r requirements-test.txt

ENV MONGO crawler_db
ENV MONGO_PORT 27017
ENV RMQ_HOST rabbitmq
ENV RMQ_QUEUE crawler
ENV RMQ_USERNAME rabbitmq
ENV RMQ_PASSWORD rabbitmq
ENV CHECK_INTERVAL 30
ENV EXCLUDE_URLS '.*github.com'

CMD [ "python", "-u", "crawler/crawler.py", "https://vitkhab.github.io/search_engine_test_site/" ]