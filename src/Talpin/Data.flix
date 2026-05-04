mod Talpin.Data {
    use Talpin.Data.RefLoc
    use Talpin.Data.Value
    use Talpin.Data.Id
    use Talpin.Data.TyScheme

    pub type alias Id = String

    pub type alias RefLoc = Int32

    pub type alias Store = Map[RefLoc, Value]

    pub type alias TyEnv = Map[Id, TyScheme]
}
