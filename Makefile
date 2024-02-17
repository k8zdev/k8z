K8SAPIVER=v1.25.0
K8SMODELPATH=lib/models/kubernetes
K8SAPISPEC=https://raw.githubusercontent.com/kubernetes/kubernetes/${K8SAPIVER}/api/openapi-spec/swagger.json

.PHONY: bindings-android

.PHONY: install-gomobile
install-gomobile:
	go install golang.org/x/mobile/cmd/gomobile@latest

.PHONY: bindings-ios
bindings-ios:
	mkdir -p ios/Runner/libs
	gomobile bind -o ios/Runner/libs/K8z.xcframework -target=ios github.com/k8zdev/k8z/cmd/mobile

.PHONY: library-ios
library-ios:
	GOARCH=amd64 GOOS=darwin CGO_ENABLED=1 SDK=iphonesimulator CC=$(PWD)/hack/clangwrap.sh CGO_CFLAGS="-fembed-bitcode" go build -buildmode=c-archive -o tmp/libs/libk8z.x64.a github.com/k8zdev/k8z/cmd/
	GOARCH=arm64 GOOS=ios CGO_ENABLED=1 SDK=iphoneos CC=$(PWD)/hack/clangwrap.sh CGO_CFLAGS="-fembed-bitcode" go build -buildmode=c-archive -o tmp/libs/libk8z.arm64.a github.com/k8zdev/k8z/cmd/
	mkdir -p ios/libs/ && cp tmp/libs/libk8z.arm64.h ios/libs/libk8z.h
	lipo -create tmp/libs/libk8z.x64.a tmp/libs/libk8z.arm64.a  -output ios/libs/libk8z.a

.PHONY: library-macos
library-macos:
	GOARCH=amd64 GOOS=darwin CGO_ENABLED=1 go build -ldflags "-w" -buildmode c-shared -o tmp/libs/libk8z.macos.x64.dylib github.com/k8zdev/k8z/cmd/
	GOARCH=arm64 GOOS=darwin CGO_ENABLED=1 go build -ldflags "-w" -buildmode c-shared -o tmp/libs/libk8z.macos.arm64.dylib github.com/k8zdev/k8z/cmd/
	lipo -create tmp/libs/libk8z.macos.x64.dylib tmp/libs/libk8z.macos.arm64.dylib -output macos/k8z.dylib

.PHONY: library
library: library-macos library-ios

.PHONY: gen-k8s-api-model
gen-k8s-api-model:
	@rm -fr tmp/lib/* && sed -i '' '/io_k8s.*$ /d' lib/models/models.dart
	@docker run --rm -v "${PWD}/tmp/:/local/" -v "${PWD}/hack/k8sapi/:/api/" openapitools/openapi-generator-cli:latest generate -i /api/${K8SAPIVER}_swagger.json -g dart -o /local/
	@bash hack/codefix.sh

