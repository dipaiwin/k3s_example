S=root@35.228.146.46
CP=rsync -ahhhh --info=progress2
deploy_k3s:
	cd ansible && ansible-playbook -v -l cloud site.yaml
k3s_get_conf:
	mkdir -p ./ci/.kube
	$(CP) $(S):/etc/rancher/k3s/k3s.yaml ./ci/.kube/config
create_cert:
	./ci/scripts/cert.sh
N=
set-context:
	kubectl config set-context --current --namespace=$N

ns:
	@echo `kubectl config view --minify --output 'jsonpath={..namespace}'`

deploy_app:
	kubectl apply -f ./ci/example-app
# export KUBECONFIG=`pwd`/ci/.kube/config

C=
install_chart:
	helm install $(C) ./ci/charts/$(C)

uninstall_chart:
	helm uninstall $(C)
secret_rancher:
	cd certs && kubectl -n cattle-system create secret tls tls-rancher-ingress \
      --cert=tls.crt \
      --key=tls.key