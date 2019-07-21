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
    let displayLink = CADisplayLink(target: self, selector: #selector(updateScoreCounter))
    let animationDuration: Double = 1
    var animationStart: Date!

    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInitialView()
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
    
    private func configureInitialView() {
        
        reportView.layer.cornerRadius = reportView.bounds.width / 2
        reportView.layer.borderWidth = 1
        reportView.layer.borderColor = UIColor.black.cgColor

        let radius = (reportView.bounds.width / 2) - 5
        
        let circularPath = UIBezierPath(arcCenter: reportView.center,
                                        radius: radius,
                                        startAngle: -CGFloat.pi / 2,
                                        endAngle: 1.5 * CGFloat.pi,
                                        clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    private func updateView() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.updateLabels()
            self?.animateCircle()
        }
    }
    
    private func showAlert(for error: CreditScoreError) {
        
        let alertController = UIAlertController(title: "There was a problem", message: error.userDescription, preferredStyle: .alert)
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
        let displayLink = CADisplayLink(target: self, selector: #selector(updateScoreCounter))
        displayLink.add(to: .main, forMode: .default)
    }
    
    func animateCircle() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = CGFloat(viewModel.valuePercentage)
        basicAnimation.duration = animationDuration
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "pie")
    }
    
    @objc func updateScoreCounter() {
        
        let elapsedTime = Date().timeIntervalSince(animationStart)
        
        if elapsedTime > animationDuration {
            
            userScoreLabel.text = String(viewModel.userScore)
            
        } else {
            
            let percentage = elapsedTime / animationDuration
            let value = Int(percentage * Double(viewModel.userScore))
            userScoreLabel.text = String(value)
        }
    }
}

