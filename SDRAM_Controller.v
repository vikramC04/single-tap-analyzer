/*****************************************************************************
 *                                                                           *
 * Module:       SDRAM_Controller                                             *
 * Description:                                                              *
 *      This module is used for the sram controller for MT3TB4 Lab 4          *
 *                                                                           *
 *****************************************************************************/
`timescale 1ns / 1ps
 
module SDRAM_Controller (  // The ports sequence follows the sequence of wires in the diagram in the lab manual
		// Signals through Avalon Interface:
		// This module will be instantiated in lab4.v meaning the below signals will be connected to their respective ports in lab4.v. 
		// Those signals will come from the sopc_system controller module
		input 			clock,
		input 			reset_n,     		
		input 			chipselect,
		input				write_n,
		input				read_n,
		input	 [1:0]	byteenable_n,
		input	 [24:0]	address,   //2's power of 25 is  33,554,432 that is 32M.  (16 bits word, that makes capable for 64MBytes)
		input	 [15:0]	write_data,
		output [15:0]	read_data,
		output 			wait_request,
		output			data_validation,
	
		// Signals between Controller and SDRAM:
		// This module will be instantiated in lab4.v meaning the below signals will be connected to their respective ports in lab4.v
		// These signals will go to the output ports in the port declaration of lab4.v
		inout	 [15:0]	DRAM_DQ,
		output [12:0]	DRAM_ADDR,
		output [1:0]	DRAM_BA,
	//	output		 	DRAM_CLK,
		output			DRAM_CKE,
		output 			DRAM_LDQM,   
		output			DRAM_UDQM,		
		output 			DRAM_WE_N,
		output			DRAM_CAS_N,
		output 			DRAM_RAS_N,
		output 			DRAM_CS_N
		
);
		// Signals through Avalon Interface
		wire	 			clock_wire/*synthesis keep*/;
		wire 				reset_n_wire/*synthesis keep*/;     		
		wire 				chipselect_wire/*synthesis keep*/;
		wire				write_n_wire/*synthesis keep*/;
		wire				read_n_wire/*synthesis keep*/;
		wire	[1:0]		byteenable_n_wire/*synthesis keep*/;
		wire	[24:0]	address_wire/*synthesis keep*/;   //2's power of 25 is  33,554,432 that is 32M.  (16 bits word, that makes capable for 64MBytes)
		wire	[15:0]	write_data_wire/*synthesis keep*/;	
		wire 				Wait_request_wire/*synthesis keep*/;
		wire				data_validation_wire/*synthesis keep*/;
				
		reg	[15:0]	read_data_reg/*synthesis preserve*/;
		// wire	[15:0]	read_data_wire/*synthesis keep*/;		
		
		
		// Signals between Conroller and SDRAM:
		wire	[15:0]	DRAM_DQ_wire/*synthesis keep*/;
		wire	[12:0]	DRAM_ADDR_wire/*synthesis keep*/;
		wire	[1:0]		DRAM_BA_wire/*synthesis keep*/;
		
		wire				DRAM_CKE_wire/*synthesis keep*/;
		
		wire	[1:0] 	DRAM_DQM_wire/*synthesis keep*/;   	//higher bit for UDQM , lower bit for LDQM
		wire 				DRAM_WE_N_wire/*synthesis keep*/;
		wire				DRAM_CAS_N_wire/*synthesis keep*/;
		wire 				DRAM_RAS_N_wire/*synthesis keep*/;
		wire 				DRAM_CS_N_wire/*synthesis keep*/;
		
		wire [15:0]		m_data_wire;				// Extra signal not in lab manual
		wire				output_enable_wire;		// Extra signal not in lab manual. I'm assuming this is asserted when being read.
		
		DE1_SoC_QSYS_sdram  my_sdram (
                            // inputs:
                             .az_addr(address_wire),					// DONE
                             .az_be_n(byteenable_n_wire),			// DONE
                             .az_cs(chipselect_wire),					// DONE
                             .az_data(write_data_wire),				// DONE
                             .az_rd_n(read_n_wire),					// DONE
                             .az_wr_n(write_n_wire),					// DONE
                             .clk(clock_wire),							// DONE
                             .reset_n(reset_n_wire),					// DONE

                            // outputs:
                            //.za_data(read_data_wire),    //can not get read_data from here.
                             .za_valid(data_validation_wire),		// DONE
                             .za_waitrequest(Wait_request_wire),	// DONE
                             .zs_addr(DRAM_ADDR_wire),				// DONE
                             .zs_ba(DRAM_BA_wire),						// DONE
                             .zs_cas_n(DRAM_CAS_N_wire),				// DONE
                             .zs_cke(DRAM_CKE_wire),					// DONE
                             .zs_cs_n(DRAM_CS_N_wire),				// DONE
                             //.zs_dq(DRAM_DQ_wire),					// N/A
                             .zs_dqm(DRAM_DQM_wire),					// DONE
                             .zs_ras_n(DRAM_RAS_N_wire),				// DONE
                             .zs_we_n(DRAM_WE_N_wire),				// DONE
									  .output_enable(output_enable_wire),	// DONE
									  .internal_m_data(m_data_wire)			// DONE
                          );								  
								  
		//=============Make connections =====================	
		// Inputs for DE1_SoC_QSYS_sdram module{
		assign 			clock_wire=clock;							// DONE
		assign 			reset_n_wire=reset_n;     				// DONE
		assign 			chipselect_wire=chipselect;			// DONE
		assign			write_n_wire=write_n;					// DONE
		assign			read_n_wire=read_n;						// DONE
		assign			byteenable_n_wire=byteenable_n;		// DONE
		assign			address_wire=address;   				// DONE 2's power of 25 is  33,554,432 that is 32M.  (16 bits word, that makes capable for 64MBytes)
		assign			write_data_wire=write_data;			// DONE
		//}

//		// A NOTE ON INOUT PORTS
//		1. You can't read and write an inout port simultaneously. You need to keep a high Z for reading
//		2. An inout port can NEVER be type reg
//		3. There should be a condition at which the port should be written to by the module.
//		This means that it is being read from the perspective of the module that instantiated it
//		
//		EX/
//		
//		module test(value, var);
//			inout value;
//			output reg var;
//			
//			assign value = (condition) ? <Value/Expression> : n'bz;
//			// So basically if the condition is true, the circuit is complete such that the net value takes the value of <Value/Expression>
//			// BUT if the condition isn't true, this circuit is disconnected. Literally imagine in your head that the circuit is disconnected.
//			// That means this value is now driven by the input to the circuit. Isn't that cool? HDL. Imagine it in your head.
//			
//			always@(<event>) // IF IT'S A REG
//				var = value;
//
//			assign var = (opposite condition to the write condition) ? value : n'bz; // IF IT'S A WIRE
//
//		endmodule
//		// A NOTE ON INOUT PORTS
		
		// Output za_data from DE1_SoC_QSYS_sdram module{
		assign 			DRAM_DQ=output_enable_wire?m_data_wire:{16{1'bz}};
		// This is a write operation because DRAM_DQ goes to the SDRAM and is being set to a value. This is acting as an output to the SDRAM.
		// DRAM_DQ is an inout port. If read_n is low, DRAM_DQ is an output. If write_n is low, DRAM_DQ is an input.
		// 16{1'bz} means 16 bits of high impedance (Z = high impedance) meaning an invalid value (The circuit is open).
		// If output_enable_wire is asserted (chip is outputting data to be read), then DRAM_DQ = the data coming out (m_data_wire) and becomes an output. Otherwise the circuit is not driven by m_date_wire and becomes an input.
		
		// This way works, getting data from za_data port does not work.
		always @(posedge clock or negedge reset_n)   // must be synchronized with the clock! 
		 begin
			if (reset_n == 0)
				read_data_reg<= 0;
			else 
				read_data_reg <= DRAM_DQ;
				// read_data_reg is synchronously driven by DRAM_DQ, an input from the SDRAM.
				// This is a read operation because read_data_reg is taking the value that came from DRAM_DQ that came from the SDRAM.
		 end
		//}
		
		// Output signals
		assign 			read_data=read_data_reg;
		// assign 			read_data=read_data_wire;   //can not get read_data from the za_data port
		assign 			wait_request=Wait_request_wire;
		assign			data_validation=data_validation_wire;
	
		//signals between Conroller and SDRAM:
		
		assign 			DRAM_UDQM=DRAM_DQM_wire[1];   	//higher bit for UDQM , lower bit for LDQM
		assign			DRAM_LDQM=DRAM_DQM_wire[0];

	//  ==========Make  more  necessary connections=================		

		assign DRAM_ADDR = DRAM_ADDR_wire;
		assign DRAM_BA = DRAM_BA_wire;
		assign DRAM_CKE = DRAM_CKE_wire;
		assign DRAM_WE_N = DRAM_WE_N_wire;
		assign DRAM_CAS_N = DRAM_CAS_N_wire;
		assign DRAM_RAS_N = DRAM_RAS_N_wire;
		assign DRAM_CS_N = DRAM_CS_N_wire;
								  
endmodule
