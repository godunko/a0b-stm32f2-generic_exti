--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  Common definitions for STM32F2xx family [RM0033]
--
--  EXTI: External interrupt/event controller
--
--  It is generalized version to reuse by other MCUs.

pragma Ada_2022;

package A0B.Peripherals.EXTI
  with Preelaborate, No_Elaboration_Code_All
is

   EXTI_IMR_Offset  : constant := 16#00#;
   EXTI_RTSR_Offset : constant := 16#08#;
   EXTI_FTSR_Offset : constant := 16#0C#;
   EXTI_PR_Offset   : constant := 16#14#;

   type EXTI_Line_Identifier is range 0 .. 31;

   ---------------
   -- EXTI_FTSR --
   ---------------

   type EXTI_FTSR_TR_Array is array (EXTI_Line_Identifier) of Boolean
     with Pack, Size => 32;

   type EXTI_FTSR_Register is record
      TR : EXTI_FTSR_TR_Array;
   end record with Size => 32;

   --------------
   -- EXTI_IMR --
   --------------

   type EXTI_IMR_MR_Array is array (EXTI_Line_Identifier) of Boolean
     with Pack, Size => 32;

   type EXTI_IMR_Register is record
      MR : EXTI_IMR_MR_Array;
   end record with Size => 32;

   -------------
   -- EXTI_PR --
   -------------

   type EXTI_PR_PR_Array is array (EXTI_Line_Identifier) of Boolean
     with Pack, Size => 32;

   type EXTI_PR_Register is record
      PR : EXTI_PR_PR_Array;
   end record with Size => 32;

   ---------------
   -- EXTI_RTSR --
   ---------------

   type EXTI_RTSR_TR_Array is array (EXTI_Line_Identifier) of Boolean
     with Pack, Size => 32;

   type EXTI_RTSR_Register is record
      TR : EXTI_RTSR_TR_Array;
   end record with Size => 32;

   ----------
   -- EXTI --
   ----------

   type EXTI_Registers is record
      EXTI_IMR  : EXTI_IMR_Register  with Volatile, Full_Access_Only;
      EXTI_RTSR : EXTI_RTSR_Register with Volatile, Full_Access_Only;
      EXTI_FTSR : EXTI_FTSR_Register with Volatile, Full_Access_Only;
      EXTI_PR   : EXTI_PR_Register   with Volatile, Full_Access_Only;
   end record;

   for EXTI_Registers use record
      EXTI_IMR  at EXTI_IMR_Offset  range 0 .. 31;
      EXTI_RTSR at EXTI_RTSR_Offset range 0 .. 31;
      EXTI_FTSR at EXTI_FTSR_Offset range 0 .. 31;
      EXTI_PR   at EXTI_PR_Offset   range 0 .. 31;
   end record;

end A0B.Peripherals.EXTI;
