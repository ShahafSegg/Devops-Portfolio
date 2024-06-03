FROM python:3.9-slim

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY ./static/index.html ./static

ENTRYPOINT ["python", "app.py"]
