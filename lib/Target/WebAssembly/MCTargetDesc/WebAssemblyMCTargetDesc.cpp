//===-- WebAssemblyMCTargetDesc.cpp - WebAssembly Target Descriptions -----===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// \brief This file provides WebAssembly-specific target descriptions.
///
//===----------------------------------------------------------------------===//

#include "WebAssemblyMCTargetDesc.h"
#include "InstPrinter/WebAssemblyInstPrinter.h"
#include "WebAssemblyMCAsmInfo.h"
#include "WebAssemblyTargetStreamer.h"
#include "llvm/MC/MCCodeGenInfo.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

#define DEBUG_TYPE "wasm-mc-target-desc"

#define GET_INSTRINFO_MC_DESC
#include "WebAssemblyGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "WebAssemblyGenSubtargetInfo.inc"

#define GET_REGINFO_MC_DESC
#include "WebAssemblyGenRegisterInfo.inc"

static MCAsmInfo *createMCAsmInfo(const MCRegisterInfo & /*MRI*/,
                                  const Triple &TT) {
  return new WebAssemblyMCAsmInfo(TT);
}

static MCCodeGenInfo *createMCCodeGenInfo(const Triple & /*TT*/,
                                          Reloc::Model /*RM*/,
                                          CodeModel::Model CM,
                                          CodeGenOpt::Level OL) {
  CodeModel::Model M = (CM == CodeModel::Default || CM == CodeModel::JITDefault)
                           ? CodeModel::Large
                           : CM;
  if (M != CodeModel::Large)
    report_fatal_error("Non-large code models are not supported yet");
  MCCodeGenInfo *CGI = new MCCodeGenInfo();
  CGI->initMCCodeGenInfo(Reloc::PIC_, CM, OL);
  return CGI;
}

static MCInstrInfo *createMCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitWebAssemblyMCInstrInfo(X);
  return X;
}

static MCRegisterInfo *createMCRegisterInfo(const Triple & /*T*/) {
  MCRegisterInfo *X = new MCRegisterInfo();
  InitWebAssemblyMCRegisterInfo(X, 0);
  return X;
}

static MCInstPrinter *createMCInstPrinter(const Triple & /*T*/,
                                          unsigned SyntaxVariant,
                                          const MCAsmInfo &MAI,
                                          const MCInstrInfo &MII,
                                          const MCRegisterInfo &MRI) {
  assert(SyntaxVariant == 0 && "WebAssembly only has one syntax variant");
  return new WebAssemblyInstPrinter(MAI, MII, MRI);
}

static MCCodeEmitter *createCodeEmitter(const MCInstrInfo &MCII,
                                        const MCRegisterInfo & /*MRI*/,
                                        MCContext & /*Ctx*/) {
  return createWebAssemblyMCCodeEmitter(MCII);
}

static MCAsmBackend *createAsmBackend(const Target & /*T*/,
                                      const MCRegisterInfo & /*MRI*/,
                                      const Triple &TT, StringRef /*CPU*/) {
  return createWebAssemblyAsmBackend(TT);
}

static MCSubtargetInfo *createMCSubtargetInfo(const Triple &TT, StringRef CPU,
                                              StringRef FS) {
  return createWebAssemblyMCSubtargetInfoImpl(TT, CPU, FS);
}

static MCTargetStreamer *
createObjectTargetStreamer(MCStreamer &S, const MCSubtargetInfo & /*STI*/) {
  return new WebAssemblyTargetELFStreamer(S);
}

static MCTargetStreamer *createAsmTargetStreamer(MCStreamer &S,
                                                 formatted_raw_ostream &OS,
                                                 MCInstPrinter * /*InstPrint*/,
                                                 bool /*isVerboseAsm*/) {
  return new WebAssemblyTargetAsmStreamer(S, OS);
}

// Force static initialization.
extern "C" void LLVMInitializeWebAssemblyTargetMC() {
  for (Target *T : {&TheWebAssemblyTarget32, &TheWebAssemblyTarget64}) {
    // Register the MC asm info.
    RegisterMCAsmInfoFn X(*T, createMCAsmInfo);

    // Register the MC instruction info.
    TargetRegistry::RegisterMCInstrInfo(*T, createMCInstrInfo);

    // Register the MC codegen info.
    TargetRegistry::RegisterMCCodeGenInfo(*T, createMCCodeGenInfo);

    // Register the MC register info.
    TargetRegistry::RegisterMCRegInfo(*T, createMCRegisterInfo);

    // Register the MCInstPrinter.
    TargetRegistry::RegisterMCInstPrinter(*T, createMCInstPrinter);

    // Register the MC code emitter.
    TargetRegistry::RegisterMCCodeEmitter(*T, createCodeEmitter);

    // Register the ASM Backend.
    TargetRegistry::RegisterMCAsmBackend(*T, createAsmBackend);

    // Register the MC subtarget info.
    TargetRegistry::RegisterMCSubtargetInfo(*T, createMCSubtargetInfo);

    // Register the object target streamer.
    TargetRegistry::RegisterObjectTargetStreamer(*T,
                                                 createObjectTargetStreamer);
    // Register the asm target streamer.
    TargetRegistry::RegisterAsmTargetStreamer(*T, createAsmTargetStreamer);
  }
}
