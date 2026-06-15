# GCD-in-verilog

## GCD Calculator using Datapath and Controlpath in Verilog
### Overview

* This project implements an 8-bit Greatest Common Divisor (GCD) calculator in Verilog HDL using the classical Euclidean subtraction algorithm.

* The design follows a Finite State Machine (FSM) based Datapath-Controlpath architecture, where:
1. The Datapath performs arithmetic and comparison operations.<br>
2. The Controlpath controls the sequence of operations using an FSM.<br>
3. The algorithm repeatedly subtracts the smaller number from the larger one until both numbers become equal.<br>
4. The final equal value is the GCD.

---
## Features

- ✅ 8-bit GCD computation using the Euclidean subtraction algorithm
- ✅ Datapath-Controlpath architecture
- ✅ FSM-based controller with 8 states
- ✅ Modular Verilog design
- ✅ Separate modules for subtractor, multiplexer, register, comparator, datapath, and controlpath
- ✅ Behavioral testbench for verification
- ✅ Easy to extend for larger bit widths
- ✅ Suitable for learning RTL design and FSM implementation

---
## Algorithm

The implemented algorithm is based on the **Euclidean subtraction method**.

```text
Input: A, B

while (A != B)
begin
    if (A > B)
        A = A - B;
    else
        B = B - A;
end

GCD = A
```

### Example

```text
Input:
A = 42
B = 16

Iteration 1:
42 > 16
A = 42 - 16 = 26

Iteration 2:
26 > 16
A = 26 - 16 = 10

Iteration 3:
10 < 16
B = 16 - 10 = 6

Iteration 4:
10 > 6
A = 10 - 6 = 4

Iteration 5:
4 < 6
B = 6 - 4 = 2

Iteration 6:
4 > 2
A = 4 - 2 = 2

Now,
A = B = 2

GCD = 2
```
---
## Datapath Components

* The datapath consists of:

1. Two subtractors: i.A - B ii.B - A <br>
2. Two multiplexers: Select between external inputs and subtraction outputs.<br>
3. Three registers : i.Register A ii.Register B iii.Output register<br>
4. Comparator<br>
Generates:<br>
a_gt_b : A > B<br>
a_lt_b : A < B<br>
a_eq_b : A == B<br>
---

## Controlpath FSM

The controlpath is implemented using a Finite State Machine (FSM) with 8 states.

| State | Function |
|-------|----------|
| **S0** | Idle state |
| **S1** | Load external inputs `A` and `B` into registers |
| **S2** | Wait state after loading inputs |
| **S3** | Compare `A` and `B` using comparator outputs (`a_gt_b`, `a_lt_b`, `a_eq_b`) |
| **S4** | Update `A = A - B` when `A > B` |
| **S5** | Update `B = B - A` when `A < B` |
| **S6** | Wait state before next comparison |
| **S7** | Output the GCD and assert `done = 1` |


* The FSM controls the datapath signals (`a_sel`, `b_sel`, `a_ld`, `b_ld`, `out_en`, and `done`) to execute the Euclidean subtraction algorithm until both operands become equal, at which point the GCD is produced.
