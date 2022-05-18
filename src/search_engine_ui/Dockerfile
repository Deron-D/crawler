FROM python:3.6-alpine

WORKDIR /app
COPY . /app

RUN pip install -r requirements.txt
# -r requirements-test.txt

# ENV MONGO mongo
# ENV MONGO_PORT 27017
ENV FLASK_APP ui.py

WORKDIR /app/ui
EXPOSE 8000
ENTRYPOINT ["gunicorn", "ui:app", "-b", "0.0.0.0"]

