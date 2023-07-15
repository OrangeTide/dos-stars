# DOS Stars

[![Build Status](https://travis-ci.com/OrangeTide/dos-stars.svg?token=YziQ9JEpcDSQoy55tXGQ&branch=master)](https://travis-ci.com/OrangeTide/dos-stars)

![GitHub](https://img.shields.io/github/license/OrangeTide/dos-stars)

[![License: CC0-1.0](https://licensebuttons.net/l/zero/1.0/80x15.png)](http://creativecommons.org/publicdomain/zero/1.0/)

## Introduction

Displays a scrolling starfield in CGA on 16-bit realmode DOS.

Code is very simplistic assembler and is more of an instructional example than anything serious.

![Starting](images/run.gif)

![Running](images/stars.gif)

## Building, Running, and Testing

### Prerequisites

 * A MASM compatible toolchain:
   * [ML64.EXE](https://learn.microsoft.com/en-us/cpp/assembler/masm/masm-for-x64-ml64-exe?view=msvc-170)
   * [JWasm](https://github.com/JWasm/JWasm) and [JWlink](https://github.com/JWasm/JWlink)
 * A DOS or PC emulator, any one of:
   * [DOSBox](https://www.dosbox.com/)
   * [Bochs](http://bochs.sourceforge.net/)
   * [PCem](https://pcem-emulator.co.uk/)
   * [XTulator](https://xtulator.com/)
   * [86Box](https://86box.net/)

### Building

```
make
```

## Testing

(requires DOSBox)

```
make test
```

or

```
dosbox
```

Edit dosbox.conf to suit your platform configuration.

## Reference

 * [Vintage PC Pages - Color Graphics Adapter Notes](http://www.seasip.info/VintagePC/cga.html)
 * [Old Pseudo-Random Number Generators](http://orangeti.de/code/oldrand.c)
 * [8086 Cheat Sheet PDF](https://www.chibialiens.com/8086/8086CheatSheet.pdf)
