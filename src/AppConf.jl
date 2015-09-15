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

# cleanstring(str::String) = strip(strip(string), '"')

function cleanstring(str::String)
  s = strip(str)
  strip(s, '"')
end

function isnumeric(str::String)
  is = true
  dots = 0
  for c in cleanstring(str)
    if c == '.'
      dots += 1
    end
    if c != '.' && !isdigit(c)
      is = false
    end
  end
  if dots > 1
    is = false
  end
  is
end

islist(str::String) = str[1] == '[' && str[length(str)] == ']'

parselist(str::String) = map((x) -> isnumeric(x) ? parse(x) : cleanstring(x),
    split(match(r"\[(.*)\]", str).captures[1], ","))

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
    if isnumeric(val) || val == "true" || val == "false"
      conf[key] = parse(val)
    elseif islist(val)
      conf[key] = parselist(val)
    else
      conf[key] = cleanstring(val)
    end
    if key == "env"
      ENV["JULIA_ENV"] = strip(val, '"')
    end
  end
end

end # module
