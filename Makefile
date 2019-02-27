init: .cloneScript .updateCarthage

.updateCarthage:
	carthage update --platform iOS --no-use-binaries --use-ssh --cache-builds
	make -C Carthage/Checkouts/swift-prelude/

.cloneScript:
	-git clone git@github.com:cheeseonhead/ios-scripts.git
