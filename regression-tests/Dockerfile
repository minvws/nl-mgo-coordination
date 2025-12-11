FROM marketsquare/robotframework-browser:19

WORKDIR /home/pwuser

USER root
RUN apt-get update && \
    apt-get install -y python3-pip && \
    ln -sf /usr/bin/python3 /usr/bin/python && \
    python3 -m pip install --upgrade --ignore-installed pip setuptools wheel --break-system-packages && \
    python3 -m pip install --ignore-installed poetry --break-system-packages && \
    poetry config virtualenvs.create false

COPY pyproject.toml poetry.lock* ./

RUN poetry install

COPY . .

RUN rfbrowser init && \
    mkdir -p /home/pwuser/results && \
    chown -R pwuser:pwuser /home/pwuser

USER pwuser

ENTRYPOINT ["/bin/bash"]
