/******************************************************************************/
/* SDMOVILE.H    SeguriDATA Privada, S. A. de C. V  Copyright (c) 1997-2016   */
/*                                                                            */
/*      History revision                                                      */
/*                                                                            */
/* 23/09/16 - JGC  - Header creation                                          */
/******************************************************************************/

#ifndef SDMOVILE_H
#define SDMOVILE_H

#ifdef __cplusplus
extern "C" {
#endif
    
#define SDM_ERR_NO_CERT                         -1
#define SDM_ERR_NO_CERTLEN                      -2
#define SDM_ERR_NO_PRIVK                        -3
#define SDM_ERR_NO_PRIVKLEN                     -4
#define SDM_ERR_NO_PASS                         -5
#define SDM_ERR_DECODING_CERT                   -6
#define SDM_ERR_DECODING_ENCR_PRIVK             -7
#define SDM_ERR_CANT_DECRYPT_PRIVK              -8
#define SDM_ERR_NO_MEMORY                       -9
#define SDM_ERR_CONVERTING_B64_2_DER_CERT      -10
#define SDM_ERR_CONVERTING_B64_2_DER_PRIVK     -11
#define SDM_ERR_NO_SGTR_OUT_PARAM_PROVIDED     -12
#define SDM_ERR_NO_SGTRLEN_OUT_PARAM_PROVIDED  -13
#define SDM_ERR_NO_HASH                        -14
#define SDM_ERR_NO_HASHLEN                     -15
#define SDM_ERR_CONVERTING_PEM_TO_DER          -16
#define SDM_ERR_NO_SOURCE_BUFFER               -17
#define SDM_ERR_NO_TARGET_BUFFER               -18
#define SDM_ERR_DECODING_DER                   -19
#define SDM_ERR_INVALID_HASHLEN                -20
#define SDM_ERR_INTERNAL_ERROR_CHECK_CODE      -21
    
#define SDM_TRUE      1
#define SDM_FALSE     0
#define SDM_OK        1000
    
    /* VERIFIES IF KEYS ARE CONSISTENT */
    int areKeysConsistent(
                          unsigned char *certificate,
                          unsigned int   certLen,
                          unsigned char *privateKey,
                          unsigned int   privKLen,
                          char *password
                          );
    
    /* GENERATES PKCS7 FROM HASH */
    int genPkcs7FromHash(
                         unsigned char  *certificate,
                         unsigned int    certLen,
                         unsigned char  *privateKey,
                         unsigned int    privKLen,
                         char           *password,
                         unsigned char  *hash,
                         unsigned int    hashLen,
                         unsigned char   b64Required,
                         unsigned char **pkcs7Signature,
                         unsigned int   *pkcs7SignatureLen);
    
    
#ifdef __cplusplus
}
#endif

#endif /* SDMOVILE_H */
