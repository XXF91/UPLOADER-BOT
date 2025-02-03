FROM clintonabraham/clinton:latest

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD gunicorn app:app & python3 bot.py
