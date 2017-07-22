//
//  Servicios.swift
//  FirmApp
//
//  Created by ginppian on 03/07/17.
//  Copyright © 2017 MBN. All rights reserved.
//

import Foundation

struct Servicios {
    
    static let shared = Servicios()
    
//---//-----//-------------//---------------------//-------------//--------//-----//---//
    
    /*
     /rest/employee/gethash: Recurso encargado de
     obtener el hash del documento pdf,
     el cual debe ser firmado por el usuario
     */
    
    func gethash() -> String {
        
        let url = "http://200.66.66.213:8080/"
        let servicio = "WS_Rest_HRV/rest/employee/gethash/"
        
        return "\(url)\(servicio)"
    }
    
    /*
     Para anexar un JSON
     a el BODY del Servicio
     tomamos un String lo convierte a un Data
     */
    
    func gethashJSONData(idDomain: String,
                         idRhEmp: String,
                         multilateralId: String,
                         resultado: String) -> Data {

        let strJson  = "{\"idDomain\":\(idDomain),\"idRhEmp\":\"\(idRhEmp)\",\"multilateralId\":\(multilateralId),\"resultado\":\(resultado)}"
        
        return strJson.data(using: String.Encoding.utf8)!
    }
    
//---//-----//-------------//---------------------//-------------//--------//-----//---//
    
    /*
     /rest/employee/establish: Recurso encargado de
     establecer la firma para un usuario
     dado que se encuentra en un proceso de firma
     */
    
    func establish() -> String {
        
        let url = "http://200.66.66.213:8080/"
        let servicio = "WS_Rest_HRV/rest/employee/establish/"
        
        return "\(url)\(servicio)"
    }
    
    /*
     Para anexar un JSON
     a el BODY del Servicio
     tomamos un String lo convierte a un Data
     */
    
    func establishJSONData(idDomain: String,
                           idRhEmp: String,
                           multilateralId : String,
                           b64Pkcs7 : String,
                           userDomain: String,
                           passwordDomain: String,
                           bISendEmail: String,
                           emailToSend: String,
                           resultado: Int) -> Data {
        
        let strJson = "{\"idDomain\":\(idDomain),\"idRhEmp\":\"\(idRhEmp)\",\"multilateralId\":\(multilateralId),\"b64Pkcs7\":\"\(b64Pkcs7)\",\"userDomain\":\(userDomain),\"passwordDomain\":\(passwordDomain),\"blSendEmail\":\(bISendEmail),\"emailToSend\":\(emailToSend),\"resultado\":\(resultado)}"
        
        return strJson.data(using: String.Encoding.utf8)!
    }
    
//---//-----//-------------//---------------------//-------------//--------//-----//---//
    
}
