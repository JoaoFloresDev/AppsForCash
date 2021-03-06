//
//  MetricsViewControllerProtocol.swift
//  MacroCHallengeApp
//
//  Created by Felipe Semissatto on 27/10/20.
//

import Foundation

protocol MetricsViewControllerProtocol {
    
    // DependĂȘncias
    var myView: MetricsViewProtocol? {get set}
    var metrics: MetricsProtocol? {get set}
}
