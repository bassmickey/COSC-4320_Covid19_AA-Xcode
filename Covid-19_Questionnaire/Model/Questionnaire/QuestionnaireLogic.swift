//
//  QuestionnaireLogic.swift
//  Covid-19_Questionnaire
//
//  Created by Miguel Barajas on 11/16/21.
//

import UIKit

struct QuestionnaireLogic {
    var questionNumber = 0
    var displayDiagnosis = 0
    var warning = false
    var alert = false
    var riskLevel: RiskLevel?
    
    let questions = [Question(q: "Regardless of your vaccination status, have you experienced any of these symptoms: \n\n- Fever or chills\n- Cough\n- Shortness of breath", a: "Yes"),
                     Question(q: "Regardless of your vaccination status, have you experienced any of these symptoms: \n\n- Fatigue\n- Muscle or body aches\n- Headache\n- New loss of taste or\n   smell", a: "Yes"),
                     Question(q: "Regardless of your vaccination status, have you experienced any of these symptoms: \n\n- Sore throat\n- Congestion or runny\n   nose\n- Nausea or vomiting\n- Diarrhea", a: "Yes"),
                     Question(q: "Have you been in close physical contact in the last 14 days:\n\nWith anyone who is known to have laboratory-confirmed COVID-19?", a: "Yes"),
                     Question(q: "Have you been in close physical contact in the last 14 days:\n\nWith anyone who has any symptoms consistent with COVID-19?", a: "Yes"),
                     Question(q: "Have you traveled in the past 10 days?", a: "Yes")
    ]
    
    func getQuestion() -> String {
        return questions[questionNumber].question
    }
    
    func getQuestionNumber() -> String {
        return "\(questionNumber + 1) / \(questions.count)"
    }
    
    func updateProgressBar() -> Float {
        return Float(questionNumber + 1) / Float(questions.count)
    }
    
    /// analyses user's answer
    /// - Parameter userAnswer: the user's answer
    mutating func checkAnswer(_ userAnswer: String) {
        if userAnswer == questions[questionNumber].answer {
            if alert == false && questionNumber < questions.count - 1 {
                alert = true
            }
            
            if questionNumber == questions.count - 1 {
                warning = true
            }
        }
    }
    
    /// goes to the next question and keeps a counter to compute the diagnosis
    mutating func nextQuestion() {
        if questionNumber < questions.count - 1 {
            questionNumber += 1
        }
        
        displayDiagnosis += 1
    }
    
    /// analyses the user's answers and computes the diagnosis
    mutating func computeDiagnosis() {
        if alert {
            riskLevel = RiskLevel(risk: "HIGH RISK", color: UIColor.systemRed)
        }
        
        if !alert && warning {
            riskLevel = RiskLevel(risk: "LOW RISK", color: UIColor.systemOrange)
        }
        
        if !alert && !warning {
            riskLevel = RiskLevel(risk: "NO RISK", color: UIColor.systemGreen)
        }
    }
    
    /// returns the risk level
    func getRiskLevel() -> String {
        return riskLevel?.risk ?? "null"
    }
    
    /// changes the background color based on the risk
    func getRiskColor() -> UIColor {
        return riskLevel?.color ?? UIColor.white
    }
    
    /// resets the user's answers
    mutating func resetQuestionnaire() {
        questionNumber = 0
        displayDiagnosis = 0
        warning = false
        alert = false
    }
}

