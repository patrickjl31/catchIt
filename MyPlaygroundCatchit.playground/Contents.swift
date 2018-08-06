//: Playground - noun: a place where people can play

import UIKit
import Foundation

var str = "Hello, playground"

let serieCourante = ["a","z","e","r","t","y","u","u","i","o","p"]

func listeDeMots(longueur:Int) -> [String] {
    // extrait longueur  mots de la serie courante
    if longueur >= serieCourante.count {return serieCourante}
    if longueur < 1 {return []}
    var result : [String] = []
    
    //var i: Int
    
    for _ in 0..<longueur {
        var contained = false
        repeat {
            let unePlace = Int(arc4random_uniform(UInt32(serieCourante.count)))
            let unMot = serieCourante[unePlace]
            if  !result.contains(unMot) {
                result.append(unMot)
                contained = true
            }
            
        } while !contained
        
    }
    return result
}

listeDeMots(longueur: 5).count



let rand = CGFloat( arc4random_uniform(UInt32(45)))

print(rand)


