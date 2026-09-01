# FPGA Digital Design Projects

## 项目简介

本仓库包含基于 **Xilinx FPGA** 和 **Verilog HDL** 完成的四个数字系统与处理器设计项目，内容涵盖 FPGA 外设控制、ARM 单周期处理器、多周期乘除法扩展以及 RISC-V 单周期处理器设计。

## 项目内容

### Lab 1 — FPGA 七段数码管显示与存储器控制系统

实现 32-bit Memory 数据读取、八位七段数码管动态显示、按键消抖以及暂停和显示速度控制。

### Lab 2 — ARM Single Cycle

设计并实现 **32-bit ARM 单周期处理器**，包括 PC、Register File、ALU、Shifter、Control Unit 和 Memory 数据通路，并支持条件执行机制。

### Lab 3 — ARM Multi-Cycle Extension

在 ARM 单周期处理器基础上集成 `MCycle`，实现 **32-bit 无符号乘除法**、`MUL` 指令以及自定义 `DIV` 指令，并加入 `Start / Busy` 多周期控制。

### RISC-V Single Cycle

基于 **RV32I** 设计并实现 **32-bit RISC-V 单周期处理器**，完成指令译码、Register File、ALU、Shifter、Immediate Generation、Memory、Branch / Jump 以及 PC 更新等核心数据通路。

## 开发环境

* **HDL:** Verilog HDL
* **FPGA:** Xilinx FPGA
* **Development Tool:** Xilinx Vivado
* **Architecture:** ARM / RISC-V RV32I

> 各项目的具体设计、实现方法和验证结果请参阅对应目录中的 `README.md`。
