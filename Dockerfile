FROM python:3.12-slim

# Install system dependencies
RUN apt update && apt install -y \
  libreoffice \
  unoconv \
  tesseract-ocr \
  poppler-utils \
  && apt clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Use a tmpfs mount for /tmp to avoid disk persistence (can be set at runtime)
ENV TMPDIR=/tmp

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
