# SignalTap Logic Analyzer for DE1-SOC Board

This repository contains a SignalTap Logic Analyzer implementation for the DE1-SOC FPGA development board, with the main Verilog file named `stap.v`. The project demonstrates the use of the SignalTap embedded logic analyzer tool within the Intel Quartus Prime environment to monitor and debug internal signals of an FPGA design.

## Project Overview

This project provides a SignalTap Logic Analyzer setup for monitoring internal signals on the DE1-SOC board. It includes a basic Verilog module (`stap.v`) that can be extended or modified to fit your specific FPGA design. The SignalTap Logic Analyzer is configured to capture and display internal signal states, aiding in the debugging and analysis of the FPGA's behavior in real-time.

## Features

- **Real-Time Signal Monitoring:** Capture and analyze internal FPGA signals on the DE1-SOC board.
- **Configurable Trigger Conditions:** Set up triggers to capture data only when specific events occur.
- **Non-Intrusive Debugging:** The SignalTap Logic Analyzer operates within the FPGA without affecting your design's performance.
- **Quartus Prime Integration:** Fully integrated with the Intel Quartus Prime software for seamless development.

## Hardware Requirements

- **DE1-SOC Board:** Altera (Intel) DE1-SOC development board.
- **USB Blaster:** For programming the FPGA on the DE1-SOC board.

## Software Requirements

- **Intel Quartus Prime:** Quartus Prime Standard version 22.1.1 for FPGA development.
- **SignalTap Logic Analyzer:** Included with the Quartus Prime software.

