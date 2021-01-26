# Builder
FROM goreleaser/goreleaser:v0.147.2 AS builder

WORKDIR /project

COPY ./ /project

ENV GOPRIVATE=gitlab.com/ip-guiabolso/go-project-template

ENV GIT_CLONE_PATH=/go

ENV TOKEN=8c7gKpeS7xnGMshQ9PXz

ENV GIT_CLONE_PATH=/project/gitlab.com/ip-guiabolso/go-project-template

RUN git config --global url."https://gitlab-ci-token:${TOKEN}@gitlab.com/".insteadOf "https://gitlab.com/"

RUN goreleaser --snapshot --skip-publish --rm-dist

# Application
FROM alpine

RUN apk add tzdata &&  cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

COPY --from=builder /project/dist/go-project-template_linux_amd64/go-project-template /usr/local/bin/go-project-template

CMD ["go-project-template"]
