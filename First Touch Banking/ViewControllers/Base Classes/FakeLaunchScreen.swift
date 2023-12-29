//
//  FakeLaunchScreen.swift
//  First Touch Banking
//
//  Created by Arsalan Amjad on 23/11/2021.
//  Copyright © 2021 Syed Uzair Ahmed. All rights reserved.
//

import UIKit
import KYDrawerController

class FakeLaunchScreen: UIViewController {

    var counter = 0
    var timer = Timer()
    
    var banArray = [String]()
    var imagearray : [String] = ["prepaid.png","prepaid.png"]
    @IBOutlet weak var collectionview: UICollectionView!
//    var imgArrr = [UIImage(named: "prepaid.png"), UIImage(named: "gas.png"), UIImage(named: "Image.jpg"), UIImage(named: "gov.png"), UIImage(named: "landline.png")]
    
    override func viewDidLoad() {
                super.viewDidLoad()
        collectionview.delegate = self
        collectionview.dataSource = self
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            
            DispatchQueue.main.async {
                
              print("almost work done")
                
            }
            
        }
     
    }
    
    @objc func changeImage() {
        
        if counter < imagearray.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionview.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.collectionview.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
//            pageView.currentPage = counter
            counter = 1
        }
        
    }


    
}


extension FakeLaunchScreen : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagearray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FakeLSCellVc", for: indexPath) as! FakeLSCellVc
        
        
//        cell.imageview.image = imagearray[indexPath.row] as UIImage
        return cell
    }
    
    
}
extension UIImageView{
var imageWithFade:UIImage?{
    get{
        return self.image
    }
    set{
        UIView.transition(with: self,
                          duration: 0.2, options: .transitionCrossDissolve, animations: {
                            self.image = newValue
        }, completion: nil)
    }
}
}
extension UIView {
    
    func fadeIn() {
        
        //Swift 3, 4, 5
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }){ finished in
            self.fadeOut()
        }
    }
    
    
    func fadeOut() {
        
        //Swift 3, 4, 5
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }){ finished in
            self.fadeIn()
        }
    }
    
    
}
