FROM python:3.10-slim

WORKDIR /app

COPY hello.py .

RUN pip install -r requirements.txt

CMD ["python", "hello.py"]