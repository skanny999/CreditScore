//
//  CreditReportViewController.swift
//  CreditScore
//
//  Created by Riccardo on 20/07/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit

class CreditReportViewController: UIViewController {
    
    var viewModel = CreditReportViewModel()
    
    let shapeLayer = CAShapeLayer()
    var displayLink: CADisplayLink?
    let animationDuration: Double = 1
    var animationStart: Date!

    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDonut()
        configureViewUpdater()
        self.title = "Dashboard"
    }
    
    func configureViewUpdater() {
        
        viewModel.displayAlert = { [weak self] (error) in
            
            self?.showAlert(for: error)
        }
        
        viewModel.updateView = { [weak self] in
            
            self?.updateView()
        }
    }
    
    private func configureDonut() {
        
        // draw outer circle
        let outerCircleRadius = reportView.bounds.width / 2
        reportView.layer.cornerRadius = reportView.bounds.width / 2
        reportView.layer.borderWidth = 1
        reportView.layer.borderColor = UIColor.black.cgColor
        
        // create inner circle progress line
        let innerProgressLineIndentation = CGFloat(5.0)
        let progressLineRadius = outerCircleRadius - innerProgressLineIndentation
        let circleCentre = CGPoint(x: reportView.frame.height/2, y: reportView.frame.width/2)
        let circularPath = UIBezierPath(arcCenter: circleCentre,
                                        radius: progressLineRadius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 1.5 * CGFloat.pi,
                                        clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        reportView.layer.addSublayer(shapeLayer)

    }
    
    private func updateView() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.updateLabels()
            self?.animateInnerCircleProgressLine()
        }
    }
    
    private func showAlert(for error: CreditScoreError) {
        
        let alertController = UIAlertController(title: "Error", message: error.userDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}



// MARK: - Animations

private extension CreditReportViewController {
    
    func updateLabels() {
        
        updateScoreLabel()
        maxScoreLabel.text = viewModel.maximumScore
    }
    
    func updateScoreLabel() {
        
        animationStart = Date()
        displayLink = CADisplayLink(target: self, selector: #selector(increaseScoreCounter))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    @objc func increaseScoreCounter() {
        
        let elapsedTime = Date().timeIntervalSince(animationStart)
        
        if elapsedTime > animationDuration {
            userScoreLabel.text = String(viewModel.userScore)
            displayLink?.invalidate()
        } else {
            let elapsedPercentage = elapsedTime / animationDuration
            let elapsedValue = Int(elapsedPercentage * Double(viewModel.userScore))
            userScoreLabel.text = String(elapsedValue)
        }
    }
    
    func animateInnerCircleProgressLine() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = CGFloat(viewModel.valuePercentage)
        basicAnimation.duration = animationDuration
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "progressLine")
    }
}

