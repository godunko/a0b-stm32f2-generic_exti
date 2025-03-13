--
--  Copyright (C) 2025, Vadim Godunko <vgodunko@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
--

--  EXTI controller driver for STM32F2. It supports some later MCU too.

pragma Restrictions (No_Elaboration_Code);

with A0B.Callbacks;
with A0B.EXTI;
with A0B.Peripherals.EXTI;
with A0B.Peripherals.SYSCFG_EXTI;

generic
   type Interrupt_Number is range <>;
   --  NVIC's external interrupt number.

   with procedure Clear_Pending_Enable_Interrupt (Interrupt : Interrupt_Number);
   --  Clear pending status and enable given interrupt

   with procedure Disable_Interrupt (Interrupt : Interrupt_Number);
   --  Disable given interrupt

   with procedure Enable_EXTI_Clock;
   --  Enable clock of EXTI peripheral. On may MCU it enables clock of the
   --  SYSCFG's peripheral.

   with procedure Disable_EXTI_Clock;
   --  Disable clock of EXTI peripheral. On may MCU it disables clock of the
   --  SYSCFG's peripheral.

   EXTI      : in out A0B.Peripherals.EXTI.EXTI_Registers;
   SYSCFG    : in out A0B.Peripherals.SYSCFG_EXTI.SYSCFG_Registers;
   --  Registers of the EXTI and SYSSFG peripherals

   EXTI0     : Interrupt_Number;
   EXTI1     : Interrupt_Number;
   EXTI2     : Interrupt_Number;
   EXTI3     : Interrupt_Number;
   EXTI4     : Interrupt_Number;
   EXTI9_5   : Interrupt_Number;
   EXTI15_10 : Interrupt_Number;
   --  Interrupt numbers

package A0B.STM32.Generic_GPIO.Generic_EXTI
  with Preelaborate
is

   type GPIO_EXTI_Line is
     new A0B.STM32.Generic_GPIO.GPIO_Line
       and A0B.EXTI.External_Interrupt_Line with null record
         with Preelaborable_Initialization;

   procedure Initialize_External_Interrupt
     (Self : aliased in out GPIO_EXTI_Line'Class;
      Mode : A0B.STM32.EXTI_Mode;
      Pull : A0B.STM32.GPIO_Pull_Mode := A0B.STM32.No);

   overriding procedure Enable_Interrupt (Self : in out GPIO_EXTI_Line);

   overriding procedure Disable_Interrupt (Self : in out GPIO_EXTI_Line);

   overriding procedure Set_Callback
     (Self     : in out GPIO_EXTI_Line;
      Callback : A0B.Callbacks.Callback);

private

   EXTI0_Mask     : constant A0B.Peripherals.EXTI.EXTI_IMR_MR_Array :=
     (0 => True, others => False);
   EXTI1_Mask     : constant A0B.Peripherals.EXTI.EXTI_IMR_MR_Array :=
     (1 => True, others => False);
   EXTI2_Mask     : constant A0B.Peripherals.EXTI.EXTI_IMR_MR_Array :=
     (2 => True, others => False);
   EXTI3_Mask     : constant A0B.Peripherals.EXTI.EXTI_IMR_MR_Array :=
     (3 => True, others => False);
   EXTI4_Mask     : constant A0B.Peripherals.EXTI.EXTI_IMR_MR_Array :=
     (4 => True, others => False);
   EXTI9_5_Mask   : constant A0B.Peripherals.EXTI.EXTI_IMR_MR_Array :=
     (5 .. 9 => True, others => False);
   EXTI15_10_Mask : constant A0B.Peripherals.EXTI.EXTI_IMR_MR_Array :=
     (10 .. 15 => True, others => False);

   procedure On_Interrupt (Mask : A0B.Peripherals.EXTI.EXTI_IMR_MR_Array);

end A0B.STM32.Generic_GPIO.Generic_EXTI;
