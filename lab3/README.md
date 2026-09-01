# ARM 处理器多周期乘除法单元与自定义指令扩展

## 项目简介

本项目基于 Lab2 实现的 **32-bit ARM 单周期处理器**，使用 **Verilog HDL** 设计并集成多周期乘除法运算单元 `MCycle`。

在原有处理器数据通路和控制逻辑基础上，实现 **32-bit 无符号多周期乘法与除法**，支持 ARM `MUL` 指令，并通过设计新的指令编码与译码逻辑，为处理器扩展自定义无符号 `DIV` 指令。

同时针对乘除法无法在单周期内完成的问题，引入 `Start / Busy` 控制机制，使处理器能够等待多周期运算完成后再继续执行。

## 主要任务

* **Multi-Cycle Unit (`MCycle_template.v`)**
  设计 32-bit 无符号多周期乘除法单元，通过迭代计算降低组合逻辑规模，并由同一运算单元完成 Multiplication 与 Division。

* **ARM Core (`ARM.v`)**
  将 `MCycle` 集成到原有 ARM 数据通路中，为乘除法增加 Operand 输入、Result 写回以及 `Busy` 状态控制。

* **Instruction Decoder (`Decoder.v`)**
  增加 `MUL` 指令识别，并设计自定义 `DIV` 指令编码与译码逻辑，产生 `Start`、`MCycleOp` 和 `MCycleWrite` 控制信号。

* **Control Unit (`ControlUnit.v`, `CondLogic.v`)**
  将多周期运算控制加入原有指令控制逻辑，并结合 ARM Condition Logic 控制乘除法结果的有效写回。

* **Register File (`RegisterFile.v`)**
  配合乘除法指令的数据通路调整寄存器读取与结果写回，实现 Operand 获取和计算结果保存。

* **Processor Integration (`ARM.v`, `Wrapper.v`, `TOP_Nexys4.v`)**
  在保留原有单周期 ARM 指令功能的基础上完成多周期执行单元的系统集成。

## 遇到的问题与解决方法

### 1. 32-bit 乘除法不适合直接作为单周期组合逻辑实现

**问题：**
如果直接使用大规模组合逻辑完成 32-bit 乘除法，会增加硬件资源占用，并形成较长的组合路径。

**解决：**
设计 `MCycle` 多周期运算单元，通过 Shift、Add/Subtract 和计数器进行迭代计算，将一次复杂运算拆分到多个 Clock Cycle 中完成。

### 2. 乘法器和除法器分别实现会增加硬件资源

**问题：**
如果为 Multiplication 和 Division 分别设计独立的数据通路，会产生重复的移位、加减和寄存器资源。

**解决：**
在 `MCycle` 中共享中间寄存器和加减/移位数据路径，通过 `MCycleOp` 选择 Multiplication 或 Division，使两种运算复用主要硬件资源。

### 3. 单周期处理器无法直接等待多周期运算结果

**问题：**
原 ARM Core 默认每条指令一个周期完成，而 `MUL / DIV` 需要多个周期。如果 PC 继续更新，处理器会在结果产生之前执行下一条指令。

**解决：**
加入 `Start / Busy` 控制机制。Decoder 检测到多周期指令后产生 `Start`，`MCycle` 在计算期间保持 `Busy`，通过 Stall 机制暂停处理器执行，直到结果计算完成。

### 4. 原有 Decoder 不支持自定义 DIV 指令

**问题：**
实验要求实现无符号除法，但目标 ARM 指令集中没有直接对应本实验需求的 Division 指令。

**解决：**
设计新的 `DIV` 指令编码，并在 `Decoder.v` 中增加对应的指令识别逻辑。检测到自定义编码后产生 `Start = 1`、`MCycleOp = 1`，将指令送入多周期除法数据路径。

### 5. 多周期运算结果需要重新接入 Register Write-Back

**问题：**
原有处理器的写回数据主要来自 ALU 或 Memory，而 `MUL / DIV` 的结果来自新的 `MCycle` 单元。

**解决：**
扩展 ARM Core 的 Write-Back 数据选择，在原有 `ALUResult / ReadData` 基础上增加 `MCycleResult`，并通过 `MCycleWrite` 控制乘除法结果写回目标寄存器。

## 项目结果

* `MCycle`：实现 **32-bit 无符号多周期 Multiplication / Division**
* `MCycle`：实现 **乘除法主要计算资源复用**
* `Decoder.v`：完成 ARM **`MUL` 指令译码**
* `Decoder.v`：设计并实现自定义 **`DIV` 指令译码**
* `ARM.v`：完成 **MCycle 数据通路与 Write-Back 集成**
* `Start / Busy`：实现 **多周期运算期间的处理器 Stall 控制**
* 保留 Lab2 原有 ARM 指令功能，并扩展 **MUL / DIV 多周期运算能力**
* 完成多周期运算单元仿真及 **Xilinx FPGA 系统集成**
