//
//  ConverterJSON.swift
//  MacroCHallengeApp
//
//  Created by Joao Flores on 22/10/20.
//

import SwiftyJSON
import Foundation

//	MARK: - Error Handling
enum ErrorQuestion: String, Error {
    
    case noNumber = "Não foi possível obter o número da questão para criar objeto tipo Question, confira ConverterQuestionsJSON"
    case noText = "Não foi possível obter o texto da questão para criar objeto tipo Question, confira ConverterQuestionsJSON"
    case noInitialText = "Não foi possível obter o texto  inicial da questão para criar objeto tipo Question, confira ConverterQuestionsJSON"
    case noSubtitle = "Não foi possível obter o subtitulo da questão para criar objeto tipo Question, confira ConverterQuestionsJSON"
    case noAnswer = "Não foi possível obter a resposta da questão para criar objeto tipo Question, confira ConverterQuestionsJSON"
    case noTopic = "Não foi possível obter o tópico da questão para criar objeto tipo Question, confira ConverterQuestionsJSON"
    case noImagesURLs = "Não foi possível obter a URL das imagens da questão para criar objeto tipo Question, confira ConverterQuestionsJSON"
    case noOptions = "Não foi possível obter as alternativas da questão para criar objeto tipo Question, confira ConverterQuestionsJSON"
    case noOptionsGet = "Não foi  possível converter string de alternativas para criar objeto tipo Question, confira ConverterQuestionsJSON"
    case noImagesAvailable = "Não foi possível executar download das imagens para criar objeto tipo Question, confira ConverterQuestionsJSON"
}

class ConverterQuestionsJSON: ConverterQuestionsJSONProtocol {
    //	MARK: - ConverterJSONProtocol methods
    func createQuestions(jsonArray: [JSON]) -> [Question]{
        var questionArray: [Question] = []
        
        for jsonEntry in jsonArray {
            do {
                questionArray.append(try createQuestion(json: jsonEntry))
            } catch is ErrorQuestion {
                continue
            } catch {
                continue
            }
        }
        
        return questionArray
    }
    
    func createQuestion(json: JSON) throws -> Question {
        var number: String
        var text: String
        var initialText: String?
        var subtitle: String?
        var answer: String
        var topic: String
        
        var images = [UIImage]()
        
        var options: [String:String]
        
        if let numberCurrent = json["number"].string {
            number = numberCurrent
        } else  {
            throw ErrorQuestion.noNumber
        }
        
        if let textCurrent = json["text"].string {
            text = textCurrent
        } else  {
            throw ErrorQuestion.noText
        }
        
        if let initialTextCurrent = json["initialText"].string {
            initialText = initialTextCurrent
        } else  {
            throw ErrorQuestion.noInitialText
        }
        
        if let subtitleCurrent = json["subtitle"].string {
            subtitle = subtitleCurrent
        } else  {
            throw ErrorQuestion.noSubtitle
        }
        
        if let answerCurrent = json["answer"].string {
            answer = answerCurrent
        } else  {
            throw ErrorQuestion.noAnswer
        }
        
        if let topicCurrent = json["topic"].string {
            topic = topicCurrent
        } else  {
            throw ErrorQuestion.noTopic
        }
        
        if let imagesCurrent = json["images"].string {
            if let imgURLs = handleImagesURL(URLs: imagesCurrent) {
                images = handleUIImages(URLs: imgURLs)
                if images.count != imgURLs.count {
                    throw ErrorQuestion.noImagesAvailable
                }
            } else {
                images = []
            }
        } else  {
            throw ErrorQuestion.noImagesURLs
        }
        
        if let optionsCurrent = json["options"].string {
            if var opt = handleOptions(text: optionsCurrent) {
                opt[""] = nil
                options = opt
            } else {
                throw ErrorQuestion.noOptionsGet
            }
        } else  {
            throw ErrorQuestion.noOptions
        }
        
        let question = Question(number: number, text: text, initialText: initialText, images: images, subtitle: subtitle, options: options, answer: answer, topic: topic)
        
        
        return question
    }
    
    /**
     
     Função responsável por converter String de alternativas recebida pelo json em dicionário com [ alternativa :  texto ]
     
     - parameter text: String única contendo as alternativas, utilizando como separador os símbolos "||" e  "#@"
     
     */
    private func handleOptions(text: String) -> [String:String]? {
        let textJoined = text.components(separatedBy: "#@")
        
        var options = [String : String]()
        
        for option in textJoined  {
            
            if let optionString = option.components(separatedBy: "||").last {
                let optionText = String(optionString.dropFirst(2))
                
                let optionLetter = String(optionString.prefix(1))
                
                options.updateValue(optionText, forKey: optionLetter)
            } else {
                return nil
            }
        }
        
        if options.isEmpty {
            return nil
        }
        else {
            return options
        }
    }
    
    /**
     
     Função responsável por converter String de URLs recebida pelo json em vetor com URLs válidas
     
     - parameter URLs: String única contendo as URLs de imagem, utilizando como separador o símbolo "@"
     
     */
    private func handleImagesURL(URLs: String) -> [String]? {
        let URLsJoined = URLs.split(separator: "@")
        
        var URLs = [String]()
        
        for url in URLsJoined  {
            URLs.append(String(url))
        }
        
        if URLs.isEmpty {
            return nil
        } else {
            return URLs
        }
    }
    
    /**
     
     Função responsável por converter vetor de String contendo URL válida em vetor com imagens da questão
     
     - parameter URLs: Vetor de Strings contendo URLs
     
     */
    private func handleUIImages(URLs: [String]) -> [UIImage] {
        
        var images = [UIImage]()
        
        for URL in URLs {
            if let url = NSURL(string: URL) as URL? {
                if let imageData: NSData = NSData(contentsOf: url) {
                    if let image = UIImage(data: imageData as Data) {
                        images.append(image)
                    }
                }
            }
        }
        return images
    }
}
