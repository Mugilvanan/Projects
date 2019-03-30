// ----------------------------------------------------------------------------------
// -- Module Name  : env_inc
// -- Project Name : Verification of AES GCM using systemverilog
// -- Engineer Name: Mugilvanan Vinayagam
// ----------------------------------------------------------------------------------

package env_inc;

//	`define DEBUG 1;                //defined to create log file of transactions
//	`define INJECT_ERROR 1;			//defined to inject error from environment through BFM

//test vectors
logic [127 : 0] test_vector_0_1[4]  = { 128'h00000000000000000000000000000000,
					  128'h00000000000000000000000000000000,
					  128'h00000000000000000000000100000060,
					  128'h00000000000000000000000000000000
					};

logic [127 : 0] test_vector_1_1[5]  = { 128'h00000000000000000000000000000000,
					  128'h00000000000000000000000000000000,
					  128'h00000000000000800000000100000060,
					  128'h00000000000000000000000000000000,
					  128'h00000000000000000000000000000000
					};

logic [127 : 0] test_vector_2_1[8]  = { 128'h00000000000000000000000000000000,
					  128'hfeffe9928665731c6d6a8f9467308308,
					  128'h00000000000002000000000100000060,
					  128'h00000000cafebabefacedbaddecaf888,
					  128'hd9313225f88406e5a55909c5aff5269a,
					  128'h86a7a9531534f7da2e4c303d8a318a72,
					  128'h1c3c0c95956809532fcf0e2449a6b525,
					  128'hb16aedf5aa0de657ba637b391aafd255
					};  

logic [127 : 0] test_vector_3_1[10] = { 128'h00000000000000000000000000000000,
					  128'hfeffe9928665731c6d6a8f9467308308,
					  128'h00000000000001e00002000100A00060,
					  128'h00000000cafebabefacedbaddecaf888,
					  128'hfeedfacedeadbeeffeedfacedeadbeef,
					  128'habaddad2000000000000000000000000,
					  128'hd9313225f88406e5a55909c5aff5269a,
					  128'h86a7a9531534f7da2e4c303d8a318a72,
					  128'h1c3c0c95956809532fcf0e2449a6b525,
					  128'hb16aedf5aa0de657ba637b3900000000
					}; 

logic [127 : 0] test_vector_4_1[10] = { 128'h00000000000000000000000000000000,
					  128'hfeffe9928665731c6d6a8f9467308308,
					  128'h00000000000001e00002000100A00040,
					  128'h0000000000000000cafebabefacedbad,
					  128'hfeedfacedeadbeeffeedfacedeadbeef,
					  128'habaddad2000000000000000000000000,
					  128'hd9313225f88406e5a55909c5aff5269a,
					  128'h86a7a9531534f7da2e4c303d8a318a72,
					  128'h1c3c0c95956809532fcf0e2449a6b525,
					  128'hb16aedf5aa0de657ba637b3900000000
					}; 

logic [127 : 0] test_vector_0_2[4]  = { 128'h00000000000000000000000000000000,
					  128'h00000000000000000000000000000000,
					  128'h00000000000000000000000100000060,
					  128'h00000000000000000000000000000000
					};

logic [127 : 0] test_vector_1_2[5]  = { 128'h00000000000000000000000000000000,
					  128'h00000000000000000000000000000000,
					  128'h00000000000000800000000100000060,
					  128'h00000000000000000000000000000000,
					  128'h00000000000000000000000000000000
					};

logic [127 : 0] test_vector_2_2[8]  = { 128'h0000000000000000feffe9928665731c,
					  128'h6d6a8f9467308308feffe9928665731c,
					  128'h00000000000002000000000100000060,
					  128'h00000000cafebabefacedbaddecaf888,
					  128'hd9313225f88406e5a55909c5aff5269a,
					  128'h86a7a9531534f7da2e4c303d8a318a72,
					  128'h1c3c0c95956809532fcf0e2449a6b525,
					  128'hb16aedf5aa0de657ba637b391aafd255
					};  

logic [127 : 0] test_vector_3_2[10] = { 128'h0000000000000000feffe9928665731c,
					  128'h6d6a8f9467308308feffe9928665731c,
					  128'h00000000000001e00002000100A00060,
					  128'h00000000cafebabefacedbaddecaf888,
					  128'hfeedfacedeadbeeffeedfacedeadbeef,
					  128'habaddad2000000000000000000000000,
					  128'hd9313225f88406e5a55909c5aff5269a,
					  128'h86a7a9531534f7da2e4c303d8a318a72,
					  128'h1c3c0c95956809532fcf0e2449a6b525,
					  128'hb16aedf5aa0de657ba637b3900000000
					}; 

logic [127 : 0] test_vector_4_2[10] = { 128'h0000000000000000feffe9928665731c,
					  128'h6d6a8f9467308308feffe9928665731c,
					  128'h00000000000001e00002000100A00040,
					  128'h0000000000000000cafebabefacedbad,
					  128'hfeedfacedeadbeeffeedfacedeadbeef,
					  128'habaddad2000000000000000000000000,
					  128'hd9313225f88406e5a55909c5aff5269a,
					  128'h86a7a9531534f7da2e4c303d8a318a72,
					  128'h1c3c0c95956809532fcf0e2449a6b525,
					  128'hb16aedf5aa0de657ba637b3900000000
					}; 

