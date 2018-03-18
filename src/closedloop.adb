with Network;
with ICD;
with HRM;
with Heart;
with ImpulseGenerator;
with Measures;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;


package body ClosedLoop is
   
   -- initialize the instance of relevant package
   Hrt : Heart.HeartType;
   Ipg : ImpulseGenerator.GeneratorType;
   HrM : HRM.HRMType;
   Ntw : Network.Network;
   Icd : ICD.Icd;
   
   
   
   procedure Init is
   begin
      Heart.Init(Hrt);
      ImpulseGenerator.Init(Ipg);
      Network.Init(Ntw);
      HRM.Init(HrM);
      ICD.Init(Icd);
   end Init;
   
   procedure Tick is
   begin
      
         -- tick all the components in the system
         ICD.Tick(Icd,Hrt,Ipg,HrM);
         Network.Tick(Ntw);
         ImpulseGenerator.Tick(Ntw, Hrt);
         Heart.Tick(Hrt);
         HRM.Tick(HrM,Hrt);
      
      
      
    
   end Tick;
   

   
end closedloop;
