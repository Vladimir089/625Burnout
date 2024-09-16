//
//  TabBarViewController.swift
//  pinUp
//
//  Created by Владимир Кацап on 05.08.2024.
//

//var plantsArr: [Plant] = []

import UIKit


class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    let homeVC = HomeViewController()
    let bestVC = BestRacerViewController()
//    let notesVC = NotesViewController()
    
    let newPlantVC = UIViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(true, forKey: "tab")

        tabBar.backgroundColor = .bgSecond
        tabBar.unselectedItemTintColor = UIColor(red: 15/255, green: 152/255, blue: 206/255, alpha: 0.3)
        tabBar.tintColor = .primary
        
        settingsTB()
        self.delegate = self
    }
    
    
    func settingsTB() {
        
        let plantsTabBarItem = UITabBarItem(title: "", image: .tab1.resize(targetSize: CGSize(width: 21, height: 21)), tag: 0)
        homeVC.tabBarItem = plantsTabBarItem
        
        
        let bestRacerVC = UITabBarItem(title: "", image: .tab2.resize(targetSize: CGSize(width: 23, height: 21)), tag: 1)
        bestVC.tabBarItem = bestRacerVC
        
        let notesTabBarItem = UITabBarItem(title: "", image: .tab3.resize(targetSize: CGSize(width: 23, height: 21)), tag: 2)
        //notesVC.tabBarItem = notesTabBarItem
        
        let imageNew = UIImage(named: "addNew")?.resize(targetSize: CGSize(width: 80, height: 80))
        let imageOriginal = imageNew?.withRenderingMode(.alwaysOriginal)
        let newPlantItem = UITabBarItem(title: "", image: imageOriginal, tag: 3)
        newPlantVC.tabBarItem = newPlantItem
        
//        eqimpVC.delegatePlant = plantsVC.self
//        notesVC.delegatePlant = plantsVC.self
//        
//        
//        eqimpVC.notesDelegate = notesVC.self
//        plantsVC.notesDel = notesVC.self
//        
//        plantsVC.eqDelegate = eqimpVC.self
//        notesVC.eqDelegate = eqimpVC.self
        
        viewControllers = [homeVC, bestVC, homeVC, newPlantVC]
    }

    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
           if viewController.tabBarItem.tag == 3 {// Модальное представление NewPlantViewController
               
               switch tabBarController.selectedIndex {
               case 0:
                   homeVC.createRace()
               case 1:
                   print(1)
                   bestVC.openEditPage()
               case 2:
                   print(2)
//                   let newEqVC = NewNoteViewController()
//                   newEqVC.delegate = notesVC.self
//                   self.present(newEqVC, animated: true, completion: nil)
               default:
                   break
               }

               
               return false
           }
       
           return true // Для других табов возвращаем true
       }

}


extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}


extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
