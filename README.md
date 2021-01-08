# CPE233 - Computer Design and Assembly Language Programming
This repository includes all associated System Verilog code used in devlelopment of the 8-bit RAT Architecture CPU

Computer Architecture can be seen as the following:

![RAT MCU](https://github.com/Arsalan-M/CPE233/blob/master/RATCPUARCH.png)

## Introduction

This device is a development of the popular classic game of ‘Snake’ written in
RAT Assembly code. The game’s algorithm itself is within the assembly code,
and the generated opcode is run on a custom RAT CPU architecture developed
and generated in a Xilinix Vivado environment and written in System Verilog.

The goal of the game is to guide the snake on screen to the nearest food
element, so it can be eaten, and the snake can grow in length, while also being
careful not to hit any walls or the snake itself in the process. When the food is
eaten, the snake grows exactly one unit (pixel) in length, before the food is
randomly generated and relocated again on screen.

The device runs on a Digilent Basys 3 Board with a 50 MHz Clock. Runtime for
execution of a single RAT Assembly code instruction is 40 ns. Peripheral
devices include a standard Keyboard and VGA compatible display.
Precision is key for taking in user input quickly, so that delay in the game is
minimal. When a key is pressed on the keyboard, an interrupt is generated,
quickly storing the user’s input in no more than 3 instructions of assembly code
(120 nanoseconds).

Before the next display cycle refresh of the game is generated, the game
device already knows of the user’s next input and is able to display new
information accordingly. Input ranges between acceptable keypresses from W,
A, S, D and unacceptable presses from any and all other keypresses (except for
the reset/menu screen, which accepts any key to continue). 

## Operation

### Controls
![Snake Keyboard Controls](https://github.com/Arsalan-M/CPE233/blob/master/SNAKE_Keys.png)

### Gameplay

To play the game, first exit the Menu Screen by pressing any key. Once in
the game, the snake will automatically start moving to the right. Now you are in
control. To move the snake, use ‘W’ to move upwards, ‘S’ to move down, and
‘A’ and ‘D’ to move left and right respectively. The goal is to lead the snake over
the food element, shown in green, and grow the snake as long as possible
without hitting the snake itself or a bordering wall. To keep it easy to
understand the snake’s orientation, the head of the snake is colored red, and
the body colored yellow. The border of the game is just determined by the
edge of the display.

Score is displayed on the Basys Board’s Seven Segment LED display. The
score starts out as 0 and increments by +1 for every food consumed by the
snake. 

## Software Design

### Program Function

The software design and program function start with clearing all registers
and the screen of any printed elements. The program sits in an infinite ‘wait’
loop until a key is pressed, triggering the interrupt routine. This routine takes
the key pressed and stores it to be used to identify direction the snake should
move.

After this is done, the program enters a subroutine to obtain a random
(X,Y) location for the food element and enters the game loop. In this loop, the
current location of the snake is saved for later use (default is center of the
screen). The key pressed by the user is then parsed to check validity, and is
compared to preloaded registers, determining what direction the snake should
go if the key was valid. If the key was invalid (wrong key or no key pressed) the
program defaults the next move to the previous move, keeping the snake
moving in its initial direction.

Once a valid key press is received, an update is received to the changing
coordinate value for the required move (Up & Down changes Y axis, Left &
Right changes X axis value). Then, this valid move is stored to be used as the
last valid move in case of an invalid keypress by the user during or at the end
of the loop. The body is then updated in a loop according to the length. For
future loops once the food is eaten, this body update ensures that the snake
doesn’t grow from the center of the screen, but rather actually moves along
the screen. The body is displayed in a similar fashion. Growth is checked
through a simple compare and adds a pixel to the end of the snake if satisfied.

Collisions are determined through checking against set values for game
borders or through comparing the head value to body value locations for wall
and self-collisions respectively. Food ‘collision’ is also checked in an equivalent
method. Any wall/self-collisions lead to a death screen, then a game restart. 

## Software Design

### Flowchart
![Software Flow Chart](https://github.com/Arsalan-M/CPE233/blob/master/SofwareFlowchart.png)

## Other Information
CPE 233 involved the design and implementation of digital computer circuits via CAD tools for programmable logic devices (PLDs).
Basic computer design with its datapath components and control unit. Introduction to assembly language programming of an off-the-shelf RISC-based microcontroller.

