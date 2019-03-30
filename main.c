// ----------------------------------------------------------------------------------
// -- Module Name  : main.c
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------

#define _GNU_SOURCE
#include "gcm.h"
#include "utils.h"
#include "svdpi.h"
#include <stdio.h>
#include <stdlib.h>

#ifndef __dpi_c_ex_c
#define __dpi_c_ex_c

static void single_encryption(int key_len, int iv_len, int aad_len, int data_len, unsigned char *key, unsigned char *iv, unsigned char *aad, unsigned char *data) {
    mbedtls_gcm_context ctx;
    unsigned char *buf;
    unsigned char tag_buf[16];
    int ret;
    mbedtls_cipher_id_t cipher = MBEDTLS_CIPHER_ID_AES;
    FILE *fp;
    char zero = 0;
  	int i;

    //Initialisation before starting encryption
    mbedtls_gcm_init( &ctx );
    
    //Setting key and key length
    ret = mbedtls_gcm_setkey( &ctx, cipher, key, key_len);
	
    //Allocating memory for output buffer
	  buf = (unsigned char *)calloc(data_len, sizeof(unsigned char *)); 

    //Encryption function which will return encrypted data into the output buffer pointer(buf)
    ret = mbedtls_gcm_crypt_and_tag(&ctx, MBEDTLS_GCM_ENCRYPT, data_len, iv, iv_len, aad, aad_len, data, buf, 16, tag_buf);
    mbedtls_gcm_free( &ctx );

    //Opening a file to write encrypted data and the tag
    fp = fopen("encrypt.bin", "w+");
    for(i = 0; i < data_len; i++)
    {
      if(i%16 == 0 && i > 0)
        fprintf(fp, "\n");
      fprintf(fp, "%02x", (unsigned char)buf[i]);
    }
    //Appending zeros at the end of encrypted data if required
    if(i%16 == 0)
      fprintf(fp, "\n");
    else
    {
      while(i%16 != 0)
      {
        i++;
        fprintf(fp, "00");
      }
      fprintf(fp, "\n");
    }
    for(i = 0; i < 16; i++)
      fprintf(fp, "%02x", (unsigned char)tag_buf[i]);
    fprintf(fp, "\n");
    fclose(fp);
}

//function that will be imported and called in SystemVerilog
void AES_GCM_encrypt(int key_len, int iv_len, int aad_len, int data_len, const svOpenArrayHandle h, const svOpenArrayHandle j, const svOpenArrayHandle k, const svOpenArrayHandle l)
{
  unsigned char *key;
  unsigned char *iv;
  unsigned char *aad;
  unsigned char *data;
  int i;
  
  //To find the lowest and highest index of an array
  int lo_key  = svLow(h, 1);
  int hi_key  = svHigh(h, 1);
  int lo_iv   = svLow(j, 1);
  int hi_iv   = svHigh(j, 1);
  int lo_aad  = svLow(k, 1);
  int hi_aad  = svHigh(k, 1);
  int lo_data = svLow(l, 1);
  int hi_data = svHigh(l, 1);

  //Allocting the memory based on the length 
  key   = (unsigned char *)calloc((key_len >> 3), sizeof(unsigned char *));
  iv    = (unsigned char *)calloc(iv_len, sizeof(unsigned char *)); 
  aad   = (unsigned char *)calloc(aad_len, sizeof(unsigned char *)); 
  data  = (unsigned char *)calloc(data_len, sizeof(unsigned char *)); 
  
  //Extracting element by element from svOpenArrayHandle and type casting it into unsigned char 
  for(i = lo_key; i <= hi_key; i++)
    key[i] = *(unsigned char *)svGetArrElemPtr1(h, i);
  for(i = lo_iv; i <= hi_iv; i++)
    iv[i] = *(unsigned char *)svGetArrElemPtr1(j, i);
  if(aad_len > 0)
  {  
    for(i = lo_aad; i <= hi_aad; i++)
      aad[i] = *(unsigned char *)svGetArrElemPtr1(k, i);
  }
  for(i = lo_data; i <= hi_data; i++)
    data[i] = *(unsigned char *)svGetArrElemPtr1(l, i); 

  //Calling the encryption function
  single_encryption(key_len, iv_len, aad_len, data_len, key, iv, aad, data);         
}
#endif

