ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE

WORKDIR /home/irisowner/dev/

COPY . .

USER root
RUN chmod 777 /home/irisowner/dev/templates/
USER irisowner

RUN pip install jinja2schema

ARG INSTANCE_DEST
ENV INSTANCE_DEST=${INSTANCE_DEST}

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    iris stop IRIS quietly
