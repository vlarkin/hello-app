FROM python:3.11-alpine

ENV VERSION=1.0

RUN mkdir /app
WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY *.py .

EXPOSE 80
CMD ["python", "/app/main.py"]
