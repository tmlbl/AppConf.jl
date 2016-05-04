AppConf.jl
==========
[![Build Status](https://travis-ci.org/tmlbl/AppConf.jl.svg?branch=master)](https://travis-ci.org/tmlbl/AppConf.jl)

A simple configuration module for Julia applications. Implements a basic syntax
for a configuration file, and manages an environment variable `JULIA_ENV` to
manage code differences for development and production environments.

## Basic Configuration

When using AppConf, call `parseconf` with a path to your configuration file to
load it.

```julia
using AppConf

parseconf("app.conf")
```

Where `app.conf` contains basic name-value pairs:

```
log.level=DEBUG
app.secret="provoke-dance-surveillance-friend"
session.timeout=60
require.auth=false
```

Then, the global variable `conf` will be a dictionary populated with those items.

```julia
julia> conf
Dict{AbstractString,Any} with 4 entries:
  "require.auth"    => false
  "app.secret"      => "provoke-dance-surveillance-friend"
  "log.level"       => "DEBUG"
  "session.timeout" => 60
```

## Supported Values

Values will be interpreted as strings or numbers based on their structure.
Strings can optionally be in double quotes. Arrays are also supported with the
following syntax:

```
arr=["one", 2, three]
```

Is parsed into:

```julia
Dict{AbstractString,Any}("arr" => Any["one",2,"three"])
```

## Using JULIA_ENV

The variable `JULIA_ENV` is set to `"dev"` by default. It can be overridden by
setting its value in the system environment, or by setting `env` in the config
file. The macros `@dev` and `@prod` allow code blocks to be specified to compile
in only one environment.

```julia
@dev begin
  println("I'm on your laptop")
end
@prod begin
  println("I'm on your server")
end
```

## TODO

Support full [HOCON](http://getakka.net/docs/concepts/hocon) syntax to emulate TypeSafe config library.
