# Bloco de Controle VHDL: Architecture and Functionality

This repository contains the VHDL code for a control block that coordinates logical, arithmetic, and sequential operations between two 8-bit vectors. The project was developed to provide an efficient implementation of basic operations with overflow detection and execution control.

## Features

- **Logical Operations**: AND, OR, XOR, and NOT.
- **Arithmetic Operations**: Addition and subtraction with overflow detection.
- **Sequential Operations**: Right shift.
- **Execution Control**: Operation enabling and completion signaling (`Done`).

## Project Structure

### BlocoControle Entity

The `BlocoControle` entity defines the following ports:

- **A**: 8-bit input (`STD_LOGIC_VECTOR`) representing the first operand.
- **B**: 8-bit input (`STD_LOGIC_VECTOR`) representing the second operand.
- **Opcode**: 3-bit input (`STD_LOGIC_VECTOR`) that determines the operation to be performed.
- **Clock**: Clock signal (`STD_LOGIC`) for synchronization.
- **Resetar_Carregar**: Reset/load signal (`STD_LOGIC`) to initialize the registers.
- **Y**: 8-bit output (`STD_LOGIC_VECTOR`) that contains the operation result.
- **Done**: 1-bit output (`STD_LOGIC`) that indicates the operation's completion.
- **Overflow**: 1-bit output (`STD_LOGIC`) that indicates overflow in the arithmetic operation.

### Internal Components

#### BlocoLogico

The `BlocoLogico` performs logical operations between the `A` and `B` vectors:

- **Ports**:
  - **A**: 8-bit input.
  - **B**: 8-bit input.
  - **Sel**: Selection signal (`STD_LOGIC_VECTOR`) to determine the logical operation.
  - **En**: Enable signal (`STD_LOGIC`).
  - **Y**: 8-bit output with the result of the logical operation.

#### BlocoAritmetico

The `BlocoAritmetico` performs addition and subtraction operations between the `A` and `B` vectors:

- **Ports**:
  - **A**: 8-bit input.
  - **B**: 8-bit input.
  - **Sel**: Selection signal (`STD_LOGIC`) to determine the operation (0 = addition, 1 = subtraction).
  - **En**: Enable signal (`STD_LOGIC`).
  - **Y**: 8-bit output with the result of the arithmetic operation.
  - **Overflow**: 1-bit output that indicates overflow.

#### BlocoSequencial

The `BlocoSequencial` performs right shift operations on the `A` vector:

- **Ports**:
  - **A**: 8-bit input.
  - **B**: 8-bit input (not directly used for the shift operation).
  - **En**: Enable signal (`STD_LOGIC`).
  - **Clock**: Clock signal (`STD_LOGIC`) for synchronization.
  - **Y**: 8-bit output with the result of the shift operation.
  - **Overflow**: 1-bit output that indicates overflow.

### Control Logic

The `Behavioral` architecture defines the internal logic to control the operations:

- **Internal Registers**:
  - `A_reg`, `B_reg`: Registers to store the operands.
  - `Y_logico`, `Y_aritmetico`, `Y_sequencial`: Registers to store the operation results.
  - `Overflow_aritmetico`, `Overflow_sequencial`: Overflow signals for arithmetic and sequential operations.
  - `Done_reg`: Operation completion signal.

- **Control Process**:
  1. On the clock cycle, if `Resetar_Carregar` is active, the operands are loaded into the registers.
  2. The `Opcode` determines which operation will be performed, enabling the corresponding block (`BlocoLogico`, `BlocoAritmetico`, or `BlocoSequencial`).
  3. The multiplexer selects the correct output (`Y_logico`, `Y_aritmetico`, or `Y_sequencial`) based on the `Opcode`.

### Multiplexer

The multiplexer is used to select the correct output (`Y`) based on the `Opcode`. It ensures that only the result of the selected operation is sent to the output `Y`.

### Example Operations

- **AND (Opcode = 000)**:
  - Enables `BlocoLogico` with AND selection.
  - Result stored in `Y_logico`.

- **Addition (Opcode = 100)**:
  - Enables `BlocoAritmetico` with addition selection.
  - Result stored in `Y_aritmetico`.

- **Right Shift (Opcode = 110)**:
  - Enables `BlocoSequencial` to perform the shift.
  - Result stored in `Y_sequencial`.

## How to Run

To run the control block, you will need a development environment compatible with VHDL, such as ModelSim or Quartus.

1. **Compile the Code**: Compile the provided VHDL code.
2. **Simulate the Design**: Use a testbench to simulate the behavior of the control block.
3. **Verify the Results**: Observe the `Y`, `Done`, and `Overflow` outputs to ensure that the operations are performed correctly.

## Testbench

A testbench is provided to test the control block. Make sure to add all relevant signals to the waveform (`wave`) to observe the simulation results.