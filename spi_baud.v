module spi_baud_generator(
    input PCLK, PRESET_n,
    input [1:0] spi_mode_i,
    input spiswai_i,
    input [2:0] sppr_i, 
    input [2:0] spr_i,
    input cpol_i, 
    input cpha_i,
    input ss_i,
    output reg sclk_o,
    output reg miso_recieve_sclk_o,
    output reg miso_recieve_sclk0_o,
    output reg mosi_send_sclk_o,
    output reg mosi_send_sclk0_o,
    output [11:0] baudratedivisor_o
);
    wire pre_sclk_s;
    reg [11:0] count_s;

    // BaudRateDivisor calculation
    
       assign baudratedivisor_o = (sppr_i + 1) * (2 ** (spr_i + 1));

    // pre_sclk_s signal based on cpol_i
    assign pre_sclk_s = cpol_i ? 1'b1 : 1'b0;

    // SPI clock (sclk) generation
    always @(posedge PCLK or negedge PRESET_n)
    begin
        if (!PRESET_n)
        begin
            count_s <= 12'b0;
            sclk_o <= pre_sclk_s;
        end
        else if (!ss_i && !spiswai_i && (spi_mode_i == 2'b00 || spi_mode_i == 2'b01))
        begin
            if (count_s == (baudratedivisor_o / 2 - 1'b1))
            begin
                count_s <= 12'b0;
                sclk_o <= ~sclk_o;
            end
            else 
            begin
					 sclk_o <= sclk_o;
                count_s <= count_s + 1'b1;
            end
        end
        else
        begin
            sclk_o <= pre_sclk_s;
            count_s <= 12'b0;
        end
    end

    // Generate miso_receive_sclk0_o and miso_receive_sclk_o flags
    always @(posedge PCLK or negedge PRESET_n)
    begin
        if (!PRESET_n)
        begin
            miso_recieve_sclk0_o <= 1'b0;
            miso_recieve_sclk_o <= 1'b0;
        end
        else
        begin
            if ((!cpha_i && cpol_i) || (cpha_i && !cpol_i))  // Clock polarity and phase check
            begin
                if (sclk_o)
                begin
                    if (count_s == (baudratedivisor_o/2 - 1'b1))
                        miso_receive_sclk0_o <= 1'b1;
                    else
                        miso_receive_sclk0_o <= 1'b0;
                end
                else
                begin
                    miso_receive_sclk0_o <= 1'b0;
                end
            end
            else if ((!cpha_i && !cpol_i) || (cpha_i && cpol_i))
            begin
                if (!sclk_o)
                begin
                    if (count_s == (baudratedivisor_o / 2 - 1'b1))
                        miso_receive_sclk_o <= 1'b1;
                    else
                        miso_receive_sclk_o <= 1'b0;
                end
                else
                begin
                    miso_receive_sclk_o <= 1'b0;
                end
            end
        end
    end

    // Generate mosi_send_sclk0_o and mosi_send_sclk_o flags
    always @(posedge PCLK or negedge PRESET_n)
    begin
        if (!PRESET_n)
        begin
            mosi_send_sclk_o <= 1'b0;
            mosi_send_sclk0_o <= 1'b0;
        end
        else
        begin
            if ((!cpha_i && cpol_i) || (cpha_i && !cpol_i))  // Clock polarity and phase check
            begin
                if (sclk_o)
                begin
                    if (count_s == (baudratedivisor_o / 2 - 2'b10))
                        mosi_send_sclk0_o <= 1'b1;
                    else
                        mosi_send_sclk0_o <= 1'b0;
                end
                else
                begin
                    mosi_send_sclk0_o <= 1'b0;
                end
            end
            else if ((!cpha_i && !cpol_i) || (cpha_i && cpol_i))
            begin
                if (!sclk_o)
                begin
                    if (count_s == (baudratedivisor_o / 2 - 2'b10))
                        mosi_send_sclk_o <= 1'b1;
                    else
                        mosi_send_sclk_o <= 1'b0;
                end
                else
                begin
                    mosi_send_sclk_o <= 1'b0;
                end
            end
        end
    end

endmodule
[13/11, 21:35] Mahanda Kotyal: module spi_baud_generator_tb();
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
