# Tracking Room Occupancy System (VHDL)

## Project Overview
This project involves the design, implementation, and verification of a digital room occupancy counter using VHDL. The system tracks the number of people entering and exiting a room in real time while enforcing a configurable maximum capacity limit. It is designed to operate reliably in synchronous digital systems and is suitable for smart building and security applications.

The project was completed as part of the COEN 313 – Digital Systems Design course at Concordia University.

## Objectives
- Track room occupancy based on entry and exit sensor signals
- Prevent overflow and underflow conditions
- Detect and handle sensor glitches and long pulses
- Assert a full flag when maximum capacity is reached
- Verify correctness through comprehensive simulation

## System Design
- Synchronous sequential logic driven by a system clock
- Rising-edge detection for entry and exit sensors
- 8-bit occupancy counter supporting capacities from 0 to 255
- Full-flag logic triggered when occupancy reaches capacity
- Reset functionality to clear internal states

## VHDL Implementation
- Single clocked process controlling all system logic
- Edge detection implemented using previous sensor state storage
- Protection against simultaneous entry and exit events
- Saturation logic to prevent overflow and underflow
- Clean, synthesizable VHDL code following best practices

## Verification & Testing
- Developed a dedicated VHDL testbench
- Executed 15 test cases covering:
  - Normal operation
  - Boundary conditions
  - Simultaneous entry/exit
  - Long pulses and rapid toggling
  - Reset behavior
  - Maximum capacity handling
- Verified functionality using ModelSim waveforms

## Tools & Technologies
- VHDL
- ModelSim (simulation and testbench verification)
- Vivado (RTL elaboration, synthesis, and implementation)
- FPGA-targeted design workflow

## Skills Demonstrated
- Digital system design
- VHDL coding and simulation
- Sequential logic and edge detection
- Testbench development
- Debugging and verification
- Timing-aware hardware design

## Project Status
Completed, simulated, and fully validated against all specified requirements.
