--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

with Ada.Unchecked_Conversion;

with A0B.Types.GCC_Builtins;

package body A0B.STM32.Generic_GPIO.Generic_EXTI is

   subtype EXTI_Line_Identifier is
     A0B.Peripherals.EXTI.EXTI_Line_Identifier;

   type GPIO_Line_Access is access all GPIO_Line'Class;

   type EXTI_Descriptor is limited record
      Line     : GPIO_Line_Access;
      Callback : A0B.Callbacks.Callback;
   end record;

   Empty          : constant A0B.Peripherals.EXTI.EXTI_IMR_MR_Array :=
     (others => False);

   EXTI_Line : array (EXTI_Line_Identifier) of aliased EXTI_Descriptor;

   -----------------------
   -- Disable_Interrupt --
   -----------------------

   overriding procedure Disable_Interrupt (Self : in out GPIO_EXTI_Line) is
      pragma Suppress (Range_Check);

      use type A0B.Peripherals.EXTI.EXTI_IMR_MR_Array;

      Old_IMR : constant A0B.Peripherals.EXTI.EXTI_IMR_MR_Array :=
        EXTI.EXTI_IMR.MR;
      Mask    : A0B.Peripherals.EXTI.EXTI_PR_PR_Array := (others => False);
      New_IMR : A0B.Peripherals.EXTI.EXTI_IMR_MR_Array;

   begin
      Mask (EXTI_Line_Identifier (Self.Identifier)) := True;
      New_IMR :=
        Old_IMR and not A0B.Peripherals.EXTI.EXTI_IMR_MR_Array (Mask);

      --  Disable external interrupt

      EXTI.EXTI_IMR.MR := New_IMR;

      --  Disable NVIC interrupt

      if (Old_IMR and EXTI0_Mask) /= Empty
        and (New_IMR and EXTI0_Mask) = Empty
      then
         Disable_Interrupt (EXTI0);
      end if;

      if (Old_IMR and EXTI1_Mask) /= Empty
        and (New_IMR and EXTI1_Mask) = Empty
      then
         Disable_Interrupt (EXTI1);
      end if;

      if (Old_IMR and EXTI2_Mask) /= Empty
        and (New_IMR and EXTI2_Mask) = Empty
      then
         Disable_Interrupt (EXTI2);
      end if;

      if (Old_IMR and EXTI3_Mask) /= Empty
        and (New_IMR and EXTI3_Mask) = Empty
      then
         Disable_Interrupt (EXTI3);
      end if;

      if (Old_IMR and EXTI4_Mask) /= Empty
        and (New_IMR and EXTI4_Mask) = Empty
      then
         Disable_Interrupt (EXTI4);
      end if;

      if (Old_IMR and EXTI9_5_Mask) /= Empty
        and (New_IMR and EXTI9_5_Mask) = Empty
      then
         Disable_Interrupt (EXTI9_5);
      end if;

      if (Old_IMR and EXTI15_10_Mask) /= Empty
        and (New_IMR and EXTI15_10_Mask) = Empty
      then
         Disable_Interrupt (EXTI15_10);
      end if;
   end Disable_Interrupt;

   ----------------------
   -- Enable_Interrupt --
   ----------------------

   overriding procedure Enable_Interrupt (Self : in out GPIO_EXTI_Line) is
      pragma Suppress (Range_Check);

      use type A0B.Peripherals.EXTI.EXTI_IMR_MR_Array;

      Old_IMR : constant A0B.Peripherals.EXTI.EXTI_IMR_MR_Array :=
        EXTI.EXTI_IMR.MR;
      Mask    : A0B.Peripherals.EXTI.EXTI_PR_PR_Array := (others => False);
      New_IMR : A0B.Peripherals.EXTI.EXTI_IMR_MR_Array;

   begin
      Mask (EXTI_Line_Identifier (Self.Identifier)) := True;
      New_IMR := Old_IMR or A0B.Peripherals.EXTI.EXTI_IMR_MR_Array (Mask);

      --  Clear pending status and enable external interrupt

      EXTI.EXTI_PR.PR  := Mask;
      EXTI.EXTI_IMR.MR := New_IMR;

      --  Enable NVIC interrupt

      if (Old_IMR and EXTI0_Mask) = Empty
        and (New_IMR and EXTI0_Mask) /= Empty
      then
         Clear_Pending_Enable_Interrupt (EXTI0);
      end if;

      if (Old_IMR and EXTI1_Mask) = Empty
        and (New_IMR and EXTI1_Mask) /= Empty
      then
         Clear_Pending_Enable_Interrupt (EXTI1);
      end if;

      if (Old_IMR and EXTI2_Mask) = Empty
        and (New_IMR and EXTI2_Mask) /= Empty
      then
         Clear_Pending_Enable_Interrupt (EXTI2);
      end if;

      if (Old_IMR and EXTI3_Mask) = Empty
        and (New_IMR and EXTI3_Mask) /= Empty
      then
         Clear_Pending_Enable_Interrupt (EXTI3);
      end if;

      if (Old_IMR and EXTI4_Mask) = Empty
        and (New_IMR and EXTI4_Mask) /= Empty
      then
         Clear_Pending_Enable_Interrupt (EXTI4);
      end if;

      if (Old_IMR and EXTI9_5_Mask) = Empty
        and (New_IMR and EXTI9_5_Mask) /= Empty
      then
         Clear_Pending_Enable_Interrupt (EXTI9_5);
      end if;

      if (Old_IMR and EXTI15_10_Mask) = Empty
        and (New_IMR and EXTI15_10_Mask) /= Empty
      then
         Clear_Pending_Enable_Interrupt (EXTI15_10);
      end if;
   end Enable_Interrupt;

   -----------------------------------
   -- Initialize_External_Interrupt --
   -----------------------------------

   procedure Initialize_External_Interrupt
     (Self : aliased in out GPIO_EXTI_Line'Class;
      Mode : A0B.STM32.EXTI_Mode;
      Pull : A0B.STM32.GPIO_Pull_Mode := A0B.STM32.No)
   is
      pragma Suppress (Range_Check);
      pragma Suppress (Overflow_Check);

   begin
      pragma Assert
        (EXTI_Line (EXTI_Line_Identifier (Self.Identifier)).Line = null);
      EXTI_Line (EXTI_Line_Identifier (Self.Identifier)).Line :=
        Self'Unchecked_Access;
      --  Link EXTI line with GPIO line

      Self.Initialize_Input (Pull);
      --  Configure IO line in input mode, it is required for EXTI, enable
      --  pull-up/pull-down when requested.

      Enable_EXTI_Clock;
      --  Enable clock of the SYSCFG controller.

      --  Select GPIO controller to be used to generate external interrupt.

      declare
         R : constant A0B.Types.Unsigned_2 :=
           A0B.Types.Unsigned_2 (Self.Identifier / 4);
         F : constant A0B.Types.Unsigned_2 :=
           A0B.Types.Unsigned_2 (Self.Identifier mod 4);

      begin
         SYSCFG.SYSCFG_EXTICR (R).EXTI (F) := Self.Controller.Identifier;
      end;

      --  Select which edge(s) generates interrupt.

      case Mode is
         when Both_Edge =>
            EXTI.EXTI_RTSR.TR (EXTI_Line_Identifier (Self.Identifier)) := True;
            EXTI.EXTI_FTSR.TR (EXTI_Line_Identifier (Self.Identifier)) := True;

         when Rising_Edge =>
            EXTI.EXTI_RTSR.TR (EXTI_Line_Identifier (Self.Identifier)) := True;
            EXTI.EXTI_FTSR.TR (EXTI_Line_Identifier (Self.Identifier)) := False;

         when Falling_Edge =>
            EXTI.EXTI_RTSR.TR (EXTI_Line_Identifier (Self.Identifier)) := False;
            EXTI.EXTI_FTSR.TR (EXTI_Line_Identifier (Self.Identifier)) := True;
      end case;
   end Initialize_External_Interrupt;

   ------------------
   -- On_Interrupt --
   ------------------

   procedure On_Interrupt (Mask : A0B.Peripherals.EXTI.EXTI_IMR_MR_Array) is
      use type A0B.Peripherals.EXTI.EXTI_IMR_MR_Array;
      use type A0B.Types.Unsigned_32;

      function As_Unsigned_32 is
        new Ada.Unchecked_Conversion
              (A0B.Peripherals.EXTI.EXTI_IMR_MR_Array, A0B.Types.Unsigned_32);

      Status : A0B.Peripherals.EXTI.EXTI_IMR_MR_Array :=
        A0B.Peripherals.EXTI.EXTI_IMR_MR_Array (EXTI.EXTI_PR.PR) and Mask;
      Line   : A0B.Peripherals.EXTI.EXTI_Line_Identifier;
      Clean  : A0B.Peripherals.EXTI.EXTI_PR_PR_Array := (others => False);

   begin
      while Status /= Empty loop
         Line          :=
           A0B.Peripherals.EXTI.EXTI_Line_Identifier
             (A0B.Types.GCC_Builtins.ctz (As_Unsigned_32 (Status)));
         Status (Line) := False;
         Clean (Line)  := True;

         EXTI.EXTI_PR.PR := Clean;
         --  Clear interrupt pending bit, it should be done by software.

         A0B.Callbacks.Emit (EXTI_Line (EXTI_Line_Identifier (Line)).Callback);
      end loop;
   end On_Interrupt;

   ------------------
   -- Set_Callback --
   ------------------

   overriding procedure Set_Callback
     (Self     : in out GPIO_EXTI_Line;
      Callback : A0B.Callbacks.Callback)
   is
      pragma Suppress (Range_Check);

   begin
      pragma Assert
        (EXTI_Line (EXTI_Line_Identifier (Self.Identifier)).Line
           = Self'Unchecked_Access);

      EXTI_Line (EXTI_Line_Identifier (Self.Identifier)).Callback := Callback;
   end Set_Callback;

end A0B.STM32.Generic_GPIO.Generic_EXTI;
