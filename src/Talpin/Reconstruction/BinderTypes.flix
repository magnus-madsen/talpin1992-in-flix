pub mod Talpin.Reconstruction.BinderTypes {
    use Talpin.Data.Type
    use Talpin.Data.TyScheme
    use Talpin.Reconstruction.BinderTypes

    pub def handleWithNothing(f: a -> b \ ef): a -> b \ ef - BinderTypes =
        x -> runWithNothing(() -> f(x))

    pub def runWithNothing(f: Unit -> b \ ef): b \ ef - BinderTypes =
        run f() with handler BinderTypes { def typed(_x, _t, k) = k() }

    pub def handleWithList(f: a -> b \ ef): a -> (b, Vector[(String, TyScheme)]) \ ef - BinderTypes =
        x -> runWithList(() -> f(x))

    pub def runWithList(f: Unit -> b \ ef): (b, Vector[(String, TyScheme)]) \ ef - BinderTypes =
        region local {
            let types = MutList.empty(local);
            run {
                (f(), MutList.toVector(types))
            } with handler BinderTypes {
                def typed(x, t, k) = {
                    MutList.push((x, t), types);
                    k()
                }
            }
        }
}
