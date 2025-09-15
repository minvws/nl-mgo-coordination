FROM marketsquare/robotframework-browser:19.1

WORKDIR /home/pwuser

COPY . /home/pwuser
RUN pip install poetry && \
    poetry install && \
    .venv/bin/rfbrowser init

USER root
RUN mkdir -p results && \
    chown -R pwuser:pwuser /home/pwuser

USER pwuser
ENTRYPOINT ["/bin/bash"]