logic [127 : 0] test_vector_0_3[4]  = { 128'h00000000000000000000000000000000,
					  128'h00000000000000000000000000000000,
					  128'h00000000000000000000000100000060,
					  128'h00000000000000000000000000000000
					};

logic [127 : 0] test_vector_1_3[5]  = { 128'h00000000000000000000000000000000,
					  128'h00000000000000000000000000000000,
					  128'h00000000000000800000000100000060,
					  128'h00000000000000000000000000000000,
					  128'h00000000000000000000000000000000
					};

logic [127 : 0] test_vector_2_3[8]  = { 128'hfeffe9928665731c6d6a8f9467308308,
					  128'hfeffe9928665731c6d6a8f9467308308,
					  128'h00000000000002000000000100000060,
					  128'h00000000cafebabefacedbaddecaf888,
					  128'hd9313225f88406e5a55909c5aff5269a,
					  128'h86a7a9531534f7da2e4c303d8a318a72,
					  128'h1c3c0c95956809532fcf0e2449a6b525,
					  128'hb16aedf5aa0de657ba637b391aafd255
					};  

logic [127 : 0] test_vector_3_3[10] = { 128'hfeffe9928665731c6d6a8f9467308308,
					  128'hfeffe9928665731c6d6a8f9467308308,
					  128'h00000000000001e00002000100A00060,
					  128'h00000000cafebabefacedbaddecaf888,
					  128'hfeedfacedeadbeeffeedfacedeadbeef,
					  128'habaddad2000000000000000000000000,
					  128'hd9313225f88406e5a55909c5aff5269a,
					  128'h86a7a9531534f7da2e4c303d8a318a72,
					  128'h1c3c0c95956809532fcf0e2449a6b525,
					  128'hb16aedf5aa0de657ba637b3900000000
					}; 

logic [127 : 0] test_vector_4_3[10] = { 128'hfeffe9928665731c6d6a8f9467308308,
					  128'hfeffe9928665731c6d6a8f9467308308,
					  128'h00000000000001e00002000100A00040,
					  128'h0000000000000000cafebabefacedbad,
					  128'hfeedfacedeadbeeffeedfacedeadbeef,
					  128'habaddad2000000000000000000000000,
					  128'hd9313225f88406e5a55909c5aff5269a,
					  128'h86a7a9531534f7da2e4c303d8a318a72,
					  128'h1c3c0c95956809532fcf0e2449a6b525,
					  128'hb16aedf5aa0de657ba637b3900000000
					}; 


logic [127 : 0] H_value[15]		=	{ 128'h66e94bd4ef8a2c3b884cfa59ca342b2e,
					  128'h66e94bd4ef8a2c3b884cfa59ca342b2e,
					  128'hb83b533708bf535d0aa6e52980d53b78,
					  128'hb83b533708bf535d0aa6e52980d53b78,
					  128'hb83b533708bf535d0aa6e52980d53b78,
					  128'haae06992acbf52a3e8f4a96ec9300bd7,
					  128'haae06992acbf52a3e8f4a96ec9300bd7,
					  128'h466923ec9ae682214f2c082badb39249,
					  128'h466923ec9ae682214f2c082badb39249,
					  128'h466923ec9ae682214f2c082badb39249,
					  128'hdc95c078a2408989ad48a21492842087,
					  128'hdc95c078a2408989ad48a21492842087,
					  128'hacbef20579b4b8ebce889bac8732dad7,
					  128'hacbef20579b4b8ebce889bac8732dad7,
					  128'hacbef20579b4b8ebce889bac8732dad7
					};

logic [127 : 0] Ek_value[15]    =   { 128'h58e2fccefa7e3061367f1d57a4e7455a,
                      128'h58e2fccefa7e3061367f1d57a4e7455a,
                      128'h3247184b3c4f69a44dbcd22887bbb418,
                      128'h3247184b3c4f69a44dbcd22887bbb418,
                      128'he94ab9535c72bea9e089c93d48e62fb0,
                      128'hcd33b28ac773f74ba00ed1f312572435,
                      128'hcd33b28ac773f74ba00ed1f312572435,
                      128'hc835aa88aebbc94f5a02e179fdcfc3e4,
                      128'hc835aa88aebbc94f5a02e179fdcfc3e4,
                      128'h7bb6d647c902427ce7cf26563a337371,
                      128'h530f8afbc74536b9a963b4f1c4cb738b,
                      128'h530f8afbc74536b9a963b4f1c4cb738b,
                      128'hfd2caa16a5832e76aa132c1453eeda7e,
                      128'hfd2caa16a5832e76aa132c1453eeda7e,
                      128'h4f903f37fe611d454217fbfa5cd7d791
                    };


