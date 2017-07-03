# xcodebuild build-for-testing -project OCMonkey.xcodeproj -scheme MonkeyRunner -derivedDataPath /tmp/derivedDataPath3 -sdk iphonesimulator

DERIVED_DATA_PATH=/tmp/buildOCMonkeyLib
SCHEME=OCMonkeyLib
CONFIG=Debug
PRODUCT_TYPE="framework"
PRODUCT_NAME="$SCHEME"
PRODUCT_FULLNAME="${PRODUCT_NAME}.${PRODUCT_TYPE}"

# rm -rf $DERIVED_DATA_PATH
echo "Build for iphoneos:"
xcodebuild build -scheme $SCHEME -configuration $CONFIG -sdk iphoneos -derivedDataPath $DERIVED_DATA_PATH

echo "Build for iphonesimulator:"
xcodebuild build -scheme $SCHEME -configuration $CONFIG -sdk iphonesimulator -derivedDataPath $DERIVED_DATA_PATH

echo "Merge binaries:"

IPHONEOS_DIR="${DERIVED_DATA_PATH}/Build/Products/${CONFIG}-iphoneos"
IPHONESIMULATOR_DIR="${DERIVED_DATA_PATH}/Build/Products/${CONFIG}-iphonesimulator"
IPHONEUNIVERSAL_DIR="${DERIVED_DATA_PATH}/Build/Products/${CONFIG}-iphoneuniversal"
rm -rf $IPHONEUNIVERSAL_DIR
mkdir $IPHONEUNIVERSAL_DIR

UniversalFramework="${IPHONEUNIVERSAL_DIR}/${PRODUCT_FULLNAME}"
IphoneosFramework="${IPHONEOS_DIR}/${PRODUCT_FULLNAME}"
IphonesimulatorFramework="${IPHONESIMULATOR_DIR}/${PRODUCT_FULLNAME}"
cp -r $IphoneosFramework $UniversalFramework
lipo -create "${IphoneosFramework}/${PRODUCT_NAME}" "${IphonesimulatorFramework}/${PRODUCT_NAME}" -output "${UniversalFramework}/${PRODUCT_NAME}"
lipo -info "${UniversalFramework}/${PRODUCT_NAME}"

SubFrameworkName="Peertalk"
SubFrameworkFullName="${SubFrameworkName}.framework"
lipo -create \
"${IphoneosFramework}/Frameworks/${SubFrameworkFullName}/${SubFrameworkName}" "${IphonesimulatorFramework}/Frameworks/${SubFrameworkFullName}/${SubFrameworkName}" -output "${UniversalFramework}/Frameworks/${SubFrameworkFullName}/${SubFrameworkName}"
lipo -info "${UniversalFramework}/Frameworks/${SubFrameworkFullName}/${SubFrameworkName}"

