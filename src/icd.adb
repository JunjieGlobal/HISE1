with HRM; use HRM;
with ImpulseGenerator;
with Measures;
with Network; use Network;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Assertions;
with Principal;

package body ICD is

   procedure Init(Icd : out ICDType) is
   begin
      --initial mode is off
      Icd.IsOn := False;
      --initial upper bound is 100
      Icd.Tachy := 100;
      --initial Joules
      Icd.Joules := 30;
      Icd.IsFirstTick :=True;
      Icd.rate1 := Measures.BPM(0);
      Icd.rate2 := Measures.BPM(0);
      Icd.rate3 := Measures.BPM(0);
      Icd.rate4 := Measures.BPM(0);
      Icd.rate5 := Measures.BPM(0);
      Icd.rateCurrent := Measures.BPM(0);

   end Init;

   

   

   procedure SetBound(Icd : in out ICDType; Bound:in Measures.BPM) is
      newBound : Measures.BPM;
   begin
      newBound := Measures.LimitBPM(Bound);
      Icd.Tachy := newBound;
   end SetBound;

   procedure SetJoules(Icd: in out ICDType; J:in Measures.Joules) is
      newJ : Measures.Joules;
   begin
      newJ := Measures.LimitJoules(J);
      Icd.Joules := newJ;
   end SetJoules;


   function GetHistory(Icd: in ICDType) return Network.RateHistory is
      RH : Network.RateHistory;
   begin
      RH(1) := Icd.Rate1;
      RH(2) := Icd.Rate2;
      RH(3) := Icd.Rate3;
      RH(4) := Icd.Rate4;
      RH(5) := Icd.Rate5;
      
      return RH;
   end GetHistory;


   function ProcessMessage(Msg: in out Network.NetworkMessage; Icd: in out ICDType)
                           return Network.NetworkMessage is
   begin
      case Msg.MessageType is
         when ModeOn =>
            On(Icd);
            return (MessageType => ModeOn,
                    MOnSource => Msg.MOnSource);

         when ModeOff =>
            Off(Icd);
            return (MessageType => ModeOff,
                    MOffSource => Msg.MOffSource);

         when ReadRateHistoryRequest =>
            return (MessageType => ReadRateHistoryResponse,
                    HDestination => Msg.HSource,
                    History => GetHistory(Icd));

         when ReadSettingsRequest =>
            return (MessageType => ReadSettingsResponse,
                    RDestination => Msg.RSource,
                    RTachyBound => Icd.Tachy,
                    RJoulesToDeliver => Icd.Joules);

         when ChangeSettingsRequest =>
            SetBound(Icd => Icd, Bound => Msg.CTachyBound);
            SetJoules(Icd => Icd, J => Msg.CJoulesToDeliver);
            return (MessageType => ChangeSettingsResponse,
                    CDestination => Msg.CSource);

         when others =>
            raise Ada.Assertions.Assertion_Error;
      end case;

   end ReceiveMessage;

   procedure Tick(Icd: in out ICDType; Hrm: in HRMType; Gen: out GeneratorType; Net: in out Network) is
   
      
      ComingMessage : Network.NetworkMessage;
      
      NewMessageAvailable : Boolean;
      
   
   
   begin
      
      Icd.totalTick := Icd.totalTick+1;
      
      -- at the beginning the response is unavailable
      Icd.ResponseAvailable = False;
      
      if Icd.IsFirstTick then
         Icd.rateCurrent := GetRate(Hrm);
         Icd.rate5 := Icd.rateCurrent;
         Icd.rate4 := Icd.rateCurrent;
         Icd.rate3 := Icd.rateCurrent;
         Icd.rate2 := Icd.rateCurrent;
         Icd.rate1 := Icd.rateCurrent;
         
         Icd.IsFirstTick = False;
      else
         
         Icd.rate1 := Icd.rate2;
         Icd.rate2 := Icd.rate3;
         Icd.rate3 := Icd.rate4;
         Icd.rate4 := Icd.rate5;
         Icd.rate5 := Icd.rateCurrent;
         Icd.rateCurrent := GetRate(Hrm);
         
           
      end if;
      
      Network.GetNewMessage(Network, NewMessageAvailable, ComingMessage);
      
      --handle the message 
      
      if NewMessageAvailable then 
         
         case ComingMessage.MessageType is
            
            when ReadRateHistoryRequest =>
               if Icd.IsOn = true and  then 
                 
               
               end if;
                 
            when ReadSettingsRequest =>
               
               if Icd.IsOn = False then 
                  Icd.ResponseAvailable := True;
                  Icd.ResponseMessage := ProcessMessage(Icd,ComingMessage);

               end if;
            
            
            when ChangeSettingsRequest =>
               if Icd.IsOn = False and then 
                  Icd.ResponseAvailable :=true;
                  Icd.ResponseMessage := ProcessMessage(Icd, ComingMessage);
            
            
         end case;
      end if;

   end Tick;


   procedure CheckMax(Gen: out ImpulseGenerator.GeneratorType) is
   begin
      Put("hi");
   end CheckMax;


   procedure CheckAvg(ICD: ICDType; Gen: out ImpulseGenerator.GeneratorType) is
   begin
      Put("hi");
   end CheckAvg;


   function CheckAuthority(Net: in out Network.Network) return Boolean is
   begin
      return True;
   end CheckAuthority;


end ICD;


