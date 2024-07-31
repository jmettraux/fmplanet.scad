
#
# test.rb

def red(s); "\e[31m#{s}\e[0m"; end
def green(s); "\e[32m#{s}\e[0m"; end

def test(message, opts, &block)

  print("#{message} #{opts.inspect} ")

  o = opts[:o]
  r = block.call(opts)

  if r == o
    puts green('OK')
  else
    print red('NG'); puts " #{r.inspect} != #{o.inspect}"
  end

rescue => err
  print red('ERR'); puts " #{err.to_s}"
  err.backtrace.each { |t| puts "  #{t}" }
end

$: << '.'
require 'lib/tile'
$tile = Tile.new

#       a0  b0  c0  d0
#
#     a1  b1  c1  d1  e1
#
#   a2  b2  c2  d2  e2  f2
#
# a3  b3  c3  d3  e3  f3  g3
#
#   b4  c4  d4  e4  f4  g4
#
#     c5  d5  e5  f5  g5
#
#       d6  e6  f6  g6

puts
test("Hex#e", k: :a0, o: 'b0') { |os| $tile[os[:k]].e.key }
test("Hex#e", k: :f3, o: :g3) { |os| $tile[os[:k]].e.key }
test("Hex#e", k: :g3, o: nil) { |os| $tile[os[:k]].e }
puts


