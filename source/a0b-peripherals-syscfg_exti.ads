--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  Common definitions for STM32F2xx family [RM0033]
--
--  SYSCFG: System configuration controller
--
--  It is subset of SYSCFG to use by EXTI

pragma Ada_2022;

with A0B.STM32;
with A0B.Types;

package A0B.Peripherals.SYSCFG_EXTI
  with Preelaborate, No_Elaboration_Code_All
is

   SYSCFG_EXTICR_Offset : constant := 16#08#;

   -------------------
   -- SYSCFG_EXTICR --
   -------------------

   type SYSCFG_EXTICR_EXTI_Array is
     array (A0B.Types.Unsigned_2) of A0B.STM32.GPIO_Controller_Identifier
       with Pack, Size => 16;

   type SYSCFG_EXTICR_Register is record
      EXTI           : SYSCFG_EXTICR_EXTI_Array;
      Reserved_16_31 : A0B.Types.Reserved_16;
   end record with Size => 32, Volatile, Full_Access_Only;
   --  XXX FSF GCC 14: crash when `Atomic` aspect is specified, so use
   --  `Volatile` for now.

   for SYSCFG_EXTICR_Register use record
      EXTI           at 0 range 0 .. 15;
      Reserved_16_31 at 0 range 16 .. 31;
   end record;

   type SYSCFG_EXTICR_Array is
     array (A0B.Types.Unsigned_2) of aliased SYSCFG_EXTICR_Register
       with Size => 128;

   ------------
   -- SYSCFG --
   ------------

   type SYSCFG_Registers is record
      SYSCFG_EXTICR : SYSCFG_EXTICR_Array with Volatile;
   end record;

   for SYSCFG_Registers use record
      SYSCFG_EXTICR at SYSCFG_EXTICR_Offset range 0 .. 127;
   end record;

end A0B.Peripherals.SYSCFG_EXTI;
