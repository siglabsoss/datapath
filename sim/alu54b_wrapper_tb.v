module alu54b_wrapper_tb;

   reg clk,rst;
   reg [35:0] a,b;
   wire [54:0] c;
   reg 	      addsub;
   reg 	      ce;
   

   wire       clk_c;
   wire       ce_c;
   
   
   alu54b_wrapper alu54b_wrapper_inst
     (.clk(clk_c),
      .rst(rst),
      .a(a),
      .b(b),
      .ce(ce_c),
      .addsub(addsub),
      .c(c));

   always
     #4 clk = !clk;

   assign clk_c = clk;
   assign ce_c = ce;
   
   initial begin
      rst=1;
      clk=0;
      addsub=1;
      ce=1;
      repeat(10) @(posedge clk);
      rst=0;
      repeat(10) @(posedge clk);
      @(posedge clk);
      a=1;
      b=2;
      @(posedge clk);
      a=2;
      b=3;
      ce=0;
      @(posedge clk);
      ce=1;
      @(posedge clk);
      a='1;
      b='1;
      @(posedge clk);
      addsub=0;
      repeat(2) @(posedge clk);
      a=2;
      b=3;
      @(posedge clk);
      a='1;
      b=1;
      @(posedge clk);
      a=4;
      b='1;
      repeat(10) @(posedge clk);
      $finish;
   end
   
endmodule
