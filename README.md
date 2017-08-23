# MLHybrid

[![CI Status](http://img.shields.io/travis/yang cai/MLHybrid.svg?style=flat)](https://travis-ci.org/yang cai/MLHybrid)
[![Version](https://img.shields.io/cocoapods/v/MLHybrid.svg?style=flat)](http://cocoapods.org/pods/MLHybrid)
[![License](https://img.shields.io/cocoapods/l/MLHybrid.svg?style=flat)](http://cocoapods.org/pods/MLHybrid)
[![Platform](https://img.shields.io/cocoapods/p/MLHybrid.svg?style=flat)](http://cocoapods.org/pods/MLHybrid)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MLHybrid is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MLHybrid"
```

## How To Use
1.first,you must register MLHybrid in Appdelegate,like this:
```ruby
MLHybrid.register(sess: "GuU7KeV154f8juslkNWRONyVE3m8Sq9h5nJFpcARiCFIvrMsp6boxDzcYabBwAoM",
                  platform: "i",
                  appName: "medlinker",
                  domain: "medlinker.com",
                  backIndicator: "hybridBack",
                  delegate: MethodExtension())
```


## Author

yang cai, caiyang@medlinker.com

## License

MLHybrid is available under the MIT license. See the LICENSE file for more info.
