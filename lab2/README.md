# 基于 FPGA 的 ARM 单周期处理器设计与实现

## 项目简介

本项目基于 **Xilinx FPGA**，使用 **Verilog HDL** 设计并实现一个简化的 **32-bit ARM 单周期处理器**。

处理器完成了从取指、指令译码、寄存器访问、移位与 ALU 运算到 Memory 读写和 PC 更新的完整数据通路，支持 **LDR、STR、AND、ORR、ADD、SUB、CMP、CMN、B** 等指令，并实现 **LSL、LSR、ASR、ROR** 四种移位操作及 ARM 条件执行机制。

最终将 ARM Core、Memory 与 FPGA 板载外设完成集成，并在 Xilinx FPGA 上进行运行验证。

## 主要任务

* **ARM Core (`ARM.v`)**
  搭建 32-bit ARM 单周期数据通路，连接 PC、Register File、Shifter、ALU、Control Unit 与 Memory 接口。

* **Program Counter (`ProgramCounter.v`)**
  实现 PC 更新、`PC + 4` 顺序执行以及 Branch 后的目标地址更新。

* **Control Unit (`ControlUnit.v`, `Decoder.v`, `CondLogic.v`)**
  完成 ARM 指令译码，根据 Opcode 和指令字段产生数据通路控制信号，并结合 `N/Z/C/V` Flags 实现条件执行。

* **Register File (`RegisterFile.v`)**
  实现 ARM `R0~R15` 寄存器访问，包括双端口读取、寄存器写回以及 R15/PC 读取。

* **ALU (`ALU.v`)**
  实现 32-bit **ADD、SUB、AND、ORR** 运算，并产生 `N/Z/C/V` 状态标志。

* **Shifter (`Shifter.v`)**
  实现 **LSL、LSR、ASR、ROR** 四种立即数移位，为 ARM Data-Processing 指令提供移位后的 Src2。

* **Immediate Extend (`Extend.v`)**
  根据不同指令格式完成 Data Processing、Memory 和 Branch 指令的立即数扩展。

* **Adder (`Adder1.v`, `Adder4.v`, `Adder16.v`)**
  从 1-bit Full Adder 开始进行层次化设计，构建 4-bit、16-bit 并进一步组成 ALU 使用的 32-bit 加法运算结构。

* **FPGA Integration (`Wrapper.v`, `TOP_Nexys4.v`)**
  将 ARM Core 与 Instruction/Data Memory 及 FPGA 板载外设连接，实现处理器的板级运行与结果观察。

## 遇到的问题与解决方法

### 1. 不同 ARM 指令需要使用不同的数据通路

**问题：**
Data Processing、Memory 和 Branch 指令的数据来源、写回位置以及 PC 更新方式不同，无法使用固定的数据通路完成所有操作。

**解决：**
通过 `Decoder.v` 对指令字段进行译码，产生 `RegSrc`、`ALUSrc`、`MemtoReg`、`RegWrite`、`MemWrite`、`PCSrc` 等控制信号，在统一的数据通路中选择不同的数据来源和执行路径。

### 2. ARM Operand2 同时支持立即数和移位寄存器

**问题：**
Data Processing 指令的第二操作数不仅可以来自立即数或寄存器，还需要支持寄存器的 `LSL / LSR / ASR / ROR` 移位。

**解决：**
独立设计 `Shifter.v`，根据指令中的 Shift Type 和 Shift Amount 对 32-bit 输入进行移位，再将结果送入 ALU，实现带立即数移位的寄存器操作数。

### 3. CMP / CMN 只更新 Flags，不能写回寄存器

**问题：**
`CMP` 和 `CMN` 使用 ALU 完成比较运算，但与普通 `SUB / ADD` 不同，运算结果不能写回 Register File。

**解决：**
在 Decoder 中识别 `CMP / CMN` 指令并产生 `NoWrite` 信号，在保留 ALU 运算和 Flags 更新的同时禁止 Register File 写回。

### 4. ARM 指令需要根据 Condition Flags 决定是否执行

**问题：**
ARM 指令包含 Condition 字段，指令是否真正修改寄存器、Memory 或 PC 取决于当前 `N/Z/C/V` 状态。

**解决：**
设计 `CondLogic.v` 保存 ALU Flags，并根据指令中的 Condition 字段判断执行条件，只在条件满足时使能 `RegWrite`、`MemWrite` 和 `PCSrc`。

### 5. Memory 地址需要同时支持正、负立即数偏移

**问题：**
`LDR / STR` 不仅需要支持正立即数 Offset，还需要支持负 Offset 地址计算。

**解决：**
在指令译码阶段识别 Memory 指令的加减控制位，并复用 ALU 的 ADD/SUB 数据通路计算最终 Memory Address。

## 项目结果

* `ARM.v`：完成 **32-bit ARM 单周期数据通路**
* `ControlUnit / Decoder / CondLogic`：完成 **指令译码、Flags 与条件执行控制**
* `ALU.v`：实现 **ADD / SUB / AND / ORR + N/Z/C/V**
* `Shifter.v`：实现 **LSL / LSR / ASR / ROR**
* `RegisterFile.v`：完成 **ARM Register File 读写**
* 支持 **Data Processing、Memory、Branch** 三类 ARM 指令
* 完成 **ARM Core + Memory + FPGA 外设**的板级集成与验证
