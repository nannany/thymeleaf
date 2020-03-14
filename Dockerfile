FROM node:13 AS front-build

WORKDIR /work1
ADD my-app .

RUN npx yarn && npx yarn build

FROM maven:3.6 AS back-build
WORKDIR /work2
ADD thymeleaf .
RUN mkdir -p /work2/thymeleaf/src/main/resources/static
COPY --from=front-build /work1/build/ /work2/thymeleaf/src/main/resources/static/
RUN mkdir -p /work2/thymeleaf/src/main/resources/templates && \
      sed -e "s!<meta name=\"from-environment\" content=\"\"/>!<meta name=\"from-environment\" th:content=\${@environment.getProperty('thymeleaf.test')}>!" \
        /work2/thymeleaf/src/main/resources/static/index.html > /work2/thymeleaf/src/main/resources/templates/index.html && \
      rm /work2/thymeleaf/src/main/resources/static/index.html && \
      mvn package

FROM adoptopenjdk/openjdk11:jdk-11.0.6_10-alpine

COPY --from=back-build /work2/target/thymeleaf-0.0.1-SNAPSHOT.jar .

ENTRYPOINT ["java", "-jar", "thymeleaf-0.0.1-SNAPSHOT.jar"]
