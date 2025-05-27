# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Copy requirements (Flask only for now)
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt


# Copy the rest of the application
COPY . .
# Ensure the data directory exists and is writable (for SQLite on PVC)
RUN mkdir -p /app/data && chmod 777 /app/data

# Expose the port Flask runs on
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]
