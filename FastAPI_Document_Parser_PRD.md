# 📄 Document Parser API - Product Requirements Document (PRD)

## 📌 Overview
The **Document Parser API** is a FastAPI-based microservice designed to parse and extract readable text from a wide range of document formats. It acts as a centralized preprocessing service that enables other systems (e.g., AI agents, n8n workflows, automation pipelines) to receive clean, structured text from various uploaded file types. 

The goal is to support a wide variety of formats including Office documents, PDFs, plain text, images (OCR), emails, and archives.

---

## 🎯 Goals
- ✅ Accept file uploads or file paths via HTTP POST.
- ✅ Automatically detect file type and route to the appropriate parser.
- ✅ Return extracted plain text content.
- ✅ Support modern and legacy document types.
- ✅ Expose clean REST endpoints for use in automation flows.
- ✅ Containerize the service for secure on-prem deployment.

---

## 🛠 Supported File Types & Handlers

| File Type(s)        | Parser / Tool         | Install Method | Notes |
|---------------------|------------------------|----------------|-------|
| `.docx`             | `python-docx` or `mammoth` | pip            | Structured Word format |
| `.doc`, `.xls`, `.ppt` | `unoconv` + `libreoffice` | apt            | Requires LibreOffice for legacy formats |
| `.xlsx`             | `openpyxl`, `pandas`   | pip            | Handles modern Excel |
| `.csv`              | `csv`, `pandas`        | pip            | Simple parsing |
| `.txt`, `.md`, `.log` | Native Python          | built-in       | UTF-8 assumed |
| `.pdf`              | `pdfplumber`, `pdfminer.six`, `PyMuPDF` | pip | Handle both extractable and image-based PDFs |
| `.pptx`             | `python-pptx`          | pip            | Slide text only |
| `.png`, `.jpeg`     | `pytesseract` + `tesseract-ocr` | apt + pip    | OCR required |
| `.eml`              | `email` module, `extract-msg` | pip        | Extracts body + subject + metadata |
| `.zip`, `.rar`      | `zipfile`, `rarfile`, `unrar` | apt + pip    | Unpacks archives, recursively parses contents |

---

## 🧱 System Requirements

### Dependencies
- Python 3.12+
- FastAPI
- Uvicorn (ASGI server)

### Pip Requirements (`requirements.txt`)
```
fastapi
uvicorn
python-docx
mammoth
pandas
openpyxl
pdfminer.six
pdfplumber
PyMuPDF
python-pptx
pytesseract
extract-msg
rarfile
python-multipart
```

### OS-Level Dependencies (for Docker or apt-based install)
```
apt install -y \
    libreoffice \
    unoconv \
    tesseract-ocr \
    poppler-utils \
    unrar
```

---

## 🔌 API Endpoints

### `POST /parse`
**Description:** Accepts file upload and returns extracted plain text.

**Payload:**
- `file`: File upload via `multipart/form-data`

**Response:**
```json
{
  "filename": "upload.docx",
  "filetype": "docx",
  "content": "Extracted plain text here..."
}
```

### `POST /parse-path`
**Description:** Accepts full file path (for internal Docker/n8n workflows).

**Payload:**
```json
{
  "filepath": "/tmp/upload-abc123.docx"
}
```

**Response:** Same as above.

---

## 📦 Dockerfile (Sketch)
```Dockerfile
FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    libreoffice \
    unoconv \
    tesseract-ocr \
    poppler-utils \
    unrar \
 && apt-get clean

WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

---

## 🧪 Testing Examples
- Upload `.docx` → get bullet point text.
- Upload `.pdf` → extract text from both selectable and image-based pages.
- Upload `.zip` with multiple docs → receive flat, concatenated text response.
- Upload `.png` with text → run OCR and return results.

---

## 🚫 Non-Goals
- ❌ Live editing of parsed documents.
- ❌ Output in formats other than plain text (e.g., HTML, Markdown).
- ❌ Streaming large file chunks (initial version).

---

## 🔐 Security & Compliance
- No content is stored on disk after parsing.
- All processing happens in isolated temp directories.
- Option to mount a `tmpfs` volume in Docker to avoid disk persistence.
- Deployable fully on-prem with no cloud dependencies.

---

## 🧠 Future Enhancements
- Detect language and return metadata.
- Return structured format (e.g., JSON with sections/headers).
- Expose `/healthz` endpoint.
- Add rate limiting or token auth for protected use.

---

## 🧑‍💻 Team Roles
| Role             | Responsibility             |
|------------------|-----------------------------|
| API Dev          | Build and test endpoint logic |
| Parser Engineer  | Integrate and validate file handlers |
| DevOps           | Package Docker container and CI/CD |
| Security Officer | Ensure data handling compliance |

---

## 📆 Timeline
| Phase | Goal                        | Duration |
|-------|-----------------------------|----------|
| 1     | Basic `.docx`, `.txt`, `.pdf`, `.csv` support | 3 days |
| 2     | Add `.xlsx`, `.pptx`, `.eml`, `.zip`         | 2 days |
| 3     | Integrate `unoconv`, `tesseract`, OCR support | 3 days |
| 4     | Finalize Docker, cleanup, deploy-ready image | 2 days |
