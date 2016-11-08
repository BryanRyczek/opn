//
//  ModalBusinessViewController.swift
//  Open
//
//  Created by Bryan Ryczek on 11/8/16.
//  Copyright © 2016 Bryan Ryczek. All rights reserved.
//

import UIKit

class ModalBusinessViewController: UIViewController {

    var interactor:Interactor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        
        //How far down to trigger the dismissal of the modal
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view) //convert pan gesture coordinate to Modal VCs coordinate space
        let verticalMovement = translation.y / view.bounds.height // vertical distance to %
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)// capture movement in downward direction
        let downwardMovementPercent = fminf(downwardMovement, 1.0)// ensures max downward movement of 100%
        let progress = CGFloat(downwardMovementPercent) // % as a CGFloat
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
        
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
