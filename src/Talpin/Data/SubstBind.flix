mod Talpin.Data.SubstBind {
    use Talpin.Data.Subst
    use Talpin.Data.Type
    use Talpin.Data.Reg
    use Talpin.Data.Effect
    use Talpin.Data.TVar
    use Talpin.Data.RVar
    use Talpin.Data.EVar

    pub trait SubstBind[t] {
        type Value: Type
        pub def bind(k: t, v: SubstBind.Value[t], s: Subst): Subst
    }

    instance SubstBind[TVar] {
        type Value = Type
        pub def bind(x: TVar, t: Type, s: Subst): Subst = Subst.bindTVar(x, t, s)
    }

    instance SubstBind[RVar] {
        type Value = Reg
        pub def bind(x: RVar, p: Reg, s: Subst): Subst = Subst.bindRVar(x, p, s)
    }

    instance SubstBind[EVar] {
        type Value = Effect
        pub def bind(x: EVar, effect: Effect, s: Subst): Subst = Subst.bindEVar(x, effect, s)
    }

    pub def bindAll(l: List[(k, v)], s: Subst): Subst with SubstBind[k] where SubstBind.Value[k] ~ v =
        (s, l) ||> List.foldLeft(acc -> match (x, t) -> SubstBind.bind(x, t, acc))

}
