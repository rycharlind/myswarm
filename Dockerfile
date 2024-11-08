FROM --platform=$BUILDPLATFORM python:3.11-slim
# FROM python:3.11-slim

WORKDIR /app

# Copy poetry files
COPY pyproject.toml poetry.lock ./

# Install poetry
RUN pip install poetry

# Install dependencies
RUN poetry config virtualenvs.create false \
  && poetry install --no-interaction --no-ansi

# Copy the rest of your application
COPY . .

# Command to run your application
CMD ["python", "lib/app.py"]