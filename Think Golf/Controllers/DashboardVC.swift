//
//  DashboardVC.swift
//  Think Golf
//
//  Created by Mohsin Jamadar on 16/02/17.
//  Copyright © 2017 Vogcalgary App Developer. All rights reserved.
//

import Foundation
import PaperCollectionView
import UIKit

let kReuseID = "Cell"

class DashboardVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,PaperViewDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgViewCircle1: UIImageView!
    @IBOutlet weak var imgViewCircle2: UIImageView!
    @IBOutlet weak var imgViewCircle3: UIImageView!
    @IBOutlet weak var imgViewCircle4: UIImageView!
    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var paperView: PaperView!
    
    fileprivate var items = [Character]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupLayout()
        self.items = self.createItems()
        
        //Pre Set
        self.currentPage = 0
        imgViewCircle1.isHighlighted = true
        
        setupPaperView()
    }
    
    // MARK: - UI Helper
    
    func setupPaperView(){
        paperView.collectionViewController.collectionView?.register(CustomPaperCell.self, forCellWithReuseIdentifier: kReuseID)
//        collectionView.register(CarouselCollectionViewCell.self, forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
        
        paperView.addShadow()

    }
    
    fileprivate func setupLayout() {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 30)
    }
 
    func resetCircleSelection()  {
        imgViewCircle1.isHighlighted = false
        imgViewCircle2.isHighlighted = false
        imgViewCircle3.isHighlighted = false
        imgViewCircle4.isHighlighted = false
    }
    
    func scrollLayoutAtIndex(index:Int) {
        self.currentPage = index
        let indexPath = NSIndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: true)
        paperView.collectionViewController.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .centeredHorizontally, animated: true)
    }
    
    // MARK: - PaperView Delegate
    func paperViewHeightDidChange(_ height: CGFloat, percentMaximized percent: CGFloat) {
        print("percent: \(percent)")
        viewCircle.alpha = 1.0 - percent

        if percent < 0.1 {
            return
        }
        self.viewCircle.transform = CGAffineTransform.identity
        self.viewCircle.frame = UIScreen.main.bounds
        self.viewCircle.transform = CGAffineTransform(scaleX: 1.0 - percent, y:1.0 -  percent)
    }
    
    func paperViewWillMinimize(_ view: PaperView){
        //        self.view.bringSubview(toFront: viewCircle)
        print("Minimize")
    }
    func paperViewWillMaximize(_ view: PaperView){
        //        self.view.sendSubview(toBack: viewCircle)
        print("Maximize")
}

    
    // MARK: - IBAction
    
    @IBAction func onTapCircle1(_ sender: UITapGestureRecognizer) {
           print("Tapped 1")
        resetCircleSelection()
        imgViewCircle1.isHighlighted = true
        scrollLayoutAtIndex(index: 0)
    }
    @IBAction func onTapCircle2(_ sender: UITapGestureRecognizer) {
        print("Tapped 2")
        resetCircleSelection()
        imgViewCircle2.isHighlighted = true
        scrollLayoutAtIndex(index: 1)
    }
    @IBAction func onTapCircle3(_ sender: UITapGestureRecognizer) {
        print("Tapped 3")
        resetCircleSelection()
        imgViewCircle3.isHighlighted = true
        scrollLayoutAtIndex(index: 2)
    }
    @IBAction func onTapCircle4(_ sender: UITapGestureRecognizer) {
        print("Tapped 4")
        resetCircleSelection()
        imgViewCircle4.isHighlighted = true
        scrollLayoutAtIndex(index: 3)
    }
    
    // MARK: - Card Collection Delegate & DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionView FRAME\(collectionView.frame)")
        if collectionView.frame.size.height > 190 {
            //Circle Collecton
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as! CarouselCollectionViewCell
            let character = items[(indexPath as NSIndexPath).row]
            cell.image.image = UIImage(named: character.imageName)
            cell.lblTitle.text = character.name
            return cell

        }
        else{
           //paper collection
            let cell = collectionView .dequeueReusableCell(withReuseIdentifier: kReuseID, for: indexPath) as! CustomPaperCell
            
            if cell.contentVC == nil {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContentViewController") as! ContentViewController
                cell.delegate = vc
                paperView.collectionViewController.addChildViewController(vc)
                cell.scaledView = vc.view
                vc.didMove(toParentViewController: paperView.collectionViewController)
                cell.contentVC = vc
                
                cell.layer.cornerRadius = 4
                cell.clipsToBounds = true
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = items[(indexPath as NSIndexPath).row]
        let alert = UIAlertController(title: character.name, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Scroll Helper
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }

    fileprivate var currentPage: Int = 0 {
        didSet {
            let character = self.items[self.currentPage]
            self.infoLabel.text = character.name
        }
    }

    fileprivate func createItems() -> [Character] {
        let characters = [
            Character(imageName: "main golf ball", name: "New Session", movie: "Wall-E"),
            Character(imageName: "main golf ball", name: "My Golf Pro", movie: "Finding Nemo"),
            Character(imageName: "main golf ball", name: "Tutorials", movie: "Ratatouille"),
            Character(imageName: "main golf ball", name: "Load Session", movie: "Toy Story"),
        ]
        return characters
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
        
        //Set selction
        switch currentPage {
        case 0:
            self.onTapCircle1(UITapGestureRecognizer())
            break
        case 1:
            self.onTapCircle2(UITapGestureRecognizer())
            break
        case 2:
            self.onTapCircle3(UITapGestureRecognizer())
            break
        case 3:
            self.onTapCircle4(UITapGestureRecognizer())
            break

        default:
            self.onTapCircle1(UITapGestureRecognizer())
        }
    }
 
}

