# veggie_model_service/Dockerfile

# Base image
FROM python:3.9-slim

# Install dep OS untuk OpenCV
RUN apt-get update && apt-get install -y \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# User non-root (standar HF)
RUN useradd -m -u 1000 user
USER user
ENV PATH="/home/user/.local/bin:${PATH}"

# Workdir
WORKDIR /app

# Install dependencies
COPY --chown=user requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Copy semua file proyek (app.py, model, scaler)
COPY --chown=user . /app

# Expose port HF
EXPOSE 7860

# Jalankan FastAPI via uvicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "7860"]
