Require Import Basics Types ReflectiveSubuniverse Pointed.Core.

Local Open Scope pointed_scope.

(** * Modalities and pointed types *)

Global Instance ispointed_O `{O : ReflectiveSubuniverse} (X : Type)
  `{IsPointed X} : IsPointed (O X) := to O _ (point X).

Definition pto (O : ReflectiveSubuniverse@{u}) (X : pType@{u})
  : X ->* [O X, _]
  := Build_pMap X [O X, _] (to O X) idpath.

(** If [A] is already [O]-local, then Coq knows that [pto] is an equivalence, so we can simply define: *)
Definition pequiv_pto `{O : ReflectiveSubuniverse} {X : pType} `{In O X}
  : X <~>* [O X, _] := Build_pEquiv _ _ (pto O X) _.

(** Applying [O_rec] to a pointed map yields a pointed map. *)
Definition pO_rec `{O : ReflectiveSubuniverse} {X Y : pType}
  `{In O Y} (f : X ->* Y) : [O X, _] ->* Y
  := Build_pMap [O X, _] _ (O_rec f) (O_rec_beta _ _ @ point_eq f).

Definition pO_rec_beta `{O : ReflectiveSubuniverse} {X Y : pType}
  `{In O Y} (f : X ->* Y)
  : pO_rec f o* pto O X ==* f.
Proof.
  srapply Build_pHomotopy.
  1: nrapply O_rec_beta.
  cbn.
  apply moveL_pV.
  exact (concat_1p _)^.
Defined.

(** ** Pointed functoriality *)

Definition O_pfunctor `(O : ReflectiveSubuniverse) {X Y : pType}
  (f : X ->* Y) : [O X, _] ->* [O Y, _]
  := pO_rec (pto O Y o* f).

(** Coq knows that [O_pfunctor O f] is an equivalence whenever [f] is. *)
Definition equiv_O_pfunctor `(O : ReflectiveSubuniverse) {X Y : pType}
  (f : X ->* Y) `{IsEquiv _ _ f} : [O X, _] <~>* [O Y, _]
  := Build_pEquiv _ _ (O_pfunctor O f) _.

(** Pointed naturality of [O_pfunctor]. *)
Definition pto_O_natural `(O : ReflectiveSubuniverse) {X Y : pType}
  (f : X ->* Y) : O_pfunctor O f o* pto O X ==* pto O Y o* f.
Proof.
  nrapply pO_rec_beta.
Defined.
