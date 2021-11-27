//
//  Question.swift
//  Covid-19_Questionnaire
//
//  Created by Miguel Barajas on 11/16/21.
//

import Foundation

struct Question {
    let question: String
    let answer: String
    
    init(q: String, a: String) {
        question = q
        answer = a
    }
}
