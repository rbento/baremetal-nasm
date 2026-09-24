# baremetal-nasm

[![CI](https://github.com/rbento/baremetal-nasm/actions/workflows/makefile.yml/badge.svg)](https://github.com/rbento/baremetal-nasm/actions/workflows/makefile.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A minimal starter template for bare-metal x86-64 Linux assembly programming, small utilities, systems development, and deliberate practice.

## Introduction and Goals

`baremetal-nasm` is a minimal template for deliberate practice while programming freestanding x86-64 assembly on Linux using NASM.

```bash
git clone https://github.com/rbento/baremetal-nasm.git my-project
cd my-project
./bootstrap.sh
make run
```

**Primary Goals:**
*   **Artifact Isolation:** Strictly separate build outputs from the source tree.
*   **Freestanding Execution:** Execute directly on the kernel ABI using raw syscalls and the native `_start` entry point (`-nostdlib`).
*   **Editor Agnosticism:** Integrate seamlessly with lightweight editors (Vim, Emacs) via standard CLI tooling (`ctags`).

## Architecture Constraints
*   **Target Architecture:** x86-64 (AMD64).
*   **Target OS:** Linux (System V AMD64 ABI / Linux syscall convention).
*   **Assembler:** `nasm` (Intel syntax, ELF64 output).
*   **Linker:** `clang` (invoked with `-nostdlib`).
*   **Debugger:** `gdb`.
*   **Tooling:** Universal Ctags (source indexing). No language server is used because NASM syntax lacks mainstream LSP support.

## System Scope and Context
*   **Context:** The template serves as a generic starting point for practicing Linux x86-64 assembly—building standalone programs and small libraries directly against the syscall interface.
*   **Technical Scope:** The pipeline consumes raw `.asm` source implementations and `.inc` include headers, processes them through a direct POSIX `make` workflow with automatic dependency generation, and produces native ELF64 executables in `build/bin/`.

## Solution Strategy
*   **Out-of-Source Compilation:** Object files (`.o`), dependency files (`.d`), and executables route exclusively to a transient `build/` tree to keep the repository root clean.
*   **Header Dependency Tracking:** Assembler flags (`-MD`) generate Make prerequisites during assembly, ensuring proper recompilation when included headers change.
*   **No C Runtime:** Passes `-nostdlib` at link time and defines `_start`. Programs interact with the kernel via `syscall` instructions, avoiding `libc` wrappers.
*   **Automated Tooling Sync:** `bootstrap.sh` automates the generation of tag indexes so editor navigation matches the current build state.

## Building Block View
### Level 1: Directory Structure
*   `.editorconfig`: Fallback editor indentation, charset, and line-ending rules tailored for assembly.
*   `.gitignore`: Excludes `build/` and generated tooling artifacts from version control.
*   `bootstrap.sh`: Shell script for clean rebuilding and tooling generation.
*   `build/`: Transient output tree (ignored by Git).
    *   `build/obj/`: Assembled object files (`.o`) and dependency graphs (`.d`).
    *   `build/bin/`: Final linked executables.
*   `src/`: Implementation files (`.asm`).
*   `include/`: Public headers (`.inc`).
*   `Makefile`: Build rules, dependency includes, and compiler targets.

## Runtime View
### Standard Build Sequence
1.  `make` is executed.
2.  The assembler compiles modified `.asm` files in `src/` into `.o` objects in `build/obj/`.
3.  The assembler writes header dependency `.d` files alongside object files in `build/obj/`.
4.  The linker combines all `.o` objects into the final binary inside `build/bin/`.

### Environment Bootstrap Sequence (`bootstrap.sh`)
1.  Invokes `make clean` to purge existing build artifacts.
2.  Removes stale caches, debugger histories, and editor indexes (`.cache`, `.gdb_history`, `tags`).
3.  Executes `make debug` to run a debug build (`-g -F dwarf`).
4.  Runs `ctags -R .` to index function signatures and identifiers for tag-based navigation.
5.  Prints the output paths of all generated artifacts.

## Cross-cutting Concepts
*   **Freestanding Entry & ABI:** System calls follow the Linux x86-64 register convention (`rax` for syscall number; `rdi`, `rsi`, `rdx`, `r10`, `r8`, `r9` for arguments).
*   **Editor Integration:** Standard CLI tools (`ctags`) are preferred. The tag index provides practical, reliable symbol navigation without background daemon overhead.
*   **Code Style Enforcement:** `.editorconfig` provides basic whitespace and tab rules for environments, as no standard auto-formatter exists for NASM.
*   **Debugging Instrumentation:** The `make debug` target applies `-g -F dwarf` so `gdb` retains DWARF symbol tables and can map raw instructions back to source lines.

## Architecture Decisions
*   **ADR-01: Artifact Segregation:** Source directories must contain zero generated files. *Rationale:* Prevents clutter, simplifies `.gitignore`, and eliminates accidental binary check-ins.
*   **ADR-02: POSIX Make over CMake:** Direct Makefiles are chosen over CMake or Meson. *Rationale:* Eliminates meta-build dependencies, keeps the build process transparent, and avoids unnecessary abstractions for pure assembly.
*   **ADR-03: Clang as Freestanding Linker Driver:** `clang` is used with `-nostdlib` instead of invoking `ld` directly. *Rationale:* Maintains toolchain consistency with C projects while effectively eliminating C startup files (`crt1.o`).
*   **ADR-04: Ctags over LSP:** Symbol indexing via Universal Ctags is preferred over language server daemons. *Rationale:* Mainstream language servers lack robust NASM support.

## Glossary
*   **ABI:** Application Binary Interface. The low-level interface defining calling conventions and system call register mappings.
*   **Ctags:** A tool that indexes language objects (labels, constants, macros) into a `tags` file for text-editor jump navigation.
*   **DWARF:** Standardized debugging data format embedded in ELF binaries for GDB inspection.
*   **Freestanding:** A program that executes without the presence of an operating system runtime library (`libc`).
*   **NASM:** Netwide Assembler. An Intel-syntax assembler for the x86 and x86-64 architectures.

## References
*   [arc42](https://arc42.org) - Architecture communication template.
*   [GNU Debugger (GDB)](https://www.gnu.org/software/gdb/) - Debugger referenced in §2, §8.
*   [Linux Kernel System Calls](https://man7.org/linux/man-pages/man2/syscall.2.html) - Linux syscall convention referenced in §2, §3, §8, §12.
*   [NASM Documentation](https://www.nasm.us/doc/) - Netwide Assembler documentation referenced in §1, §2, §4, §6.1, §12.
*   [Universal Ctags](https://ctags.io) - Source code indexer referenced in §1, §2, §4, §6.2, §8, §9, §12.
