; RUN: opt -memcpyopt -S < %s | FileCheck %s

target datalayout = "e-i64:64-f80:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%S = type { i8*, i8, i32 }

define void @copy(%S* %src, %S* %dst) {
; CHECK-LABEL: copy
; CHECK-NOT: load
; CHECK: call void @llvm.memmove.p0i8.p0i8.i64
; CHECK-NEXT: ret void
  %1 = load %S, %S* %src
  store %S %1, %S* %dst
  ret void
}

define void @noaliassrc(%S* noalias %src, %S* %dst) {
; CHECK-LABEL: noaliassrc
; CHECK-NOT: load
; CHECK: call void @llvm.memcpy.p0i8.p0i8.i64
; CHECK-NEXT: ret void
  %1 = load %S, %S* %src
  store %S %1, %S* %dst
  ret void
}

define void @noaliasdst(%S* %src, %S* noalias %dst) {
; CHECK-LABEL: noaliasdst
; CHECK-NOT: load
; CHECK: call void @llvm.memcpy.p0i8.p0i8.i64
; CHECK-NEXT: ret void
  %1 = load %S, %S* %src
  store %S %1, %S* %dst
  ret void
}

define void @destroysrc(%S* %src, %S* %dst) {
; CHECK-LABEL: destroysrc
; CHECK: load %S, %S* %src
; CHECK: call void @llvm.memset.p0i8.i64
; CHECK-NEXT: store %S %1, %S* %dst
; CHECK-NEXT: ret void
  %1 = load %S, %S* %src
  store %S zeroinitializer, %S* %src
  store %S %1, %S* %dst
  ret void
}

define void @destroynoaliassrc(%S* noalias %src, %S* %dst) {
; CHECK-LABEL: destroynoaliassrc
; CHECK-NOT: load
; CHECK: call void @llvm.memcpy.p0i8.p0i8.i64
; CHECK-NEXT: call void @llvm.memset.p0i8.i64
; CHECK-NEXT: ret void
  %1 = load %S, %S* %src
  store %S zeroinitializer, %S* %src
  store %S %1, %S* %dst
  ret void
}

define void @copyalias(%S* %src, %S* %dst) {
; CHECK-LABEL: copyalias
; CHECK-NEXT: [[LOAD:%[a-z0-9\.]+]] = load %S, %S* %src
; CHECK-NOT: load
; CHECK: call void @llvm.memmove.p0i8.p0i8.i64
; CHECK-NEXT: store %S [[LOAD]], %S* %dst
; CHECK-NEXT: ret void
  %1 = load %S, %S* %src
  %2 = load %S, %S* %src
  store %S %1, %S* %dst
  store %S %2, %S* %dst
  ret void
}


; The GEP is present after the aliasing store, preventing to move the memcpy before
; (without further analysis/transformation)
define void @copyaliaswithproducerinbetween(%S* %src, %S* %dst) {
; CHECK-LABEL: copyalias
; CHECK-NEXT: [[LOAD:%[a-z0-9\.]+]] = load %S, %S* %src
; CHECK-NOT: call
  %1 = load %S, %S* %src
  store %S undef, %S* %dst
  %dst2 = getelementptr %S , %S* %dst, i64 1
  store %S %1, %S* %dst2
  ret void
}
