//
//  RequestSenderImplementation.swift
//  MacroCHallengeApp
//
//  Created by João Pedro de Amorim on 26/10/20.
//

import Foundation
import Alamofire
import SwiftyJSON

enum RequestError: Error {
    case responseError(_ errorMessage: String)
}

class RequestSenderImplementation: RequestSenderProtocol {
    
    private var parser = ConverterJSON()
    
    func getQuestionsForTestRequest(testName: String, testYear: String, completion: ([Question]) -> Void, onFailure: (String) -> Void) {
        guard let url = URL(string: rootBackendURL + "/tests?testName=\(testName)&testYear=\(testYear)") else {
            onFailure("Erro ao decodificar a URL")
            return
        }
        
        do {
            
            let jsonResponseArray = try sendGetRequestForUrl(url)
            let questionsArrayForTest =  parser.createQuestions(jsonArray: jsonResponseArray)
            completion(questionsArrayForTest)
            
        } catch RequestError.responseError(let errorMessage) {
            onFailure(errorMessage)
            
        } catch {
            onFailure("Erro ao processar resposta do servidor")
        }
        
    }
    
    private func sendGetRequestForUrl(_ url: URL) throws -> [JSON] {
        var errorMessage: String = "Erro ao se conectar ao servidor" // Valor "default" para o erro, isto é, um erro genérico
        var jsonResponse: JSON?
        
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                
                switch response.result {
                case.success:
                    guard let responseValue = response.value else { return }
                    jsonResponse = JSON(responseValue)
                    
                case .failure:
                    if let data = response.data {
                        errorMessage = String(decoding: data, as: UTF8.self)
                    }
                }
            }
        
        guard let jsonResponseAsArray = jsonResponse?.array else {
            throw RequestError.responseError(errorMessage)
        }
        
        return jsonResponseAsArray
    }
}
