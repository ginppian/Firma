//
//  HexToBase64.swift
//  sglibSwiftUsage
//
//  Created by ginppian on 02/07/17.
//  Copyright © 2017 Seguridata Privada S.A de C.V. All rights reserved.
//

import Foundation

struct HexToBase64 {

    static let shared = HexToBase64()
    
    // Esta es la función qué se usa al final de cuentas
    func hashToBase64From(hex: String) -> String {
    
        // Obtienen una cadena de bits separada por ',' cada 6 bits
        let longBinWithCommas = get_StrBinarios_From(strHex: hex)
        print(longBinWithCommas)
        
        // Se obtiene una cadena en Base64
        let _hash = get_base64_From(longBinWithCommas: longBinWithCommas)
        print("\nHash: \(_hash)")
        
        return _hash
    }
    
    
    func getDupla_From(strHex: String, noDupla: Int) -> String {
        
        /* Definimos un rango de DUPLA */
        
        // Comienza el rango
        let start = strHex.index(strHex.startIndex, offsetBy: (noDupla*2))
        
        // Termina el rango
        let end = strHex.index(strHex.startIndex, offsetBy: (noDupla*2+2))
        
        // Crea el rango
        let range = start..<end
        
        // Obtiene el substring
        let dupla = strHex.substring(with: range)
        
        return dupla
    }
    
    func convertDupla_To_StrNum_From(strHex: String) -> UInt {
        
        if let enteroSinSigno = UInt(strHex, radix: 16) {
            
            return enteroSinSigno
            
        } else {
            
            print("ERROR al convertir Hex a UInt")
            return 0
        }
        
    }
    
    func convertDupla_To_StrBinary_From(num: UInt) -> String {
        
        var strBinary = String(num, radix: 2)
        
        if strBinary.characters.count != 8 {
            
            if strBinary.characters.count < 8 {
                
                while strBinary.characters.count < 8 {
                    
                    strBinary = "0" + strBinary
                    
                }
                
            } else {
                
                print("ERROR tiene menos de 8 caracteres el String Binario")
                return ""
            }
            
        }
        
        return strBinary
    }
    
    func get_StrBinarios_From(strHex: String) -> String {
        
        var longBinWithCommas = ""
        var cont = 0
        var contaComa = 0
        
        // Del 0 al 31 en intervalor de 1
        var (first, last, interval) = (0, strHex.characters.count/2, 1)
        for i in stride(from: first, to: last, by: interval) {
            
            let dupla  = getDupla_From(strHex: strHex, noDupla: i)
            let strNum = convertDupla_To_StrNum_From(strHex: dupla)
            let strBin = convertDupla_To_StrBinary_From(num: strNum)
            
            for bite in strBin.characters {
                
                if cont < 6 {
                    
                    longBinWithCommas += "\(bite)"
                    cont += 1
                    
                } else {
                    
                    longBinWithCommas += ","
                    longBinWithCommas += "\(bite)"
                    cont = 1
                    contaComa += 1
                    
                }
            }
            
        }
        
        return longBinWithCommas
    }
    
    
    func get_base64_From(longBinWithCommas: String) -> String {
        
        var contadroSignosIgual = 0
        var strLongBase64 = ""
        
        let arrayBinarios = longBinWithCommas.components(separatedBy: ",")
        print(arrayBinarios)
        
        var longBinWithCommasAux = longBinWithCommas
        while (longBinWithCommasAux.characters.count-(arrayBinarios.count-1)) % 6 != 0 {
            
            // Parte importante aqui es acompletar los ceros mochados que le faltan
            longBinWithCommasAux += "0"
            contadroSignosIgual += 1
        }
        
        let arrayBinariosAux = longBinWithCommasAux.components(separatedBy: ",")
        print(arrayBinariosAux)
        
        for str6bites in arrayBinariosAux {
            
            print(str6bites)
            
            let num = Int(str6bites, radix: 2)!
            
            switch num {
            case 0:
                strLongBase64 += "A"
            case 1:
                strLongBase64 += "B"
            case 2:
                strLongBase64 += "C"
            case 3:
                strLongBase64 += "D"
            case 4:
                strLongBase64 += "E"
            case 5:
                strLongBase64 += "F"
            case 6:
                strLongBase64 += "G"
            case 7:
                strLongBase64 += "H"
            case 8:
                strLongBase64 += "I"
            case 9:
                strLongBase64 += "J"
            case 10:
                strLongBase64 += "K"
            case 11:
                strLongBase64 += "L"
            case 12:
                strLongBase64 += "M"
            case 13:
                strLongBase64 += "N"
            case 14:
                strLongBase64 += "O"
            case 15:
                strLongBase64 += "P"
            case 16:
                strLongBase64 += "Q"
            case 17:
                strLongBase64 += "R"
            case 18:
                strLongBase64 += "S"
            case 19:
                strLongBase64 += "T"
            case 20:
                strLongBase64 += "U"
            case 21:
                strLongBase64 += "V"
            case 22:
                strLongBase64 += "W"
            case 23:
                strLongBase64 += "X"
            case 24:
                strLongBase64 += "Y"
            case 25:
                strLongBase64 += "Z"
            case 26:
                strLongBase64 += "a"
            case 27:
                strLongBase64 += "b"
            case 28:
                strLongBase64 += "c"
            case 29:
                strLongBase64 += "d"
            case 30:
                strLongBase64 += "e"
            case 31:
                strLongBase64 += "f"
            case 32:
                strLongBase64 += "g"
            case 33:
                strLongBase64 += "h"
            case 34:
                strLongBase64 += "i"
            case 35:
                strLongBase64 += "j"
            case 36:
                strLongBase64 += "k"
            case 37:
                strLongBase64 += "l"
            case 38:
                strLongBase64 += "m"
            case 39:
                strLongBase64 += "n"
            case 40:
                strLongBase64 += "o"
            case 41:
                strLongBase64 += "p"
            case 42:
                strLongBase64 += "q"
            case 43:
                strLongBase64 += "r"
            case 44:
                strLongBase64 += "s"
            case 45:
                strLongBase64 += "t"
            case 46:
                strLongBase64 += "u"
            case 47:
                strLongBase64 += "v"
            case 48:
                strLongBase64 += "w"
            case 49:
                strLongBase64 += "x"
            case 50:
                strLongBase64 += "y"
            case 51:
                strLongBase64 += "z"
            case 52:
                strLongBase64 += "0"
            case 53:
                strLongBase64 += "1"
            case 54:
                strLongBase64 += "2"
            case 55:
                strLongBase64 += "3"
            case 56:
                strLongBase64 += "4"
            case 57:
                strLongBase64 += "5"
            case 58:
                strLongBase64 += "6"
            case 59:
                strLongBase64 += "7"
            case 60:
                strLongBase64 += "8"
            case 61:
                strLongBase64 += "9"
            case 62:
                strLongBase64 += "+"
            case 63:
                strLongBase64 += "/"
            default:
                print("ERROR: Entero fuera de rango de la Base64")
            }
            
            print(strLongBase64)
        }
        
        for _ in 0..<contadroSignosIgual/2 {
            
            strLongBase64 += "="
        }
        
        return strLongBase64
    }
}


