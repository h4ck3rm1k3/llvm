//===- IntrinsicsAMDGPU.td - Defines AMDGPU intrinsics -----*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the R600-specific intrinsics.
//
//===----------------------------------------------------------------------===//

class AMDGPUReadPreloadRegisterIntrinsic<string name>
  : Intrinsic<[llvm_i32_ty], [], [IntrNoMem]>,
    GCCBuiltin<name>;

let TargetPrefix = "r600" in {

multiclass AMDGPUReadPreloadRegisterIntrinsic_xyz<string prefix> {
  def _x : AMDGPUReadPreloadRegisterIntrinsic<!strconcat(prefix, "_x")>;
  def _y : AMDGPUReadPreloadRegisterIntrinsic<!strconcat(prefix, "_y")>;
  def _z : AMDGPUReadPreloadRegisterIntrinsic<!strconcat(prefix, "_z")>;
}

defm int_r600_read_global_size : AMDGPUReadPreloadRegisterIntrinsic_xyz <
                                       "__builtin_r600_read_global_size">;
defm int_r600_read_local_size : AMDGPUReadPreloadRegisterIntrinsic_xyz <
                                       "__builtin_r600_read_local_size">;
defm int_r600_read_ngroups : AMDGPUReadPreloadRegisterIntrinsic_xyz <
                                       "__builtin_r600_read_ngroups">;
defm int_r600_read_tgid : AMDGPUReadPreloadRegisterIntrinsic_xyz <
                                       "__builtin_r600_read_tgid">;
defm int_r600_read_tidig : AMDGPUReadPreloadRegisterIntrinsic_xyz <
                                       "__builtin_r600_read_tidig">;

def int_r600_rat_store_typed :
  // 1st parameter: Data
  // 2nd parameter: Index
  // 3rd parameter: Constant RAT ID
  Intrinsic<[], [llvm_v4i32_ty, llvm_v4i32_ty, llvm_i32_ty], []>,
  GCCBuiltin<"__builtin_r600_rat_store_typed">;

def int_r600_rsq : Intrinsic<
  [llvm_anyfloat_ty], [LLVMMatchType<0>], [IntrNoMem]
>;

def int_r600_read_workdim : AMDGPUReadPreloadRegisterIntrinsic <
  "__builtin_r600_read_workdim"
>;

} // End TargetPrefix = "r600"

// FIXME: These should be renamed/moved to r600
let TargetPrefix = "AMDGPU" in {
def int_AMDGPU_ldexp : Intrinsic<
  [llvm_anyfloat_ty], [LLVMMatchType<0>, llvm_i32_ty], [IntrNoMem]
>;
}

