module AppConf

export @dev,
       @prod,
       conf,
       parseconf

if !haskey(ENV, "JULIA_ENV")
  ENV["JULIA_ENV"] = "dev"
end

macro dev(e)
  if ENV["JULIA_ENV"] == "dev"
    return esc(e)
  end
end

macro prod(e)
  if ENV["JULIA_ENV"] == "prod"
    return esc(e)
  end
end

conf = Dict{String,Any}()

function findeq(ln::String)
  for i = 1:length(ln)
    if ln[i] == '='
      return i
    end
  end
  return -1
end

function stripcomments(ln::String)
  ret = ""
  for c in ln
    if c == '#'
      break
    end
    ret = string(ret, c)
  end
  ret
end

function parseconf(file::String)
  f = open(file)
  inquotes = false
  while !eof(f)
    ln = stripcomments(readline(f))
    ix = findeq(ln)
    if ix == -1
      continue
    end
    key = ln[1:ix - 1]
    val = strip(chomp(ln[ix + 1:end]))
    if isnumber(val) || val == "true" || val == "false"
      conf[key] = parse(val)
    else
      conf[key] = strip(val, '"')
    end
    if key == "env"
      ENV["JULIA_ENV"] = strip(val, '"')
    end
  end
end

end # module
