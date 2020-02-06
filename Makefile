-SHELL:=/bin/sh
export DOCKER_BUILDKIT=1

install:
	sudo apt remove containerd docker docker-engine docker.io runc -y || true
	sudo apt update -y
	sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common -y
	sudo passwd $(USER)
	$(eval export DISTRIBUTOR_ID=$(shell lsb_release -si))
	$(eval export DISTRIBUTOR_ID=$(shell echo $(DISTRIBUTOR_ID) | awk '{print tolower($$0)}'))
	curl -fsSL https://download.docker.com/linux/$$DISTRIBUTOR_ID/gpg | sudo apt-key add -
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$$DISTRIBUTOR_ID $$(lsb_release -cs) stable"
	sudo apt update -y
	sudo apt install containerd.io docker-ce docker-ce-cli -y
	sudo usermod -aG docker $(USER)
	su - $(USER)

run:
	docker build . -f Dockerfile -t alicorp/jupyterlab:1.0 --no-cache=False
	docker run \
		-it \
		--rm \
		-v $(PWD):/app:rw \
		-p 8888:8888 \
		alicorp/jupyterlab:1.0

bash:
	docker build . -f Dockerfile -t alicorp/jupyterlab:1.0 --no-cache=False
	docker run \
		-it \
		--rm \
		-v $(PWD):/app:rw \
		-p 8888:8888 \
		alicorp/jupyterlab:1.0 \
		bash