//
//  AddAndEditTotalsViewController.swift
//  625Burnout
//
//  Created by Владимир Кацап on 14.09.2024.
//

import UIKit
import Combine

class AddAndEditTotalsViewController: UIViewController {
    
    var oldRacersPublisher: PassthroughSubject<[Race], Never>?
    var racersOld: [Race]?
    var indexEditRace = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgSecond
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
