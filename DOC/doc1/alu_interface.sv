`include "defines.sv"
interface alu_interface( input bit      CLK,RST);
  logic [1:0]INP_VALID;
  logic [`M-1:0]CMD;
  logic CE,CIN,MODE;
  logic [`N-1:0]OPA,OPB;

  logic ERR,OFLOW,COUT,E,G,L;
  logic [`N:0] RES;

  clocking drv_cb @(posedge CLK);
    default input #0 output #0;
    output INP_VALID,CE,CIN,MODE,OPA,OPB,CMD,RST;
  endclocking

  clocking mon_cb @(posedge CLK);
    default input #0 output #0;
    input ERR,OFLOW,COUT,E,G,L,RES;
  endclocking

  clocking ref_cb @(posedge CLK);
    default input #0 output #0;
    input RST;
  endclocking

  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);
  modport REF(clocking ref_cb);

property ppt_reset;
    @(posedge CLK) RST |=> (RES === 9'bzzzzzzzz && ERR === 1'bz && E === 1'bz && G === 1'bz && L === 1'bz && COUT === 1'bz && OFLOW === 1'bz)
  endproperty
  assert property(ppt_reset)
    $display("RST assertion PASSED at time %0t", $time);
  else
    $info("RST assertion FAILED @ time %0t", $time);

 property ppt_timeout;
   @(posedge CLK) disable iff(RST)(CE && (INP_VALID == 2'b00 ||INP_VALID == 2'b01 ||  INP_VALID == 2'b10)) |-> !(INP_VALID == 2'b11) [*16] |-> ##1 ERR;
  endproperty
    assert property (ppt_timeout)  $info("passed");
    else $info("failed");

  property ppt_valid_inp_valid;
   @(posedge CLK) disable iff(RST) INP_VALID inside {2'b00, 2'b01, 2'b10, 2'b11};
  endproperty
  assert property(ppt_valid_inp_valid)
  else $info("Invalid INP_VALID value: %b at time %0t", INP_VALID, $time);


  property ppt_clock_enable;
     @(posedge CLK) disable iff(RST) !CE |-> ##1 ($stable(RES) && $stable(COUT) && $stable(OFLOW) && $stable(G) && $stable(L) && $stable(E) && $stable(ERR));
  endproperty
  assert property(ppt_clock_enable)
  else $info("Clock enable assertion failed at time %0t", $time);

endinterface


  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);
  modport REF(clocking ref_cb);

endinterface
