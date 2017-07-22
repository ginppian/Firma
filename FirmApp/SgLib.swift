//  SgLib.swift
//  sglibSwiftUsage
//
//  Created by Pedro Cervantges on 9/23/16.
//  Copyright © 2016 Seguridata Privada S.A de C.V. All rights reserved.
//

import Foundation
import CSgLibSwift

class SgLib {

    
    //
    //
    // areKeysConsistentSwift Versión con String
    //
    //
    
    func areKeysConsistentSwift(_ certificate : String,
                                privateKey : String,
                                password : String) -> Int32 {
        
        var result: Int32 = 0
        var certificateCString = certificate.utf8CString
        var privateKeyCString = privateKey.utf8CString
        var passwordCString = password.utf8CString
        
        
        certificateCString.withUnsafeMutableBytes { certUMRBP in
            privateKeyCString.withUnsafeMutableBytes { pkUMRBP in
                passwordCString.withUnsafeMutableBytes { passUMRBP in
                    
                    result = areKeysConsistent(
                        certUMRBP.baseAddress!.bindMemory(to: UInt8.self, capacity: certUMRBP.count),
                        UInt32(certUMRBP.count),
                        pkUMRBP.baseAddress!.bindMemory(to: UInt8.self, capacity: pkUMRBP.count),
                        UInt32(pkUMRBP.count),
                        passUMRBP.baseAddress!.bindMemory(to: Int8.self, capacity: passUMRBP.count)
                        
                    )
                    print ("-------1--------")
                    print (certUMRBP)
                    print ("---------------")
                    
                    print ("-------2--------")
                    print (pkUMRBP)
                    print ("---------------")
                    
                    print ("-------3--------")
                    print (passUMRBP)
                    print (password)
                    print ("---------------")
                    
                }
            }
        }
        return Int32(result)
        
    }
    
    //
    //
    // genPkcs7FromHashSwift Versión con String
    //
    //
    /*
    func genPkcs7FromHashSwift(_ certificate : String,
                               privateKey : String,
                               password : String,
                               hash : String,
                               b64Required : UInt8) -> (Int32, Data) {
        
        var result: Int32 = 0
        var pkcs7: NSData? = nil
        var certificateCString = certificate.utf8CString
        var privateKeyCString = privateKey.utf8CString
        var passwordCString = password.utf8CString
        var hashCString = hash.utf8CString
        
        certificateCString.withUnsafeMutableBytes { certUMRBP in
            privateKeyCString.withUnsafeMutableBytes { pkUMRBP in
                passwordCString.withUnsafeMutableBytes { passUMRBP in
                    hashCString.withUnsafeMutableBytes { hashUMRBP in
                        /* Los datos estan siendo enviados correctamente */
                        result =  genPkcs7FromHash_SharedBuff(certUMRBP.baseAddress!.bindMemory(to: UInt8.self, capacity: certUMRBP.count), UInt32(certUMRBP.count),  pkUMRBP.baseAddress!.bindMemory(to: UInt8.self, capacity: pkUMRBP.count), UInt32(pkUMRBP.count),passUMRBP.baseAddress!.bindMemory(to: Int8.self, capacity: passUMRBP.count) , hashUMRBP.baseAddress!.bindMemory(to: UInt8.self, capacity: hashUMRBP.count), UInt32(hashUMRBP.count), b64Required)
                        /* Anteriormente en Swift 2.3 */
                        //let pkcs7 = NSData(bytes: UnsafePointer<Void>(shared_mem_buff), length: Int(shared_mem_buff_size));
                        
                        /*Este es el método que debe ser utilizado en Swift 3.0*/
                        pkcs7 = NSData(bytes: UnsafeMutableRawPointer(shared_mem_buff), length:Int(shared_mem_buff_size))
                        
                        //Esto imprime: Optional(<>), sin embargo no es importante.
                        print (pkcs7)
                        
                        //Impresión de datos enviados solo para verificar.
                        print ("------apuntador al certificado-------")
                        print (certUMRBP)
                        print ("-------------------------------------")
                        
