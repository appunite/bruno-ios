[![Build Status](https://travis-ci.org/appunite/bruno-ios.svg?branch=master)](https://travis-ci.org/appunite/bruno-ios)
[![codecov](https://codecov.io/gh/appunite/bruno-ios/branch/master/graph/badge.svg)](https://codecov.io/gh/appunite/bruno-ios)

# Bruno

This simple lib helps you to represent image in RGB565 format.

Example use:

```swift
// get some source image
let source = UIImage(...)

// resize image to 8x8pm, convert image from RGB8888 to RGB565 format
let data = source.encodeRGB565(width: 8, height: 8)

// convert image from RGB565 to RGB8888 format
let image = data?.decodeRGB565(width: 8, height: 8)
```

## Installation

### Carthage

If you use [Carthage](https://github.com/Carthage/Carthage), you can add the following dependency to your `Cartfile`:

``` ruby
github "appunite/bruno-ios" "master"
```

### CocoaPods

If your project uses [CocoaPods](https://cocoapods.org), just add the following to your `Podfile`:

``` ruby
pod 'Bruno', :git => 'https://github.com/appunite/bruno-ios.git'
```

### Xcode Sub-project

Submodule, clone, or download Bruno, and drag `Bruno.xcodeproj` into your project.
