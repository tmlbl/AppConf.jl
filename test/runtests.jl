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

@show conf
