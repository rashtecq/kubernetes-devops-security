package main

deny[msg] {
  input.kind == "Deployment"
  not input.spec.template.spec.containers[0].securityContext.runAsNonRoot = true

  msg := "Containers must not run as root" - use runAsNonRoot within container security securityContext"
}

deny[msg] {
    input.kind == "Service"
    not input.spec.Type = "NodePort"
    msg = "Service Type should be NodePort"
}
