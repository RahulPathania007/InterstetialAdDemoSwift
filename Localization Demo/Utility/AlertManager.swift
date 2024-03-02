//
//  AlertManager.swift
//  Trailer2You
//
//  Created by SIERRA on 4/6/18.
//  Copyright © 2018 GsBitLabs. All rights reserved.
//

import UIKit

struct GPAlert {
    let title: String!
    let message: String!
}

let kColorGray74: Int    = 0xBDBDBD

class AlertManager: NSObject , UIAlertViewDelegate {
    static let shared: AlertManager = AlertManager()
    var completionBlock: ((_ selectedIndex: Int) -> Void)?
    var alertAlreadyShown = false
    
//    func addToast(_ onView: UIView, message: String, duration: TimeInterval = 3.0, position: ToastPosition = .top ) {
//        onView.makeToast(message, duration: duration, position: position)
//    }
    
    
 func showAlert(_ alert: GPAlert
     , buttonsArray : [Any] = ["OK"],  vc: UIViewController
     , completionBlock : ((_ : Int) -> ())? = nil) {
     self.completionBlock = completionBlock
     let alertView = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
     for i in 0..<buttonsArray.count {
         let buttonTitle: String = buttonsArray[i] as! String
         let btnAction = UIAlertAction(title: buttonTitle, style: .default) { (alertAction) in
             if self.completionBlock != nil {
                 self.completionBlock!(i)
             }
         }
//         alertView.view.tintColor = UIColor.FlatColor.Green.ThemeColor
         alertView.addAction(btnAction)
         
     }
     vc.present(alertView, animated: true)
 }
    
    func show(_ alert: GPAlert, buttonsArray: [Any] = ["OK"], completionBlock: ((_ : Int) -> Void)? = nil) {
        self.alertAlreadyShown = true
        self.completionBlock = completionBlock
        let alertView = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        for index in 0..<buttonsArray.count {
            let buttonTitle: String = buttonsArray[index] as! String
            let btnAction = UIAlertAction(title: buttonTitle, style: .default) { (_) in
                self.alertAlreadyShown = false
                if self.completionBlock != nil {
                    self.completionBlock!(index)
                }
            }
            alertView.addAction(btnAction)
        }
        if #available(iOS 13.0, *) {
            
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            
            if var topController = keyWindow?.rootViewController {
                
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                DispatchQueue.main.async {
                    topController.present(alertView, animated: true, completion: nil)
                }
                
            }
            
        } else {
            UIApplication.shared.windows.first?.rootViewController?.present(alertView, animated: true, completion: nil)
        }
    }
    
    func showWithoutLocalize(_ alert: GPAlert, buttonsArray: [Any] = ["Ok"], completionBlock: ((_ : Int) -> Void)? = nil) {
        
        self.completionBlock = completionBlock
        let alertView = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        for index in 0..<buttonsArray.count {
            let buttonTitle: String = buttonsArray[index] as! String
            let btnAction = UIAlertAction(title: buttonTitle, style: .default) { (_) in
                if self.completionBlock != nil {
                    self.completionBlock!(index)
                }
            }
            alertView.addAction(btnAction)
        }
        
        UIApplication.shared.windows.first?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    func showPopup(_ alert: GPAlert, forTime time: Double, completionBlock: ((_ : Int) -> Void)? = nil) {
    
        self.completionBlock = completionBlock
        
        let alertView = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        UIApplication.shared.windows.first?.rootViewController?.present(alertView, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((ino64_t)(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {() -> Void in
            alertView.dismiss(animated: true)
            if completionBlock != nil {
                completionBlock!(0)
            }
        })
    }
    
    func showActionSheet(_ sender: UIView, cell: UITableViewCell? = nil, alert: GPAlert,buttonsArray: [Any] = ["Ok"], completionBlock : ((_ : Int) -> Void)?) {
        self.completionBlock = completionBlock
        let alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .actionSheet)
        alert.view.tintColor = .black
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            if self.completionBlock != nil {
                self.completionBlock!(-1)
            }
        }))
        for index in 0..<buttonsArray.count {
            let buttonTitle: String = buttonsArray[index] as! String
            let btnAction = UIAlertAction(title: buttonTitle, style: .default) { (_) in
                if self.completionBlock != nil {
                    self.completionBlock!(index)
                }
            }
            alert.addAction(btnAction)
        }
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            if cell != nil {
            alert.popoverPresentationController?.sourceView = cell
                alert.popoverPresentationController?.sourceRect = cell!.bounds
           // alert.popoverPresentationController?.permittedArrowDirections = .up
            }
        default:
            break
        }
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}
