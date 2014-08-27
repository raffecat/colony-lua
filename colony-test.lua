function tap (n) print('1..' .. tostring(n)); end
function ok (cond, why) if not cond then io.write('not '); end print('ok - ' .. tostring(why)); end

tap(13)

ok(tostring(0/0) == 'NaN', 'nan is NaN not nan')
ok((not 0) == true, '0 is falsy')
ok((not "") == true, '"" is falsy')
ok(tonumber(true) == 1, 'can cast boolean to number')
ok((0 or 1) == 1, 'shortcut 0 in boolean operator')
ok(debug.getinfo(function (b, c, d) end, 'u').nparams == 3, 'nparams implemented')

local a = {}
setmetatable(a, { __tovalue = function () return 5; end })
ok(a + 5 == 10, 'can arithmetic objects with __tovalue in arith')

debug.setmetatable(nil, {__lt = function () return true; end })
ok(nil < 5, 'nil comparsions allowed')

debug.setmetatable(0, {__lt = function () return true; end })
debug.setmetatable('', {__lt = function () return true; end })
ok(5 < '6', 'comparison between differing types works')

local a = {}
a['5'] = 1
a[5] = 2
ok(a['5'] == 2, 'numerical keys are converted')
a['nan'] = 1
a['-nan'] = 1
ok(true, 'nan and -nan are allowed')
a['inf'] = 1
a['-inf'] = 1
ok(true, 'inf and -inf are allowed')
a['00'] = 1
a[0] = 2
ok(a['00'] == 1, 'numbers with leading 0 are parsed fully for numericness')

-- ECMAScript number-string interaction tests

-- expected output is based on node.js 0.10.30 (change ~= to != in tests)
-- function eq (a, b, why) { console.log((a !== b ? 'not ' : 'ok - ') + why); }

-- eq function will work even if == coerces types
function eq (a, b, why)
  local isok, res = pcall(a)
  if isok then
    ok(type(res) == type(b) and res == b, why)
  else
    print('not ok - '..why..': '..res)
  end
end

eq(function() return 5+2 end, 7, 'number + number = number')
eq(function() return 5-2 end, 3,   'number - number = number')
eq(function() return 5*2 end, 10,  'number * number = number')
eq(function() return 5/2 end, 2.5, 'number / number = number')
eq(function() return 5%2 end, 1,   'number % number = number')

eq(function() return 5+"2" end, '52', 'number + string = string')
eq(function() return 5-"2" end, 3,    'number - string = number')
eq(function() return 5*"2" end, 10,   'number * string = number')
eq(function() return 5/"2" end, 2.5,  'number / string = number')
eq(function() return 5%"2" end, 1,    'number % string = number')

eq(function() return -("5") end, -5, '- string = number')

eq(function() return "5"+2 end, '52', 'string + number = string')
eq(function() return "5"-2 end, 3,    'string - number = number')
eq(function() return "5"*2 end, 10,   'string * number = number')
eq(function() return "5"/2 end, 2.5,  'string / number = number')
eq(function() return "5"%2 end, 1,    'string % number = number')

eq(function() return 1==2 end, false, 'number == number when not equal')
eq(function() return 2==2 end, true,  'number == number when equal')
eq(function() return 1~=2 end, true,  'number ~= number when not equal')
eq(function() return 2~=2 end, false, 'number ~= number when equal')
eq(function() return 1<2 end, true,  'number < number when number less')
eq(function() return 2<2 end, false, 'number < number when number equal')
eq(function() return 3<2 end, false, 'number < number when number greater')
eq(function() return 1<=2 end, true,  'number <= number when number less')
eq(function() return 2<=2 end, true,  'number <= number when number equal')
eq(function() return 3<=2 end, false, 'number <= number when number greater')
eq(function() return 1>2 end, false, 'number > number when number less')
eq(function() return 2>2 end, false, 'number > number when number equal')
eq(function() return 3>2 end, true,  'number > number when number greater')
eq(function() return 1>=2 end, false, 'number >= number when number less')
eq(function() return 2>=2 end, true,  'number >= number when number equal')
eq(function() return 3>=2 end, true,  'number >= number when number greater')

eq(function() return 1=="2" end, false, 'number == string when not equal')
eq(function() return 2=="2" end, true,  'number == string when equal')
eq(function() return 1~="2" end, true,  'number ~= string when not equal')
eq(function() return 2~="2" end, false, 'number ~= string when equal')
eq(function() return 1<"2" end, true,  'number < string when number less')
eq(function() return 2<"2" end, false, 'number < string when number equal')
eq(function() return 3<"2" end, false, 'number < string when number greater')
eq(function() return 1<="2" end, true,  'number <= string when number less')
eq(function() return 2<="2" end, true,  'number <= string when number equal')
eq(function() return 3<="2" end, false, 'number <= string when number greater')
eq(function() return 1>"2" end, false, 'number > string when number less')
eq(function() return 2>"2" end, false, 'number > string when number equal')
eq(function() return 3>"2" end, true,  'number > string when number greater')
eq(function() return 1>="2" end, false, 'number >= string when number less')
eq(function() return 2>="2" end, true,  'number >= string when number equal')
eq(function() return 3>="2" end, true,  'number >= string when number greater')

eq(function() return "1"==2 end, false, 'number == string when not equal')
eq(function() return "2"==2 end, true,  'number == string when equal')
eq(function() return "1"~=2 end, true,  'number ~= string when not equal')
eq(function() return "2"~=2 end, false, 'number ~= string when equal')
eq(function() return "1"<2 end, true,  'number < string when number less')
eq(function() return "2"<2 end, false, 'number < string when number equal')
eq(function() return "3"<2 end, false, 'number < string when number greater')
eq(function() return "1"<=2 end, true,  'number <= string when number less')
eq(function() return "2"<=2 end, true,  'number <= string when number equal')
eq(function() return "3"<=2 end, false, 'number <= string when number greater')
eq(function() return "1">2 end, false, 'number > string when number less')
eq(function() return "2">2 end, false, 'number > string when number equal')
eq(function() return "3">2 end, true,  'number > string when number greater')
eq(function() return "1">=2 end, false, 'number >= string when number less')
eq(function() return "2">=2 end, true,  'number >= string when number equal')
eq(function() return "3">=2 end, true,  'number >= string when number greater')

-- ECMAScript === vs == equality

-- colonize.js does this: var infixops = { '!==': '~=', '!=': '~=', '===': '==' };
-- TODO: implement both kinds of equality in the runtime.
