isdefined(Base, :__precompile__) && __precompile__(true)

module AppConf

using Compat

export @dev,
       @prod,
       conf,
       parseconf

function __init__()
  if !haskey(ENV, "JULIA_ENV")
    ENV["JULIA_ENV"] = "dev"
  end
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

function findeq(ln::AbstractString)
    for i = 1:length(ln)
        c = chr2ind(ln, i);
        if ln[c] == '='
            return c
        end
    end
    return -1
end

function stripcomments(ln::AbstractString)
  ret = ""
  for c in ln
    if c == '#'
      break
    end
    ret = string(ret, c)
  end
  ret
end

function evalEnv(ln::AbstractString)
  nln = ln
  for v in matchall(r"\$[A-Z|_|-]+", ln)
    vname = replace(v, "\$", "")
    nln = replace(nln, v, ENV[vname])
  end
  nln
end

function cleanstring(str::AbstractString)
  s = strip(str)
  strip(s, '"')
end

function isnumeric(str::AbstractString)
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

islist(str::AbstractString) = str[1] == '[' && str[length(str)] == ']'
istuple(str::AbstractString) = str[1] == '(' && str[length(str)] == ')'

parselist(str::AbstractString) = map((x) -> isnumeric(x) ? parse(x) : cleanstring(x),
    split(match(r"\[(.*)\]", str).captures[1], ","))

function parsetuple(str::AbstractString)
    res = map((x) -> isnumeric(x) ? parse(x) : cleanstring(x),
        split(match(r"\((.*)\)", str).captures[1], ","))
    return ntuple((i) -> res[i], length(res))
end

function parseconf(file::AbstractString)
  file = abspath(file)
  tpath = abspath("$file.template")
  if !isfile(file)
    if isfile(tpath)
      warn("No file found at $file, using template at $tpath")
      file = tpath
    else
      error("No file found at $file")
    end
  end

  f = open(file)
  inquotes = false
    if !isdefined(:conf)
        conf = Dict{AbstractString, Any}()
    end
  while !eof(f)
    ln = evalEnv(stripcomments(readline(f)))
    ix = findeq(ln)
    if ix == -1
      continue
    end
    key = strip(ln[1:ix - 1])
    val = strip(chomp(ln[ix + 1:end]))
    if isnumeric(val) || val == "true" || val == "false"
      conf[key] = parse(val)
    # Handle single-line lists
    elseif islist(val)
      conf[key] = parselist(val)
    # Handle single-line lists
    elseif istuple(val)
      conf[key] = parsetuple(val)
    # Parse multi-line lists
    elseif val[1] == '['
      # Base case: first line
      curLn = val
      s = IOBuffer()
      while length(curLn) == 0 || curLn[end] != ']'
        println(s, curLn)
        eof(f) && (error("Unexpected end of input: ", curLn))
        curLn = strip(readline(f))
      end
      println(s, curLn)
      lst = takebuf_string(s)
      # parse and eval may not be performance optimal.
      conf[key] = eval(parse(lst))
    else
      conf[key] = cleanstring(val)
    end
    if key == "env"
      ENV["JULIA_ENV"] = strip(val, '"')
    end
  end
  global conf = conf
  conf
end

end # module
