`include "defines.sv"

class alu_transaction;
  rand bit [1:0]INP_VALID;
  rand bit [`M-1:0]CMD;
  rand bit CE,CIN,MODE;
  rand bit [`N-1:0]OPA,OPB;

  bit ERR,OFLOW,COUT,E,G,L;
  bit [`N:0] RES;

  constraint c1{ if(MODE==1) CMD inside {[0:10]};
                else CMD inside {[0:10]};
               }
  constraint c2{
                CE==1;
               }

  virtual function alu_transaction copy();
  copy = new();
  copy.INP_VALID=this.INP_VALID;
  copy.CMD=this.CMD;
  copy.CE=this.CE;
  copy.CIN=this.CIN;
  copy.MODE=this.MODE;
  copy.OPA=this.OPA;
  copy.OPB=this.OPB;
  return copy;
  endfunction

endclass
