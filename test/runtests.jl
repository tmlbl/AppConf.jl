using AppConf, Base.Test

@dev x = "dev"
@prod x = "prod"
@test x == "dev"

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

@show conf["arr"]
@test length(conf["arr"]) == 4
@test conf["arr"][1] == "foo"
@test conf["arr"][2] == "bar"
@test conf["arr"][4] == 7

@test conf["vals"][1] == "one"
@test conf["vals"][2] == 2
@test conf["vals"][3] == "three"
@test conf["white.space"] == ["Hi", 42, "Hello", 111]

@show conf
