module spi_baud_generator_tb();
	reg PCLK, PRESET_n;
	reg  [1:0] spi_mode_i;
    reg spiswai_i;
    reg  [2:0] sppr_i; 
    reg  [2:0] spr_i;
    reg  cpol_i;
    reg  cpha_i;
    reg ss_i;
    wire sclk_o;
    wire  miso_receive_sclk_o;
    wire  miso_receive_sclk0_o;
    wire  mosi_send_sclk_o;
    wire  mosi_send_sclk0_o;
    wire  [11:0] baudratedivisor_o;
	 spi_baud_generator dut(PCLK, PRESET_n,  spi_mode_i,  spiswai_i, sppr_i, spr_i, cpol_i, cpha_i, ss_i, 
											sclk_o, miso_receive_sclk_o, miso_receive_sclk0_o,  mosi_send_sclk_o, mosi_send_sclk0_o, baudratedivisor_o);     
	 initial
		begin 
		 PCLK =1'b0;
		 forever #10  PCLK =~PCLK;
		 end
	 task initialize;
		begin
			spiswai_i=1'b0;
			sppr_i=3'b000;
			spr_i=3'b000;
			cpol_i=1'b0;
			cpha_i=1'b0;
			ss_i=1'b1;
		end
	 endtask
	 task reset;
		begin
			@(negedge PCLK)
			PRESET_n = 1'b0;
			#20;
			@(negedge PCLK)
			PRESET_n =1'b1;
		end
	 endtask
	
	 task values;
		input i;
		input j;
			begin
				spi_mode_i = 2'b01;
				spiswai_i = 1'b0;
				sppr_i = 3'b000;
				spr_i = 3'b010;
				cpol_i = i;
				cpha_i = j;
				ss_i = 1'b0;
			end
	 endtask
	
	 initial
		begin
			initialize;
			reset;
			#10;
			//@(negedge PCLK)
			//values(1'b0, 1'b1);
			//#300;
			//values(1'b0, 1'b0);
			//#300;
			@(negedge PCLK)
			values(1'b1, 1'b1);
			#300;
			//values(1'b0, 1'b0);
			#1500 $finish;
		end
		
 endmodule