let TargetPrefix = "amdgcn" in {

defm int_amdgcn_workitem_id : AMDGPUReadPreloadRegisterIntrinsic_xyz <
  "__builtin_amdgcn_workitem_id">;
defm int_amdgcn_workgroup_id : AMDGPUReadPreloadRegisterIntrinsic_xyz <
  "__builtin_amdgcn_workgroup_id">;

def int_amdgcn_s_barrier : GCCBuiltin<"__builtin_amdgcn_s_barrier">,
  Intrinsic<[], [], [IntrConvergent]>;

def int_amdgcn_div_scale : Intrinsic<
  // 1st parameter: Numerator
  // 2nd parameter: Denominator
  // 3rd parameter: Constant to select select between first and
  //                second. (0 = first, 1 = second).
  [llvm_anyfloat_ty, llvm_i1_ty],
  [LLVMMatchType<0>, LLVMMatchType<0>, llvm_i1_ty],
  [IntrNoMem]
>;

def int_amdgcn_div_fmas : Intrinsic<[llvm_anyfloat_ty],
  [LLVMMatchType<0>, LLVMMatchType<0>, LLVMMatchType<0>, llvm_i1_ty],
  [IntrNoMem]
>;

def int_amdgcn_div_fixup : Intrinsic<[llvm_anyfloat_ty],
  [LLVMMatchType<0>, LLVMMatchType<0>, LLVMMatchType<0>],
  [IntrNoMem]
>;

def int_amdgcn_trig_preop : Intrinsic<
  [llvm_anyfloat_ty], [LLVMMatchType<0>, llvm_i32_ty], [IntrNoMem]
>;

def int_amdgcn_sin : Intrinsic<
  [llvm_anyfloat_ty], [LLVMMatchType<0>], [IntrNoMem]
>;

def int_amdgcn_cos : Intrinsic<
  [llvm_anyfloat_ty], [LLVMMatchType<0>], [IntrNoMem]
>;

def int_amdgcn_log_clamp : Intrinsic<
  [llvm_anyfloat_ty], [LLVMMatchType<0>], [IntrNoMem]
>;

def int_amdgcn_rcp : Intrinsic<
  [llvm_anyfloat_ty], [LLVMMatchType<0>], [IntrNoMem]
>;

def int_amdgcn_rsq :  Intrinsic<
  [llvm_anyfloat_ty], [LLVMMatchType<0>], [IntrNoMem]
>;

def int_amdgcn_rsq_clamp : Intrinsic<
  [llvm_anyfloat_ty], [LLVMMatchType<0>], [IntrNoMem]>;

def int_amdgcn_ldexp : Intrinsic<
  [llvm_anyfloat_ty], [LLVMMatchType<0>, llvm_i32_ty], [IntrNoMem]
>;

def int_amdgcn_class : Intrinsic<
  [llvm_i1_ty], [llvm_anyfloat_ty, llvm_i32_ty], [IntrNoMem]
>;

def int_amdgcn_cubeid : GCCBuiltin<"__builtin_amdgcn_cubeid">,
  Intrinsic<[llvm_float_ty],
    [llvm_float_ty, llvm_float_ty, llvm_float_ty], [IntrNoMem]
>;

def int_amdgcn_cubema : GCCBuiltin<"__builtin_amdgcn_cubema">,
  Intrinsic<[llvm_float_ty],
  [llvm_float_ty, llvm_float_ty, llvm_float_ty], [IntrNoMem]
>;

def int_amdgcn_cubesc : GCCBuiltin<"__builtin_amdgcn_cubesc">,
  Intrinsic<[llvm_float_ty],
    [llvm_float_ty, llvm_float_ty, llvm_float_ty], [IntrNoMem]
>;

def int_amdgcn_cubetc : GCCBuiltin<"__builtin_amdgcn_cubetc">,
  Intrinsic<[llvm_float_ty],
    [llvm_float_ty, llvm_float_ty, llvm_float_ty], [IntrNoMem]
>;

class AMDGPUImageLoad : Intrinsic <
  [llvm_v4f32_ty],    // vdata(VGPR)
  [llvm_anyint_ty,    // vaddr(VGPR)
   llvm_v8i32_ty,     // rsrc(SGPR)
   llvm_i32_ty,       // dmask(imm)
   llvm_i1_ty,        // r128(imm)
   llvm_i1_ty,        // da(imm)
   llvm_i1_ty,        // glc(imm)
   llvm_i1_ty],       // slc(imm)
  [IntrReadMem]>;

def int_amdgcn_image_load : AMDGPUImageLoad;
def int_amdgcn_image_load_mip : AMDGPUImageLoad;

class AMDGPUImageStore : Intrinsic <
  [],
  [llvm_v4f32_ty,     // vdata(VGPR)
   llvm_anyint_ty,    // vaddr(VGPR)
   llvm_v8i32_ty,     // rsrc(SGPR)
   llvm_i32_ty,       // dmask(imm)
   llvm_i1_ty,        // r128(imm)
   llvm_i1_ty,        // da(imm)
   llvm_i1_ty,        // glc(imm)
   llvm_i1_ty],       // slc(imm)
  []>;

def int_amdgcn_image_store : AMDGPUImageStore;
def int_amdgcn_image_store_mip : AMDGPUImageStore;

def int_amdgcn_read_workdim : AMDGPUReadPreloadRegisterIntrinsic <
  "__builtin_amdgcn_read_workdim">;


def int_amdgcn_buffer_wbinvl1_sc :
  GCCBuiltin<"__builtin_amdgcn_buffer_wbinvl1_sc">,
  Intrinsic<[], [], []>;

def int_amdgcn_buffer_wbinvl1 :
  GCCBuiltin<"__builtin_amdgcn_buffer_wbinvl1">,
  Intrinsic<[], [], []>;

def int_amdgcn_s_dcache_inv :
  GCCBuiltin<"__builtin_amdgcn_s_dcache_inv">,
  Intrinsic<[], [], []>;

def int_amdgcn_dispatch_ptr :
  GCCBuiltin<"__builtin_amdgcn_dispatch_ptr">,
  Intrinsic<[LLVMQualPointerType<llvm_i8_ty, 2>], [], [IntrNoMem]>;

// __builtin_amdgcn_interp_p1 <i>, <attr_chan>, <attr>, <m0>
def int_amdgcn_interp_p1 :
  GCCBuiltin<"__builtin_amdgcn_interp_p1">,
  Intrinsic<[llvm_float_ty],
            [llvm_i32_ty, llvm_i32_ty, llvm_i32_ty, llvm_i32_ty],
            [IntrNoMem]>;  // This intrinsic reads from lds, but the memory
                           // values are constant, so it behaves like IntrNoMem.

// __builtin_amdgcn_interp_p2 <p1>, <j>, <attr_chan>, <attr>, <m0>
def int_amdgcn_interp_p2 :
  GCCBuiltin<"__builtin_amdgcn_interp_p2">,
  Intrinsic<[llvm_float_ty],
            [llvm_float_ty, llvm_i32_ty, llvm_i32_ty, llvm_i32_ty, llvm_i32_ty],
            [IntrNoMem]>;  // See int_amdgcn_v_interp_p1 for why this is
                           // IntrNoMem.

def int_amdgcn_mbcnt_lo :
  GCCBuiltin<"__builtin_amdgcn_mbcnt_lo">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], [IntrNoMem]>;

