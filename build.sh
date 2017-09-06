#!/usr/bin/env bash

# This script is intended for CI system (RDM) to perform a CI job.
# More details at:
#   http://km.oa.com/group/20528/articles/show/259187
#   http://km.oa.com/group/18155/articles/show/149556


CONFIG=Debug


# WORKSPACE is an environment variable defined by the CI System (RDM)
# Your project will be clone under this directory. That means: git clone REPOSITORY_ADDRESS ${WORKSPACE}
# Also this build.sh execution context will be at ${WORKSPACE}. You don't need to change direcotry.
# Here we check whether it is set otherwise assign a value to it for local usage.
DERIVED_DATA_PATH="/tmp/workspace"
if [ -z ${WORKSPACE+x} ]; then
	echo "WORKSPACE is unset"
	if [ -d "$DERIVED_DATA_PATH" ]; then
	    rm -rf
    fi
    mkdir ${DERIVED_DATA_PATH}
    cd ${DERIVED_DATA_PATH}
else
	echo "WORKSPACE is set to ${WORKSPACE}"
	DERIVED_DATA_PATH=${WORKSPACE}
fi


# GIT_COMMIT is an environment variable passed from the CI System (RDM)
# Here we check whether it is set otherwise assign a value to it for local usage.
revision="UnknownRevision"
if [ -z ${GIT_COMMIT+x} ]; then
    echo "GIT_COMMIT is unset."
else
	echo "GIT_COMMIT=${GIT_COMMIT}"
	# if GIT_COMMMIT is 123456789..., then revision=12345678
	revision=`echo ${GIT_COMMIT} | cut -c1-8`
fi


# Expecting a folder path
RemoveOldFolderIfExistAndCreateANewOne()
{
    if [ -z ${1+x} ]; then
        echo "Function need one argument!"
        return
    fi
    echo "Cleaning folder (or create if not exist): $1"
    if [ -e $1 ] ;then
    rm -r $1
    fi
    mkdir -p $1
}

# The 'result' folder is required by CI system to put the output files
#  you want to display on the CI system's front-end (web page).
ResultDir="${DERIVED_DATA_PATH}/result"
RemoveOldFolderIfExistAndCreateANewOne ${ResultDir}
IPHONEOS_DIR="${DERIVED_DATA_PATH}/Build/Products/${CONFIG}-iphoneos"
IPHONESIMULATOR_DIR="${DERIVED_DATA_PATH}/Build/Products/${CONFIG}-iphonesimulator"
IPHONEUNIVERSAL_DIR="${DERIVED_DATA_PATH}/Build/Products/${CONFIG}-iphoneuniversal"
RemoveOldFolderIfExistAndCreateANewOne ${IPHONEUNIVERSAL_DIR}


# Expect an argument: scheme name
BuildFramework()
{
    if [ -z ${1+x} ]; then
        echo "Function need one argument!"
        return
    fi

    SCHEME=$1
    PRODUCT_TYPE="framework"
    PRODUCT_NAME="$SCHEME"
    PRODUCT_FULLNAME="${PRODUCT_NAME}.${PRODUCT_TYPE}"

    echo "Start building framework: ${SCHEME}"

    echo "Clean workspace:"
    xcodebuild clean -scheme $SCHEME -derivedDataPath $DERIVED_DATA_PATH

    echo "Build for iphoneos:"
    xcodebuild build -scheme $SCHEME -configuration $CONFIG -sdk iphoneos -derivedDataPath $DERIVED_DATA_PATH

    echo "Build for iphonesimulator:"
    xcodebuild build -scheme $SCHEME -configuration $CONFIG -sdk iphonesimulator -derivedDataPath $DERIVED_DATA_PATH

    echo "Merge binaries:"


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
    ZIP_OUTPUT="${PRODUCT_FULLNAME}_${revision}.zip"
    cp -rf ${UniversalFramework} .
    zip -rq ${ZIP_OUTPUT} ${PRODUCT_FULLNAME}
    cp ${ZIP_OUTPUT} ${ResultDir}
}


BuildRunner()
{
    RUNNER_SCHEME=MonkeyRunner
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

    ZIP_OS_OUTPUT="${RUNNER_SCHEME}_r${revision}-iphoneos.ipa"
    ZIP_SI_OUTPUT="${RUNNER_SCHEME}_r${revision}-iphonesimulator.ipa"

    echo "Mark1"
    mkdir Payload
    cp -rf ${AppIphoneOSPathNew} Payload
    zip -rq ${ZIP_OS_OUTPUT} Payload/
    cp ${ZIP_OS_OUTPUT} "${DERIVED_DATA_PATH}/result"

    rm -rf Payload
    echo "Mark0"
    mkdir Payload
    cp -rf ${AppIphoneSIPathNew} Payload
    zip -rq ${ZIP_SI_OUTPUT} Payload/
    cp ${ZIP_SI_OUTPUT} "${DERIVED_DATA_PATH}/result"
}

BuildFramework "OCMonkeyLib"
BuildFramework "libmonkey"
BuildRunner