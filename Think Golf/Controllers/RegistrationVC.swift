//
//  LoginVC.swift
//  Think Golf
//
//  Created by Mohsin Jamadar on 15/02/17.
//  Copyright © 2017 Vogcalgary App Developer. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import BWWalkthrough
import SVProgressHUD
import EZAlertController

class RegistrationVC: UIViewController, BWWalkthroughViewControllerDelegate {

    //Outlets
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPass: UITextField!
    @IBOutlet weak var txtFieldConfirmPass: UITextField!
    @IBOutlet weak var txtFieldPhone: UITextField!
    
    //iVars
    var callTimer:Timer!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        }

    // MARK: - Initial Setup
    func prepareUI(){
        txtFieldUsername.layer.borderWidth = 1.0
        txtFieldUsername.layer.borderColor = UIColor.white.cgColor
        txtFieldPass.layer.borderWidth = 1.0
        txtFieldPass.layer.borderColor = UIColor.white.cgColor
        txtFieldEmail.layer.borderWidth = 1.0
        txtFieldEmail.layer.borderColor = UIColor.white.cgColor
        txtFieldConfirmPass.layer.borderWidth = 1.0
        txtFieldConfirmPass.layer.borderColor = UIColor.white.cgColor
        txtFieldPhone.layer.borderWidth = 1.0
        txtFieldPhone.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    // MARK: - Event Listeners
    
    @IBAction func onTapSignup(_ sender: Any) {
        showSpinner(message: "Signing up...")
        callTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.registerUser), userInfo: nil, repeats: false)
    }
    
    @IBAction func onTapForgotPass(_ sender: Any) {
    }
    
    
    // MARK: - UI Helper
    func registerUser(){
        SVProgressHUD.dismiss()
        EZAlertController.alert("Success", message: "You have successfully registered. Please Login to continue.", acceptMessage: "OK") { () -> () in
            self.performSegue(withIdentifier: SegueIdentifiers.unwindSignUpToLogin, sender: self)
        }

    }
    
    // MARK: - Navigation
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.presentDashboard {
            let navController = segue.destination as! UINavigationController
            _ = navController.topViewController as! DashboardVC
        }
    }

    // MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

