# UART Controller with Parity Detection in Verilog

A parameterised Universal Asynchronous Receiver Transmitter (UART) implemented in Verilog HDL, supporting configurable parity modes, FIFO buffering, and oversampling-based reception. The design enables reliable asynchronous serial communication and includes comprehensive verification through self-checking testbenches.

## Features

- Parameterised UART transmitter and receiver modules
- Configurable even and odd parity generation/checking
- 16× oversampling for robust start-bit detection
- FSM-based TX and RX architectures
- Configurable stop-bit duration
- Separate transmit and receive FIFO buffers
- Programmable baud-rate generation using timer-based tick generation
- Self-checking loopback and parity-error verification testbenches

---

## Project Architecture

### Top-Level Block Diagram

<img width="3016" height="1172" alt="schematic" src="https://github.com/user-attachments/assets/35292cc2-2aad-4a71-978d-80e69f212ff6" />


## Module Description

### 1. UART Top Module (`uart.v`)

Integrates all UART components, including:

- Baud-rate generator
- UART transmitter
- UART receiver
- TX FIFO
- RX FIFO
- Parity handling circuitry

### 2. UART Transmitter (`uart_tx.v`)

Implements serial transmission using an FSM consisting of:

- Idle State
- Start Bit State
- Data Transmission State
- Parity State
- Stop Bit State

#### ASMD Chart

> **Include TX ASMD diagram here**

```markdown
![UART TX ASMD](docs/images/uart_tx_asmd.png)
```

---

### 3. UART Receiver (`uart_rx.v`)

Implements serial reception using 16× oversampling and FSM-based control:

- Idle State
- Start Bit Validation
- Data Reception
- Parity Checking
- Stop Bit Detection

#### ASMD Chart

> **Include RX ASMD diagram here**

```markdown
![UART RX ASMD](docs/images/uart_rx_asmd.png)
```

---

### 4. Baud Rate Generator (`timer_input.v`)

Generates sampling ticks used by the transmitter and receiver based on the programmed timer value.

### 5. Parity Generator (`parity_generator.v`)

Supports:

- Even parity
- Odd parity

### 6. Parity Checker (`parity_checker.v`)

Verifies received parity bits and asserts an error flag upon a mismatch.

---

## Verification

### Testbenches

The design was verified using the following testbenches:

### 1. Loopback Verification

Tests end-to-end transmission and reception through the complete UART system.

Checks:

- Successful data transmission
- Correct FIFO operation
- Proper TX/RX synchronisation

#### Simulation Waveform

<img width="740" height="306" alt="Screenshot 2026-06-24 131118" src="https://github.com/user-attachments/assets/b21225d1-ebd5-41b0-884a-aeeb13bfa8c3" />


### 2. Parity Error Detection Verification

Injects frames with incorrect parity bits to verify error detection functionality.

Checks:

- Correct parity generation
- Detection of parity mismatches
- Assertion of `parity_error`

#### Simulation Waveform

<img width="740" height="230" alt="Screenshot 2026-06-24 131929" src="https://github.com/user-attachments/assets/0f8ce74f-631d-4bdb-8662-b6acd04e4218" />


## Results

- Successful UART transmission and reception verified.
- Even and odd parity modes validated.
- Parity errors are correctly detected and flagged.
- FIFO buffering enabled reliable data transfer.
