.PHONY: test run docker-build docker-run tf-fmt tf-init tf-plan tf-apply

IMAGE ?= hello-cicd:local

test:
	cd app && npm test

run:
	cd app && npm start

docker-build:
	docker build -t $(IMAGE) .

docker-run: docker-build
	docker run --rm -p 3000:3000 $(IMAGE)

tf-fmt:
	terraform -chdir=infra fmt -recursive

tf-init:
	terraform -chdir=infra init -backend-config=backend.hcl

tf-plan:
	terraform -chdir=infra plan

tf-apply:
	terraform -chdir=infra apply
