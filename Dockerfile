# استخدم صورة Python المناسبة
FROM python:3.10.8

# ضبط التوقيت إلى UTC
ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# تثبيت الأدوات اللازمة لمزامنة الوقت
RUN apt-get update && apt-get install -y ntpdate ffmpeg && apt-get clean

# تحديد مجلد العمل
WORKDIR /app

# نسخ الملفات إلى الحاوية
COPY ./ /app

# تثبيت المتطلبات
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# تشغيل مزامنة الوقت قبل تشغيل التطبيق
CMD ntpdate -s time.google.com && gunicorn app:app & python3 bot.py