def int_amdgcn_mbcnt_hi :
  GCCBuiltin<"__builtin_amdgcn_mbcnt_hi">,
  Intrinsic<[llvm_i32_ty], [llvm_i32_ty, llvm_i32_ty], [IntrNoMem]>;

//===----------------------------------------------------------------------===//
// CI+ Intrinsics
//===----------------------------------------------------------------------===//

def int_amdgcn_s_dcache_inv_vol :
  GCCBuiltin<"__builtin_amdgcn_s_dcache_inv_vol">,
  Intrinsic<[], [], []>;

def int_amdgcn_buffer_wbinvl1_vol :
  GCCBuiltin<"__builtin_amdgcn_buffer_wbinvl1_vol">,
  Intrinsic<[], [], []>;

//===----------------------------------------------------------------------===//
// VI Intrinsics
//===----------------------------------------------------------------------===//

// llvm.amdgcn.mov.dpp.i32 <src> <dpp_ctrl> <bound_ctrl> <bank_mask> <row_mask>
def int_amdgcn_mov_dpp :
  Intrinsic<[llvm_anyint_ty],
            [LLVMMatchType<0>, llvm_i32_ty, llvm_i1_ty, llvm_i32_ty,
             llvm_i32_ty], [IntrNoMem, IntrConvergent]>;

def int_amdgcn_s_dcache_wb :
  GCCBuiltin<"__builtin_amdgcn_s_dcache_wb">,
  Intrinsic<[], [], []>;

def int_amdgcn_s_dcache_wb_vol :
  GCCBuiltin<"__builtin_amdgcn_s_dcache_wb_vol">,
  Intrinsic<[], [], []>;

}
