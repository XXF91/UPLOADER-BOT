# استخدم صورة بايثون الرسمية
FROM python:3.10.8

# تعيين منطقة التوقيت إلى UTC لتجنب مشاكل التزامن
ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# تثبيت الأدوات اللازمة لمزامنة الوقت
RUN apt-get update && apt-get install -y ntpdate ffmpeg && apt-get clean
RUN apt-get update && apt-get install -y ntpdate
RUN ntpdate time.google.com
# تحديد مجلد العمل
WORKDIR /app

# نسخ الملفات إلى الحاوية
COPY ./ /app

# منع التخزين المؤقت لملفات بايثون
ENV PYTHONUNBUFFERED=1

# تثبيت المتطلبات
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# مزامنة الوقت مع خادم Google قبل تشغيل البوت
RUN ntpdate -q time.google.com

# تشغيل البوت عند بدء الحاوية
CMD gunicorn app:app & python3 bot.py
