class alu_test;
  virtual alu_interface m_viff;
  virtual alu_interface d_viff;
  virtual alu_interface r_viff;

  alu_environment env;

  function new( virtual alu_interface m_vif,virtual alu_interface d_vif,virtual alu_interface r_vif);

    m_viff=m_vif;
    d_viff=d_vif;
     r_viff=r_vif;
    endfunction

  task run();
    env=new(m_viff,d_viff,r_viff);
    env.build();
    env.start();
  endtask

endclass
