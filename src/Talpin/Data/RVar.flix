mod Talpin.Data.RVar {
    use Coerce.coerce

    pub enum RVar(String) with Eq, Coerce, Order

    instance ToString[RVar] {
        pub def toString(x: RVar): String = RVar.toString(x)
    }

    pub def toString(x: RVar): String = coerce(x)

}
