VERSION=$(shell git describe --tags --exact-match 2> /dev/null || git symbolic-ref -q --short HEAD)
GITCOMMIT=$(shell git rev-parse --short HEAD 2> /dev/null || true)
BUILDTIME=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

PROJECT_NAME = `basename ${PWD}`
PROJECT_DIR = ${PWD}
MODULE_NAME = `go list`
LDFLAGS = \
	-X $(MODULE_NAME)/version.GitCommit=$(GITCOMMIT) \
	-X $(MODULE_NAME)/version.Version=$(VERSION) \
	-X $(MODULE_NAME)/version.BuildTime=$(BUILDTIME)

deps: ## Install project dependencies
	GOPRIVATE="gitlab.com/ip-guiabolso" go mod download
	GOPRIVATE="gitlab.com/ip-guiabolso" go mod tidy
events: ## Update events
    GOPRIVATE="gitlab.com/ip-guiabolso" go get -u gitlab.com/ip-guiabolso/events-protocol-go
    GOPRIVATE="gitlab.com/ip-guiabolso" go mod tidy

clean: ## Remove ignored files and folders
	git check-ignore --no-index \
		{,.[!.]}**  \
		{,.[!.]}**/{,.[!.]}** \
		{,.[!.]}**/{,.[!.]}**/{,.[!.]}** \
		{,.[!.]}**/{,.[!.]}**/{,.[!.]}**/{,.[!.]}** \
		| grep -v vendor \
		| grep -v .idea \
		| sort | uniq \
		| while read line; do rm -rf "$$line";done;

binary: ## Build binary to current OS
	CGO_ENABLED=0 GOPRIVATE="gitlab.com/ip-guiabolso" go build -o "$(PROJECT_NAME)" --ldflags "$(LDFLAGS)" "$(MODULE_NAME)"

.PHONY: fmt
fmt: ## fmt go files
	go fmt `go list ./... | grep -v /vendor/`

vet: ## vet go files
	go vet `go list ./... | grep -v /vendor/`

toolkit: ## Update go-toolkit
	GOPRIVATE="gitlab.com/ip-guiabolso" go get -u gitlab.com/ip-guiabolso/go-toolkit
	GOPRIVATE="gitlab.com/ip-guiabolso" go mod tidy

.PHONY: test
test: ## Test go files
	go test -race `go list ./...|grep -v "/vendor"` -coverpkg=./... -coverprofile ./cover.out ./...


help: ## print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: rename
rename:
	sed -i -e  "s/go-project-template/github.com\/gbprojectbr\/$(PROJECT_NAME)/g" ./go.mod
	sed -i -e  "s/go-project-template/$(PROJECT_NAME)/g" ./Jenkinsfile
	sed -i -e  "s/go-project-template/$(PROJECT_NAME)/g" ./Dockerfile
	sed -i -e  "s/go-project-template/$(PROJECT_NAME)/g" ./Dockerfile-tests-bkp
	sed -i -e  "s/go-project-template/github.com\/gbprojectbr\/$(PROJECT_NAME)/g" ./cmd/server.go
	sed -i -e  "s/go-project-template/github.com\/gbprojectbr\/$(PROJECT_NAME)/g" ./main.go
