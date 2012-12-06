require 'helper_for_test'

class TestCommand < ::MiniTest::Unit::TestCase
  def test_min_max
    str = <<-EOS
4 5 6
1 2 3
3 2 4
    EOS
    assert_equal(["1.0/4.0", "2.0/5.0", "3.0/6.0"], ::CmdTools::Command::MinMax.run(str, '/'))
  end
end
