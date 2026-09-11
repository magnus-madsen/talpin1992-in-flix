pub mod Talpin.RunFile {
    use Talpin.FreshName
    use Talpin.Reconstruction
    use Talpin.EffectSolver
    use Talpin.Data.Subst
    use Sys.Env
    pub def checkFileArg(): Result[RichString, Unit] \ IO + Fs.FileRead =
        run {
            match Env.getArgs() {
                case path :: Nil => checkFile(path)
                case _ => println("expects one path argument")
            }
        }
        with Env.runWithIO
        with Abort.runWithResult

    pub def checkFile(path: String): Unit \ IO + Fs.FileRead =
        run checkFileEff(path)
        with handler Abort {
            def abort(m, _k) = println(m)
        }

    pub def checkFileEff(path: String): Unit \ IO + Abort + Fs.FileRead = {
        let input = Fs.FileRead.read(path) |> Result.getOrAbort;
        let p =
            run Talpin.Parsing.Parser.parse(input)
            with handler Abort {
                def abort(m, _k) = Abort.abort(Formattable.format("Parsing Error: ${m}"))
            };
        let info =
            run Reconstruction.reconstructInfo(p)
            with FreshName.runWithState
            with handler Abort {
                def abort(m, _k) = Abort.abort(Formattable.format("Typer Error: ${m}"))
            } with handler KeyNotFound {
                def keyNotFound(msg, _k) = Abort.abort(Formattable.format("Typer Error: ${msg}"))
            };
        info |> Reconstruction.Info.toStrings |> List.forEach(println)
    }

}
