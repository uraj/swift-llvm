; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-unknown -mattr=+avx < %s | FileCheck %s

declare { i8, double } @fun()

; Check that this does not fail to combine concat_vectors of a value from
; merge_values through a bitcast.
define void @d(i1 %cmp) {
; CHECK-LABEL: d:
; CHECK:       # %bb.0: # %bar
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq fun
bar:
  %val = call { i8, double } @fun()
  %extr = extractvalue { i8, double } %val, 1
  %bc = bitcast double %extr to <2 x float>
  br label %baz

baz:
  %extr1 = extractelement <2 x float> %bc, i64 0
  unreachable
}
