FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
COPY shelly-mapper.py shelly-mapper.py

RUN pip install --no-cache-dir -r requirements.txt

CMD [ "python", "./shelly-mapper.py" ]

