--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  It is version for `light` runtime and `light-startup`

pragma Restrictions (No_Elaboration_Code);

package body A0B.STM32.Generic_GPIO.Generic_EXTI.Generic_Interrupts is

   procedure EXTI0_Handler
     with Export, Convention => C, External_Name => "EXTI0_Handler";
   procedure EXTI1_Handler
     with Export, Convention => C, External_Name => "EXTI1_Handler";
   procedure EXTI2_Handler
     with Export, Convention => C, External_Name => "EXTI2_Handler";
   procedure EXTI3_Handler
     with Export, Convention => C, External_Name => "EXTI3_Handler";
   procedure EXTI4_Handler
     with Export, Convention => C, External_Name => "EXTI4_Handler";
   procedure EXTI9_5_Handler
     with Export, Convention => C, External_Name => "EXTI9_5_Handler";
   procedure EXTI15_10_Handler
     with Export, Convention => C, External_Name => "EXTI15_10_Handler";
   --  EXTI* interrupt handlers

   -------------------
   -- EXTI0_Handler --
   -------------------

   procedure EXTI0_Handler is
   begin
      On_Interrupt (EXTI0_Mask);
   end EXTI0_Handler;

   -----------------------
   -- EXTI15_10_Handler --
   -----------------------

   procedure EXTI15_10_Handler is
   begin
      On_Interrupt (EXTI15_10_Mask);
   end EXTI15_10_Handler;

   -------------------
   -- EXTI1_Handler --
   -------------------

   procedure EXTI1_Handler is
   begin
      On_Interrupt (EXTI1_Mask);
   end EXTI1_Handler;

   -------------------
   -- EXTI2_Handler --
   -------------------

   procedure EXTI2_Handler is
   begin
      On_Interrupt (EXTI2_Mask);
   end EXTI2_Handler;

   -------------------
   -- EXTI3_Handler --
   -------------------

   procedure EXTI3_Handler is
   begin
      On_Interrupt (EXTI3_Mask);
   end EXTI3_Handler;

   -------------------
   -- EXTI4_Handler --
   -------------------

   procedure EXTI4_Handler is
   begin
      On_Interrupt (EXTI4_Mask);
   end EXTI4_Handler;

   ---------------------
   -- EXTI9_5_Handler --
   ---------------------

   procedure EXTI9_5_Handler is
   begin
      On_Interrupt (EXTI9_5_Mask);
   end EXTI9_5_Handler;

end A0B.STM32.Generic_GPIO.Generic_EXTI.Generic_Interrupts;
