mod Talpin.Data.SubstApp {
    use Talpin.Data.Subst
    use Talpin.Data.Type
    use Talpin.Data.Reg
    use Talpin.Data.Effect
    use Talpin.Data.TyScheme
    use Talpin.Data.Constraint
    use Talpin.Data.TVar
    use Talpin.Data.RVar
    use Talpin.Data.EVar

    pub trait SubstApp[t] {
        type Out: Type
        pub def app(s: Subst, x: t): SubstApp.Out[t]
    }

    instance SubstApp[TVar] {
        type Out = Type
        pub def app(s: Subst, x: TVar): Type = Subst.appTVar(s, x)
    }

    instance SubstApp[RVar] {
        type Out = Reg
        pub def app(s: Subst, x: RVar): Reg = Subst.appRVar(s, x)
    }

    instance SubstApp[EVar] {
        type Out = Effect
        pub def app(s: Subst, x: EVar): Effect = Subst.appEVar(s, x)
    }

    instance SubstApp[Reg] {
        type Out = Reg
        pub def app(s: Subst, x: Reg): Reg = Subst.appReg(s, x)
    }

    instance SubstApp[Type] {
        type Out = Type
        pub def app(s: Subst, x: Type): Type = Subst.appType(s, x)
    }

    instance SubstApp[Effect] {
        type Out = Effect
        pub def app(s: Subst, x: Effect): Effect = Subst.appEffect(s, x)
    }

    instance SubstApp[Constraint] {
        type Out = Constraint
        pub def app(s: Subst, x: Constraint): Constraint = Subst.appConstraint(s, x)
    }

    instance SubstApp[TyScheme] {
        type Out = TyScheme
        pub def app(s: Subst, x: TyScheme): TyScheme = Subst.appTyScheme(s, x)
    }

    instance SubstApp[Map[k, v]] with SubstApp[v] {
        type Out = Map[k, SubstApp.Out[v]]
        pub def app(s: Subst, x: Map[k, v]): Map[k, SubstApp.Out[v]] =
            Map.map(SubstApp.app(s), x)
    }

}
