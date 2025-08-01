`include "defines.sv"
class alu_monitor;
  alu_transaction t3;
  mailbox #(alu_transaction) m_ms;
  virtual alu_interface.MON vif;

  covergroup c2;
    ERR      : coverpoint t3.ERR {bins err[]={0,1};}
    COUT     : coverpoint t3.COUT {bins cout[]={0,1};}
    OFLOW    : coverpoint t3.OFLOW {bins oflow[]={0,1};}
    E        : coverpoint t3.E {bins e[]={0,1};}
    G        : coverpoint t3.G {bins g[]={0,1};}
    L        : coverpoint t3.L {bins l[]={0,1};}
    RES      : coverpoint t3.RES {bins res[]={[0:(1<<(`N+1))-1]};}

  endgroup


   function new( mailbox  #(alu_transaction) mbx_ms,virtual alu_interface.MON viff);
     m_ms=mbx_ms;
     vif=viff;
     c2=new();
     t3=new();
   endfunction

  task start();
    repeat(5) @(vif.mon_cb);
                $display($time);
         for(int i=0;i<`no_of_transactions;i++)
           begin
             repeat(2) @(vif.mon_cb);

           t3.ERR=vif.mon_cb.ERR;
           t3.COUT=vif.mon_cb.COUT;
           t3.OFLOW=vif.mon_cb.OFLOW;
           t3.E=vif.mon_cb.E;
           t3.G=vif.mon_cb.G;
           t3.L=vif.mon_cb.L;
           t3.RES=vif.mon_cb.RES;
         repeat(1)@(vif.mon_cb)
             $display(" MONITOR PASSING VALUES TO SCOREBOARD TIME=[%0t] ,ERR=%d,COUT=%d,OFLOW=%d,E=%d,G=%d,L=%d,RES=%d",$time,vif.mon_cb.ERR,vif.mon_cb.COUT,vif.mon_cb.OFLOW,vif.mon_cb.E,vif.mon_cb.G,vif.mon_cb.L,vif.mon_cb.RES);

       m_ms.put(t3);
       c2.sample();
             $display("OUTPUT FUNCTIONAL COVERAGE = %.2f %%",c2.get_coverage());
//    repeat(3) @(vif.mon_cb);
         end
     endtask
    endclass


   function new( mailbox  #(alu_transaction) mbx_ms,virtual alu_interface.MON viff);
     m_ms=mbx_ms;
     vif=viff;
     c2=new();
     t3=new();
   endfunction

  task start();
    repeat(5) @(vif.mon_cb);
                $display($time);
         for(int i=0;i<`no_of_transactions;i++)
           begin
             repeat(1) @(vif.mon_cb);

           t3.ERR=vif.mon_cb.ERR;
           t3.COUT=vif.mon_cb.COUT;
           t3.OFLOW=vif.mon_cb.OFLOW;
           t3.E=vif.mon_cb.E;
           t3.G=vif.mon_cb.G;
           t3.L=vif.mon_cb.L;
           t3.RES=vif.mon_cb.RES;

             $display(" MONITOR PASSING VALUES TO SCOREBOARD TIME=[%0t] ,ERR=%d,COUT=%d,OFLOW=%d,E=%d,G=%d,L=%d,RES=%d",$time,vif.mon_cb.ERR,vif.mon_cb.COUT,vif.mon_cb.OFLOW,vif.mon_cb.E,vif.mon_cb.G,vif.mon_cb.L,vif.mon_cb.RES);

       m_ms.put(t3);
       c2.sample();
             $display("OUTPUT FUNCTIONAL COVERAGE = %.2f %%",c2.get_coverage());
    //repeat(3) @(vif.mon_cb);
         end
     endtask
    endclass
