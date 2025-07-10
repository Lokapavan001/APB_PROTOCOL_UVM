# APB Verification Using UVM

This project contains a **UVM (Universal Verification Methodology)** based testbench for verifying an **AMBA APB (Advanced Peripheral Bus)** slave device. It is designed to be modular, reusable, and easy to integrate with Synopsys tools (VCS, Verdi) or others that support SystemVerilog and UVM.

---

## 📚 Project Overview

- **Protocol**: AMBA APB 2.0/3.0
- **Language**: SystemVerilog
- **Verification Methodology**: UVM (IEEE 1800.2)
- **Tools Supported**:
  - Synopsys VCS (Simulation)
  - Synopsys Verdi (Debug)
  - Xilinx Vivado (RTL Synthesis/Analysis)
  - Other EDA tools with UVM support

---

##  Directory Structure

apb_uvm_verification/
│
├── docs/ # Documentation and specs
│ └── apb_spec.pdf
│
├── rtl/ # Design Under Test (DUT)
│ └── apb_slave.v
│
├── tb/ # UVM Testbench
│
│ ├── top/
│ │ └── tb_top.sv # Testbench top: connects DUT and env
│
│ ├── interfaces/
│ │ └── apb_if.sv # SystemVerilog interface for APB signals
│
│ ├── env/
│ │ ├── apb_env.sv # UVM environment
│ │ ├── apb_config.sv # Configuration object
│ │ └── apb_scoreboard.sv # Scoreboard (moved inside env)
│
│ ├── agent/
│ │ ├── apb_agent.sv
│ │ ├── apb_driver.sv
│ │ ├── apb_monitor.sv
│ │ ├── apb_sequencer.sv # Sequencer (non-virtual)
│ │ ├── apb_transaction.sv # Sequence item
│ │ └── apb_coverage.sv # Optional coverage
│
│ ├── tests/
│ │ ├── apb_write_test.sv
│ │ ├── apb_read_test.sv
│ │ ├── apb_random_test.sv
│ │ └── apb_error_test.sv



---

##  Testbench Features

- ✅ UVM agent with monitor, driver, sequencer
- ✅ Scoreboard for functional checking
- ✅ Configurable test sequences
- ✅ Protocol-compliant APB interface
- ✅ Reusable UVM environment structure
- ✅ Reset, error, and corner-case tests

---

##  How to Run

### Using Synopsys VCS

#### Step 1: Compile
```bash
vcs -full64 -sverilog +acc +vpi +vcs+lic+wait \
    -f sim/vcs_opts.f -top top -l compile.log

./simv +UVM_TESTNAME=apb_test -l run.log

UVM Components

| Component        | Description                                  |
| ---------------- | -------------------------------------------- |
| `apb_if.sv`      | SystemVerilog interface for APB signals      |
| `apb_driver`     | Drives write/read signals to DUT             |
| `apb_monitor`    | Captures bus activity and creates tx objects |
| `apb_sequence`   | Generates transaction-level stimulus         |
| `apb_scoreboard` | Checks expected vs actual DUT output         |
| `apb_env`        | Integrates agent and scoreboard              |
| `apb_test`       | Top-level UVM test class                     |

 Example Testcases
apb_write_read_test: Simple write followed by read

apb_reset_test: Reset behavior and recovery

apb_random_test: Randomized transaction generation

apb_error_test: Protocol and invalid address tests

Requirements
SystemVerilog simulator (VCS, Riviera, etc.)

UVM library (built-in or set via $UVM_HOME)

Verdi (optional, for waveform debug)

Vivado (optional, for synthesizing apb_slave.v)
