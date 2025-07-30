 `include "design.sv"
`include "alu_package.sv"
`include "alu_interface.sv"
module top();
  import alu_pkg::*;
  bit CLK,RST,CE;
  parameter int N = 8;
  parameter int M = 4;
  alu_interface intf(CLK,RST);

    alu_test dut=new(intf.MON,intf.DRV,intf.REF);

  initial
    begin
      CLK = 0;
      forever #5 CLK=~CLK;
    end

  initial begin
    @(posedge CLK)
    CE = 1'b1;
    RST=1;
    repeat(3) @(posedge CLK)
      RST=0;

      end


    //dut instaintaion
  ALU_DESIGN  #(  .DW(N) , .CW(M) ) dut1(.INP_VALID(intf.INP_VALID),.OPA(intf.OPA),.OPB(intf.OPB),.CIN(intf.CIN),.CLK(intf.CLK),.RST(intf.RST),.CMD(intf.CMD),.CE(intf.CE),.MODE(intf.MODE),.COUT(intf.COUT),.OFLOW(intf.OFLOW),.RES(intf.RES),.G(intf.G),.E(intf.E),.L(intf.L),.ERR(intf.ERR));

    initial begin
    dut.run();
#250     $finish;
    end

endmodule
