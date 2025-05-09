from fastapi.testclient import TestClient
from main import app
import tempfile
import os

client = TestClient(app)

def test_parse_text_endpoint():
  with tempfile.NamedTemporaryFile(mode="w+", suffix=".txt", delete=False) as f:
    f.write("API text test")
    f.flush()
    path = f.name
  with open(path, "rb") as f:
    response = client.post("/parse", files={"file": ("test.txt", f, "text/plain")})
  os.remove(path)
  assert response.status_code == 200
  data = response.json()
  assert data["filetype"] == "txt"
  assert "API text test" in data["content"]

def test_parse_path_endpoint():
  with tempfile.NamedTemporaryFile(mode="w+", suffix=".csv", delete=False) as f:
    f.write("a,b\n5,6")
    f.flush()
    path = f.name
  response = client.post("/parse-path", json={"filepath": path})
  os.remove(path)
  assert response.status_code == 200
  data = response.json()
  assert data["filetype"] == "csv"
  assert "a,b" in data["content"] and "5,6" in data["content"]

def test_parse_path_not_found():
  response = client.post("/parse-path", json={"filepath": "nonexistent.txt"})
  assert response.status_code == 404
  assert response.json()["detail"] == "File not found."
