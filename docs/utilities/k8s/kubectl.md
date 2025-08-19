
**Debug busybox**
`kubectl run curl-my --image=radial/busyboxplus:curl -i --tty --rm

**Real-time logs**

`kubectl logs -f -l app=duty-slack-app --max-log-requests 11   -n miniweb-testing
`kubectl logs --since=6h -l app=reporter -n miniweb-b
`kubectl edit roles.rbac.authorization.k8s.io leader-election-role
`Kubetail oauth2-proxy -n Grafana-system
`kubectl apply --force -f test_volume.yaml -n grafana-test