                        print ("----------Apuntador a llave----------")
                        print (pkUMRBP)
                        print ("-------------------------------------")
                        
                        print ("-------Apuntador a contraseña--------")
                        print (passUMRBP)
                        print (password)
                       print ("-------------------------------------")
                        
                    }
                }
            }
        }
        
        /* Pedro, esta linea me generaba error desde la versión anterior :S */
        //genPkcs7FromHash_Clean_SharedBuff();
        //Limpiamos el buffer compartido
        
        return (result,pkcs7! as Data);
    }*/
    
    
    /*
     var hash = "PKz+Paap6wWm0i8OsSkkHnD2KHrj6Wwk9d1F38Z6CtA="
     func genPkcs7FromHashSwift(_ certificate : String,
     privateKey : String,
     password : String,
     hash : String,
     b64Required : UInt8) -> (Int32, Data)
     */
    func genPkcs7FromHashSwift(_ certificate : String,
                               privateKey : String,
                               password : String,
                               hash : String,
                               b64Required : UInt8) -> (Int32, Data) {
        
        var result: Int32 = 0
        var pkcs7: NSData? = nil
        var certificateCString = certificate.utf8CString
        var privateKeyCString = privateKey.utf8CString
        var passwordCString = password.utf8CString
        print(passwordCString)
        var hashCString = hash.utf8CString
        print(hashCString)
        //var b64CString = b64Required.utf8CString
        var pkcs7String: NSString = ""
        certificateCString.withUnsafeMutableBytes { certUMRBP in
            privateKeyCString.withUnsafeMutableBytes { pkUMRBP in
                passwordCString.withUnsafeMutableBytes { passUMRBP in
                    hashCString.withUnsafeMutableBytes { hashUMRBP in
                        //b64CString.withUnsafeMutableBytes { hashUMRBP in
                        
                        /* Los datos estan siendo enviados correctamente */
                        result =  genPkcs7FromHash_SharedBuff(certUMRBP.baseAddress!.bindMemory(to: UInt8.self, capacity: certUMRBP.count-1), UInt32(certUMRBP.count-1),  pkUMRBP.baseAddress!.bindMemory(to: UInt8.self, capacity: pkUMRBP.count-1), UInt32(pkUMRBP.count-1),passUMRBP.baseAddress!.bindMemory(to: Int8.self, capacity: passUMRBP.count-1) , hashUMRBP.baseAddress!.bindMemory(to: UInt8.self, capacity: hashUMRBP.count-1), UInt32(hashUMRBP.count-1), UInt8(true))
                        /* Anteriormente en Swift 2.3 */
                        //let pkcs7 = NSData(bytes: UnsafePointer<Void>(shared_mem_buff), length: Int(shared_mem_buff_size));
                        
                        /*Este es el método que debe ser utilizado en Swift 3.0*/
                        pkcs7 = NSData(bytes: UnsafeMutableRawPointer(shared_mem_buff), length:Int(shared_mem_buff_size))
                        print(pkcs7)
                        //Esto imprime: Optional(<>), sin embargo no es importante.
                        print (result)
                        
                        //
                        //Impresión de datos enviados solo para verificar.
                        print ("------apuntador al certificado-------")
                        print (certUMRBP)
                        print ("-------------------------------------")
                        
                        print ("----------Apuntador a llave----------")
                        print (pkUMRBP)
                        print ("-------------------------------------")
                        
                        print ("-------Apuntador a contraseña--------")
                        print (passUMRBP)
                        print (password)
                        print ("-------------------------------------")
                        
                        print ("----------Apuntador a hash-----------")
                        print (hash)
                        print (hashCString)
                        print (hashCString.count)
                        print ("-------------------------------------")
                        
                        //}
                    }
                }
            }
        }
        
        /* Pedro, esta linea me generaba error desde la versión anterior :S */
        //genPkcs7FromHash_Clean_SharedBuff();
        //Limpiamos el buffer compartido
        let pkcs7Data = pkcs7 as! Data
        //pkcs7String = NSString(data:  , encoding:String.Encoding.utf8.rawValue)!
        
        return (result,pkcs7Data);
    }

    
}
