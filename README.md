# Asynchronous FIFO UVM Verification Project

## Project Overview

This project focuses on the design and verification of an asynchronous First-In-First-Out (FIFO) buffer using SystemVerilog for the design and the Universal Verification Methodology (UVM) for verification. Asynchronous FIFOs are crucial components in digital systems for reliably transferring data between modules operating in different clock domains.

The FIFO design implemented here is parameterized for adaptability, supporting configurable FIFO depth and pointer width. For this specific project implementation, the **data width is set to 8 bits**.

### Key Challenges Addressed:

*   **Clock Domain Crossing (CDC):** Ensuring reliable data transfer and synchronization between asynchronous clock domains (write clock `w_clk` and read clock `r_clk`).
*   **Full/Empty Conditions:** Accurately generating and testing `full` and `empty` flags to prevent data overwrite and underflow.
*   **Metastability Mitigation:** Verifying the Gray code pointer synchronization mechanism to minimize metastability risks.
*   **Edge Case Handling:** Thoroughly testing boundary conditions and scenarios like simultaneous read/write operations.
*   **Comprehensive Coverage:** Achieving high functional and code coverage using a robust UVM environment.

## FIFO Architecture

The design employs a modular architecture for clarity and reliability:

*   **FIFO Memory (`fifo_mem.v`):** The core storage element (RAM) with configurable depth and an 8-bit data width.
*   **Write Control (`fifo_wr.v`):** Manages write operations, generates binary write addresses, and creates the Gray-coded write pointer (`gray_w_ptr`). Implements the `full` flag logic.
*   **Read Control (`fifo_rd.v`):** Manages read operations, generates binary read addresses, and creates the Gray-coded read pointer (`gray_rd_ptr`). Implements the `empty` flag logic.
*   **Bit Synchronizers (`BIT_SYNC.v`):** Two instances of a multi-flop synchronizer module handle the safe transfer of Gray-coded pointers across clock domains (write-to-read `w2r_ptr` and read-to-write `r2w_ptr`).
*   **Gray Code Encoding:** Used for pointers crossing clock domains to ensure only single-bit transitions, preventing synchronization errors.
  
![FIFO Block diagram](https://github.com/user-attachments/assets/eb614540-87f2-4724-a4ee-f54200c54f1e)

### Key Features:

*   **Full/Empty Flags:** Provide status to prevent overflow and underflow.
*   **Configurability:** Parameterized depth and pointer width (Data width fixed at 8 bits for this project).
*   **Reliability:** Robust CDC handling using Gray code and multi-stage synchronizers.

## Verification Strategy

A comprehensive UVM-based strategy was employed, combining constrained-random stimulus, directed testing, and assertion-based verification.

### Verification Plan Highlights:

*   **Data Transfer Integrity:** Verifying correct data write/read across domains.
*   **Pointer Management:** Checking correct increment, wraparound, and Gray code conversion.
*   **Clock Domain Synchronization:** Validating the synchronizer logic.
*   **Flag Generation Logic:** Ensuring accurate `full` and `empty` flag assertion/deassertion.
*   **Reset Behavior:** Testing reset functionality in both clock domains.
*   **Edge Case Handling:** Covering scenarios like back-to-back operations and different clock ratios.

[Verification plan.xlsx](https://github.com/user-attachments/files/20407362/Verification.plan.xlsx)

## UVM Environment

A standard, layered UVM environment was developed, including:

*   **Interface (`interface.sv`):** Connects the testbench to the DUT.
*   **Sequence Item (`sequence_item.sv`):** Defines the transaction structure.
*   **Sequences (`sequence.sv`):** Generate specific test stimuli (reset, fill, empty, concurrent R/W, edge cases, etc.).
*   **Driver (`driver.sv`):** Drives transactions to the DUT interface.
*   **Monitor (`monitor.sv`):** Observes DUT interface activity and creates transactions.
*   **Agent (`agent.sv`):** Encapsulates driver, monitor, and sequencer.
*   **Environment (`environment.sv`):** Instantiates and connects all components, including scoreboard/checker and coverage collectors.
*   **Test (`test.sv`):** Configures the environment and selects sequences to run.
  
![Picture1](https://github.com/user-attachments/assets/29496447-4a8b-4e10-93c4-8eaf7d7b95de)

## Test Scenarios

A diverse range of scenarios were tested:

*   Basic Write/Read Operations
*   Full FIFO Handling (Write-to-Full)
*   Empty FIFO Handling (Read-from-Empty)
*   Reset Behavior (Write Domain, Read Domain)
*   Concurrent Read/Write Operations
*   Various Data Patterns
*   Clock Domain Crossing (different clock ratios)
*   Full-to-Empty and Empty-to-Full Transitions

## Assertions

A dedicated SystemVerilog Assertions (SVA) module (`fifo_assertions.sv`) was used for real-time property checking:

*   **Data Transfer:** Correct write/read operations.
*   **Pointer Increment:** Proper pointer updates & wraparound.
*   **Gray Code Conversion:** Correct binary-to-Gray logic.
*   **Pointer Synchronization:** Valid CDC sync (w2r & r2w).
*   **Flag Generation:** Accurate full/empty flag logic.
*   **Reset Behavior:** Correct initialization on reset.
*   **FIFO Operation Rules:** No writes when full, no reads when empty.

## Results & Coverage

*   **Functional Coverage:** 100% coverage achieved for all planned verification goals.
*   **Assertion Coverage:** All assertions passed across all test scenarios.
*   **UVM Report:** *(Placeholder - Add summary of key findings or link to report if available)*

![Picture2](https://github.com/user-attachments/assets/d6acb256-1b2f-41a9-a0ae-44e5fb5ed6b7)

![Picture3](https://github.com/user-attachments/assets/92f31fa8-844e-4ecc-864b-67013279ccb7)

![Picture5](https://github.com/user-attachments/assets/e081639b-bd8c-4357-b150-a53135b8f4e2)

