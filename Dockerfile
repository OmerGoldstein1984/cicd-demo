FROM python:3.11-slim

# Prevent Python from writing .pyc files and buffer flushing
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Copy application code
COPY app/ ./app/

# Install runtime dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r app/requirements.txt gunicorn

EXPOSE 80

# Run the Flask app using Gunicorn (app located at ./app/main.py, app object named `app`)
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:80", "main:app", "--chdir", "app"]
