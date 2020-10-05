module github.com/infomaniak/cert-manager-webhook-infomaniak

go 1.15

// see https://github.com/kubernetes/kubectl/issues/925
replace vbom.ml/util => github.com/fvbommel/sortorder v1.0.1

require (
	github.com/jetstack/cert-manager v1.0.1
	k8s.io/apiextensions-apiserver v0.19.0
	k8s.io/apimachinery v0.19.0
	k8s.io/client-go v0.19.0
	k8s.io/klog v1.0.0
	k8s.io/klog/v2 v2.3.0
)
