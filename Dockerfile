FROM quay-proxy.ci.openshift.org/openshift/ci:ocp_builder_rhel-9-golang-1.24-openshift-4.20 AS builder
WORKDIR /go/src/github.com/openshift/cluster-cloud-controller-manager-operator
COPY . .
RUN make build

FROM quay-proxy.ci.openshift.org/openshift/ci:ocp_4.20_base-rhel9
COPY --from=builder /go/src/github.com/openshift/cluster-cloud-controller-manager-operator/bin/cluster-controller-manager-operator .
COPY --from=builder /go/src/github.com/openshift/cluster-cloud-controller-manager-operator/bin/config-sync-controllers .
COPY --from=builder /go/src/github.com/openshift/cluster-cloud-controller-manager-operator/bin/azure-config-credentials-injector .
COPY --from=builder /go/src/github.com/openshift/cluster-cloud-controller-manager-operator/manifests manifests

LABEL io.openshift.release.operator true
