#on part sur une image python legere et compatible avec psycopg2
FROM python:3.11-slim

# VOIR SI JE GARDE
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

#notre dossier de travail dans le conteneur
WORKDIR /app

#on installe les dependances systeme necessaires pour psycopg2
RUN apt-get update && apt-get install -y \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

#on recup nos biblio
COPY requirements-docker.txt .

#on installe les biblio python
RUN pip install --no-cache-dir -r requirements-docker.txt

#on copie le reste du projet
COPY . .

#le port
EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
