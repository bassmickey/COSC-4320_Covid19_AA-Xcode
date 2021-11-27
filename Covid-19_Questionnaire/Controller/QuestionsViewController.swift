//
//  ViewController.swift
//  Covid-19_Questionnaire
//
//  Created by Miguel Barajas on 11/16/21.
//

import UIKit

class QuestionsViewController: UIViewController {
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var progressViewLabel: UIProgressView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var questionView: UIView!
    
    var questionnaireLogic = QuestionnaireLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // updates UI on load
        updateUI()
        // view with rounded corners
        customeView(myView: questionView)
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        // check user answer
        let userAnswer = sender.currentTitle!
        questionnaireLogic.checkAnswer(userAnswer)
        
        // get the next question
        questionnaireLogic.nextQuestion()
        
        // allows time for the button to flicker
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        
        // display diagnosis
        if questionnaireLogic.displayDiagnosis == questionnaireLogic.questions.count {
            // compute the diagnosis
            questionnaireLogic.computeDiagnosis()
            
            // segue to diagnosis screen
            if questionnaireLogic.getRiskLevel() == "HIGH RISK" {
                self.performSegue(withIdentifier: "goToHighRisk", sender: self)
            } else {
                self.performSegue(withIdentifier: "goToL_NoRisk", sender: self)
            }
            
            // resets the questionnaire
            questionnaireLogic.resetQuestionnaire()
            Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        }
    }
    
    /// prepares app to go to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHighRisk" {
            let destinationVC = segue.destination as! DiagnosisViewController
            destinationVC.riskLevel = questionnaireLogic.getRiskLevel()
            destinationVC.color = questionnaireLogic.getRiskColor()
        }
        
        if segue.identifier == "goToL_NoRisk" {
            let destinationVC = segue.destination as! DiagnosisViewController
            destinationVC.riskLevel = questionnaireLogic.getRiskLevel()
            destinationVC.color = questionnaireLogic.getRiskColor()
        }
    }
    
    /// updates the UI
    @objc func updateUI() {
        // update the question
        questionLabel.text = questionnaireLogic.getQuestion()
        // update question number
        questionNumberLabel.text = questionnaireLogic.getQuestionNumber()
        // update the progress bar
        progressViewLabel.progress = questionnaireLogic.updateProgressBar()
    }
    
    
    /// creates a custom view
    /// - Parameter myView: gets the view
    func customeView(myView: UIView) {
        myView.layer.cornerRadius = 30
        myView.layer.masksToBounds = true
    }
}
