
# RTL Design of SPI Protocol with APB Interface

## Overview
This project implements the RTL design of an SPI Master Controller using Verilog HDL.  
The architecture integrates an APB interface and includes register logic, data-path logic,  
APB-FSM behavior, and protocol-level control for SPI communication.

## 1. Status Register Logic
- Handles status flag updates based on internal SPI operations.
- Tracks conditions used during transmission and control operations.

## 2. Control Register 1 Logic
- Stores primary configuration fields for SPI operation.
- Controls enable bits, mode settings, and feature options.

## 3. Control Register 2 Logic
- Handles additional configuration fields.
- Supports extended control features required during SPI activity.



## 4. Baud-Rate Register Logic
- Implements programmable clock division for generating SPI clock.
- Updates baud-rate settings based on APB writes.

---

## 5. Data Register Logic
- Stores data to be transmitted over MOSI.
- Updated through APB write operations.
- Acts as the source input for the send_data block.

## 6. APB-FSM States Logic
- Controls APB read and write cycles.
- Decodes PADDR to select appropriate register.
- Generates PRDATA during APB read operations.
- Handles state transitions for idle → read/write → update.

---

## 7. Send_Data Logic
- Processes the data from the Data Register.
- Drives serialization logic for MOSI output.
- Coordinates with control fields and baud-rate log

## 8. MOSI Logic
- Implements the output shift logic for sending bits serially.
- Uses clock edges defined by baud-rate and mode configuration.

## 9. PRDATA Logic
- Returns the selected register contents during APB read.
- Works with APB-FSM for proper bus timing.
- 
## 10. IRQ Logic
- Generates interrupt request signals based on status conditions.
- Supports event-driven notification for SPI operations.
- 
## 11. Mode Update Logic
- Updates mode signals such as CPOL and CPHA.
- Ensures correct timing behavior according to selected SPI mode.

## Tools & Language
- **HDL:** Verilog
- **Design Level:** Register Transfer Level (RTL)
- **Interface:** AMBA APB


