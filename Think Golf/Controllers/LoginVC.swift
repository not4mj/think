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

extension DefaultsKeys {
    static let isFirstTimeLaunched = DefaultsKey<Bool?>("isFirstTimeLaunched")
}


class LoginVC: UIViewController, BWWalkthroughViewControllerDelegate {

    //Outlets
    @IBOutlet weak var txtFieldUsername: UITextField!
    @IBOutlet weak var txtFieldPass: UITextField!
    
    //iVars
     var callTimer: Timer!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        prepareUI()
//        displayIntro()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIntro()
        
        
        }

    // MARK: - Initial Setup
    func prepareUI(){
        txtFieldUsername.layer.borderWidth = 1.0
        txtFieldUsername.layer.borderColor = UIColor.white.cgColor

        txtFieldPass.layer.borderWidth = 1.0
        txtFieldPass.layer.borderColor = UIColor.white.cgColor
        
        
    }
 
    // MARK: - Walkthrough
    func checkIntro(){
          let userDefaults = UserDefaults.standard
          if !userDefaults.bool(forKey: "isFirstTimeLaunched") {
            Defaults[.isFirstTimeLaunched] = true
            userDefaults.set(true, forKey: "isFirstTimeLaunched")
            userDefaults.synchronize()
            displayIntro()
        }
    }

    func displayIntro(){
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewController(withIdentifier: "walk") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewController(withIdentifier: "walk0")
        let page_one = stb.instantiateViewController(withIdentifier: "walk1")
        let page_two = stb.instantiateViewController(withIdentifier: "walk2")
        let page_three = stb.instantiateViewController(withIdentifier: "walk3")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        walkthrough.add(viewController:page_zero)
        
        self.present(walkthrough, animated: true, completion: nil)

    }
    
    // MARK: - Event Listeners
    @IBAction func onTapLogin(_ sender: UIButton) {
        showSpinner(message: "Logging in...")
        callTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.login), userInfo: nil, repeats: false)
    }
    
    
    @IBAction func onTapFacebook(_ sender: Any) {
    }
    
    @IBAction func onTapLinkedin(_ sender: Any) {
    }
    
    @IBAction func onTapSignup(_ sender: Any) {
    }
    
    @IBAction func onTapForgotPass(_ sender: Any) {
    }
    
    // MARK: - Unwind
    @IBAction func unwindToLogin(segue: UIStoryboardSegue) {
    }

    
    // MARK: - UI Helper
    func login(){
        SVProgressHUD.dismiss()
        self.performSegue(withIdentifier: SegueIdentifiers.presentDashboard, sender: self)
    }
    
    // MARK: - Navigation
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifiers.presentDashboard {
            let navController = segue.destination as! UINavigationController
            _ = navController.topViewController as! DashboardVC
        }
    }

    
    // MARK: - Walkthrough delegate -
    
    func walkthroughPageDidChange(_ pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

