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

> **Include overall UART architecture schematic here**

Insert:

```text
images/schematic.jpg
```

The diagram should show:

- UART Top Module
- Baud Rate Generator
- UART Transmitter
- UART Receiver
- TX FIFO
- RX FIFO
- Parity Generator
- Parity Checker

Example:

```markdown
![UART Architecture](docs/images/uart_top_architecture.png)
```

---

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

Verifies received parity bits and asserts an error flag upon mismatch.

---

## Verification

### Testbenches

The design was verified using the following testbenches:

### 1. Loopback Verification

Tests end-to-end transmission and reception through the complete UART system.

Checks:

- Successful data transmission
- Correct FIFO operation
- Proper TX/RX synchronization

#### Simulation Waveform

> **Insert loopback waveform here**

```markdown
![Loopback Waveform](docs/images/loopback_waveform.png)
```

---

### 2. Parity Error Detection Verification

Injects frames with incorrect parity bits to verify error detection functionality.

Checks:

- Correct parity generation
- Detection of parity mismatches
- Assertion of `parity_error`

#### Simulation Waveform

> **Insert parity error waveform here**

```markdown
![Parity Error Waveform](docs/images/parity_error_waveform.png)
```

---

## Directory Structure

```text
UART_Controller/
│
├── rtl/
│   ├── uart.v
│   ├── uart_tx.v
│   ├── uart_rx.v
│   ├── timer_input.v
│   ├── parity_generator.v
│   └── parity_checker.v
│
├── tb/
│   ├── uart_parity_tb.v
│   └── uart_rx_error_detection_tb.v
│
├── docs/
│   └── images/
│       ├── uart_top_architecture.png
│       ├── uart_tx_asmd.png
│       ├── uart_rx_asmd.png
│       ├── loopback_waveform.png
│       └── parity_error_waveform.png
│
├── README.md
└── LICENSE
```

---

## Simulation

The design can be simulated using:

- Vivado Simulator
- ModelSim / QuestaSim
- XSIM

Example simulation flow:

```tcl
vlog rtl/*.v tb/*.v
vsim uart_parity_tb
run -all
```

---

## Results

- Successful UART transmission and reception verified.
- Even and odd parity modes validated.
- Parity errors correctly detected and flagged.
- FIFO buffering enabled reliable data transfer.

---

## Future Improvements

- Support configurable data widths.
- Add selectable baud-rate presets.
- Implement hardware flow control (RTS/CTS).
- Extend verification using SystemVerilog assertions and constrained-random testing.

---

## Author

**Your Name**

Personal Project • May–June 2026
