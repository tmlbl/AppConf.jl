using AppConf, Base.Test

@dev x = "dev"
@prod x = "prod"
@test x == "dev"

parseconf("sample.conf")

@dev x = "dev"
@prod x = "prod"
@test x == "prod"

@test conf["test.param"] == "foo"
@test conf["baz.dot"] == "bar"
@test conf["num"] == 34
@test conf["bool"] == false

@show conf
