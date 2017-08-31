#!/usr/bin/env bash

# This script is intended for CI system (RDM) to perform a CI job.
# More details at:
#   http://km.oa.com/group/20528/articles/show/259187
#   http://km.oa.com/group/18155/articles/show/149556


# WORKSPACE is an environment variable defined by the CI System (RDM)
DERIVED_DATA_PATH=$WORKSPACE
SCHEME=OCMonkeyLib
RUNNER_SCHEME=MonkeyRunner
CONFIG=Debug
PRODUCT_TYPE="framework"
PRODUCT_NAME="$SCHEME"
PRODUCT_FULLNAME="${PRODUCT_NAME}.${PRODUCT_TYPE}"


# The 'result' folder is required by CI system to put the output files
#  you want to display on the CI system's front-end (web page).
if [ -e result ] ;then
rm -r result
fi
mkdir result

echo "About to print all envs."
printenv

# xcodebuild build-for-testing -project OCMonkey.xcodeproj -scheme MonkeyRunner -derivedDataPath /tmp/derivedDataPath3 -sdk iphonesimulator

echo "Clean workspace:"
xcodebuild clean -scheme $SCHEME -derivedDataPath $DERIVED_DATA_PATH

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

# Remember, only files under $WORKSPACE/result will be displayed by the CI System (RDM).
# Also XXX.framework is a folder and it will not be displayed.
# So we need to zip it.
ZIP_OUTPUT="${PRODUCT_FULLNAME}.zip"
cp -rf ${UniversalFramework} .
zip -rq ${ZIP_OUTPUT} ${PRODUCT_FULLNAME}
cp ${ZIP_OUTPUT} "${WORKSPACE}/result"



echo "Build runner for iphoneos:"
xcodebuild build-for-testing -scheme ${RUNNER_SCHEME} -configuration ${CONFIG} -sdk iphoneos -derivedDataPath ${DERIVED_DATA_PATH}
echo "Build runner for simulator:"
xcodebuild build-for-testing -scheme ${RUNNER_SCHEME} -configuration ${CONFIG} -sdk iphonesimulator -derivedDataPath ${DERIVED_DATA_PATH}
AppFullName="${RUNNER_SCHEME}-Runner.app"
AppIphoneOSPath="${IPHONEOS_DIR}/${AppFullName}"
AppIphoneSIPath="${IPHONESIMULATOR_DIR}/${AppFullName}"

AppIphoneOSPathNew="${IPHONEOS_DIR}/${RUNNER_SCHEME}.app"
AppIphoneSIPathNew="${IPHONESIMULATOR_DIR}/${RUNNER_SCHEME}.app"

mv ${AppIphoneOSPath} ${AppIphoneOSPathNew}
mv ${AppIphoneSIPath} ${AppIphoneSIPathNew}

ZIP_OS_OUTPUT="${RUNNER_SCHEME}-iphoneos.ipa"
ZIP_SI_OUTPUT="${RUNNER_SCHEME}-iphonesimulator.ipa"

mkdir Payload
cp -rf ${AppIphoneOSPathNew} Payload
zip -rq ${ZIP_OS_OUTPUT} Payload/
cp ${ZIP_OS_OUTPUT} "${WORKSPACE}/result"

rm -rf Payload
mkdir Payload
cp -rf ${AppIphoneSIPathNew} Payload
zip -rq ${ZIP_SI_OUTPUT} Payload/
cp ${ZIP_SI_OUTPUT} "${WORKSPACE}/result"