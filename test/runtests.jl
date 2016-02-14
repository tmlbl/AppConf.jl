using AppConf, Base.Test

@dev x = "dev"
@prod x = "prod"
@test x == "dev"

ENV["VAR"] = "foo"

parseconf("sample.conf")

@dev x = "dev"
@prod x = "prod"
@test x == "prod"

@test conf["test.param"] == "foo=bar"
@test conf["baz.dot"] == "bar"
@test conf["num"] == 34
@test conf["bool"] == false
@test conf["pi"] == 3.14
@test conf["ip"] == "192.168.31.12"

@test length(conf["arr"]) == 4
@test conf["arr"][1] == "foo"
@test conf["arr"][2] == "bar"
@test conf["arr"][4] == 7

@test conf["vals"][1] == "one"
@test conf["vals"][2] == 2
@test conf["vals"][3] == "three"

#tuples
@test conf["tvals"][1] == "one"
@test conf["tvals"][2] == 2
@test conf["tvals"][3] == "three"

@test conf["white.space"] == ["Hi", 42, "Hello", 111]

@test conf["var"] == "foo/bar"
@test conf["ρ"] == 4
@test conf["γ"] == 1.667
@test conf["V₁"] == 3

@test parseconf("foo.conf")["template"] == true

@test_throws ErrorException parseconf("bar.conf")
