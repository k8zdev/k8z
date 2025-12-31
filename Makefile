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

.PHONY: update-icon
update-icon:
	dart run icons_launcher:create

.PHONY: decrypt
decrypt:
	@gpg --quiet --batch --yes --decrypt --passphrase="${LARGE_SECRET_PASSPHRASE}" \
	 --output ${PWD}/lib/firebase_options.dart ${PWD}/lib/firebase_options.dart.gpg
	echo "Decrypt firebase_options done"
	@gpg --quiet --batch --yes --decrypt --passphrase="${LARGE_SECRET_PASSPHRASE}" \
	 --output ${PWD}/lib/common/secrets.dart ${PWD}/lib/common/secrets.dart.gpg
	echo "Decrypt secrets done"

.PHONY: dmg
dmg:
	@echo Building DMG...
	@hack/build_macos_dmg.sh

# BDD tests using gherkin framework may exit with code 79 (no standard flutter tests)
# This is expected behavior as scenarios are executed by GherkinRunner
.PHONY: test-bdd-macos
test-bdd-macos:
	@flutter test -d macos test/bdd/macos_fast_runner.dart || [ $$? -eq 79 ]

.PHONY: test-bdd-ios
test-bdd-ios:
	@flutter test -d simulator test/bdd/ios_critical_runner.dart || [ $$? -eq 79 ]
