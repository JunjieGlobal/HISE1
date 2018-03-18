with HRM;
with ImpulseGenerator;
with Network;
with Measures;

package ICD is

   type ICDType is

      record
         -- status of current mode
         IsOn : Boolean;

         Tachy : Measures.BPM;

         Joules : Measures.Joules;
         
         -- judge whether there are 5 tick before now
         IsFirstTick: Boolean;
         
         HeartbeatMax: Measures.BPM;
         
         HeartbeatAvg: Measures.BPM;
         
         totalTick : Natural;
         
         -- 5 tick before current tick
         rate1 : Measures.BPM;
         -- 4 tick before current tick
         rate2 : Measures.BPM;
         -- 3 tick before current tick
         rate3 : Measures.BPM;
         -- 2 tick before current tick
         rate4 : Measures.BPM;
         -- 1 tick before current tick
         rate5 : Measures.BPM;
         -- current tick
         rateCurrent : Measures.BPM;
         
         ResponseAvailable : Boolean;
         
         ResponseMessage : Network.NetworkMessage;


      end record;

   procedure Init(ICD : out ICDType);

   

   function IsOn(ICD : in ICDType) return Boolean;

   procedure SetBound(ICD : in out ICDType; Bound:in Measures.BPM);

   procedure SetJoules(ICD: in out ICDType; J:in Measures.Joules);

   function GetHistory(ICD: in ICDType) return Network.RateHistory;

   procedure ReceiveMessage(Net: in out Network.Network);

   procedure Tick(Icd : in out ICD.ICDType; Network : in out Network.Network;
                 Hrm : in HRM.HRMType; Gen : ImpulseGenerator.GeneratorType);

   procedure CheckMax(Gen: out ImpulseGenerator.GeneratorType);

   procedure CheckAvg(ICD: ICDType; Gen: out ImpulseGenerator.GeneratorType);

   function CheckAuthority(Net: in out Network.Network) return Boolean;


end ICD;
