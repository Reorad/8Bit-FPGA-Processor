# 8-Bit Microprocessor (PicoBlaze Architecture)

## Table of Contents

1.  [CHAPTER 1: Project Specifications](#1-chapter-1--project-specifications)
2.  [CHAPTER 2: Design](#2-chapter-2--design)
3.  [CHAPTER 3: User Manual](#3-chapter-3--user-manual)
4.  [CHAPTER 4: Design Solution Justification](#4-chapter-4--design-solution-justification)
5.  [CHAPTER 5: Further Development](#5-chapter-5--further-development)
6.  [How to Build and Run (Vivado)](#6-how-to-build-and-run-vivado)
7.  [Bibliography](#7-bibliography)

## 1. CHAPTER 1: Project Specifications

### Operating Procedure

- **Initial state**: Program starts at instruction 0. The default program running on the board computes the N-th Fibonacci number. A `0` will always be printed on the 7-segment display at startup.
- **Fetching phase**: The program awaits the Center button press for the user to continue to the next instruction.
- **Decoding phase**: The instruction decoder checks the 16-bit instruction and enables writing to the Register file, modifying flags, and deciding between working with a constant or a register.
- **Advance PC**: Depends on the instruction:
    - A `JUMP` will load the address of the next instruction into the PC.
    - `INPUT`/`OUTPUT` instructions don't modify the flags (Carry, Zero flags).
    - For most ALU operations, flags are updated, and the ALU modifies the specified Register.
- **Interrupt State**: If the user presses the Up BTN, it will trigger an interrupt for the next instruction. It holds the PC counter for 5 clock cycles without running the instruction twice. It will trigger LED 15 on the board, the 7-segment display will print `1A7`, and the PC will not advance.
- **Output phase**: Prints the last value requested on the 7-segment display, or `0` if none.

## 2. CHAPTER 2: Design

### 2.1 Black Box

![](scheme/Top%20Level.drawio.png)

### 2.2 Control and Execution Unit

![](scheme/ec%20uc%20v2.drawio.png)

The **Control Unit** is composed entirely of the **Instruction Decoder.**

The **Execution Unit** is composed of:
- **ALU (includes the Rotation Unit)**
- **Register File**
- **Input and Output components**
- **Interruptor Component**
- **ROM and Program Counter Register**
- **Flag Registers**
- **Constant Decider (A multiplexer)**

### 2.2.1 Mapping Control and Execution Unit

![](scheme/Mapped%20ports.drawio.png)

- **Data inputs**: Switches read during the `INPUT` instruction.
- **Control inputs**: Continue Button (Center), Interrupt Button (Up), Reset Button (Down).
- **Data outputs**: Result from the latest `OUTPUT` instruction displayed on the 7-segment display.
- **Control outputs**: `1A7` for Interrupt or `EEE` for entering Input.

### 2.2.2 Resources needed for Execution Unit

**TOP Level PicoBlaze:**

![](scheme/Top%20Level%20Pico%20Blazer.drawio%20.png)

1.  **SSD driver** -> It uses a 2kHz CLK divider and a 7-segment display to print data. It loops through the data to be printed and the anodes to be activated. Disabled anodes are used when interrupting. `Write_Strobe` will print `EEE` on the SSD.

![](scheme/SSD%20Driver.drawio.png)

2.  **BTN** -> 3 buttons used to generate impulses.

**Processor Complete Top Level:**

![](scheme/Procesor%20Complete.png)

1.  **Input** reads values from the switches continuously but only retains the needed value when the `INPUT` instruction is detected by the PC.
2.  **Output** sends data in BCD or outputs `EEE` and disables anodes to force printing `1A7` for an interrupt.

**Input Component:**

![](scheme/Input%20final.drawio.png)

An input instruction contains an IP Port. This port indicates what device to use. Considering 8-bit inputs and 16 switches: for IP ports between `0-127`, it uses the first 8 switches; otherwise, it uses the other 8 switches. It constantly detects the switch values but only writes to the Register file when `Write_Strobe` is `1`.

**Output Component:**

![](scheme/Output%20final.drawio.png)

The output component constantly reads the `Sx` register and converts the binary into 3 digits. This output is sent to a `Digit_Buffer` that only writes data when `Write_Strobe` is `1`. This ensures the printed data is always the latest output value. A `Read_Strobe` of `1` forces the output to `EEE` (indicating a number input is expected). The `Interrupt_Led` signal from the Interruptor disables anodes, forcing the output to `1A7`.

**Processor Top Level:**

![](scheme/Procesor%20top%20level.png)

Processor Top Level contains:
- PC Top Level -> holds PC register, ROM, Instruction Decoder.
- Interruptor
- ALU + Rotation Unit
- Flag Register
- Register File

**Interruptor Component:**

![](scheme/Interuptor%20top%20level.drawio%20.png)

The Interruptor triggers an interrupt only after finding an "Interrupt Enable" instruction. It sends `Interrupt_On` into the flag register, setting the Interrupt Flag to `1`. `Register_Latch` ensures it saves an Interrupt Button (Up btn) press, running on `CLK_Board` so you don't have to press Continue and Interrupt simultaneously. 

Once `Interrupt_Sw` is `1` and no interrupt is currently running, it sends the `Interrupt_Latch` signal into the PC hold. This sends `Hold_PC` to the Program Counter, stopping it from counting. It forces `Update_flags` to `0` and `Write_enable` to `0`—preventing ALU operations from saving into the register file or flag register. For 5 button presses, the interrupt persists, and it will only execute the instruction after the interrupt stops.

**ALU**

| ALU Selection | Operation | Flags Modified |
| :--- | :--- | :--- |
| `000` | Load | C - NO, Z - NO |
| `001` | AND | C - 0, Z - depends |
| `010` | OR | C - 0, Z - depends |
| `011` | XOR | C - 0, Z - depends |
| `100` | ADD | C - depends, Z - depends |
| `101` | ADDC | C - depends, Z - depends |
| `110` | SUB | C - depends, Z - depends |
| `111` | SUBC | C - depends, Z - depends |

**Rotation Unit**

**Rotation Code [3-0]**: Bit 3 decides if it's left or right.

| Rotation Code | Operation | Flags Modified |
| :--- | :--- | :--- |
| `000` | SLA/SRA sX | C - bit 0 or bit 7, Z - depends |
| `001` | --- | |
| `010` | SLX/SRX sX | C - bit 0 or bit 7, Z - depends |
| `011` | --- | |
| `100` | RL/RR sX | C - bit 0 or bit 7, Z - depends |
| `101` | --- | |
| `110` | SL0/SR0 sX | C - bit 0 or bit 7, Z - depends |
| `111` | SL1/SR1 sX | C - bit 0 or bit 7, Z - 0 |

Looking at the ALU and Rotation logic, we default most flags to `0`, check the result, and then set the required flags.

**Flag Register:**

![](scheme/Flag%20Register.png)

The Flag Register saves the last instance of Flags when modified and allowed by the Instruction Decoder. For example, `LOAD` doesn't modify flags, so `Update_flags` is set to `0`.

![](scheme/Register%20file.png)
**Register File:**

The Register File is a RAM with a clock. It always has memory access and writes in the next CLK cycle. It contains 16 registers, each of 8 bits. You can access each register via `Sx_Add` or `Sy_Add`.

**PC TOP Level:**

![](scheme/Program%20Counter%20.png)

The PC Register acts mainly as a counter, advancing `+1` to fetch the next instruction. If a `JUMP` signal arrives, the PC register loads the jump address. If `HOLD_PC` is active, it stops counting.

The **ROM** stores our Code and supports a maximum of 256 instructions.

The **Instruction Decoder** is the most complex component. It sets flags and routes data to the ALU for operations.
It is structured as follows:
- The first bit decides if we use a constant or register values.
- If the first bit is `0` -> The instruction uses a constant, and `ALU_Sel[2-0]` is determined by bits `[14-12]`.
- If the first bit is `1` -> It depends on the Operation Code `[3-0]` selected from the top 4 bits `[15-12]`.

| Operation Code | Description |
| :--- | :--- |
| `1100` | Works with ALU |
| `1101` | Works with Rotation Unit |
| `1010` | Input operation, PORT ID = KK |
| `1011` | Input operation, PORT ID = Sy |
| `1110` | Output operation, PORT ID = KK |
| `1111` | Output operation, PORT ID = Sy |

After checking the Operation Code, there are 3 more special flow control instructions: `JUMP`, `Interrupt Enable`, and `Interrupt Disable`. Jumps have the following structure:

`100 C[3-0] 01 Address_Jmp[7-0]`

If `C[3] = 0`, it's an unconditional jump (we ignore other conditions) and the `JUMP` signal is set to `1`. Otherwise:

| C[2-0] | Condition |
| :--- | :--- |
| `00` | If Zero |
| `01` | If NOT Zero |
| `10` | If Carry |
| `11` | If NOT Carry |

**Interrupt Instructions:**
- Enable Interrupt: `1000000000110000`
- Disable Interrupt: `1000000000010000`

### Instruction Set Encoding

| Instruction | Binary Encoding (Address[15-0]) | Flags Affected |
| :--- | :--- | :--- |
| `LOAD Sx, KK` | `0 000 Sx[3-0] Kk[7-0]` | Write_ram = 1, Update_Carry_zero = 0 |
| `LOAD Sx, Sy` | `1100 Sx[3-0] Sy[3-0] 0000` | Write_ram = 1, Update_Carry_zero = 0 |
| `AND Sx, KK` | `0 001 Sx[3-0] Kk[7-0]` | Write_ram = 1, Update_Carry_zero = 1 |
| `AND Sx, Sy` | `1100 Sx[3-0] Sy[3-0] 0001` | Write_ram = 1, Update_Carry_zero = 1 |
| `OR Sx, KK` | `0 010 Sx[3-0] Kk[7-0]` | Write_ram = 1, Update_Carry_zero = 1 |
| `OR Sx, Sy` | `1100 Sx[3-0] Sy[3-0] 0010` | Write_ram = 1, Update_Carry_zero = 1 |
| `XOR Sx, KK` | `0 011 Sx[3-0] Kk[7-0]` | Write_ram = 1, Update_Carry_zero = 1 |
| `XOR Sx, Sy` | `1100 Sx[3-0] Sy[3-0] 0011` | Write_ram = 1, Update_Carry_zero = 1 |
| `ADD Sx, KK` | `0 100 Sx[3-0] Kk[7-0]` | Write_ram = 1, Update_Carry_zero = 1 |
| `ADD Sx, Sy` | `1100 Sx[3-0] Sy[3-0] 0100` | Write_ram = 1, Update_Carry_zero = 1 |
| `ADDC Sx, KK` | `0 101 Sx[3-0] Kk[7-0]` | Write_ram = 1, Update_Carry_zero = 1 |
| `ADDC Sx, Sy` | `1100 Sx[3-0] Sy[3-0] 0101` | Write_ram = 1, Update_Carry_zero = 1 |
| `SUB Sx, KK` | `0 110 Sx[3-0] Kk[7-0]` | Write_ram = 1, Update_Carry_zero = 1 |
| `SUB Sx, Sy` | `1100 Sx[3-0] Sy[3-0] 0110` | Write_ram = 1, Update_Carry_zero = 1 |
| `SUBC Sx, KK` | `0 111 Sx[3-0] Kk[7-0]` | Write_ram = 1, Update_Carry_zero = 1 |
| `SUBC Sx, Sy` | `1100 Sx[3-0] Sy[3-0] 0111` | Write_ram = 1, Update_Carry_zero = 1 |
| `Shift Ops` | `1101 Sx[3-0] 0000 Rot_Code[3-0]` | Write_ram = 1, Update_Carry_zero = 1 |
| `INPUT Sx, KK` | `1010 Sx[3-0] KK[7-0]` | Write_ram = 1, Update_Carry_zero = 0 |
| `INPUT Sx, (Sy)` | `1011 Sx[3-0] Sy[3-0] xxxx` | Write_ram = 1, Update_Carry_zero = 0 |
| `OUTPUT Sx, KK` | `1110 Sx[3-0] KK[7-0]` | Write_ram = 0, Update_Carry_zero = 0 |
| `OUTPUT Sx, (Sy)`| `1111 Sx[3-0] Sy[3-0] xxxx` | Write_ram = 0, Update_Carry_zero = 0 |
| `JUMP` | `100 C[2-0] 01 Add_Jump[7-0]` | Write_ram = 0, Update_Carry_zero = 0 |
| `Enable Int` | `1000000000110000` | Write_ram = 0, Update_Carry_zero = 0, Int_Enable = 1 |
| `Disable Int` | `1000000000010000` | Write_ram = 0, Update_Carry_zero = 0, Int_Disable = 1 |

### 3. State diagram of Control Unit

![](scheme/State%20diagram.drawio.png)

## 3. CHAPTER 3: User Manual

The project will come loaded with a program written in ROM respecting the PicoBlaze encoding. You can use the Pico Assembler (16-bit instructions) [hasn't been tested yet, but should work]. Recommendation: write an ASM program, decode it manually, and write the binary representation:

![](./images/media/image15.png)

You will have to keep track of the instruction number and its function. Any mistake in encoding may result in unexpected output. It is recommended to write it down or track the instructions. You can use the LEDs on the board as well.

![](./images/media/image16.png)

The `Continue` button is pressed to advance the program. You could change the clock to a slower 1Hz clock, and it would still work. For the pre-loaded Fibonacci program, you must input the N-th Fibonacci number. (Max input is 11, which yields 233).

![](./images/media/image17.png)

When the display shows `EEE`, it means you've hit an `INPUT` instruction. Depending on the input port code, it will take the 8 left switches (for IP ports `127-255`) or the 8 right switches. After setting the desired value on the switches, the program will continue executing.

![](./images/media/image18.png)

For example, choosing to compute the 11th Fibonacci Number outputs 233. 
The program loops through all Fibonacci numbers, calculating them by the recurrence formula: 2, 3, ... 144, 233. After printing 233, it resets to `000` (due to `Output s8` which is 0). 
The Fibonacci sequence logic uses `s0, s1 -> 1`, `s2` as the sum (`s2 = s1 + s0`), and `s10` as a counter. The counter subtracts 1 and executes `JUMP NOT ZERO` back to the addition. When finished, it unconditionally jumps back to address `0`.

![](./images/media/image19.png)
![](./images/media/image20.png)

If the user presses the **Interrupt button**, the next instruction will trigger an interrupt for 5 button presses:

![](./images/media/image21.png)

The interrupted instruction will only execute after the interrupt completes.

This project currently supports a maximum of 256 instructions. Keep programs small and handle overflows accordingly. A basic understanding of VHDL and FPGA testing is recommended. The project also includes a simple program that adds 2 numbers given by the user and outputs the sum.

The **Reset button** resets the instruction pointer back to 0, stops any ongoing interrupt, and clears the Program Counter.

## 4. CHAPTER 4: Design Solution Justification

At the start of instruction decoding, `Write_enable` and `Update_carry_zero` flags are set to `1` since almost all instructions modify them (except flow control). The Decoder evaluates cases, checking the first bit:
- `0` -> Constant instruction. ALU operation is set at bits `[14-12]`.
- `1` -> Register instruction. Operation code is at bits `[3-0]` (e.g., `1100` means ALU operation).

Next, for shift instructions, a `Rotation` signal and `Rotation_code` are sent to the ALU/Rotation unit. For `INPUT`/`OUTPUT`, flags are disabled from being modified.

If it's a flow control instruction, `Update_carry_zero_flags` and `Write_enable` are set to `0`. The jump address takes the last bits `[7-0]`. Depending on the jump type (bit `12`), the `JUMP` flag is set. 

For interrupts, we allow them to happen anytime since the Interrupt flag is in a register. We use the Board Clock (5ns) in the Top Level Processor to instantly detect a button press without waiting for the Continue button. A latch holds the `Interrupt_impulse` until a Continue button is pressed, ensuring the interrupt is cleanly executed. Without using the fast board clock, the user would have to perfectly time pressing the Continue and Interrupt buttons simultaneously.

## 5. CHAPTER 5: Further Development

- Implementation of `CALL`, `JUMP`, `RETURN` instructions, and a Stack.
- Create UUT (Unit Under Test) testbenches for all sub-components.
- **UART Integration**: Configure a port to receive instructions from a PC (PicoAssembler output) and send data back to the PC terminal.

## 6. How to Build and Run (Vivado)

1. **Prerequisites**: Install Xilinx Vivado (WebPACK/ML Standard edition is sufficient). Ensure you have the Digilent board files installed if using a Basys 3 or similar FPGA board.
2. **Open the Project**: 
   - Launch Vivado.
   - Click **Open Project** and navigate to `A5_Procesor.xpr` in the root directory.
3. **Run Synthesis & Implementation**:
   - In the Flow Navigator (left panel), click **Run Synthesis**.
   - After synthesis completes, click **Run Implementation**.
4. **Generate Bitstream**:
   - Click **Generate Bitstream**. This will compile the `.bit` file needed for the FPGA.
5. **Program the FPGA**:
   - Connect your Basys 3 board via USB and power it on.
   - In Vivado, open the **Hardware Manager** -> **Open Target** -> **Auto Connect**.
   - Click **Program Device**, select the generated `.bit` file, and program the board.
6. **Simulation**:
   - To run tests without the physical board, click **Run Simulation** -> **Run Behavioral Simulation** in the Flow Navigator. The testbench `TEST_TOP_MODULE.vhd` is already set up to simulate the Top Level behavior.

## 7. Bibliography

- **XAPP213.PDF** -- Reference for implementation of the PicoBlaze Architecture.

Project developed by **Șandru Sebastian** and **Cătălin Oltean Marin**.

**GitHub Repository:** [Reorad/A5_Microprocessor](https://github.com/Reorad/A5_Microprocessor)
