ARG PRODUCT_IMAGE 

FROM $PRODUCT_IMAGE as product_image
COPY --chown=sagadmin ./scripts /src/scripts
#copy config.xml
COPY --chown=sagadmin ./data/config.xml /opt/softwareag/UniversalMessaging/tools/runner/config.xml 

RUN chmod +x /src/scripts/* && /src/scripts/uploadAssets.sh

ENTRYPOINT /src/scripts/Entrypoint.sh