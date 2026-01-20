#!/usr/bin/env bash

set -e

BASE_PWD="$PWD"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
OUTPUT_DIR="${SCRIPT_DIR}/build/"
WORKSPACE_PATH="${SCRIPT_DIR}/Example/DemoAlexSDK.xcworkspace"

# Validate workspace exists
if [ ! -d "${WORKSPACE_PATH}" ]; then
	echo "Error: Workspace not found at ${WORKSPACE_PATH}"
	echo "Please run 'pod install' in the Example directory first."
	exit 1
fi

# build clean up
# rm -rf ./build only for testing

# cocoapod clean up - only clean frameworks, keep other files
rm -rf lib/*

echo $'\n\n ✅ clean build'

echo $'\n\n Build Started............'

COMMON_SETUP="-workspace ${WORKSPACE_PATH} -scheme DemoAlexSDK -configuration Release -quiet SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES"

# iOS

echo $'\n\n 📱 Building platform iOS .........\n'
DERIVED_DATA_PATH=$( mktemp -d )
if ! xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=iOS'; then
	echo "Error: iOS build failed"
	rm -rf "${DERIVED_DATA_PATH}"
	exit 1
fi

mkdir -p "${OUTPUT_DIR}/iphoneos"
FRAMEWORK_PATH="${DERIVED_DATA_PATH}/Build/Products/Release-iphoneos/DemoAlexSDK/DemoAlexSDK.framework"
if [ ! -d "${FRAMEWORK_PATH}" ]; then
	echo "Error: Framework not found at ${FRAMEWORK_PATH}"
	echo "Searching for framework in derived data..."
	find "${DERIVED_DATA_PATH}" -name "DemoAlexSDK.framework" -type d 2>/dev/null || true
	rm -rf "${DERIVED_DATA_PATH}"
	exit 1
fi
ditto "${FRAMEWORK_PATH}" "${OUTPUT_DIR}/iphoneos/DemoAlexSDK.framework"
rm -rf "${DERIVED_DATA_PATH}"
echo "   ✅ iOS framework built successfully"

# iOS Simulator
echo $'\n\n 📱 Building platform iOS Simulator .........\n'
DERIVED_DATA_PATH=$( mktemp -d )
if ! xcrun xcodebuild build \
	$COMMON_SETUP \
	-derivedDataPath "${DERIVED_DATA_PATH}" \
	-destination 'generic/platform=iOS Simulator'; then
	echo "Error: iOS Simulator build failed"
	rm -rf "${DERIVED_DATA_PATH}"
	exit 1
fi

mkdir -p "${OUTPUT_DIR}/iphonesimulator"
FRAMEWORK_PATH="${DERIVED_DATA_PATH}/Build/Products/Release-iphonesimulator/DemoAlexSDK/DemoAlexSDK.framework"
if [ ! -d "${FRAMEWORK_PATH}" ]; then
	echo "Error: Framework not found at ${FRAMEWORK_PATH}"
	echo "Searching for framework in derived data..."
	find "${DERIVED_DATA_PATH}" -name "DemoAlexSDK.framework" -type d 2>/dev/null || true
	rm -rf "${DERIVED_DATA_PATH}"
	exit 1
fi
ditto "${FRAMEWORK_PATH}" "${OUTPUT_DIR}/iphonesimulator/DemoAlexSDK.framework"
rm -rf "${DERIVED_DATA_PATH}"
echo "   ✅ iOS Simulator framework built successfully"

# XCFRAMEWORK
echo $'\n\n 📱 Building xcframework .........\n'
mkdir -p "${SCRIPT_DIR}/lib/Frameworks"
if ! xcrun xcodebuild -quiet -create-xcframework \
	-framework "${OUTPUT_DIR}/iphoneos/DemoAlexSDK.framework" \
	-framework "${OUTPUT_DIR}/iphonesimulator/DemoAlexSDK.framework" \
	-output ${SCRIPT_DIR}/lib/Frameworks/DemoAlexSDK.xcframework; then
	echo "Error: Failed to create xcframework"
	exit 1
fi

# Validate xcframework was created
if [ ! -d "${SCRIPT_DIR}/lib/Frameworks/DemoAlexSDK.xcframework" ]; then
	echo "Error: xcframework was not created at expected location"
	exit 1
fi

echo $'\n\n ✅ DemoAlexSDK.xcframework created successfully!'
echo "   Location: ${SCRIPT_DIR}/lib/Frameworks/DemoAlexSDK.xcframework"

# Copy additional files if needed
if [ ! -f "${SCRIPT_DIR}/lib/README.md" ]; then
	cp -r README.md lib/README.md
fi

if [ ! -f "${SCRIPT_DIR}/lib/LICENSE" ]; then
	cp -r LICENSE lib/LICENSE
fi

# Ensure lib/DemoAlexSDK.podspec exists with vendored_frameworks configuration
# This podspec is for xcframework distribution via CocoaPods (different from root podspec)
if [ ! -f "${SCRIPT_DIR}/lib/DemoAlexSDK.podspec" ]; then
	echo $'\n\n 📝 Creating lib/DemoAlexSDK.podspec for xcframework distribution...'
	cat > "${SCRIPT_DIR}/lib/DemoAlexSDK.podspec" << 'EOF'
#
# Be sure to run `pod lib lint DemoAlexSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DemoAlexSDK'
  s.version          = '1.0.1'
  s.summary          = 'Demo SDK - iOS SDK'

  s.description      = <<-DESC
Demo SDK for iOS for test
DESC

  s.homepage         = 'https://github.com/alexinx/demo-fm-ios'
  s.license          = { :type => 'ISC', :file => 'LICENSE' }
  s.author           = { 'Demo' => 'demo@example.com' }
  s.source           = { :git => 'https://github.com/alexinx/demo-fm-ios.git', :tag => "v#{s.version}"}

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.vendored_frameworks = 'Frameworks/DemoAlexSDK.xcframework'
  
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
end
EOF
	echo $'   ✅ Created lib/DemoAlexSDK.podspec'
else
	echo $'\n\n ℹ️  lib/DemoAlexSDK.podspec already exists (preserving xcframework configuration)'
fi

# Ensure lib/Package.swift exists for Swift Package Manager distribution
# This Package.swift is for xcframework distribution via SPM (different from root Package.swift)
if [ ! -f "${SCRIPT_DIR}/lib/Package.swift" ]; then
	echo $'\n\n 📝 Creating lib/Package.swift for xcframework distribution...'
	cat > "${SCRIPT_DIR}/lib/Package.swift" << 'EOF'
// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DemoAlexSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "DemoAlexSDK",
            targets: ["DemoAlexSDK"]
        ),
    ],
    dependencies: [],
    targets: [
        .binaryTarget(
            name: "DemoAlexSDK",
            path: "Frameworks/DemoAlexSDK.xcframework"
        ),
    ]
)
EOF
	echo $'   ✅ Created lib/Package.swift'
else
	echo $'\n\n ℹ️  lib/Package.swift already exists (preserving xcframework configuration)'
fi

# Copy README.md from root to lib/README.md (overwrite if exists)
cp -r README.md lib/README.md

# Copy LICENSE from root to lib/LICENSE (overwrite if exists)
cp -r LICENSE lib/LICENSE

echo $'\n\n ✅ Build complete! Framework is ready for CocoaPods submission.'
echo $'   Framework location: lib/Frameworks/DemoAlexSDK.xcframework'

#open reveal folder
# open "${SCRIPT_DIR}/lib/"

#end
cd ${BASE_PWD}
