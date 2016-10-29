pod install --verbose --no-repo-update &&  \
xcodebuild -workspace LZAlbum.xcworkspace -scheme LZAlbum archive -archivePath ./build/LZAlbum.xcarchive && \
rm -rf ./build/LZAlbum.ipa && \
xcodebuild -exportArchive -exportFormat ipa -archivePath build/LZAlbum.xcarchive -exportPath build/LZAlbum.ipa && \
fir p build/LZAlbum.ipa -T 2713fc7a920dcf1e937e126fbceae34a
