# ImageClassifier-CoreML-iOS-App

<p align="center"><img src="ImageClassifier/Assets.xcassets/AppIcon.appiconset/1024.png" width="256" height="256" /></p>

[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platform](https://img.shields.io/badge/iOS-12.1-blue.svg?style=flat)](https://developer.apple.com/swift/)
[![Linkedin](https://img.shields.io/badge/Linkedin-@mnowak061-blue.svg?style=flat)](www.linkedin.com/in/michał-nowak-53075a17a)

## Table of contents
* [General info](#general-info)
* [Functionality](#functionality)
* [Demo](#demo)

## General info
This project is simple iOS app using CoreML framework to predict object class on the photo

## Functionality

The application can load models from the device memory and compile them to .mlmodelc formats. The loaded models can be viewed in the form of a list and searched by keywords. Using the swipe left gesture you can delete the loaded model or read its metadata (author, general info, version ...)

<p align="center"> <img src="Screenshots/screenshot2.png"{:height="20%" width="20%"} />
                   <img src="Screenshots/screenshot3.png"{:height="20%" width="20%"} /> </p>
		   
After selecting the model, you can load a photo from your camera roll or take a new one. The result of the prediction is presented in terms of probability and class name. You can view the probability of belonging to other classes included in the model

<p align="center"> <img src="Screenshots/screenshot4.png"{:height="20%" width="20%"} />
                   <img src="Screenshots/screenshot5.png"{:height="20%" width="20%"} /> </p>

## Demo

<p align="center"> <img src="Screenshots/demo_animation.gif" {:height="20%" width="20%"} /> </p>
