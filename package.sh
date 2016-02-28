pod install --verbose --no-repo-update &&  \
xcodebuild -workspace LZAlbum.xcworkspace -scheme LZAlbum archive -archivePath ./build/LZAlbum.xcarchive && \
rm -rf ./build/LZAlbum.ipa && \
xcodebuild -exportArchive -exportFormat ipa -archivePath build/LZAlbum.xcarchive -exportPath build/LZAlbum.ipa && \
fir p build/LZAlbum.ipa -T eeca39297cfda6e31a67c9b66e1edd07
