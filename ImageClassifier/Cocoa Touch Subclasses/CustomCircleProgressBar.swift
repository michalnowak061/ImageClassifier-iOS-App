//
//  CustomCircleProgressBar.swift
//  ImageClassifier
//
//  Source: https://github.com/RealLifeSwift/customprogressbar
//

import UIKit

class CustomCircleProgressBar: UIView {
    @IBInspectable public lazy var backgroundCircleColor: UIColor = UIColor.lightGray
      @IBInspectable public lazy var foregroundCircleColor: UIColor = UIColor.red
      @IBInspectable public lazy var startGradientColor: UIColor = UIColor.red
      @IBInspectable public lazy var endGradientColor: UIColor = UIColor.orange
      @IBInspectable public lazy var textColor: UIColor = UIColor.white
      
      private lazy var fillColor: UIColor = UIColor.clear
      
      private var backgroundLayer: CAShapeLayer!
      private var progressLayer: CAShapeLayer!
      private var textLayer: CATextLayer!
      
      public var progress: CGFloat = 0 {
        didSet {
          didProgressUpdated()
        }
      }
      
      public var animationDidStarted: (()->())?
      public var animationDidCanceled: (()->())?
      public var animationDidStopped: (()->())?
      
      private var timer: AppTimer?
      private var isAnimating = false
      private let tickInterval = 0.1
      
      public var maxDuration: Int = 3
      
      
      override func draw(_ rect: CGRect) {
        
        guard layer.sublayers == nil else {
          return
        }
        
        let lineWidth = min(frame.size.width, frame.size.height) * 0.1
        
        backgroundLayer = createCircularLayer(strokeColor: backgroundCircleColor.cgColor, fillColor: fillColor.cgColor, lineWidth: lineWidth)
        
        progressLayer = createCircularLayer(strokeColor: foregroundCircleColor.cgColor, fillColor: fillColor.cgColor, lineWidth: lineWidth)
        progressLayer.strokeEnd = progress
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
        
        gradientLayer.colors = [startGradientColor.cgColor, endGradientColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.mask = progressLayer
     
        textLayer = createTextLayer(textColor: textColor)
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(gradientLayer)
        layer.addSublayer(textLayer)
      }
      
      private func createCircularLayer(strokeColor: CGColor, fillColor: CGColor, lineWidth: CGFloat) -> CAShapeLayer {
        
        let startAngle = -CGFloat.pi / 2
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let width = frame.size.width
        let height = frame.size.height
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let radius = (min(width, height) - lineWidth) / 2
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = fillColor
        shapeLayer.lineCap = .round
        
        return shapeLayer
      }
      
      private func createTextLayer(textColor: UIColor) -> CATextLayer {
        
        let width = frame.size.width
        let height = frame.size.height
        
        let fontSize = min(width, height) / 4 - 5
        let offset = min(width, height) * 0.1
        
        let layer = CATextLayer()
        layer.string = "\(Int(progress * 100))"
        layer.backgroundColor = UIColor.clear.cgColor
        layer.foregroundColor = textColor.cgColor
        layer.fontSize = fontSize
        layer.frame = CGRect(x: 0, y: (height - fontSize - offset) / 2, width: width, height: height)
        layer.alignmentMode = .center
        
        return layer
      }
      
      private func didProgressUpdated() {
        
        textLayer?.string = "\(Int(progress * 100))"
        progressLayer?.strokeEnd = progress
      }
}

extension CustomCircleProgressBar {
  
    func startAnimation(duration: TimeInterval) {
        
        print("Start animation")
        isAnimating = true
        
        progressLayer.removeAllAnimations()
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = duration
        basicAnimation.toValue = progress
        
        basicAnimation.delegate = self
        
        timer = AppTimer(duration: maxDuration, tickInterval: tickInterval)
        
        timer?.timerFired = { [weak self] value in
          self?.textLayer.string = "\(value)"
        }
        
        timer?.timerStopped = { [weak self] in
          self?.textLayer.string = ""
        }
        
        timer?.timerCompleted = {}
        
        progressLayer.add(basicAnimation, forKey: "recording")
        timer?.start()
      }
      
      func stopAnimation() {
        timer?.stop()
        progressLayer.removeAllAnimations()
      }
}

extension CustomCircleProgressBar: CAAnimationDelegate {
  
    func animationDidStart(_ anim: CAAnimation) {
        animationDidStarted?()
      }
      
      func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        isAnimating = false
        flag ? animationDidStopped?() : animationDidCanceled?()
      }
  
}

class AppTimer {
  
    private var timer: Timer?
      
      var timerStarted: (()->())?
      var timerStopped: (()->())?
      var timerFired: ((Int)->())?
      var timerCompleted: (()->())?
      
      var isRunning: Bool {
        if let isTimerValid = timer?.isValid {
          return isTimerValid
        }
        return false
      }
      
      var duration: Int = 3
      var tickInterval: TimeInterval = 0.1
      
      init(duration: Int, tickInterval: TimeInterval) {
        self.duration = duration
        self.tickInterval = tickInterval
      }
      
      func start() {
        DispatchQueue.main.async { [weak self] in
          guard let strongSelf = self else { return }
          
          if strongSelf.timer != nil {
            strongSelf.timer?.invalidate()
            strongSelf.timer = nil
          }
          
          strongSelf.timer = Timer.scheduledTimer(timeInterval: strongSelf.tickInterval, target: strongSelf, selector: #selector(strongSelf.handleTimerTrigger), userInfo: nil, repeats: true)
          strongSelf.timer?.fire()
          strongSelf.timerStarted?()
        }
      }
      
      func stop() {
        DispatchQueue.main.async { [weak self] in
          guard let strongSelf = self else { return }
          
          strongSelf.timer?.invalidate()
          strongSelf.timer = nil
          strongSelf.timerStopped?()
        }
      }
      
      @objc private func handleTimerTrigger() {
        if duration > 0 {
          timerFired?(duration)
          duration -= 1
          return
        }
        stop()
        timerCompleted?()
      }
}
