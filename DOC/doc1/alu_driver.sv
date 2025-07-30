`include "defines.sv"

class alu_driver;
  alu_transaction t2;
  mailbox #(alu_transaction) m_gd;
  mailbox #(alu_transaction) m_dr;
  virtual alu_interface.DRV vif;
    bit got_valid;


  covergroup c;
    MODE_CP: coverpoint t2.MODE;
    INP_VALID_CP : coverpoint t2.INP_VALID;
    CMD_CP : coverpoint t2.CMD {
      bins valid_cmd[] = {[0:13]};
      ignore_bins invalid_cmd[] = {14, 15};
    }
    OPA_CP : coverpoint t2.OPA {
      bins all_zeros_a = {0};
      bins opa = {[0:`MAX]};
      bins all_ones_a = {`MAX};
    }
    OPB_CP : coverpoint t2.OPB {
      bins all_zeros_b = {0};
      bins opb = {[0:`MAX]};
      bins all_ones_b = {`MAX};
    }
    CIN_CP : coverpoint t2.CIN;
    CMD_X_IP_V: cross CMD_CP, INP_VALID_CP;
    MODE_X_INP_V: cross MODE_CP, INP_VALID_CP;
    MODE_X_CMD: cross MODE_CP, CMD_CP;
    OPA_X_OPB : cross OPA_CP, OPB_CP;
  endgroup



  function new(mailbox #(alu_transaction)mbx_gd,
               mailbox #(alu_transaction)mbx_dr,
               virtual alu_interface.DRV viff);
    m_gd=mbx_gd;
    m_dr=mbx_dr;
    vif=viff;
    c=new();
    t2=new();


  endfunction

  task start();
 begin
    repeat(1) @(vif.drv_cb);
    for(int i=0;i<`no_of_transactions;i++)
      begin
        m_gd.get(t2);
        if(vif.drv_cb.RST == 1)
         @(vif.drv_cb)begin
          vif.drv_cb.INP_VALID<=0;
          vif.drv_cb.CE<=0;
          vif.drv_cb.CIN<=0;
          vif.drv_cb.MODE<=0;
          vif.drv_cb.OPA<=0;
          vif.drv_cb.OPB<=0;
          vif.drv_cb.CMD<=0;
            m_dr.put(t2);
             repeat(1) @(vif.drv_cb)
           $display("DRIVER DRIVING VALUES TO INTERFACE AT TIME[%0t],INP_VALID =%b,CMD=%b,CE=%b,CIN=%b,MODE=%b,OPA=%d,OPB=%d",$time,vif.drv_cb.INP_VALID,vif.drv_cb.CMD,vif.drv_cb.CE,vif.drv_cb.CIN,vif.drv_cb.MODE,vif.drv_cb.OPA,vif.drv_cb.OPB);

          end
        else
          begin
          got_valid = 0;
          if (t2.INP_VALID != 2'b11) begin
          t2.CMD.rand_mode(0);
          t2.MODE.rand_mode(0);
          t2.CIN.rand_mode(0);
          t2.CE.rand_mode(0);
           t2.OPA.rand_mode(0);
           t2.OPB.rand_mode(0);
        for (int j = 0; j < 16; j++) begin
          t2.randomize();
        repeat(1) @(vif.drv_cb);
          vif.drv_cb.INP_VALID<=t2.INP_VALID;
          vif.drv_cb.CE<=t2.CE;
          vif.drv_cb.CIN<=t2.CIN;
          vif.drv_cb.MODE<=t2.MODE;
          vif.drv_cb.OPA<=t2.OPA;
          vif.drv_cb.OPB<=t2.OPB;
          vif.drv_cb.CMD<=t2.CMD;
              @(vif.drv_cb)
                $display("DRIVER DRIVING VALUES TO INTERFACE AND REFERANCE AT TIME=[%0t]-INP_VALID =%b,CMD=%b,CE=%b,CIN=%b,MODE=%b,OPA=%d,OPB=%d",$time,t2.INP_VALID,t2.CMD,t2.CE,t2.CIN,t2.MODE,t2.OPA,t2.OPB);
              m_dr.put(t2);
          if (t2.INP_VALID == 2'b11) begin
            got_valid = 1;
            t2.CMD.rand_mode(1);
            t2.MODE.rand_mode(1);
            t2.CIN.rand_mode(1);
            t2.CE.rand_mode(1);
          t2.OPA.rand_mode(1);
          t2.OPB.rand_mode(1);
            break;
          end
        end
      end
   // end

   else  if(t2.INP_VALID==2'b11 )begin
          repeat(1) @(vif.drv_cb);
          vif.drv_cb.INP_VALID<=t2.INP_VALID;
          vif.drv_cb.CE<=t2.CE;
          vif.drv_cb.CIN<=t2.CIN;
          vif.drv_cb.MODE<=t2.MODE;
          vif.drv_cb.OPA<=t2.OPA;
          vif.drv_cb.OPB<=t2.OPB;
          vif.drv_cb.CMD<=t2.CMD;
              repeat(1) @(vif.drv_cb)
                $display("DRIVER DRIVING VALUES TO INTERFACE AND REFERENCE AT TIME=[%0t]-INP_VALID =%b,CMD=%b,CE=%b,CIN=%b,MODE=%b,OPA=%d,OPB=%d",$time,t2.INP_VALID,t2.CMD,t2.CE,t2.CIN,t2.MODE,t2.OPA,t2.OPB);
              m_dr.put(t2);
              c.sample();
              $display("INPUT FUNCTIONAL COVERAGE =%.2f %%",c.get_coverage());

      end
end
end
end
  endtask
endclass
