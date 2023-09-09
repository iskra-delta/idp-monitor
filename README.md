![status.badge] ![language.badge] [![compiler.badge]][compiler.url] 

# idp-monitor

The Iskra Delta Partner Monitor program.

# Compile

To compile this monitor, you will need a Linux machine with the SDCC compiler suite and the sed tool installed.

You can get the source code by cloning this repository:

~~~
git clone https://github.com/tstih/idp-monitor.git
~~~

Then, navigate to the idp-monitor directory and compile it by running:

~~~
cd idp-monitor
make
~~~

After compilation, you will find the monitor.rom file inside the bin/ directory.

 > By default, the monitor is compiled to the top of Iskra Delta Partner memory. However, you have the flexibility to change this by passing arguments to the make command. For more details on how to do this, please refer to the "memory layout" chapter for a step-by-step explanation.

# The Code

...todo...

# The Memory layout

...todo...

[language.badge]: https://img.shields.io/badge/languages-c11%2C%20z80%20assembly-blue.svg

[compiler.url]:   http://sdcc.sourceforge.net/
[compiler.badge]: https://img.shields.io/badge/compiler-sdcc-blue.svg

[status.badge]:  https://img.shields.io/badge/status-development-red.svg