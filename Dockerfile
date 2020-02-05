FROM python:3.8.1

RUN apt-get update

RUN apt-get install locales locales-all -y
ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US.UTF-8'
ENV LC_ALL 'en_US.UTF-8'

ENV TZ 'America/Lima'
RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install libgeos-dev libspatialindex-dev -y

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

CMD jupyter lab \
  --ip 0.0.0.0 \
  --port 8888 \
  --no-browser \
  --allow-root \
  --NotebookApp.token=''