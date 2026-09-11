pub mod Talpin.Reconstruction.Info {
    use Functor.map
    use Talpin.Data.Constraint
    use Talpin.Data.Subst
    use Talpin.Reconstruction.Info

    pub def toStrings(i: Info): List[String] = region local {
        use ToString.toString;
        let {
            exp,
            tpe,
            effect,
            binders,
            preEffTpe,
            preEffEffect,
            constraints,
            preEffSubst,
            preEffBinders,
            solvedSubst
        } = i;
        let l = MutList.empty(local);
        def add(title, content, start, end) = l |> MutList.push(Some((title, content, start, end)));
        def addOne(title, content) = l |> MutList.push(Some((title, List#{content}, "", "")));
        def addEmpty() = l |> MutList.push(None);
        addOne("Exp", exp |> toString);
        addOne("Type", tpe |> toString);
        addOne("Effect", effect |> toString);
        add("Binders", binders |> map(match (x, sigma) -> "${x}: ${sigma}") |> Vector.toList, "{", "}");
        addEmpty();
        addOne("(PreEff) Tpe", preEffTpe |> toString);
        addOne("(PreEff) Effect", preEffEffect |> toString);
        add("(PreEff) Constraints", constraints |> Constraint.toStrings, "{", "}");
        add("(PreEff) Subst", preEffSubst |> Subst.toStrings, "[", "]");
        add("(PreEff) Binders", preEffBinders |> map(match (x, sigma) -> "${x}: ${sigma}") |> Vector.toList, "{", "}");
        addEmpty();
        add("(Solved) Subst", solvedSubst |> Subst.toStrings, "[", "]");

        let maxFirst = l |> MutList.map(local, Option.map(match (x, _, _, _) -> String.length(x)) >> Option.getWithDefault(0)) |> MutList.maximum |> Option.getWithDefault(0);
        let indent = String.repeat(maxFirst+6, " ");
        l |> MutList.toList |> List.flatMap(line -> match line {
            case None => List#{""}
            case Some((title, content, start, end)) =>
                let paddedTitle = String.padRight(maxFirst+2, '.', title);
                match content {
                    case Nil => List#{"${paddedTitle}: ${start}${end}"}
                    case one :: Nil => List#{"${paddedTitle}: ${start}${one}${end}"}
                    case many => "${paddedTitle}: ${start}" :: map(String.concat(indent), many) ::: List#{String.concat(String.padLeft(maxFirst+2, ' ', ""), "  ${end}")}
                }
        })
    }
}
