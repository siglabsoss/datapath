module muladdsub_tb;

   reg clk,rst;
   reg [35:0] a0,b0,a1,b1;
   reg 	      addsub;
   reg 	      ce0,ce1,ce2;

   wire       clk_c;
   wire       ce0_c,ce1_c,ce2_c;

   muladdsub muladdsub_inst
     (.CLK0(clk_c),
      .CE0(ce0_c),
      .CE1(ce1_c),
      .CE2(ce2_c),
      .RST0(rst),
      .ADDNSUB(addsub),
      .A0(a0),
      .A1(a1),
      .B0(b0),
      .B1(b1),
      .SUM()
      );

   always
     #4 clk = !clk;

   assign clk_c = clk;

   assign ce0_c = ce0;
   assign ce1_c = ce1;
   assign ce2_c = ce2;
   
   initial begin
      rst=1;
      clk=0;
      addsub=1;
      ce0=0;
      ce1=0;
      ce2=0;
      
      repeat(10) @(negedge clk);
      rst=0;
      a0=2;
      a1=3;
      b0=3;
      b1=3;
      @(negedge clk);
      ce0=1;
      @(negedge clk);
      a0=0;
      a1=0;
      b0=0;
      b1=0;
      ce0=0;
      @(negedge clk);
      ce1=1;
      repeat(1) @(negedge clk);
      ce1=0;
      @(negedge clk);
      ce2=1;
      @(negedge clk);
      ce2=0;
      repeat(100) begin
	 @(negedge clk);
	 ce0=1;
	 ce1=1;
	 ce2=1;
	 a0=a0+1;
	 a1=a1+1;
	 b0=a0+1;
	 b1=a1+1;
      end
      
      repeat(10) @(negedge clk);
      $finish;
   end // initial begin
endmodule
      
