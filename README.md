# FXP - AS3 Functional Programing

As implied by the name, FXP is a functional programing library for use with actionscript 3. It was initially inspired by the [mostly adequate guide](https://github.com/DrBoolean/mostly-adequate-guide), which, even though uses javascript, is worth a read to get started. I won't enter into details about functional programming concepts provided by this library.

The library is divided into 3 main subpackages:
 * `fxp.core` provides core functional programming features
 * `fxp.monads` provides monads (really?)
 * `fxp.utils` provides utility function, exposed in `fxp.core.F`

## Maintainer

 * Jean-Christophe Hoelt <hoelt@fovea.cc>

Please use [github](https://github.com/j3k0/fxp-as3) for issues and pull requests.

## API Documentation

**Important notice**: all functions provided by the API are "curryfied". If you don't know what that means, please read the [mostly adequate guide](https://github.com/DrBoolean/mostly-adequate-guide) before going any further.

 * [fxp.core.F](doc/fxp.core.F.md)
   * [core](doc/fxp.core.F.md)
   * [utils](doc/fxp.core.F.utils.md)
   * [debug](doc/fxp.core.F.debug.md)
   * [object](doc/fxp.core.F.object.md)
   * [array](doc/fxp.core.F.array.md)
   * [string](doc/fxp.core.F.string.md)
 * [fxp.monads.Maybe](doc/fxp.monads.Maybe.md)
 * [fxp.monads.IO](doc/fxp.monads.IO.md)

# License

The New BSD License.

Copyright (c) 2015, Fovea.cc

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * Neither the name of Fovea nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
