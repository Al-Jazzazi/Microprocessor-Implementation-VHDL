# VHDL Microprocessor Implementation on Basys 2 FPGA

This repository contains the implementation of a microprocessor in VHDL, designed to execute simple programs on a Basys 2 FPGA board. This project is part of the Advanced Digital Logic course (ENGR-UH 2310) at NYU Abu Dhabi.

## Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Components](#components)
4. [Implemented Programs](#implemented-programs)
   - [Program 1: Arithmetic Operations](#program-1-arithmetic-operations)
   - [Program 2: Sum of Squares](#program-2-sum-of-squares)
5. [Usage](#usage)
6. [Contributors](#contributors)
7. [Acknowledgements](#acknowledgements)

## Introduction

This project involves designing and implementing a microprocessor using VHDL, capable of executing binary-coded programs. The project demonstrates various digital logic concepts, including arithmetic operations, control flow, and FPGA deployment.

## Features

- 14-bit signed data handling
- 16 operations
- Eight data registers
- 128-entry instruction memory
- Execution on Basys 2 FPGA board

## Components

1. **Top-level module**: Connects all functional modules.
2. **Program Counter (PC)**: Tracks the address of the next instruction.
3. **Instruction Memory (ROM)**: Stores up to 128 instructions.
4. **Register File**: Contains 8 registers for 14-bit signed data.
5. **Decoder**: Extracts addresses and immediate values from instructions.
6. **Controller**: Generates control signals and delegates data signals.
7. **ALU**: Performs arithmetic and logical operations.
8. **Display Control Unit**: Manages the 7-segment displays on the FPGA board.

## Implemented Programs
The assembly code for the following programs can be found inside ./src/Instructions_ROM.vhd
### Program 1: Arithmetic Operations

This program demonstrates basic arithmetic operations and overflow handling.

- **Instructions**:
  - `ADDI R1, R0, -32`: Sets R1 to -32.
  - `ADDI R2, R0, -32`: Sets R2 to -32.
  - `ADD R3, R1, R2`: Adds R1 and R2, setting R3 to -64.
  - `ADD R3, R3, R3`: Doubles R3, setting it to -128.
  - Repeatedly doubles R3 to showcase arithmetic operations.
  - `SUBI R4, R3, -1`: Subtracts -1 from R3, testing overflow handling.

- **Explanation**:
  The program starts by setting initial values, then repeatedly doubles a register's value, showcasing the microprocessor's ability to handle arithmetic operations and register updates. The final subtraction instruction tests the overflow handling capability of the processor.

- **Video Demonstration**:
[Watch me](https://drive.google.com/file/d/1jkFzaudPVhIjc8UivboQ-itRqftXlUEm/view?usp=sharing)
### Program 2: Sum of Squares

This program calculates the sum of the squares from 1 to n using nested loops.

- **Objective**: Calculate the sum of the squares from 1 to n.
- **Instructions**:
  - Initialize registers for sum, counter, and square calculation.
  - Outer loop: Iterates from n down to 1.
  - Inner loop: Calculates the square of the current number by repeated addition.
  - Adds the calculated square to the sum.
  - Decrements the counter and repeats until the counter reaches 0.

- **Explanation**:
  The program uses nested loops to calculate the square of each number from n to 1 by repeated addition, then sums these squares. This demonstrates control flow using branch instructions and arithmetic operations.

## Usage

1. **Clone the Repository**:
   ```sh
   git clone https://github.com/yourusername/Microprocessor-Implementation-VHDL.git
   cd Microprocessor-Implementation-VHDL
   ```

2. **Compile the VHDL Code**:
   Use your preferred VHDL compiler to compile the VHDL files.

3. **Simulate the Processor**:
   Use a VHDL simulator to run the provided testbenches and observe the behavior of the microprocessor.

4. **Deploy to FPGA**:
   Load the compiled code onto the Basys 2 FPGA board and observe the processor executing instructions.

## Contributors

- Mohammad Amjad (maa9951@nyu.edu)
- Yousef Al-Jazzazi (ya2225@nyu.edu)

## Acknowledgements

This project is part of the Advanced Digital Logic course (ENGR-UH 2310) at New York University Abu Dhabi. Special thanks to Instructor Muhammad Hassan Jamil for guidancethroughout the project.

