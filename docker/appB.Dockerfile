FROM python:3.11-slim

# Install curl
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY src/appB/requirements.txt .
RUN pip install -r requirements.txt

COPY src/appB/app ./app

ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app
ENV FLASK_DEBUG=1

EXPOSE 5001

CMD ["flask", "run", "--host=0.0.0.0", "--port=5001"] 