logic [127 : 0] output_1_1[1]       = { 128'h58e2fccefa7e3061367f1d57a4e7455a };

logic [127 : 0] output_2_1[2]       =  { 128'h0388dace60b6a392f328c2b971b2fe78,
					   128'hab6e47d42cec13bdf53a67b21257bddf
					 };

logic [127 : 0] output_3_1[5]      =  { 128'h42831ec2217774244b7221b784d0d49c,
                      128'he3aa212f2c02a4e035c17e2329aca12e,
                      128'h21d514b25466931c7d8f6a5aac84aa05,
                      128'h1ba30b396a0aac973d58e091473f5985,
                      128'h4d5c2af327cd64a62cf35abd2ba6fab4
                    };

logic [127 : 0] output_4_1[5]      =  { 128'h42831ec2217774244b7221b784d0d49c,
                      128'he3aa212f2c02a4e035c17e2329aca12e,
                      128'h21d514b25466931c7d8f6a5aac84aa05,
                      128'h1ba30b396a0aac973d58e09100000000,
                      128'h5bc94fbc3221a5db94fae95ae7121a47
                    };


logic [127 : 0] output_5_1[5]      =  { 128'h61353b4c2806934a777ff51fa22a4755,
                      128'h699b2a714fcdc6f83766e5f97b6c7423,
                      128'h73806900e49f24b22b097544d4896b42,
                      128'h4989b5e1ebac0f07c23f459800000000,
                      128'h3612d2e79e3b0785561be14aaca2fccb
                    };

logic [127 : 0] output_1_2[1]       = { 128'hcd33b28ac773f74ba00ed1f312572435 };

logic [127 : 0] output_2_2[2]       =  { 128'h98e7247c07f0fe411c267e4384b0f600,
					   128'h2ff58d80033927ab8ef4d4587514f0fb
					 };

logic [127 : 0] output_3_2[5]      =  { 128'h3980ca0b3c00e841eb06fac4872a2757,
                      128'h859e1ceaa6efd984628593b40ca1e19c,
                      128'h7d773d00c144c525ac619d18c84a3f47,
                      128'h18e2448b2fe324d9ccda2710acade256,
                      128'h9924a7c8587336bfb118024db8674a14
                    };

logic [127 : 0] output_4_2[5]      =  { 128'h3980ca0b3c00e841eb06fac4872a2757,
                      128'h859e1ceaa6efd984628593b40ca1e19c,
                      128'h7d773d00c144c525ac619d18c84a3f47,
                      128'h18e2448b2fe324d9ccda271000000000,
                      128'h2519498e80f1478f37ba55bd6d27618c
                    };


logic [127 : 0] output_5_2[5]      =  { 128'h0f10f599ae14a154ed24b36e25324db8,
                      128'hc566632ef2bbb34f8347280fc4507057,
                      128'hfddc29df9a471f75c66541d4d4dad1c9,
                      128'he93a19a58e8b473fa0f062f700000000,
                      128'h65dcc57fcf623a24094fcca40d3533f8
                    };

logic [127 : 0] output_1_3[1]       = { 128'h530f8afbc74536b9a963b4f1c4cb738b };

logic [127 : 0] output_2_3[2]       =  { 128'hcea7403d4d606b6e074ec5d3baf39d18,
					   128'hd0d1c8a799996bf0265b98b5d48ab919
					 };

logic [127 : 0] output_3_3[5]      =  { 128'h522dc1f099567d07f47f37a32a84427d,
                      128'h643a8cdcbfe5c0c97598a2bd2555d1aa,
                      128'h8cb08e48590dbb3da7b08b1056828838,
                      128'hc5f61e6393ba7a0abcc9f662898015ad,
                      128'hb094dac5d93471bdec1a502270e3cc6c
                    };

logic [127 : 0] output_4_3[5]      =  { 128'h522dc1f099567d07f47f37a32a84427d,
                      128'h643a8cdcbfe5c0c97598a2bd2555d1aa,
                      128'h8cb08e48590dbb3da7b08b1056828838,
                      128'hc5f61e6393ba7a0abcc9f66200000000,
                      128'h76fc6ece0f4e1768cddf8853bb2d551b
                    };


logic [127 : 0] output_5_3[5]      =  { 128'hc3762df1ca787d32ae47c13bf19844cb,
                      128'haf1ae14d0b976afac52ff7d79bba9de0,
                      128'hfeb582d33934a4f0954cc2363bc73f78,
                      128'h62ac430e64abe499f47c9b1f00000000,
                      128'h3a337dbf46a792c45e454913fe2ea8f2
                    };


	//Importing a C-function
	import "DPI-C" function void AES_GCM_encrypt(int key_len, int iv_len, int aad_len, int data_len, byte unsigned key[], byte unsigned iv[], byte unsigned aad[], byte unsigned data[]);

	int number_of_operations = 200;
	
	`include "generator.sv";
	`include "driver.sv";
	`include "scoreboard.sv";
	`include "bfm.sv";	
	`include "coverage.sv"
	`include "monitor.sv"	
	`include "environment.sv";

endpackage : env_inc