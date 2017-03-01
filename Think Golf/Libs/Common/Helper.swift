//
//  Helper.swift
//  MCHAnywhere
//
//  Created by Tejaswi on 9/4/15.
//  Copyright (c) 2015 Miami Children's Hospital. All rights reserved.
//

import Foundation
import SVProgressHUD

// Global xConstants

//Notifications
let kNotificationStartAutoRefreshTimer = "StartAutoRefreshTimer"

//Placeholders
let kPlaceholderAddNotes = "Add doctor notes here"

//Alerts
let kAlertButtonOk = "Ok"
let kAlertButtonCancel = "Cancel"
let kAlertTitleCommon = "Attention"
let kAlertMessageNetworkConnection = "Make sure your device is connected to the internet."
let kAlertTitleNetworkConnection = "No Internet Connection"
let kAlertMessageInvalidCredential = "The Username or Password is incorrect"
let kAlertMessageLoginFailed = "Login Failed"
let kAlertMessageToLogout = "Are you sure you want to logout?"
let kAlertMessageEmptyMail = "Please enter your email"
let kAlertMessageInvalidMail = "Please enter your email"
let kAlertMessageEmptyPass = "Login Failed"
let kAlertMessageErrorSubmittingNotes = "Could not submit the notes. Please try again later"
let kAlertMessageErrorEnterNotes = "Please enter notes"
let kAlertMessageErrorUpdateNotes = "There was a problem updating your info.  Please try again."
//RegEx
let kRegExEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

//Enums
enum ApponintmentType : Int {
    case Waiting
    case Scheduled
    case Unknown
}

//Font
let FontUITextRegular = "SFUIText-Regular"

typealias BasicBlock = () -> (Void)

func showSpinner(message: String) {
    SVProgressHUD.show(withStatus: message)
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
}

func dismissSpinner() {
    SVProgressHUD.dismiss()
}

func dismissSpinnerWithError(message: String) {
    SVProgressHUD.showError(withStatus: message)
}
func printLog(log: AnyObject?) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
    print(formatter.string(from: NSDate() as Date), terminator: "")
    if log == nil {
        print("nil")
    }
    else {
        print(log!)
    }
}


func dismissModalStack(viewController: UIViewController, animated: Bool, completionBlock: BasicBlock?) {
    if viewController.presentingViewController != nil {
        var vc = viewController.presentingViewController!
        while (vc.presentingViewController != nil) {
            vc = vc.presentingViewController!;
        }
        vc.dismiss(animated: animated, completion: nil)
        
        if let c = completionBlock {
            c()
        }
    }
}

func showAlert(title: String, message: String,buttonTitle:String,source:AnyObject) {
    
    
    //    source.view.addSubview(blurEffectView)
    let actionSheetController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //Create and an option action
    let nextAction: UIAlertAction = UIAlertAction(title: buttonTitle, style: .default) { action -> Void in
        //Do some other stuff
    }
    actionSheetController.addAction(nextAction)
    
    //Present the AlertController
    source.present(actionSheetController, animated: true, completion: nil)
    
}

func appendAuthorizationHeader(token: String?, request: NSMutableURLRequest) {
    if let t = token {
        request.setValue("Bearer \(t)", forHTTPHeaderField: "Authorization")
    }
    
}
