//
//  DiagnosisViewController.swift
//  Covid-19_Questionnaire
//
//  Created by Miguel Barajas on 11/19/21.
//

import UIKit

class DiagnosisViewController: UIViewController {
    @IBOutlet weak var riskLabel: UILabel!
    
    var riskLevel: String?
    var color: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        riskLabel.text = riskLevel
        view.backgroundColor = color
    }
    
    @IBAction func exitButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
