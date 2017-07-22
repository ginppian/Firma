//
//  sdmovile.hpp
//  sglib
//
//  Created by Pedro Cervantes on 9/26/16.
//  Copyright © 2016 Seguridata Privada S.A de C.V. All rights reserved.
//

#ifndef sdmovile_hpp
#define sdmovile_hpp

#ifdef __cplusplus
extern "C" {
#endif
    
#include <stdio.h>
#include "sdmovile.h"
    
    
    /*THIS SHOULD BE CALLED FROM SWIFT*/
    int genPkcs7FromHash_SharedBuff(
                                    unsigned char  *certificate,
                                    unsigned int    certLen,
                                    unsigned char  *privateKey,
                                    unsigned int    privKLen,
                                    char           *password,
                                    unsigned char  *hash,
                                    unsigned int    hashLen,
                                    unsigned char   b64Required);
    
    /*THIS SHOULD BE CALLED FROM SWIFT*/
    void genPkcs7FromHash_Clean_SharedBuff();
    
    
    /* FOR SHARED MEMORY SWIFT/C */
    unsigned char* shared_mem_buff;
    unsigned int shared_mem_buff_size;
    
    
    
#ifdef __cplusplus
}
#endif

#endif /* sdmovile_hpp */
