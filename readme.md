# Design and Verification of Async FIFO

## Project Overview
This project focuses on the **Design and Verification of an Asynchronous FIFO** (First In, First Out) buffer, implemented in Verilog. The FIFO design ensures reliable data transfer across asynchronous clock domains, utilizing Gray code pointers for smooth and safe synchronization. Verification is conducted with a UVM-based environment, which rigorously tests and validates the design through comprehensive functional and code coverage.

## Repository Structure
- **`src/`**: SystemVerilog source files, including modules for FIFO memory, read/write pointer control, and synchronizers.
- **`testbench/`**: UVM-based testbench files for thorough verification of FIFO functionality.
- **`scripts/`**: Scripts for setting up, compiling, and running simulations.
- **`docs/`**: Documentation, including design specifications and verification plans.
- **`sim/`**: Simulation outputs, such as transcripts and coverage reports.

## Project Goals
- **Asynchronous FIFO Design**: The FIFO buffer enables data transfer across clock domains with different frequencies.
- **Gray Code Pointers**: Gray code counters are used to manage pointer synchronization across clock domains, minimizing metastability.
- **UVM-Based Verification**: A structured UVM environment tests the design with various scenarios, including edge cases and random burst testing.

## Key Features
- **Cross-Domain Data Integrity**: Ensures secure data transfers between asynchronous sender and receiver clock domains.
- **State Flags (Full, Half-Full, and Empty)**: Integrated control flags manage FIFO states—indicating when the buffer is full, half-full, or empty. These flags support efficient data handling and prevent data overflow or underflow, making the FIFO adaptable for a range of applications.
- **Configurable Design**: Adjustable FIFO depth and data width for different application requirements.
- **Coverage-Driven Validation**: Functional and code coverage metrics ensure that all parts of the FIFO design are exercised.

## Design Specifications
The FIFO is configured with the following specifications:
- **FIFO Depth**: 256 data items
- **Data Width**: 8 bits
- **Write Clock Frequency**: 250 MHz
- **Read Clock Frequency**: 100 MHz
- **Maximum Write Burst Size**: 150 items
- **Idle Cycles**:
  - **Write Idle Cycles**: 0 cycles
  - **Read Idle Cycles**: 2 cycles between successive reads
- **Control Signals**: The FIFO includes full, half-full, and empty flags, supporting precise control and monitoring of data flow across asynchronous domains.

## Documentation
Refer to the `docs/` folder for:
- **Design Specifications**: Detailed descriptions of FIFO architecture, timing, signal descriptions, and logic for all FIFO operations.
- **Verification Plan**: Outlines the UVM testbench architecture, verification strategy, and coverage goals, ensuring thorough testing of the FIFO.
