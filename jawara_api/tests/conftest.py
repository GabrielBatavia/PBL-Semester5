# tests/conftest.py
import sys
from pathlib import Path

# Arahkan ke folder jawara_api (parent dari tests)
ROOT_DIR = Path(__file__).resolve().parents[1]

# Tambahkan ke sys.path kalau belum ada
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))
