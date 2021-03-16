# ImageClassifier

<p align="center"><img src="ImageClassifier/Assets.xcassets/AppIcon.appiconset/1024.png" width="256" height="256" /></p>

## Technologies
<a href="https://developer.apple.com/swift/"> <img src="https://i.imgur.com/dYAJWbw.png" width="50" height="50" /> </a>
<a href="https://developer.apple.com/documentation/coreml"> <img src="https://i.imgur.com/cslSQQT.png" width="50" height="50" /> </a>
<a href="https://cocoapods.org"> <img src="https://i.imgur.com/pgrumIx.png" width="50" height="50" /> </a>
<a href="https://developer.apple.com/support/xcode/"> <img src="https://i.imgur.com/vDFUkmr.png" width="50" height="50" /> </a>

## Runtime environment

<img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat" /> 
<img src="https://img.shields.io/badge/iOS-12.1+-blue.svg?style=flat" /> 
<img src="https://img.shields.io/badge/Xcode-12.4-blue.svg?style=flat" /> 
<img src="https://img.shields.io/badge/MacOS-11.2.3-blue.svg?style=flat" /> 

## Table of contents
* [General info](#general-info)
* [Functionality](#functionality)
* [Demo](#demo)
* [Sources](#sources)
* [Contact](#contact)

## General info
This project is simple iOS app using CoreML framework to predict object class on the photo

## Functionality

The application can load models from the device memory and compile them to .mlmodelc formats. The loaded models can be viewed in the form of a list and searched by keywords. Using the swipe left gesture you can delete the loaded model or read its metadata (author, general info, version ...)

<p align="center"> <img src="Screenshots/screenshot6.png"{:height="20%" width="20%"} />
		   <img src="Screenshots/screenshot2.png"{:height="20%" width="20%"} />
                   <img src="Screenshots/screenshot3.png"{:height="20%" width="20%"} /> </p>
		   
After selecting the model, you can load a photo from your camera roll or take a new one. The result of the prediction is presented in terms of probability and class name. You can view the probability of belonging to other classes included in the model

<p align="center"> <img src="Screenshots/screenshot7.png"{:height="20%" width="20%"} />
		   <img src="Screenshots/screenshot4.png"{:height="20%" width="20%"} />
                   <img src="Screenshots/screenshot5.png"{:height="20%" width="20%"} /> </p>

## Demo

<p align="center"> <img src="Screenshots/demo_animation.gif" {:height="20%" width="20%"} /> </p>

## Sources
* Swipe gesture: https://github.com/SwipeCellKit/SwipeCellKit
* Prediction as circular progress bar: https://github.com/MatiBot/MBCircularProgressBar

## Contact
<a href="https://www.linkedin.com/in/michał-nowak-53075a17a/"> <img src="https://i.imgur.com/Ba61VxB.png" width="50" height="50" /> </a>
<a href="https://www.facebook.com/mnowak061/"> <img src="https://i.imgur.com/MYo1OfP.png" width="50" height="50" /> </a>
<a href="https://www.instagram.com/mnowak061/"> <img src="https://i.imgur.com/9KYCrE2.png" width="50" height="50" /> </a>
