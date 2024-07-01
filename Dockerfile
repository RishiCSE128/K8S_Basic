FROM python:3.12
ADD requirements.txt .
ADD app.py .
RUN pip3 install -r requirements.txt
EXPOSE 5000
CMD ["python3","app.py"]




