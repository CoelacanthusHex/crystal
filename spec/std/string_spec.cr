require "./spec_helper"
require "spec/helpers/iterate"
require "../support/string"

describe "String" do
  describe "[]" do
    it "gets with positive index" do
      c = "hello!"[1]
      c.should be_a(Char)
      c.should eq('e')
    end

    it "gets with negative index" do
      "hello!"[-1].should eq('!')
    end

    it "gets with inclusive range" do
      "hello!"[1..4].should eq("ello")
    end

    it "gets with inclusive range with negative indices" do
      "hello!"[-5..-2].should eq("ello")
    end

    it "gets with exclusive range" do
      "hello!"[1...4].should eq("ell")
    end

    it "gets with start and count" do
      "hello"[1, 3].should eq("ell")
    end

    it "gets with exclusive range with unicode" do
      "há日本語"[1..3].should eq("á日本")
    end

    it "gets with range without end" do
      "há日本語"[1..nil].should eq("á日本語")
    end

    it "gets with range without beginning" do
      "há日本語"[nil..2].should eq("há日")
    end

    it "gets when index is last and count is zero" do
      "foo"[3, 0].should eq("")
    end

    it "gets when index is last and count is positive" do
      "foo"[3, 10].should eq("")
    end

    it "gets when index is last and count is negative at last" do
      expect_raises(ArgumentError) do
        "foo"[3, -1]
      end
    end

    it { "foo"[3..-10].should eq("") }

    it "gets when index is last and count is negative at last with utf-8" do
      expect_raises(ArgumentError) do
        "há日本語"[5, -1]
      end
    end

    it "gets when index is last and count is zero in utf-8" do
      "há日本語"[5, 0].should eq("")
    end

    it "gets when index is last and count is positive in utf-8" do
      "há日本語"[5, 10].should eq("")
    end

    it "raises IndexError if pointing after last char which is non-ASCII" do
      expect_raises(IndexError) do
        "ß"[1]
      end
    end

    it "raises index out of bound on index out of range with range" do
      expect_raises(IndexError) do
        "foo"[4..1]
      end
    end

    it "raises index out of bound on index out of range with range and utf-8" do
      expect_raises(IndexError) do
        "há日本語"[6..1]
      end
    end

    it "gets with exclusive with start and count" do
      "há日本語"[1, 3].should eq("á日本")
    end

    it "gets with exclusive with start and count to end" do
      "há日本語"[1, 4].should eq("á日本語")
    end

    it "gets with start and count with negative start" do
      "こんにちは"[-3, 2].should eq("にち")
    end

    it "raises if index out of bounds" do
      expect_raises(IndexError) do
        "foo"[4, 1]
      end
    end

    it "raises if index out of bounds with utf-8" do
      expect_raises(IndexError) do
        "こんにちは"[6, 1]
      end
    end

    it "raises if count is negative" do
      expect_raises(ArgumentError) do
        "foo"[1, -1]
      end
    end

    it "raises if count is negative with utf-8" do
      expect_raises(ArgumentError) do
        "こんにちは"[3, -1]
      end
    end

    it "gets with single char" do
      ";"[0..-2].should eq("")
    end

    it "raises on too negative left bound" do
      expect_raises IndexError do
        "foo"[-4..0]
      end
    end

    describe "with a regex" do
      it { "FooBar"[/o+/].should eq "oo" }
      it { "FooBar"[/([A-Z])/, 1].should eq "F" }
      it { "FooBar"[/x/]?.should be_nil }
      it { "FooBar"[/x/, 1]?.should be_nil }
      it { "FooBar"[/(x)/, 1]?.should be_nil }
      it { "FooBar"[/o(o)/, 2]?.should be_nil }
      it { "FooBar"[/o(?<this>o)/, "this"].should eq "o" }
      it { "FooBar"[/(?<this>x)/, "that"]?.should be_nil }
    end

    it "gets with a string" do
      "FooBar"["Bar"].should eq "Bar"
      expect_raises(Exception, "Nil assertion failed") { "FooBar"["Baz"] }
    end

    it "gets with a char" do
      expect_raises(Exception, "Nil assertion failed") { "foo/bar"['-'] }
    end
  end

  describe "[]?" do
    it "gets with a string" do
      "FooBar"["Bar"]?.should eq "Bar"
      "FooBar"["Baz"]?.should be_nil
    end

    it "gets with a char" do
      "foo/bar"['/'].should eq '/'
      expect_raises(Exception, "Nil assertion failed") { "foo/bar"['-'] }
      "foo/bar"['/']?.should eq '/'
      "foo/bar"['-']?.should be_nil
    end

    it "gets with index" do
      "hello"[1]?.should eq('e')
      "hello"[5]?.should be_nil
      "hello"[-1]?.should eq('o')
      "hello"[-6]?.should be_nil
    end

    it "returns nil if pointing after last char which is non-ASCII" do
      "ß"[1]?.should be_nil
    end

    it "gets with range" do
      "hello"[1..2]?.should eq "el"
      "hello"[6..-1]?.should be_nil
      "hello"[-6..-1]?.should be_nil
      "hello"[-6..]?.should be_nil
    end

    it "gets with start and count" do
      "hello"[1, 3]?.should eq("ell")
      "hello"[6, 3]?.should be_nil
    end

    it "gets with range without end" do
      "hello"[1..nil]?.should eq("ello")
      "hello"[6..nil]?.should be_nil
    end

    it "gets with range without beginning" do
      "hello"[nil..2]?.should eq("hel")
    end
  end

  describe "byte_slice" do
    it "gets byte_slice" do
      "hello".byte_slice(1, 3).should eq("ell")
    end

    it "gets byte_slice with negative count" do
      expect_raises(ArgumentError) do
        "hello".byte_slice(1, -10)
      end
    end

    it "gets byte_slice with negative count at last" do
      expect_raises(ArgumentError) do
        "hello".byte_slice(5, -1)
      end
    end

    it "gets byte_slice with start out of bounds" do
      expect_raises(IndexError) do
        "hello".byte_slice(10, 3)
      end
    end

    it "gets byte_slice with large count" do
      "hello".byte_slice(1, 10).should eq("ello")
    end

    it "gets byte_slice with negative index" do
      "hello".byte_slice(-2, 3).should eq("lo")
    end

    it "gets byte_slice(Int) with start out of bounds" do
      expect_raises(IndexError) do
        "hello".byte_slice(10)
      end
      expect_raises(IndexError) do
        "hello".byte_slice(-10)
      end
    end
  end

  describe "to_i" do
    it { "1234".to_i.should eq(1234) }
    it { "-128".to_i8.should eq(-128) }
    it { "   +1234   ".to_i.should eq(1234) }
    it { "   -1234   ".to_i.should eq(-1234) }
    it { "   +1234   ".to_i.should eq(1234) }
    it { "   -00001234".to_i.should eq(-1234) }
    it { "\u00A01234\u00A0".to_i.should eq(1234) }
    it { "1_234".to_i(underscore: true).should eq(1234) }
    it { "1101".to_i(base: 2).should eq(13) }
    it { "12ab".to_i(16).should eq(4779) }
    it { "0x123abc".to_i(prefix: true).should eq(1194684) }
    it { "0b1101".to_i(prefix: true).should eq(13) }
    it { "0b001101".to_i(prefix: true).should eq(13) }
    it { "0123".to_i(prefix: true).should eq(123) }
    it { "0o123".to_i(prefix: true).should eq(83) }
    it { "0123".to_i(leading_zero_is_octal: true).should eq(83) }
    it { "123".to_i(leading_zero_is_octal: true).should eq(123) }
    it { "0o755".to_i(prefix: true, leading_zero_is_octal: true).should eq(493) }
    it { "5".to_i(prefix: true).should eq(5) }
    it { "0".to_i(prefix: true).should eq(0) }
    it { "00".to_i(prefix: true).should eq(0) }
    it { "00".to_i(leading_zero_is_octal: true).should eq(0) }
    it { "00".to_i(prefix: true, leading_zero_is_octal: true).should eq(0) }
    it { "123hello".to_i(strict: false).should eq(123) }
    it { "99 red balloons".to_i(strict: false).should eq(99) }
    it { "   99 red balloons".to_i(strict: false).should eq(99) }
    it { expect_raises(ArgumentError) { "hello".to_i } }
    it { expect_raises(ArgumentError) { "1__234".to_i } }
    it { expect_raises(ArgumentError) { "1_234".to_i } }
    it { expect_raises(ArgumentError) { "   1234   ".to_i(whitespace: false) } }
    it { expect_raises(ArgumentError) { "0x123".to_i } }
    it { expect_raises(ArgumentError) { "0b123".to_i } }
    it { expect_raises(ArgumentError) { "000b123".to_i(prefix: true) } }
    it { expect_raises(ArgumentError) { "000x123".to_i(prefix: true) } }
    it { expect_raises(ArgumentError) { "000o89a".to_i(prefix: true) } }
    it { expect_raises(ArgumentError) { "123hello".to_i } }
    it { expect_raises(ArgumentError) { "0".to_i(leading_zero_is_octal: true) } }
    it { expect_raises(ArgumentError) { "0o755".to_i(leading_zero_is_octal: true) } }
    it { "z".to_i(36).should eq(35) }
    it { "Z".to_i(36).should eq(35) }
    it { "0".to_i(62).should eq(0) }
    it { "1".to_i(62).should eq(1) }
    it { "a".to_i(62).should eq(10) }
    it { "z".to_i(62).should eq(35) }
    it { "A".to_i(62).should eq(36) }
    it { "Z".to_i(62).should eq(61) }
    it { "10".to_i(62).should eq(62) }
    it { "1z".to_i(62).should eq(97) }
    it { "ZZ".to_i(62).should eq(3843) }

    # Test for #11671
    it { "0_1".to_i(underscore: true).should eq(1) }

    describe "to_i8" do
      it { "127".to_i8.should eq(127) }
      it { "-128".to_i8.should eq(-128) }
      it { expect_raises(ArgumentError) { "128".to_i8 } }
      it { expect_raises(ArgumentError) { "-129".to_i8 } }

      it { "127".to_i8?.should eq(127) }
      it { "128".to_i8?.should be_nil }
      it { "128".to_i8 { 0 }.should eq(0) }

      it { expect_raises(ArgumentError) { "18446744073709551616".to_i8 } }
    end

    describe "to_u8" do
      it { "255".to_u8.should eq(255) }
      it { "0".to_u8.should eq(0) }
      it { expect_raises(ArgumentError) { "256".to_u8 } }
      it { expect_raises(ArgumentError) { "-1".to_u8 } }

      it { "255".to_u8?.should eq(255) }
      it { "256".to_u8?.should be_nil }
      it { "256".to_u8 { 0 }.should eq(0) }

      it { expect_raises(ArgumentError) { "18446744073709551616".to_u8 } }
    end

    describe "to_i16" do
      it { "32767".to_i16.should eq(32767) }
      it { "-32768".to_i16.should eq(-32768) }
      it { expect_raises(ArgumentError) { "32768".to_i16 } }
      it { expect_raises(ArgumentError) { "-32769".to_i16 } }

      it { "32767".to_i16?.should eq(32767) }
      it { "32768".to_i16?.should be_nil }
      it { "32768".to_i16 { 0 }.should eq(0) }

      it { expect_raises(ArgumentError) { "18446744073709551616".to_i16 } }
    end

    describe "to_u16" do
      it { "65535".to_u16.should eq(65535) }
      it { "0".to_u16.should eq(0) }
      it { expect_raises(ArgumentError) { "65536".to_u16 } }
      it { expect_raises(ArgumentError) { "-1".to_u16 } }

      it { "65535".to_u16?.should eq(65535) }
      it { "65536".to_u16?.should be_nil }
      it { "65536".to_u16 { 0 }.should eq(0) }

      it { expect_raises(ArgumentError) { "18446744073709551616".to_u16 } }
    end

    describe "to_i32" do
      it { "2147483647".to_i32.should eq(2147483647) }
      it { "-2147483648".to_i32.should eq(-2147483648) }
      it { expect_raises(ArgumentError) { "2147483648".to_i32 } }
      it { expect_raises(ArgumentError) { "-2147483649".to_i32 } }

      it { "2147483647".to_i32?.should eq(2147483647) }
      it { "2147483648".to_i32?.should be_nil }
      it { "2147483648".to_i32 { 0 }.should eq(0) }

      it { expect_raises(ArgumentError) { "18446744073709551616".to_i32 } }
    end

    describe "to_u32" do
      it { "4294967295".to_u32.should eq(4294967295) }
      it { "0".to_u32.should eq(0) }
      it { expect_raises(ArgumentError) { "4294967296".to_u32 } }
      it { expect_raises(ArgumentError) { "-1".to_u32 } }

      it { "4294967295".to_u32?.should eq(4294967295) }
      it { "4294967296".to_u32?.should be_nil }
      it { "4294967296".to_u32 { 0 }.should eq(0) }

      it { expect_raises(ArgumentError) { "18446744073709551616".to_u32 } }
    end

    describe "to_i64" do
      it { "9223372036854775807".to_i64.should eq(9223372036854775807) }
      it { "-9223372036854775808".to_i64.should eq(-9223372036854775808) }
      it { expect_raises(ArgumentError) { "9223372036854775808".to_i64 } }
      it { expect_raises(ArgumentError) { "-9223372036854775809".to_i64 } }

      it { "9223372036854775807".to_i64?.should eq(9223372036854775807) }
      it { "9223372036854775808".to_i64?.should be_nil }
      it { "9223372036854775808".to_i64 { 0 }.should eq(0) }

      it { expect_raises(ArgumentError) { "18446744073709551616".to_i64 } }
    end

    describe "to_u64" do
      it { "18446744073709551615".to_u64.should eq(18446744073709551615) }
      it { "0".to_u64.should eq(0) }
      it { expect_raises(ArgumentError) { "18446744073709551616".to_u64 } }
      it { expect_raises(ArgumentError) { "-1".to_u64 } }

      it { "18446744073709551615".to_u64?.should eq(18446744073709551615) }
      it { "18446744073709551616".to_u64?.should be_nil }
      it { "18446744073709551616".to_u64 { 0 }.should eq(0) }
    end

    describe "to_i128" do
      it { "170141183460469231731687303715884105727".to_i128.should eq(Int128::MAX) }
      it { "-170141183460469231731687303715884105728".to_i128.should eq(Int128::MIN) }
      it { expect_raises(ArgumentError) { "170141183460469231731687303715884105728".to_i128 } }
      it { expect_raises(ArgumentError) { "-170141183460469231731687303715884105729".to_i128 } }

      it { "170141183460469231731687303715884105727".to_i128?.should eq(Int128::MAX) }
      it { "170141183460469231731687303715884105728".to_i128?.should be_nil }
      it { "170141183460469231731687303715884105728".to_i128 { 0 }.should eq(0) }

      it { expect_raises(ArgumentError) { "340282366920938463463374607431768211456".to_i128 } }
    end

    describe "to_u128" do
      it { "340282366920938463463374607431768211455".to_u128.should eq(UInt128::MAX) }
      it { "0".to_u128.should eq(0) }
      it { expect_raises(ArgumentError) { "340282366920938463463374607431768211456".to_u128 } }
      it { expect_raises(ArgumentError) { "-1".to_u128 } }

      it { "340282366920938463463374607431768211455".to_u128?.should eq(UInt128::MAX) }
      it { "340282366920938463463374607431768211456".to_u128?.should be_nil }
      it { "340282366920938463463374607431768211456".to_u128 { 0 }.should eq(0) }
    end

    it { "1234".to_i32.should eq(1234) }
    it { "1234123412341234".to_i64.should eq(1234123412341234_i64) }
    it { "9223372036854775808".to_u64.should eq(9223372036854775808_u64) }

    it { expect_raises(ArgumentError, "Invalid base 1") { "12ab".to_i(1) } }
    it { expect_raises(ArgumentError, "Invalid base 37") { "12ab".to_i(37) } }

    it { expect_raises(ArgumentError, "Invalid Int32") { "1Y2P0IJ32E8E7".to_i(36) } }
    it { "1Y2P0IJ32E8E7".to_i64(36).should eq(9223372036854775807) }
  end

  it "does to_f" do
    expect_raises(ArgumentError) { "".to_f }
    "".to_f?.should be_nil
    expect_raises(ArgumentError) { " ".to_f }
    " ".to_f?.should be_nil
    "0".to_f.should eq(0_f64)
    "0.0".to_f.should eq(0_f64)
    "+0.0".to_f.should eq(0_f64)
    "-0.0".to_f.should eq(0_f64)
    "1234.56".to_f.should eq(1234.56_f64)
    "1234.56".to_f?.should eq(1234.56_f64)
    "+1234.56".to_f?.should eq(1234.56_f64)
    "-1234.56".to_f?.should eq(-1234.56_f64)
    expect_raises(ArgumentError) { "foo".to_f }
    "foo".to_f?.should be_nil
    "  1234.56  ".to_f.should eq(1234.56_f64)
    "  1234.56  ".to_f?.should eq(1234.56_f64)
    expect_raises(ArgumentError) { "  1234.56  ".to_f(whitespace: false) }
    "  1234.56  ".to_f?(whitespace: false).should be_nil
    expect_raises(ArgumentError) { "  1234.56foo".to_f }
    "  1234.56foo".to_f?.should be_nil
    "123.45 x".to_f64(strict: false).should eq(123.45_f64)
    expect_raises(ArgumentError) { "x1.2".to_f64 }
    "x1.2".to_f64?.should be_nil
    expect_raises(ArgumentError) { "x1.2".to_f64(strict: false) }
    "x1.2".to_f64?(strict: false).should be_nil
    "1#{Float64::MAX}".to_f?.should be_nil
    "-1#{Float64::MAX}".to_f?.should be_nil
    " NaN".to_f?.try(&.nan?).should be_true
    "NaN".to_f?.try(&.nan?).should be_true
    "-NaN".to_f?.try(&.nan?).should be_true
    " INF".to_f?.should eq Float64::INFINITY
    "INF".to_f?.should eq Float64::INFINITY
    "-INF".to_f?.should eq -Float64::INFINITY
    " +INF".to_f?.should eq Float64::INFINITY
  end

  it "does to_f32" do
    expect_raises(ArgumentError) { "".to_f32 }
    "".to_f32?.should be_nil
    expect_raises(ArgumentError) { " ".to_f32 }
    " ".to_f32?.should be_nil
    "0".to_f32.should eq(0_f32)
    "0.0".to_f32.should eq(0_f32)
    "+0.0".to_f32.should eq(0_f32)
    "-0.0".to_f32.should eq(0_f32)
    "1234.56".to_f32.should eq(1234.56_f32)
    "1234.56".to_f32?.should eq(1234.56_f32)
    "+1234.56".to_f32?.should eq(1234.56_f32)
    "-1234.56".to_f32?.should eq(-1234.56_f32)
    expect_raises(ArgumentError) { "foo".to_f32 }
    "foo".to_f32?.should be_nil
    "  1234.56  ".to_f32.should eq(1234.56_f32)
    "  1234.56  ".to_f32?.should eq(1234.56_f32)
    expect_raises(ArgumentError) { "  1234.56  ".to_f32(whitespace: false) }
    "  1234.56  ".to_f32?(whitespace: false).should be_nil
    expect_raises(ArgumentError) { "  1234.56foo".to_f32 }
    "  1234.56foo".to_f32?.should be_nil
    "123.45 x".to_f32(strict: false).should eq(123.45_f32)
    expect_raises(ArgumentError) { "x1.2".to_f32 }
    "x1.2".to_f32?.should be_nil
    expect_raises(ArgumentError) { "x1.2".to_f32(strict: false) }
    "x1.2".to_f32?(strict: false).should be_nil
    "1#{Float32::MAX}".to_f32?.should be_nil
    "-1#{Float32::MAX}".to_f32?.should be_nil
    " NaN".to_f32?.try(&.nan?).should be_true
    "NaN".to_f32?.try(&.nan?).should be_true
    "-NaN".to_f32?.try(&.nan?).should be_true
    " INF".to_f32?.should eq Float32::INFINITY
    "INF".to_f32?.should eq Float32::INFINITY
    "-INF".to_f32?.should eq -Float32::INFINITY
    " +INF".to_f32?.should eq Float32::INFINITY
  end

  it "does to_f64" do
    expect_raises(ArgumentError) { "".to_f64 }
    "".to_f64?.should be_nil
    expect_raises(ArgumentError) { " ".to_f64 }
    " ".to_f64?.should be_nil
    "0".to_f64.should eq(0_f64)
    "0.0".to_f64.should eq(0_f64)
    "+0.0".to_f64.should eq(0_f64)
    "-0.0".to_f64.should eq(0_f64)
    "1234.56".to_f64.should eq(1234.56_f64)
    "1234.56".to_f64?.should eq(1234.56_f64)
    "+1234.56".to_f?.should eq(1234.56_f64)
    "-1234.56".to_f?.should eq(-1234.56_f64)
    expect_raises(ArgumentError) { "foo".to_f64 }
    "foo".to_f64?.should be_nil
    "  1234.56  ".to_f64.should eq(1234.56_f64)
    "  1234.56  ".to_f64?.should eq(1234.56_f64)
    expect_raises(ArgumentError) { "  1234.56  ".to_f64(whitespace: false) }
    "  1234.56  ".to_f64?(whitespace: false).should be_nil
    expect_raises(ArgumentError) { "  1234.56foo".to_f64 }
    "  1234.56foo".to_f64?.should be_nil
    "123.45 x".to_f64(strict: false).should eq(123.45_f64)
    expect_raises(ArgumentError) { "x1.2".to_f64 }
    "x1.2".to_f64?.should be_nil
    expect_raises(ArgumentError) { "x1.2".to_f64(strict: false) }
    "x1.2".to_f64?(strict: false).should be_nil
    "1#{Float64::MAX}".to_f64?.should be_nil
    "-1#{Float64::MAX}".to_f64?.should be_nil
    " NaN".to_f64?.try(&.nan?).should be_true
    "NaN".to_f64?.try(&.nan?).should be_true
    "-NaN".to_f64?.try(&.nan?).should be_true
    " INF".to_f64?.should eq Float64::INFINITY
    "INF".to_f64?.should eq Float64::INFINITY
    "-INF".to_f64?.should eq -Float64::INFINITY
    " +INF".to_f64?.should eq Float64::INFINITY
  end

  it "compares strings: different size" do
    "foo".should_not eq("fo")
  end

  it "compares strings: same object" do
    f = "foo"
    f.should eq(f)
  end

  it "compares strings: same size, same string" do
    "foo".should eq("fo" + "o")
  end

  it "compares strings: same size, different string" do
    "foo".should_not eq("bar")
  end

  it "interpolates string" do
    foo = "<foo>"
    bar = 123
    "foo #{bar}".should eq("foo 123")
    "foo #{bar}".should eq("foo 123")
    "#{foo} bar".should eq("<foo> bar")
  end

  it "multiplies" do
    str = "foo"
    (str * 0).should eq("")
    (str * 3).should eq("foofoofoo")
  end

  it "multiplies with size one" do
    str = "f"
    (str * 0).should eq("")
    (str * 10).should eq("ffffffffff")
  end

  it "multiplies with negative size" do
    expect_raises(ArgumentError, "Negative argument") do
      "f" * -1
    end
  end

  describe "#downcase" do
    it { "HELLO!".downcase.should eq("hello!") }
    it { "HELLO MAN!".downcase.should eq("hello man!") }
    it { "ÁÉÍÓÚĀ".downcase.should eq("áéíóúā") }
    it { "AEIİOU".downcase(Unicode::CaseOptions::Turkic).should eq("aeıiou") }
    it { "ÁEÍOÚ".downcase(Unicode::CaseOptions::ASCII).should eq("ÁeÍoÚ") }
    it { "İ".downcase.should eq("i̇") }
    it { "Baﬄe".downcase(Unicode::CaseOptions::Fold).should eq("baffle") }
    it { "ﬀ".downcase(Unicode::CaseOptions::Fold).should eq("ff") }
    it { "tschüß".downcase(Unicode::CaseOptions::Fold).should eq("tschüss") }
    it { "ΣίσυφοςﬁÆ".downcase(Unicode::CaseOptions::Fold).should eq("σίσυφοσfiæ") }

    it "does not touch invalid code units in an otherwise ascii string" do
      "\xB5!\xE0\xC1\xB5?".downcase.should eq("\xB5!\xE0\xC1\xB5?")
    end

    describe "with IO" do
      it { String.build { |io| "HELLO!".downcase io }.should eq "hello!" }
      it { String.build { |io| "HELLO MAN!".downcase io }.should eq "hello man!" }
      it { String.build { |io| "ÁÉÍÓÚĀ".downcase io }.should eq "áéíóúā" }
      it { String.build { |io| "AEIİOU".downcase io, Unicode::CaseOptions::Turkic }.should eq "aeıiou" }
      it { String.build { |io| "ÁEÍOÚ".downcase io, Unicode::CaseOptions::ASCII }.should eq "ÁeÍoÚ" }
      it { String.build { |io| "İ".downcase io }.should eq "i̇" }
      it { String.build { |io| "Baﬄe".downcase io, Unicode::CaseOptions::Fold }.should eq "baffle" }
      it { String.build { |io| "ﬀ".downcase io, Unicode::CaseOptions::Fold }.should eq "ff" }
      it { String.build { |io| "tschüß".downcase io, Unicode::CaseOptions::Fold }.should eq "tschüss" }
      it { String.build { |io| "ΣίσυφοςﬁÆ".downcase io, Unicode::CaseOptions::Fold }.should eq "σίσυφοσfiæ" }
    end
  end

  describe "#upcase" do
    it { "hello!".upcase.should eq("HELLO!") }
    it { "hello man!".upcase.should eq("HELLO MAN!") }
    it { "áéíóúā".upcase.should eq("ÁÉÍÓÚĀ") }
    it { "aeıiou".upcase(Unicode::CaseOptions::Turkic).should eq("AEIİOU") }
    it { "áeíoú".upcase(Unicode::CaseOptions::ASCII).should eq("áEíOú") }
    it { "aeiou".upcase(Unicode::CaseOptions::Turkic).should eq("AEİOU") }
    it { "baﬄe".upcase.should eq("BAFFLE") }
    it { "ﬀ".upcase.should eq("FF") }
    it { "ňž".upcase.should eq("ŇŽ") } # #7922

    it "does not touch invalid code units in an otherwise ascii string" do
      "\xB5!\xE0\xC1\xB5?".upcase.should eq("\xB5!\xE0\xC1\xB5?")
    end

    describe "with IO" do
      it { String.build { |io| "hello!".upcase io }.should eq "HELLO!" }
      it { String.build { |io| "hello man!".upcase io }.should eq "HELLO MAN!" }
      it { String.build { |io| "áéíóúā".upcase io }.should eq "ÁÉÍÓÚĀ" }
      it { String.build { |io| "aeıiou".upcase io, Unicode::CaseOptions::Turkic }.should eq "AEIİOU" }
      it { String.build { |io| "áeíoú".upcase io, Unicode::CaseOptions::ASCII }.should eq "áEíOú" }
      it { String.build { |io| "aeiou".upcase io, Unicode::CaseOptions::Turkic }.should eq "AEİOU" }
      it { String.build { |io| "baﬄe".upcase io }.should eq "BAFFLE" }
      it { String.build { |io| "ff".upcase io }.should eq "FF" }
      it { String.build { |io| "ňž".upcase io }.should eq "ŇŽ" }
    end
  end

  describe "#capitalize" do
    it { "HELLO!".capitalize.should eq("Hello!") }
    it { "HELLO MAN!".capitalize.should eq("Hello man!") }
    it { "".capitalize.should eq("") }
    it { "ﬄİ".capitalize.should eq("FFLi̇") }
    it { "iO".capitalize(Unicode::CaseOptions::Turkic).should eq("İo") }

    it "does not touch invalid code units in an otherwise ascii string" do
      "\xB5!\xE0\xC1\xB5?".capitalize.should eq("\xB5!\xE0\xC1\xB5?")
    end

    describe "with IO" do
      it { String.build { |io| "HELLO!".capitalize io }.should eq "Hello!" }
      it { String.build { |io| "HELLO MAN!".capitalize io }.should eq "Hello man!" }
      it { String.build { |io| "".capitalize io }.should be_empty }
      it { String.build { |io| "ﬄİ".capitalize io }.should eq "FFLi̇" }
      it { String.build { |io| "iO".capitalize io, Unicode::CaseOptions::Turkic }.should eq "İo" }
    end
  end

  describe "#titleize" do
    it { "hEllO tAb\tworld".titleize.should eq("Hello Tab\tWorld") }
    it { "  spaces before".titleize.should eq("  Spaces Before") }
    it { "testa-se muito".titleize.should eq("Testa-se Muito") }
    it { "hÉllÕ tAb\tworld".titleize.should eq("Héllõ Tab\tWorld") }
    it { "  spáçes before".titleize.should eq("  Spáçes Before") }
    it { "testá-se múitô".titleize.should eq("Testá-se Múitô") }
    it { "iO iO".titleize(Unicode::CaseOptions::Turkic).should eq("İo İo") }

    it "does not touch invalid code units in an otherwise ascii string" do
      "\xB5!\xE0\xC1\xB5?".titleize.should eq("\xB5!\xE0\xC1\xB5?")
      "a\xA0b".titleize.should eq("A\xA0b")
    end

    describe "with IO" do
      it { String.build { |io| "hEllO tAb\tworld".titleize io }.should eq "Hello Tab\tWorld" }
      it { String.build { |io| "  spaces before".titleize io }.should eq "  Spaces Before" }
      it { String.build { |io| "testa-se muito".titleize io }.should eq "Testa-se Muito" }
      it { String.build { |io| "hÉllÕ tAb\tworld".titleize io }.should eq "Héllõ Tab\tWorld" }
      it { String.build { |io| "  spáçes before".titleize io }.should eq "  Spáçes Before" }
      it { String.build { |io| "testá-se múitô".titleize io }.should eq "Testá-se Múitô" }
      it { String.build { |io| "iO iO".titleize io, Unicode::CaseOptions::Turkic }.should eq "İo İo" }
    end
  end

  describe "chomp" do
    it { "hello\n".chomp.should eq("hello") }
    it { "hello\r".chomp.should eq("hello") }
    it { "hello\r\n".chomp.should eq("hello") }
    it { "hello".chomp.should eq("hello") }
    it { "hello".chomp.should eq("hello") }
    it { "かたな\n".chomp.should eq("かたな") }
    it { "かたな\r".chomp.should eq("かたな") }
    it { "かたな\r\n".chomp.should eq("かたな") }
    it { "hello\n\n".chomp.should eq("hello\n") }
    it { "hello\r\n\n".chomp.should eq("hello\r\n") }
    it { "hello\r\n".chomp('\n').should eq("hello") }

    it { "hello".chomp('a').should eq("hello") }
    it { "hello".chomp('o').should eq("hell") }
    it { "かたな".chomp('な').should eq("かた") }

    it { "hello".chomp("good").should eq("hello") }
    it { "hello".chomp("llo").should eq("he") }
    it { "かたな".chomp("たな").should eq("か") }

    it { "hello\n\n\n\n".chomp("").should eq("hello\n\n\n\n") }

    it { "hello\r\n".chomp("\n").should eq("hello") }
  end

  describe "lchop" do
    it { "".lchop.should eq("") }
    it { "h".lchop.should eq("") }
    it { "hello".lchop.should eq("ello") }
    it { "かたな".lchop.should eq("たな") }

    it { "hello".lchop('g').should eq("hello") }
    it { "hello".lchop('h').should eq("ello") }
    it { "かたな".lchop('か').should eq("たな") }

    it { "".lchop("").should eq("") }
    it { "hello".lchop("good").should eq("hello") }
    it { "hello".lchop("hel").should eq("lo") }
    it { "かたな".lchop("かた").should eq("な") }

    it { "\n\n\n\nhello".lchop("").should eq("\n\n\n\nhello") }
  end

  describe "lchop?" do
    it { "".lchop?.should be_nil }
    it { "h".lchop?.should eq("") }
    it { "hello".lchop?.should eq("ello") }
    it { "かたな".lchop?.should eq("たな") }

    it { "hello".lchop?('g').should be_nil }
    it { "hello".lchop?('h').should eq("ello") }
    it { "かたな".lchop?('か').should eq("たな") }

    it { "".lchop?("").should eq("") }
    it { "hello".lchop?("good").should be_nil }
    it { "hello".lchop?("hel").should eq("lo") }
    it { "かたな".lchop?("かた").should eq("な") }

    it { "\n\n\n\nhello".lchop("").should eq("\n\n\n\nhello") }
  end

  describe "rchop" do
    it { "".rchop.should eq("") }
    it { "foo".rchop.should eq("fo") }
    it { "foo\n".rchop.should eq("foo") }
    it { "foo\r".rchop.should eq("foo") }
    it { "foo\r\n".rchop.should eq("foo\r") }
    it { "\r\n".rchop.should eq("\r") }
    it { "かたな".rchop.should eq("かた") }
    it { "かたな\n".rchop.should eq("かたな") }
    it { "かたな\r\n".rchop.should eq("かたな\r") }

    it { "foo".rchop('o').should eq("fo") }
    it { "foo".rchop('x').should eq("foo") }

    it { "".rchop("").should eq("") }
    it { "foobar".rchop("bar").should eq("foo") }
    it { "foobar".rchop("baz").should eq("foobar") }
  end

  describe "rchop?" do
    it { "".rchop?.should be_nil }
    it { "\n".rchop?.should eq("") }
    it { "foo".rchop?.should eq("fo") }
    it { "foo\n".rchop?.should eq("foo") }
    it { "foo\r".rchop?.should eq("foo") }
    it { "foo\r\n".rchop?.should eq("foo\r") }
    it { "\r\n".rchop?.should eq("\r") }
    it { "かたな".rchop?.should eq("かた") }
    it { "かたな\n".rchop?.should eq("かたな") }
    it { "かたな\r\n".rchop?.should eq("かたな\r") }

    it { "foo".rchop?('o').should eq("fo") }
    it { "foo".rchop?('x').should be_nil }

    it { "".rchop?("").should eq("") }
    it { "foobar".rchop?("bar").should eq("foo") }
    it { "foobar".rchop?("baz").should be_nil }
  end

  describe "strip" do
    it { "  hello  \n\t\f\v\r".strip.should eq("hello") }
    it { "hello".strip.should eq("hello") }
    it { "かたな \n\f\v".strip.should eq("かたな") }
    it { "  \n\t かたな \n\f\v".strip.should eq("かたな") }
    it { "  \n\t かたな".strip.should eq("かたな") }
    it { "かたな".strip.should eq("かたな") }
    it { "".strip.should eq("") }
    it { "\n".strip.should eq("") }
    it { "\n\t  ".strip.should eq("") }
    it { "\u00A0".strip.should eq("") }

    # TODO: add spec tags so this can be run with tag:slow
    # it { (" " * 167772160).strip.should eq("") }

    it { "".strip("xyz").should eq("") }
    it { "foobar".strip("").should eq("foobar") }
    it { "rrfoobarr".strip("r").should eq("fooba") }
    it { "rfoobar".strip("x").should eq("rfoobar") }
    it { "rrrfooba".strip("r").should eq("fooba") }
    it { "foobarrr".strip("r").should eq("fooba") }
    it { "rabfooabr".strip("bar").should eq("foo") }
    it { "rabfooabr".strip("xyz").should eq("rabfooabr") }
    it { "fooabr".strip("bar").should eq("foo") }
    it { "rabfoo".strip("bar").should eq("foo") }
    it { "rababr".strip("bar").should eq("") }

    it { "aaabcdaaa".strip('a').should eq("bcd") }
    it { "bcdaaa".strip('a').should eq("bcd") }
    it { "aaabcd".strip('a').should eq("bcd") }

    it { "ababcdaba".strip { |c| c == 'a' || c == 'b' }.should eq("cd") }
  end

  describe "rstrip" do
    it { "".rstrip.should eq("") }
    it { "  hello  ".rstrip.should eq("  hello") }
    it { "hello".rstrip.should eq("hello") }
    it { "  かたな \n\f\v".rstrip.should eq("  かたな") }
    it { "かたな".rstrip.should eq("かたな") }

    it { "".rstrip("xyz").should eq("") }
    it { "foobar".rstrip("").should eq("foobar") }
    it { "foobarrrr".rstrip("r").should eq("fooba") }
    it { "foobars".rstrip("r").should eq("foobars") }
    it { "foobar".rstrip("rab").should eq("foo") }
    it { "foobar".rstrip("foo").should eq("foobar") }
    it { "bararbr".rstrip("bar").should eq("") }

    it { "foobarrrr".rstrip('r').should eq("fooba") }
    it { "foobar".rstrip('x').should eq("foobar") }

    it { "foobar".rstrip { |c| c == 'a' || c == 'r' }.should eq("foob") }

    it "does not touch invalid code units in an otherwise ascii string" do
      " \xA0 ".rstrip.should eq(" \xA0")
    end
  end

  describe "lstrip" do
    it { "  hello  ".lstrip.should eq("hello  ") }
    it { "hello".lstrip.should eq("hello") }
    it { "  \n\v かたな  ".lstrip.should eq("かたな  ") }
    it { "  かたな".lstrip.should eq("かたな") }

    it { "".lstrip("xyz").should eq("") }
    it { "barfoo".lstrip("").should eq("barfoo") }
    it { "bbbarfoo".lstrip("b").should eq("arfoo") }
    it { "sbarfoo".lstrip("r").should eq("sbarfoo") }
    it { "barfoo".lstrip("rab").should eq("foo") }
    it { "barfoo".lstrip("foo").should eq("barfoo") }
    it { "b".lstrip("bar").should eq("") }

    it { "bbbbarfoo".lstrip('b').should eq("arfoo") }
    it { "barfoo".lstrip('x').should eq("barfoo") }

    it { "barfoo".lstrip { |c| c == 'a' || c == 'b' }.should eq("rfoo") }

    it "does not touch invalid code units in an otherwise ascii string" do
      " \xA0 ".lstrip.should eq("\xA0 ")
    end
  end

  describe "empty?" do
    it { "a".empty?.should be_false }
    it { "".empty?.should be_true }
  end

  describe "blank?" do
    it { " \t\n".blank?.should be_true }
    it { "\u{1680}\u{2029}".blank?.should be_true }
    it { "hello".blank?.should be_false }
  end

  describe "presence" do
    it { " \t\n".presence.should be_nil }
    it { "\u{1680}\u{2029}".presence.should be_nil }
    it { "hello".presence.should eq("hello") }
  end

  describe "#index" do
    describe "by char" do
      it { "foo".index('o').should eq(1) }
      it { "foo".index('g').should be_nil }
      it { "bar".index('r').should eq(2) }
      it { "日本語".index('本').should eq(1) }
      it { "bar".index('あ').should be_nil }
      it { "あいう_えお".index('_').should eq(3) }

      describe "with offset" do
        it { "foobarbaz".index('a', 5).should eq(7) }
        it { "foobarbaz".index('a', -4).should eq(7) }
        it { "foo".index('g', 1).should be_nil }
        it { "foo".index('g', -20).should be_nil }
        it { "日本語日本語".index('本', 2).should eq(4) }

        # Check offset type
        it { "foobarbaz".index('a', 5_i64).should eq(7) }
        it { "foobarbaz".index('a', 5_i64).should be_a(Int32) }
        it { "日本語日本語".index('本', 2_i64).should eq(4) }
        it { "日本語日本語".index('本', 2_i64).should be_a(Int32) }
      end
    end

    describe "by string" do
      it { "foo bar".index("o b").should eq(2) }
      it { "foo".index("fg").should be_nil }
      it { "foo".index("").should eq(0) }
      it { "foo".index("foo").should eq(0) }
      it { "日本語日本語".index("本語").should eq(1) }
      it { "\xFF\xFFcrystal".index("crystal").should eq(2) }
      it { "\xFD\x9A\xAD\x50NG".index("PNG").should eq(3) }
      it { "🧲$".index("✅").should be_nil } # #11745

      describe "with offset" do
        it { "foobarbaz".index("ba", 4).should eq(6) }
        it { "foobarbaz".index("ba", -5).should eq(6) }
        it { "foo".index("ba", 1).should be_nil }
        it { "foo".index("ba", -20).should be_nil }
        it { "foo".index("", 3).should eq(3) }
        it { "foo".index("", 4).should be_nil }
        it { "日本語日本語".index("本語", 2).should eq(4) }
        it { "\xFD\x9A\xAD\x50NG".index("PNG", 2).should eq(3) }
        it { "\xFD\x9A\xAD\x50NG".index("PNG", 4).should be_nil }

        # Check offset type
        it { "foobarbaz".index("a", 5_i64).should eq(7) }
        it { "foobarbaz".index("a", 5_i64).should be_a(Int32) }
        it { "日本語日本語".index("本", 2_i64).should eq(4) }
        it { "日本語日本語".index("本", 2_i64).should be_a(Int32) }
        it { "日本語日本語".index("", 2_i64).should eq 2 }
        it { "日本語日本語".index("", 2_i64).should be_a(Int64) }
      end
    end

    describe "by regex" do
      it { "string 12345".index(/\d+/).should eq(7) }
      it { "12345".index(/\d/).should eq(0) }
      it { "Hello, world!".index(/\d/).should be_nil }
      it { "abcdef".index(/[def]/).should eq(3) }
      it { "日本語日本語".index(/本語/).should eq(1) }

      describe "with offset" do
        it { "abcDef".index(/[A-Z]/).should eq(3) }
        it { "foobarbaz".index(/ba/, -5).should eq(6) }
        it { "Foo".index(/[A-Z]/, 1).should be_nil }
        it { "foo".index(/o/, 2).should eq(2) }
        it { "foo".index(//, 3).should eq(3) }
        it { "foo".index(//, 4).should be_nil }
        it { "日本語日本語".index(/本語/, 2).should eq(4) }
      end
    end
  end

  describe "#rindex" do
    describe "by char" do
      it { "bbbb".rindex('b').should eq(3) }
      it { "foobar".rindex('a').should eq(4) }
      it { "foobar".rindex('g').should be_nil }
      it { "日本語日本語".rindex('本').should eq(4) }
      it { "あいう_えお".rindex('_').should eq(3) }

      describe "with offset" do
        it { "bbbb".rindex('b', 2).should eq(2) }
        it { "abbbb".rindex('b', 0).should be_nil }
        it { "abbbb".rindex('b', 1).should eq(1) }
        it { "abbbb".rindex('a', 0).should eq(0) }
        it { "bbbb".rindex('b', -2).should eq(2) }
        it { "bbbb".rindex('b', -5).should be_nil }
        it { "bbbb".rindex('b', -4).should eq(0) }
        it { "faobar".rindex('a', 3).should eq(1) }
        it { "faobarbaz".rindex('a', -3).should eq(4) }
        it { "日本語日本語".rindex('本', 3).should eq(1) }

        # Check offset type
        it { "bbbb".rindex('b', 2_i64).should eq(2) }
        it { "bbbb".rindex('b', 2_i64).should be_a(Int64) }
        it { "日本語日本語".rindex('本', 3_i64).should eq(1) }
        it { "日本語日本語".rindex('本', 3_i64).should be_a(Int64) }
      end
    end

    describe "by string" do
      it { "bbbb".rindex("b").should eq(3) }
      it { "foo baro baz".rindex("o b").should eq(7) }
      it { "foo baro baz".rindex("fg").should be_nil }
      it { "日本語日本語".rindex("日本").should eq(3) }

      describe "with offset" do
        it { "bbbb".rindex("b", 2).should eq(2) }
        it { "abbbb".rindex("b", 0).should be_nil }
        it { "abbbb".rindex("b", 1).should eq(1) }
        it { "abbbb".rindex("a", 0).should eq(0) }
        it { "bbbb".rindex("b", -2).should eq(2) }
        it { "bbbb".rindex("b", -5).should be_nil }
        it { "bbbb".rindex("b", -4).should eq(0) }
        it { "foo baro baz".rindex("o b", 6).should eq(2) }
        it { "foo".rindex("", 3).should eq(3) }
        it { "foo".rindex("", 4).should eq(3) }
        it { "日本語日本語".rindex("日本", 2).should eq(0) }

        # Check offset type
        it { "bbbb".rindex("b", 2_i64).should eq(2) }
        it { "bbbb".rindex("b", 2_i64).should be_a(Int32) }
        it { "日本語日本語".rindex("本", 3_i64).should eq(1) }
        it { "日本語日本語".rindex("本", 3_i64).should be_a(Int32) }
        it { "日本語日本語".rindex("", 3_i64).should eq(3) }
        it { "日本語日本語".rindex("", 3_i64).should be_a(Int32) }
      end
    end

    describe "by regex" do
      it { "bbbb".rindex(/b/).should eq(3) }
      it { "a43b53".rindex(/\d+/).should eq(4) }
      it { "bbbb".rindex(/\d/).should be_nil }

      describe "which matches empty string" do
        it { "foo".rindex(/o*/).should eq(3) }
        it { "foo".rindex(//).should eq(3) }
        it { "foo".rindex(/\b/).should eq(3) }
      end

      describe "with offset" do
        it { "bbbb".rindex(/b/, 2).should eq(2) }
        it { "abbbb".rindex(/b/, 0).should be_nil }
        it { "abbbb".rindex(/a/, 0).should eq(0) }
        it { "bbbb".rindex(/b/, -2).should eq(2) }
        it { "bbbb".rindex(/b/, -5).should be_nil }
        it { "bbbb".rindex(/b/, -4).should eq(0) }
        it { "日本語日本語".rindex(/日本/, 2).should eq(0) }
      end
    end
  end

  describe "partition" do
    describe "by char" do
      it { "hello".partition('h').should eq({"", "h", "ello"}) }
      it { "hello".partition('o').should eq({"hell", "o", ""}) }
      it { "hello".partition('l').should eq({"he", "l", "lo"}) }
      it { "hello".partition('x').should eq({"hello", "", ""}) }
    end

    describe "by string" do
      it { "hello".partition("h").should eq({"", "h", "ello"}) }
      it { "hello".partition("o").should eq({"hell", "o", ""}) }
      it { "hello".partition("l").should eq({"he", "l", "lo"}) }
      it { "hello".partition("ll").should eq({"he", "ll", "o"}) }
      it { "hello".partition("x").should eq({"hello", "", ""}) }
    end

    describe "by regex" do
      it { "hello".partition(/h/).should eq({"", "h", "ello"}) }
      it { "hello".partition(/o/).should eq({"hell", "o", ""}) }
      it { "hello".partition(/l/).should eq({"he", "l", "lo"}) }
      it { "hello".partition(/ll/).should eq({"he", "ll", "o"}) }
      it { "hello".partition(/.l/).should eq({"h", "el", "lo"}) }
      it { "hello".partition(/.h/).should eq({"hello", "", ""}) }
      it { "hello".partition(/h./).should eq({"", "he", "llo"}) }
      it { "hello".partition(/o./).should eq({"hello", "", ""}) }
      it { "hello".partition(/.o/).should eq({"hel", "lo", ""}) }
      it { "hello".partition(/x/).should eq({"hello", "", ""}) }
    end
  end

  describe "rpartition" do
    describe "by char" do
      it { "hello".rpartition('l').should eq({"hel", "l", "o"}) }
      it { "hello".rpartition('o').should eq({"hell", "o", ""}) }
      it { "hello".rpartition('h').should eq({"", "h", "ello"}) }
    end

    describe "by string" do
      it { "hello".rpartition("l").should eq({"hel", "l", "o"}) }
      it { "hello".rpartition("x").should eq({"", "", "hello"}) }
      it { "hello".rpartition("o").should eq({"hell", "o", ""}) }
      it { "hello".rpartition("h").should eq({"", "h", "ello"}) }
      it { "hello".rpartition("ll").should eq({"he", "ll", "o"}) }
      it { "hello".rpartition("lo").should eq({"hel", "lo", ""}) }
      it { "hello".rpartition("he").should eq({"", "he", "llo"}) }
    end

    describe "by regex" do
      it { "hello".rpartition(/.l/).should eq({"he", "ll", "o"}) }
      it { "hello".rpartition(/ll/).should eq({"he", "ll", "o"}) }
      it { "hello".rpartition(/.o/).should eq({"hel", "lo", ""}) }
      it { "hello".rpartition(/.e/).should eq({"", "he", "llo"}) }
      it { "hello".rpartition(/l./).should eq({"hel", "lo", ""}) }
    end
  end

  describe "byte_index" do
    it { "foo".byte_index('o'.ord).should eq(1) }
    it { "foo bar booz".byte_index('o'.ord, 3).should eq(9) }
    it { "foo".byte_index('a'.ord).should be_nil }
    it { "foo".byte_index('a'.ord).should be_nil }
    it { "foo".byte_index('o'.ord, 3).should be_nil }
    it {
      "Dizzy Miss Lizzy".byte_index('z'.ord).should eq(2)
      "Dizzy Miss Lizzy".byte_index('z'.ord, 3).should eq(3)
      "Dizzy Miss Lizzy".byte_index('z'.ord, -4).should eq(13)
      "Dizzy Miss Lizzy".byte_index('z'.ord, -17).should be_nil
    }

    it "gets byte index of string" do
      "hello world".byte_index("he").should eq(0)
      "hello world".byte_index("lo").should eq(3)
      "hello world".byte_index("world", 7).should be_nil
      "foo foo".byte_index("oo").should eq(1)
      "foo foo".byte_index("oo", 2).should eq(5)
      "こんにちは世界".byte_index("ちは").should eq(9)
    end
  end

  describe "includes?" do
    describe "by char" do
      it { "foo".includes?('o').should be_true }
      it { "foo".includes?('g').should be_false }
    end

    describe "by string" do
      it { "foo bar".includes?("o b").should be_true }
      it { "foo".includes?("fg").should be_false }
      it { "foo".includes?("").should be_true }
    end
  end

  describe "split" do
    describe "by whitespace" do
      it { "   foo   bar\n\t  baz   ".split.should eq(["foo", "bar", "baz"]) }
      it { "   foo   bar\n\t  baz   ".split(1).should eq(["   foo   bar\n\t  baz   "]) }
      it { "   foo   bar\n\t  baz   ".split(2).should eq(["foo", "bar\n\t  baz   "]) }
      it { "日本語 \n\t 日本 \n\n 語".split.should eq(["日本語", "日本", "語"]) }

      it { " foo\u00A0bar baz".split.should eq(["foo", "bar", "baz"]) }
    end

    describe "by char" do
      it { "".split(',').should eq([""]) }
      it { "".split(',', remove_empty: true).should eq([] of String) }
      it { "foo,bar,,baz,".split(',').should eq(["foo", "bar", "", "baz", ""]) }
      it { "foo,bar,,baz,".split(',', remove_empty: true).should eq(["foo", "bar", "baz"]) }
      it { "foo,bar,,baz".split(',').should eq(["foo", "bar", "", "baz"]) }
      it { "foo,bar,,baz".split(',', remove_empty: true).should eq(["foo", "bar", "baz"]) }
      it { "foo".split(',').should eq(["foo"]) }
      it { "foo".split(' ').should eq(["foo"]) }
      it { "   foo".split(' ').should eq(["", "", "", "foo"]) }
      it { "foo   ".split(' ').should eq(["foo", "", "", ""]) }
      it { "   foo  bar".split(' ').should eq(["", "", "", "foo", "", "bar"]) }
      it { "   foo   bar\n\t  baz   ".split(' ').should eq(["", "", "", "foo", "", "", "bar\n\t", "", "baz", "", "", ""]) }
      it { "   foo   bar\n\t  baz   ".split(' ').should eq(["", "", "", "foo", "", "", "bar\n\t", "", "baz", "", "", ""]) }
      it { "foo,bar,baz,qux".split(',', 1).should eq(["foo,bar,baz,qux"]) }
      it { "foo,bar,baz,qux".split(',', 3).should eq(["foo", "bar", "baz,qux"]) }
      it { "foo,bar,baz,qux".split(',', 30).should eq(["foo", "bar", "baz", "qux"]) }
      it { "foo bar baz qux".split(' ', 1).should eq(["foo bar baz qux"]) }
      it { "foo bar baz qux".split(' ', 3).should eq(["foo", "bar", "baz qux"]) }
      it { "foo bar baz qux".split(' ', 30).should eq(["foo", "bar", "baz", "qux"]) }
      it { "a,b,".split(',', 3).should eq(["a", "b", ""]) }
      it { "日本ん語日本ん語".split('ん').should eq(["日本", "語日本", "語"]) }
      it { "=".split('=').should eq(["", ""]) }
      it { "a=".split('=').should eq(["a", ""]) }
      it { "=b".split('=').should eq(["", "b"]) }
      it { "=".split('=', 2).should eq(["", ""]) }
      it { "=".split('=', 2, remove_empty: true).should eq([] of String) }
    end

    describe "by string" do
      it { "".split(",").should eq([""]) }
      it { "".split(":-").should eq([""]) }
      it { "".split(":-", remove_empty: true).should eq([] of String) }
      it { "foo:-bar:-:-baz:-".split(":-").should eq(["foo", "bar", "", "baz", ""]) }
      it { "foo:-bar:-:-baz:-".split(":-", remove_empty: true).should eq(["foo", "bar", "baz"]) }
      it { "foo:-bar:-:-baz".split(":-").should eq(["foo", "bar", "", "baz"]) }
      it { "foo".split(":-").should eq(["foo"]) }
      it { "foo".split("").should eq(["f", "o", "o"]) }
      it { "日本さん語日本さん語".split("さん").should eq(["日本", "語日本", "語"]) }
      it { "foo,bar,baz,qux".split(",", 1).should eq(["foo,bar,baz,qux"]) }
      it { "foo,bar,baz,qux".split(",", 3).should eq(["foo", "bar", "baz,qux"]) }
      it { "foo,bar,baz,qux".split(",", 30).should eq(["foo", "bar", "baz", "qux"]) }
      it { "a b c".split(" ", 2).should eq(["a", "b c"]) }
      it { "=".split("=").should eq(["", ""]) }
      it { "a=".split("=").should eq(["a", ""]) }
      it { "=b".split("=").should eq(["", "b"]) }
      it { "=".split("=", 2).should eq(["", ""]) }
      it { "=".split("=", 2, remove_empty: true).should eq([] of String) }
    end

    describe "by regex" do
      it { "".split(/\n\t/).should eq([""]) }
      it { "".split(/\n\t/, remove_empty: true).should eq([] of String) }
      it { "foo\n\tbar\n\t\n\tbaz".split(/\n\t/).should eq(["foo", "bar", "", "baz"]) }
      it { "foo\n\tbar\n\t\n\tbaz".split(/\n\t/, remove_empty: true).should eq(["foo", "bar", "baz"]) }
      it { "foo\n\tbar\n\t\n\tbaz".split(/(?:\n\t)+/).should eq(["foo", "bar", "baz"]) }
      it { "foo,bar".split(/,/, 1).should eq(["foo,bar"]) }
      it { "foo,bar,".split(/,/).should eq(["foo", "bar", ""]) }
      it { "foo,bar,baz,qux".split(/,/, 1).should eq(["foo,bar,baz,qux"]) }
      it { "foo,bar,baz,qux".split(/,/, 3).should eq(["foo", "bar", "baz,qux"]) }
      it { "foo,bar,baz,qux".split(/,/, 30).should eq(["foo", "bar", "baz", "qux"]) }
      it { "a b c".split(Regex.new(" "), 2).should eq(["a", "b c"]) }
      it { "日本ん語日本ん語".split(/ん/).should eq(["日本", "語日本", "語"]) }
      it { "九十九十九".split(/(?=十)/).should eq(["九", "十九", "十九"]) }
      it { "hello world".split(/\b/).should eq(["hello", " ", "world", ""]) }
      it { "hello world".split(/\w+|(?= )/).should eq(["", " ", ""]) }
      it { "abc".split(//).should eq(["a", "b", "c"]) }
      it { "hello".split(/\w+/).should eq(["", ""]) }
      it { "foo".split(/o/).should eq(["f", "", ""]) }
      it { "=".split(/\=/).should eq(["", ""]) }
      it { "a=".split(/\=/).should eq(["a", ""]) }
      it { "=b".split(/\=/).should eq(["", "b"]) }
      it { "=".split(/\=/, 2).should eq(["", ""]) }
      it { "=".split(/\=/, 2, remove_empty: true).should eq([] of String) }
      it { ",".split(/(?:(x)|(,))/).should eq(["", ",", ""]) }

      it "keeps groups" do
        s = "split on the word on okay?"
        s.split(/(on)/).should eq(["split ", "on", " the word ", "on", " okay?"])
      end
    end
  end

  describe "starts_with?" do
    it { "foobar".starts_with?("foo").should be_true }
    it { "foobar".starts_with?("").should be_true }
    it { "foobar".starts_with?("foobarbaz").should be_false }
    it { "foobar".starts_with?("foox").should be_false }
    it { "foobar".starts_with?(/foo/).should be_true }
    it { "foobar".starts_with?(/bar/).should be_false }
    it { "foobar".starts_with?('f').should be_true }
    it { "foobar".starts_with?('g').should be_false }
    it { "よし".starts_with?('よ').should be_true }
    it { "よし!".starts_with?("よし").should be_true }

    it "treats first char as replacement char if invalid in an otherwise ascii string" do
      "\xEEfoo".starts_with?('\u{EE}').should be_false
      "\xEEfoo".starts_with?(Char::REPLACEMENT).should be_true
    end
  end

  describe "ends_with?" do
    it { "foobar".ends_with?("bar").should be_true }
    it { "foobar".ends_with?("").should be_true }
    it { "foobar".ends_with?("foobarbaz").should be_false }
    it { "foobar".ends_with?("xbar").should be_false }
    it { "foobar".ends_with?(/bar/).should be_true }
    it { "foobar".ends_with?(/foo|baz/).should be_false }
    it { "foobar".ends_with?('r').should be_true }
    it { "foobar".ends_with?('x').should be_false }
    it { "よし".ends_with?('し').should be_true }
    it { "よし".ends_with?('な').should be_false }
    it { "あいう_".ends_with?('_').should be_true }

    it "treats last char as replacement char if invalid in an otherwise ascii string" do
      "foo\xEE".ends_with?('\u{EE}').should be_false
      "foo\xEE".ends_with?(Char::REPLACEMENT).should be_true
    end
  end

  describe "=~" do
    it "matches with group" do
      "foobar" =~ /(o+)ba(r?)/
      $1.should eq("oo")
      $2.should eq("r")
    end

    it "returns nil with string" do
      ("foo" =~ "foo").should be_nil
    end

    it "returns nil with regex and regex" do
      (/foo/ =~ /foo/).should be_nil
    end
  end

  describe "delete" do
    it { "foobar".delete { |char| char == 'o' }.should eq("fbar") }
    it { "hello world".delete("lo").should eq("he wrd") }
    it { "hello world".delete("lo", "o").should eq("hell wrld") }
    it { "hello world".delete("hello", "^l").should eq("ll wrld") }
    it { "hello world".delete("ej-m").should eq("ho word") }
    it { "hello^world".delete("\\^aeiou").should eq("hllwrld") }
    it { "hello-world".delete("a\\-eo").should eq("hllwrld") }
    it { "hello world\\r\\n".delete("\\").should eq("hello worldrn") }
    it { "hello world\\r\\n".delete("\\A").should eq("hello world\\r\\n") }
    it { "hello world\\r\\n".delete("X-\\w").should eq("hello orldrn") }

    it "deletes one char" do
      "foobar".delete('o').should eq("fbar")
      "foobar".delete('x').should eq("foobar")
    end
  end

  describe "#reverse" do
    it "reverses string" do
      "foobar".reverse.should eq("raboof")
    end

    it "reverses utf-8 string" do
      "こんにちは".reverse.should eq("はちにんこ")
    end

    it "reverses taking grapheme clusters into account" do
      "noël".reverse.should eq("lëon")
    end

    pending "converts invalid code units to replacement char" do
      "!\xB0\xC2?".reverse.chars.should eq("?\uFFFD!".chars)
      "\xC2\xB0\xB0\xC2?".reverse.chars.should eq("?\uFFFD\xC2\xB0".chars)
    end
  end

  describe "sub" do
    it "subs char with char" do
      "foobar".sub('o', 'e').should eq("feobar")
    end

    it "subs char with string" do
      "foobar".sub('o', "ex").should eq("fexobar")
    end

    it "subs char with string" do
      replaced = "foobar".sub do |char|
        char.should eq 'f'
        "some"
      end.should eq("someoobar")

      empty = ""
      empty.sub { 'f' }.should be(empty)
    end

    it "subs with regex and block" do
      actual = "foo booor booooz".sub(/o+/) do |str|
        "#{str}#{str.size}"
      end
      actual.should eq("foo2 booor booooz")
    end

    it "subs with regex and block with group" do
      actual = "foo booor booooz".sub(/(o+).*?(o+)/) do |str, match|
        "#{match[1].size}#{match[2].size}"
      end
      actual.should eq("f23r booooz")
    end

    it "subs with regex and string" do
      "foo boor booooz".sub(/o+/, "a").should eq("fa boor booooz")
    end

    it "subs with regex and string, returns self if no match" do
      str = "hello"
      str.sub(/a/, "b").should be(str)
    end

    it "subs with regex and string (utf-8)" do
      "fここ bここr bここここz".sub(/こ+/, "そこ").should eq("fそこ bここr bここここz")
    end

    it "subs with empty string" do
      "foo".sub("", "x").should eq("xfoo")
    end

    it "subs with empty regex" do
      "foo".sub(//, "x").should eq("xfoo")
    end

    it "subs null character" do
      null = "\u{0}"
      "f\u{0}\u{0}".sub(/#{null}/, "o").should eq("fo\u{0}")
    end

    it "subs with string and string" do
      "foo boor booooz".sub("oo", "a").should eq("fa boor booooz")
    end

    it "subs with string and string return self if no match" do
      str = "hello"
      str.sub("a", "b").should be(str)
    end

    it "subs with string and string (utf-8)" do
      "fここ bここr bここここz".sub("ここ", "そこ").should eq("fそこ bここr bここここz")
    end

    it "subs with string and string (#3258)" do
      "私は日本人です".sub("日本", "スペイン").should eq("私はスペイン人です")
    end

    it "subs with string and block" do
      result = "foo boo".sub("oo") do |value|
        value.should eq("oo")
        "a"
      end
      result.should eq("fa boo")
    end

    it "subs with char hash" do
      str = "hello"
      str.sub({'e' => 'a', 'l' => 'd'}).should eq("hallo")

      empty = ""
      empty.sub({'a' => 'b'}).should be(empty)
    end

    it "subs with regex and hash" do
      str = "hello"
      str.sub(/(he|l|o)/, {"he" => "ha", "l" => "la"}).should eq("hallo")
      str.sub(/(he|l|o)/, {"l" => "la"}).should be(str)
    end

    it "subs with regex and named tuple" do
      str = "hello"
      str.sub(/(he|l|o)/, {he: "ha", l: "la"}).should eq("hallo")
      str.sub(/(he|l|o)/, {l: "la"}).should be(str)
    end

    it "subs using $~" do
      "foo".sub(/(o)/) { "x#{$1}x" }.should eq("fxoxo")
    end

    it "subs using with \\" do
      "foo".sub(/(o)/, "\\").should eq("f\\o")
    end

    it "subs using with z\\w" do
      "foo".sub(/(o)/, "z\\w").should eq("fz\\wo")
    end

    it "replaces with numeric back-reference" do
      "foo".sub(/o/, "x\\0x").should eq("fxoxo")
      "foo".sub(/(o)/, "x\\1x").should eq("fxoxo")
      "foo".sub(/(o)/, "\\\\1").should eq("f\\1o")
      "hello".sub(/[aeiou]/, "(\\0)").should eq("h(e)llo")
    end

    it "replaces with incomplete named back-reference (1)" do
      "foo".sub(/(oo)/, "|\\k|").should eq("f|\\k|")
    end

    it "replaces with incomplete named back-reference (2)" do
      "foo".sub(/(oo)/, "|\\k\\1|").should eq("f|\\koo|")
    end

    it "replaces with named back-reference" do
      "foo".sub(/(?<bar>oo)/, "|\\k<bar>|").should eq("f|oo|")
    end

    it "replaces with multiple named back-reference" do
      "fooxx".sub(/(?<bar>oo)(?<baz>x+)/, "|\\k<bar>|\\k<baz>|").should eq("f|oo|xx|")
    end

    it "replaces with \\a" do
      "foo".sub(/(oo)/, "|\\a|").should eq("f|\\a|")
    end

    it "replaces with \\\\\\1" do
      "foo".sub(/(oo)/, "|\\\\\\1|").should eq("f|\\oo|")
    end

    it "ignores if backreferences: false" do
      "foo".sub(/o/, "x\\0x", backreferences: false).should eq("fx\\0xo")
    end

    it "subs at index with char" do
      "hello".sub(1, 'a').should eq("hallo")
    end

    it "subs at index with char, non-ascii" do
      "あいうえお".sub(2, 'の').should eq("あいのえお")
    end

    it "subs at negative index with char" do
      string = "abc".sub(-1, 'd')
      string.should eq("abd")
      string = string.sub(-2, 'n')
      string.should eq("and")
    end

    it "subs at index with string" do
      "hello".sub(1, "eee").should eq("heeello")
    end

    it "subs at negative index with string" do
      "hello".sub(-1, "ooo").should eq("hellooo")
    end

    it "subs at index with string, non-ascii" do
      "あいうえお".sub(2, "けくこ").should eq("あいけくこえお")
    end

    it "subs range with char" do
      "hello".sub(1..2, 'a').should eq("halo")
    end

    it "subs range with char, non-ascii" do
      "あいうえお".sub(1..2, 'け').should eq("あけえお")
    end

    it "subs range with string" do
      "hello".sub(1..2, "eee").should eq("heeelo")
    end

    it "subs range with string, non-ascii" do
      "あいうえお".sub(1..2, "けくこ").should eq("あけくこえお")
    end

    it "subs endless range with char" do
      "hello".sub(2..nil, 'a').should eq("hea")
    end

    it "subs endless range with string" do
      "hello".sub(2..nil, "ya").should eq("heya")
    end

    it "subs beginless range with char" do
      "hello".sub(nil..2, 'a').should eq("alo")
    end

    it "subs beginless range with string" do
      "hello".sub(nil..2, "ye").should eq("yelo")
    end

    it "subs the last char" do
      str = "hello"
      str.sub('o', 'a').should eq("hella")
      str.sub('o', "ad").should eq("hellad")
      str.sub(4, 'a').should eq("hella")
      str.sub(4, "ad").should eq("hellad")
      str.sub(4..4, 'a').should eq("hella")
      str.sub(4..4, "ad").should eq("hellad")
      str.sub({'a' => 'b', 'o' => 'a'}).should eq("hella")
      str.sub({'a' => 'b', 'o' => "ad"}).should eq("hellad")
      str.sub(/o/, 'a').should eq("hella")
      str.sub(/o/, "ad").should eq("hellad")
      str.sub(/o/) { 'a' }.should eq("hella")
      str.sub(/o/) { "ad" }.should eq("hellad")
      str.sub(/(o)/, {"o" => 'a'}).should eq("hella")
      str.sub(/(o)/, {"o" => "ad"}).should eq("hellad")
      str.sub(/(o)/) { 'a' }.should eq("hella")
      str.sub(/(o)/) { "ad" }.should eq("hellad")
    end
  end

  describe "gsub" do
    it "gsubs char with char" do
      "foobar".gsub('o', 'e').should eq("feebar")
    end

    it "gsubs char with string" do
      "foobar".gsub('o', "ex").should eq("fexexbar")
    end

    it "gsubs char with string (nop)" do
      s = "foobar"
      s.gsub('x', "yz").should be(s)
    end

    it "gsubs char with char in non-ascii string" do
      "/ä".gsub('/', '-').should eq("-ä")
    end

    it "gsubs char with string depending on the char" do
      replaced = "foobar".gsub do |char|
        case char
        when 'f'
          "some"
        when 'o'
          "thing"
        when 'a'
          "ex"
        else
          char
        end
      end
      replaced.should eq("somethingthingbexr")
    end

    it "gsubs with regex and block" do
      actual = "foo booor booooz".gsub(/o+/) do |str|
        "#{str}#{str.size}"
      end
      actual.should eq("foo2 booo3r boooo4z")
    end

    it "gsubs with regex and block with group" do
      actual = "foo booor booooz".gsub(/(o+).*?(o+)/) do |str, match|
        "#{match[1].size}#{match[2].size}"
      end
      actual.should eq("f23r b31z")
    end

    it "gsubs with regex and string" do
      "foo boor booooz".gsub(/o+/, "a").should eq("fa bar baz")
    end

    it "gsubs with regex and string, returns self if no match" do
      str = "hello"
      str.gsub(/a/, "b").should be(str)
    end

    it "gsubs with regex and string (utf-8)" do
      "fここ bここr bここここz".gsub(/こ+/, "そこ").should eq("fそこ bそこr bそこz")
    end

    it "gsubs with empty string" do
      "foo".gsub("", "x").should eq("xfxoxox")
    end

    it "gsubs with empty regex" do
      "foo".gsub(//, "x").should eq("xfxoxox")
    end

    it "gsubs null character" do
      null = "\u{0}"
      "f\u{0}\u{0}".gsub(/#{null}/, "o").should eq("foo")
    end

    it "gsubs with string and string" do
      "foo boor booooz".gsub("oo", "a").should eq("fa bar baaz")
    end

    it "gsubs with string and string return self if no match" do
      str = "hello"
      str.gsub("a", "b").should be(str)
    end

    it "gsubs with string and string (utf-8)" do
      "fここ bここr bここここz".gsub("ここ", "そこ").should eq("fそこ bそこr bそこそこz")
    end

    it "gsubs with string and block" do
      i = 0
      result = "foo boo".gsub("oo") do |value|
        value.should eq("oo")
        i += 1
        i == 1 ? "a" : "e"
      end
      result.should eq("fa be")
    end

    it "gsubs with char hash" do
      str = "hello"
      str.gsub({'e' => 'a', 'l' => 'd'}).should eq("haddo")
    end

    it "gsubs with char named tuple" do
      str = "hello"
      str.gsub({e: 'a', l: 'd'}).should eq("haddo")
    end

    it "gsubs with regex and hash" do
      str = "hello"
      str.gsub(/(he|l|o)/, {"he" => "ha", "l" => "la"}).should eq("halala")
    end

    it "gsubs with regex and named tuple" do
      str = "hello"
      str.gsub(/(he|l|o)/, {he: "ha", l: "la"}).should eq("halala")
    end

    it "gsubs using $~" do
      "foo".gsub(/(o)/) { "x#{$1}x" }.should eq("fxoxxox")
    end

    it "replaces with numeric back-reference" do
      "foo".gsub(/o/, "x\\0x").should eq("fxoxxox")
      "foo".gsub(/(o)/, "x\\1x").should eq("fxoxxox")
      "foo".gsub(/(ここ)|(oo)/, "x\\1\\2x").should eq("fxoox")
    end

    it "replaces with named back-reference" do
      "foo".gsub(/(?<bar>oo)/, "|\\k<bar>|").should eq("f|oo|")
      "foo".gsub(/(?<x>ここ)|(?<bar>oo)/, "|\\k<bar>|").should eq("f|oo|")
    end

    it "replaces with incomplete back-reference (1)" do
      "foo".gsub(/o/, "\\").should eq("f\\\\")
    end

    it "replaces with incomplete back-reference (2)" do
      "foo".gsub(/o/, "\\\\").should eq("f\\\\")
    end

    it "replaces with incomplete back-reference (3)" do
      "foo".gsub(/o/, "\\k").should eq("f\\k\\k")
    end

    it "raises with incomplete back-reference (1)" do
      expect_raises(ArgumentError) do
        "foo".gsub(/(?<bar>oo)/, "|\\k<bar|")
      end
    end

    it "raises with incomplete back-reference (2)" do
      expect_raises(ArgumentError, "Missing ending '>' for '\\\\k<...") do
        "foo".gsub(/o/, "\\k<")
      end
    end

    it "replaces with back-reference to missing capture group" do
      "foo".gsub(/o/, "\\1").should eq("f")

      expect_raises(IndexError, "Undefined group name reference: \"bar\"") do
        "foo".gsub(/o/, "\\k<bar>").should eq("f")
      end

      expect_raises(IndexError, "Undefined group name reference: \"\"") do
        "foo".gsub(/o/, "\\k<>")
      end
    end

    it "replaces with escaped back-reference" do
      "foo".gsub(/o/, "\\\\0").should eq("f\\0\\0")
      "foo".gsub(/oo/, "\\\\k<bar>").should eq("f\\k<bar>")
    end

    it "ignores if backreferences: false" do
      "foo".gsub(/o/, "x\\0x", backreferences: false).should eq("fx\\0xx\\0x")
    end
  end

  it "scans using $~" do
    str = String.build do |str|
      "fooxooo".scan(/(o+)/) { str << $1 }
    end
    str.should eq("ooooo")
  end

  it "#dump" do
    assert_prints "a".dump, %("a")
    assert_prints "\\".dump, %("\\\\")
    assert_prints "\"".dump, %("\\"")
    assert_prints "\0".dump, %("\\u0000")
    assert_prints "\x01".dump, %("\\u0001")
    assert_prints "\xFF".dump, %("\\xFF")
    assert_prints "\a".dump, %("\\a")
    assert_prints "\b".dump, %("\\b")
    assert_prints "\e".dump, %("\\e")
    assert_prints "\f".dump, %("\\f")
    assert_prints "\n".dump, %("\\n")
    assert_prints "\r".dump, %("\\r")
    assert_prints "\t".dump, %("\\t")
    assert_prints "\v".dump, %("\\v")
    assert_prints "\#{".dump, %("\\\#{")
    assert_prints "á".dump, %("\\u00E1")
    assert_prints "\u{81}".dump, %("\\u0081")
    assert_prints "\u{1F48E}".dump, %("\\u{1F48E}")
    assert_prints "\uF8FF".dump, %("\\uF8FF")       # private use character (Co)
    assert_prints "\u202A".dump, %("\\u202A")       # bidi control character (Cf)
    assert_prints "\u{110BD}".dump, %("\\u{110BD}") # Format character > U+FFFF (Cf)
    assert_prints "\u00A0".dump, %("\\u00A0")       # white space (Zs)
    assert_prints "\u200D".dump, %("\\u200D")       # format character (Cf)
    assert_prints " ".dump, %(" ")
  end

  it "#dump_unquoted" do
    assert_prints "a".dump_unquoted, %(a)
    assert_prints "\\".dump_unquoted, %(\\\\)
    assert_prints "á".dump_unquoted, %(\\u00E1)
    assert_prints "\u{81}".dump_unquoted, %(\\u0081)
    assert_prints "\u{1F48E}".dump_unquoted, %(\\u{1F48E})
  end

  it "#inspect" do
    assert_prints "a".inspect, %("a")
    assert_prints "\\".inspect, %("\\\\")
    assert_prints "\"".inspect, %("\\"")
    assert_prints "\0".inspect, %("\\u0000")
    assert_prints "\x01".inspect, %("\\u0001")
    assert_prints "\xFF".inspect, %("\\xFF")
    assert_prints "\a".inspect, %("\\a")
    assert_prints "\b".inspect, %("\\b")
    assert_prints "\e".inspect, %("\\e")
    assert_prints "\f".inspect, %("\\f")
    assert_prints "\n".inspect, %("\\n")
    assert_prints "\r".inspect, %("\\r")
    assert_prints "\t".inspect, %("\\t")
    assert_prints "\v".inspect, %("\\v")
    assert_prints "\#{".inspect, %("\\\#{")
    assert_prints "á".inspect, %("á")
    assert_prints "\u{81}".inspect, %("\\u0081")
    assert_prints "\u{1F48E}".inspect, %("\u{1F48E}")
    assert_prints "\uF8FF".inspect, %("\\uF8FF")       # private use character (Co)
    assert_prints "\u202A".inspect, %("\\u202A")       # bidi control character (Cf)
    assert_prints "\u{110BD}".inspect, %("\\u{110BD}") # Format character > U+FFFF (Cf)
    assert_prints "\u00A0".inspect, %("\\u00A0")       # white space (Zs)
    assert_prints "\u200D".inspect, %("\\u200D")       # format character (Cf)
    assert_prints " ".inspect, %(" ")
  end

  it "#inspect_unquoted" do
    assert_prints "a".inspect_unquoted, %(a)
    assert_prints "\\".inspect_unquoted, %(\\\\)
    assert_prints "á".inspect_unquoted, %(á)
    assert_prints "\u{81}".inspect_unquoted, %(\\u0081)
    assert_prints "\u{1F48E}".inspect_unquoted, %(\u{1F48E})
  end

  it "does pretty_inspect" do
    "a".pretty_inspect.should eq(%("a"))
    "hello\nworld".pretty_inspect.should eq(%("hello\\n" + "world"))
    "hello\nworld".pretty_inspect(width: 9).should eq(%("hello\\n" +\n"world"))
    "hello\nworld\n".pretty_inspect(width: 9).should eq(%("hello\\n" +\n"world\\n"))
  end

  it "does *" do
    ("foo" * 10).should eq("foofoofoofoofoofoofoofoofoofoo")
  end

  describe "+" do
    it "does for both ascii" do
      str = "foo" + "bar"
      str.@length.should eq(6) # Check that it was pre-computed
      str.should eq("foobar")
    end

    it "does for both unicode" do
      str = "青い" + "旅路"
      str.@length.should eq(4) # Check that it was pre-computed
      str.should eq("青い旅路")
    end

    it "does with ascii char" do
      str = "foo"
      str2 = str + '/'
      str2.should eq("foo/")
    end

    it "does with unicode char" do
      str = "fooba"
      str2 = str + 'る'
      str2.should eq("foobaる")
    end

    it "does when right is empty" do
      str1 = "foo"
      str2 = ""
      (str1 + str2).should be(str1)
    end

    it "does when left is empty" do
      str1 = ""
      str2 = "foo"
      (str1 + str2).should be(str2)
    end
  end

  it "escapes chars" do
    "\a"[0].should eq('\a')
    "\b"[0].should eq('\b')
    "\t"[0].should eq('\t')
    "\n"[0].should eq('\n')
    "\v"[0].should eq('\v')
    "\f"[0].should eq('\f')
    "\r"[0].should eq('\r')
    "\e"[0].should eq('\e')
    "\""[0].should eq('"')
    "\\"[0].should eq('\\')
  end

  it "escapes with octal" do
    "\3"[0].ord.should eq(3)
    "\23"[0].ord.should eq((2 * 8) + 3)
    "\123"[0].ord.should eq((1 * 8 * 8) + (2 * 8) + 3)
    "\033"[0].ord.should eq((3 * 8) + 3)
    "\033a"[1].should eq('a')
  end

  it "escapes with unicode" do
    "\u{12}".codepoint_at(0).should eq(1 * 16 + 2)
    "\u{A}".codepoint_at(0).should eq(10)
    "\u{AB}".codepoint_at(0).should eq(10 * 16 + 11)
    "\u{AB}1".codepoint_at(1).should eq('1'.ord)
  end

  it "does char_at" do
    "いただきます".char_at(2).should eq('だ')
    "foo".char_at(0).should eq('f')
    "foo".char_at(4) { 'x' }.should eq('x')

    expect_raises(IndexError) do
      "foo".char_at(4)
    end
  end

  it "does byte_at" do
    "hello".byte_at(1).should eq('e'.ord)
    expect_raises(IndexError) { "hello".byte_at(5) }
  end

  it "does byte_at?" do
    "hello".byte_at?(1).should eq('e'.ord)
    "hello".byte_at?(5).should be_nil
  end

  it "does chars" do
    "ぜんぶ".chars.should eq(['ぜ', 'ん', 'ぶ'])
  end

  describe "creating from a pointer" do
    it "allows creating a string with zeros" do
      p = Pointer(UInt8).malloc(3)
      p[0] = 'a'.ord.to_u8
      p[1] = '\0'.ord.to_u8
      p[2] = 'b'.ord.to_u8
      s = String.new(p, 3)
      s[0].should eq('a')
      s[1].should eq('\0')
      s[2].should eq('b')
      s.bytesize.should eq(3)
    end

    it "raises an exception when creating a string with a null pointer and no size" do
      expect_raises ArgumentError do
        String.new(Pointer(UInt8).null)
      end
    end

    it "raises when creating from a null pointer with a nonzero size" do
      expect_raises ArgumentError, "Cannot create a string with a null pointer and a non-zero (3) bytesize" do
        String.new(Pointer(UInt8).null, 3)
      end
    end

    it "doesn't raise creating from a null pointer with size 0" do
      String.new(Pointer(UInt8).null, 0).should eq ""
    end
  end

  describe "creating from a slice" do
    it "allows creating from an empty slice" do
      String.new(Bytes.empty).should eq("")
    end
  end

  describe "tr" do
    it "translates" do
      "bla".tr("a", "h").should eq("blh")
      "bla".tr("a", "⊙").should eq("bl⊙")
      "bl⊙a".tr("⊙", "a").should eq("blaa")
      "bl⊙a".tr("⊙", "ⓧ").should eq("blⓧa")
      "bl⊙a⊙asdfd⊙dsfsdf⊙⊙⊙".tr("a⊙", "ⓧt").should eq("bltⓧtⓧsdfdtdsfsdfttt")
      "hello".tr("aeiou", "*").should eq("h*ll*")
      "hello".tr("el", "ip").should eq("hippo")
      "Lisp".tr("Lisp", "Crys").should eq("Crys")
      "hello".tr("helo", "1212").should eq("12112")
      "this".tr("this", "ⓧ").should eq("ⓧⓧⓧⓧ")
      "über".tr("ü", "u").should eq("uber")
      "aabbcc".tr("a", "xyz").should eq("xxbbcc")
      "aabbcc".tr("a", "いろは").should eq("いいbbcc")
    end

    context "given no replacement characters" do
      it "acts as #delete" do
        "foo".tr("o", "").should eq("foo".delete("o"))
      end
    end
  end

  describe "compare" do
    it "compares with == when same string" do
      "foo".should eq("foo")
    end

    it "compares with == when different strings same contents" do
      s1 = "foo#{1}"
      s2 = "foo#{1}"
      s1.should eq(s2)
    end

    it "compares with == when different contents" do
      s1 = "foo#{1}"
      s2 = "foo#{2}"
      s1.should_not eq(s2)
    end

    it "sorts strings" do
      s1 = "foo1"
      s2 = "foo"
      s3 = "bar"
      [s1, s2, s3].sort.should eq(["bar", "foo", "foo1"])
    end
  end

  describe "#underscore" do
    it { "Foo".underscore.should eq "foo" }
    it { "FooBar".underscore.should eq "foo_bar" }
    it { "ABCde".underscore.should eq "ab_cde" }
    it { "FOO_bar".underscore.should eq "foo_bar" }
    it { "Char_S".underscore.should eq "char_s" }
    it { "Char_".underscore.should eq "char_" }
    it { "C_".underscore.should eq "c_" }
    it { "HTTP".underscore.should eq "http" }
    it { "HTTP_CLIENT".underscore.should eq "http_client" }
    it { "CSS3".underscore.should eq "css3" }
    it { "HTTP1.1".underscore.should eq "http1.1" }
    it { "3.14IsPi".underscore.should eq "3.14_is_pi" }
    it { "I2C".underscore.should eq "i2_c" }

    describe "with IO" do
      it { String.build { |io| "Foo".underscore io }.should eq "foo" }
      it { String.build { |io| "FooBar".underscore io }.should eq "foo_bar" }
      it { String.build { |io| "ABCde".underscore io }.should eq "ab_cde" }
      it { String.build { |io| "FOO_bar".underscore io }.should eq "foo_bar" }
      it { String.build { |io| "Char_S".underscore io }.should eq "char_s" }
      it { String.build { |io| "Char_".underscore io }.should eq "char_" }
      it { String.build { |io| "C_".underscore io }.should eq "c_" }
      it { String.build { |io| "HTTP".underscore io }.should eq "http" }
      it { String.build { |io| "HTTP_CLIENT".underscore io }.should eq "http_client" }
      it { String.build { |io| "CSS3".underscore io }.should eq "css3" }
      it { String.build { |io| "HTTP1.1".underscore io }.should eq "http1.1" }
      it { String.build { |io| "3.14IsPi".underscore io }.should eq "3.14_is_pi" }
      it { String.build { |io| "I2C".underscore io }.should eq "i2_c" }
    end
  end

  describe "#camelcase" do
    it { "foo".camelcase.should eq "Foo" }
    it { "foo_bar".camelcase.should eq "FooBar" }
    it { "foo".camelcase(lower: true).should eq "foo" }
    it { "foo_bar".camelcase(lower: true).should eq "fooBar" }
    it { "Foo".camelcase.should eq "Foo" }
    it { "Foo_bar".camelcase.should eq "FooBar" }
    it { "Foo".camelcase(lower: true).should eq "foo" }
    it { "Foo_bar".camelcase(lower: true).should eq "fooBar" }

    describe "with IO" do
      it { String.build { |io| "foo".camelcase io }.should eq "Foo" }
      it { String.build { |io| "foo_bar".camelcase io }.should eq "FooBar" }
      it { String.build { |io| "foo".camelcase io, lower: true }.should eq "foo" }
      it { String.build { |io| "foo_bar".camelcase io, lower: true }.should eq "fooBar" }
      it { String.build { |io| "Foo".camelcase io }.should eq "Foo" }
      it { String.build { |io| "Foo_bar".camelcase io }.should eq "FooBar" }
      it { String.build { |io| "Foo".camelcase io, lower: true }.should eq "foo" }
      it { String.build { |io| "Foo_bar".camelcase io, lower: true }.should eq "fooBar" }
    end
  end

  describe "ascii_only?" do
    it "answers ascii_only?" do
      "a".ascii_only?.should be_true
      "あ".ascii_only?.should be_false

      str = String.new(1) do |buffer|
        buffer.value = 'a'.ord.to_u8
        {1, 0}
      end
      str.ascii_only?.should be_true

      str = String.new(4) do |buffer|
        count = 0
        'あ'.each_byte do |byte|
          buffer[count] = byte
          count += 1
        end
        {count, 0}
      end
      str.ascii_only?.should be_false
    end

    it "broken UTF-8 is not ascii_only" do
      "\xED\xA0\x80\xED\xBF\xBF".ascii_only?.should be_false
    end
  end

  describe "scan" do
    it "does without block" do
      a = "cruel world"
      a.scan(/\w+/).map(&.[0]).should eq(["cruel", "world"])
      a.scan(/.../).map(&.[0]).should eq(["cru", "el ", "wor"])
      a.scan(/(...)/).map(&.[1]).should eq(["cru", "el ", "wor"])
      a.scan(/(..)(..)/).map { |m| {m[1], m[2]} }.should eq([{"cr", "ue"}, {"l ", "wo"}])
    end

    it "does with block" do
      a = "foo goo"
      i = 0
      a.scan(/\w(o+)/) do |match|
        case i
        when 0
          match[0].should eq("foo")
          match[1].should eq("oo")
        when 1
          match[0].should eq("goo")
          match[1].should eq("oo")
        else
          fail "expected two matches"
        end
        i += 1
      end
    end

    it "does with utf-8" do
      a = "こん こん"
      a.scan(/こ/).map(&.[0]).should eq(["こ", "こ"])
    end

    it "works when match is empty" do
      r = %r([\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"|;.*|[^\s\[\]{}('"`,;)]*))
      "hello".scan(r).map(&.[0]).should eq(["hello", ""])
      "hello world".scan(/\w+|(?= )/).map(&.[0]).should eq(["hello", "", "world"])
    end

    it "works with strings with block" do
      res = [] of String
      "bla bla ablf".scan("bl") { |s| res << s }
      res.should eq(["bl", "bl", "bl"])
    end

    it "works with strings" do
      "bla bla ablf".scan("bl").should eq(["bl", "bl", "bl"])
      "hello".scan("world").should eq([] of String)
      "bbb".scan("bb").should eq(["bb"])
      "ⓧⓧⓧ".scan("ⓧⓧ").should eq(["ⓧⓧ"])
      "ⓧ".scan("ⓧ").should eq(["ⓧ"])
      "ⓧ ⓧ ⓧ".scan("ⓧ").should eq(["ⓧ", "ⓧ", "ⓧ"])
      "".scan("").should eq([] of String)
      "a".scan("").should eq([] of String)
      "".scan("a").should eq([] of String)
    end

    it "does with number and string" do
      "1ab4".scan(/\d+/).map(&.[0]).should eq(["1", "4"])
    end
  end

  it "has match" do
    "FooBar".match(/oo/).not_nil![0].should eq("oo")
  end

  it "matches with position" do
    "こんにちは".match(/./, 1).not_nil![0].should eq("ん")
  end

  it "matches empty string" do
    match = "".match(/.*/).not_nil!
    match.group_size.should eq(0)
    match[0].should eq("")
  end

  it "matches, but returns Bool" do
    "foo".matches?(/foo/).should eq(true)
    "foo".matches?(/bar/).should eq(false)
  end

  it "has size (same as size)" do
    "テスト".size.should eq(3)
  end

  describe "count" do
    it { "hello world".count("lo").should eq(5) }
    it { "hello world".count("lo", "o").should eq(2) }
    it { "hello world".count("hello", "^l").should eq(4) }
    it { "hello world".count("ej-m").should eq(4) }
    it { "hello^world".count("\\^aeiou").should eq(4) }
    it { "hello-world".count("a\\-eo").should eq(4) }
    it { "hello world\\r\\n".count("\\").should eq(2) }
    it { "hello world\\r\\n".count("\\A").should eq(0) }
    it { "hello world\\r\\n".count("X-\\w").should eq(3) }
    it { "aabbcc".count('a').should eq(2) }
    it { "aabbcc".count(&.in?('a', 'b')).should eq(4) }
  end

  describe "squeeze" do
    it { "aaabbbccc".squeeze(&.in?('a', 'b')).should eq("abccc") }
    it { "aaabbbccc".squeeze(&.in?('a', 'c')).should eq("abbbc") }
    it { "a       bbb".squeeze.should eq("a b") }
    it { "a    bbb".squeeze(' ').should eq("a bbb") }
    it { "aaabbbcccddd".squeeze("b-d").should eq("aaabcd") }
  end

  describe "ljust" do
    it { "123".ljust(2).should eq("123") }
    it { "123".ljust(5).should eq("123  ") }
    it { "12".ljust(7, '-').should eq("12-----") }
    it { "12".ljust(7, 'あ').should eq("12あああああ") }

    describe "to io" do
      it { String.build { |io| "123".ljust(io, 2) }.should eq("123") }
      it { String.build { |io| "123".ljust(io, 5) }.should eq("123  ") }
      it { String.build { |io| "12".ljust(io, 7, '-') }.should eq("12-----") }
      it { String.build { |io| "12".ljust(io, 7, 'あ') }.should eq("12あああああ") }
    end
  end

  describe "rjust" do
    it { "123".rjust(2).should eq("123") }
    it { "123".rjust(5).should eq("  123") }
    it { "12".rjust(7, '-').should eq("-----12") }
    it { "12".rjust(7, 'あ').should eq("あああああ12") }

    describe "to io" do
      it { String.build { |io| "123".rjust(io, 2) }.should eq("123") }
      it { String.build { |io| "123".rjust(io, 5) }.should eq("  123") }
      it { String.build { |io| "12".rjust(io, 7, '-') }.should eq("-----12") }
      it { String.build { |io| "12".rjust(io, 7, 'あ') }.should eq("あああああ12") }
    end
  end

  describe "center" do
    it { "123".center(2).should eq("123") }
    it { "123".center(5).should eq(" 123 ") }
    it { "12".center(7, '-').should eq("--12---") }
    it { "12".center(7, 'あ').should eq("ああ12あああ") }

    describe "to io" do
      it { String.build { |io| "123".center(io, 2) }.should eq("123") }
      it { String.build { |io| "123".center(io, 5) }.should eq(" 123 ") }
      it { String.build { |io| "12".center(io, 7, '-') }.should eq("--12---") }
      it { String.build { |io| "12".center(io, 7, 'あ') }.should eq("ああ12あああ") }
    end
  end

  describe "succ" do
    it "returns an empty string for empty strings" do
      "".succ.should eq("")
    end

    it "returns the successor by increasing the rightmost alphanumeric (digit => digit, letter => letter with same case)" do
      "abcd".succ.should eq("abce")
      "THX1138".succ.should eq("THX1139")

      "<<koala>>".succ.should eq("<<koalb>>")
      "==A??".succ.should eq("==B??")
    end

    it "increases non-alphanumerics (via ascii rules) if there are no alphanumerics" do
      "***".succ.should eq("**+")
      "**`".succ.should eq("**a")
    end

    it "increases the next best alphanumeric (jumping over non-alphanumerics) if there is a carry" do
      "dz".succ.should eq("ea")
      "HZ".succ.should eq("IA")
      "49".succ.should eq("50")

      "izz".succ.should eq("jaa")
      "IZZ".succ.should eq("JAA")
      "699".succ.should eq("700")

      "6Z99z99Z".succ.should eq("7A00a00A")

      "1999zzz".succ.should eq("2000aaa")
      "NZ/[]ZZZ9999".succ.should eq("OA/[]AAA0000")
    end

    it "adds an additional character (just left to the last increased one) if there is a carry and no character left to increase" do
      "z".succ.should eq("aa")
      "Z".succ.should eq("AA")
      "9".succ.should eq("10")

      "zz".succ.should eq("aaa")
      "ZZ".succ.should eq("AAA")
      "99".succ.should eq("100")

      "9Z99z99Z".succ.should eq("10A00a00A")

      "ZZZ9999".succ.should eq("AAAA0000")
      "/[]ZZZ9999".succ.should eq("/[]AAAA0000")
      "Z/[]ZZZ9999".succ.should eq("AA/[]AAA0000")
    end
  end

  it "does %" do
    ("Hello %d world" % 123).should eq("Hello 123 world")
    ("Hello %d world" % [123]).should eq("Hello 123 world")
  end

  it "does each_char" do
    s = "abc"
    i = 0
    s.each_char do |c|
      case i
      when 0
        c.should eq('a')
      when 1
        c.should eq('b')
      when 2
        c.should eq('c')
      else
        fail "shouldn't happen"
      end
      i += 1
    end.should be_nil
    i.should eq(3)
  end

  it "does each_char_with_index" do
    s = "abc"
    values = [] of {Char, Int32}
    s.each_char_with_index do |c, i|
      values << {c, i}
    end
    values.should eq([{'a', 0}, {'b', 1}, {'c', 2}])
  end

  it "does each_char_with_index, with offset" do
    s = "abc"
    values = [] of {Char, Int32}
    s.each_char_with_index(10) do |c, i|
      values << {c, i}
    end
    values.should eq([{'a', 10}, {'b', 11}, {'c', 12}])
  end

  it_iterates "#each_char", ['a', 'b', 'c'], "abc".each_char
  it_iterates "#each_char with empty string", [] of Char, "".each_char
  it_iterates "#each_byte", ['a'.ord.to_u8, 'b'.ord.to_u8, 'c'.ord.to_u8], "abc".each_byte

  it "gets lines" do
    "".lines.should eq([] of String)
    "\n".lines.should eq([""] of String)
    "\r".lines.should eq(["\r"] of String)
    "\r\n".lines.should eq([""] of String)
    "foo".lines.should eq(["foo"])
    "foo\n".lines.should eq(["foo"])
    "foo\r\n".lines.should eq(["foo"])
    "foo\nbar\r\nbaz\n".lines.should eq(["foo", "bar", "baz"])
    "foo\nbar\r\nbaz\r\n".lines.should eq(["foo", "bar", "baz"])
  end

  it "gets lines with chomp = false" do
    "foo".lines(chomp: false).should eq(["foo"])
    "foo\nbar\r\nbaz\n".lines(chomp: false).should eq(["foo\n", "bar\r\n", "baz\n"])
    "foo\nbar\r\nbaz\r\n".lines(chomp: false).should eq(["foo\n", "bar\r\n", "baz\r\n"])
  end

  it "gets each_line" do
    lines = [] of String
    "foo\n\nbar\r\nbaz\n".each_line do |line|
      lines << line
    end.should be_nil
    lines.should eq(["foo", "", "bar", "baz"])
  end

  it "gets each_line with chomp = false" do
    lines = [] of String
    "foo\n\nbar\r\nbaz\r\n".each_line(chomp: false) do |line|
      lines << line
    end.should be_nil
    lines.should eq(["foo\n", "\n", "bar\r\n", "baz\r\n"])
  end

  it_iterates "#each_line", ["foo", "bar", "baz"], "foo\nbar\r\nbaz\r\n".each_line
  it_iterates "#each_line(chomp: false)", ["foo\n", "bar\r\n", "baz\r\n"], "foo\nbar\r\nbaz\r\n".each_line(chomp: false)

  it_iterates "#each_codepoint", [97, 98, 9731], "ab☃".each_codepoint

  it "has codepoints" do
    "ab☃".codepoints.should eq [97, 98, 9731]
  end

  it "gets size of \\0 string" do
    "\0\0".size.should eq(2)
  end

  describe "char_index_to_byte_index" do
    it "with ascii" do
      "foo".char_index_to_byte_index(0).should eq(0)
      "foo".char_index_to_byte_index(1).should eq(1)
      "foo".char_index_to_byte_index(2).should eq(2)
      "foo".char_index_to_byte_index(3).should eq(3)
      "foo".char_index_to_byte_index(4).should be_nil
    end

    it "with utf-8" do
      "これ".char_index_to_byte_index(0).should eq(0)
      "これ".char_index_to_byte_index(1).should eq(3)
      "これ".char_index_to_byte_index(2).should eq(6)
      "これ".char_index_to_byte_index(3).should be_nil
    end
  end

  describe "byte_index_to_char_index" do
    it "with ascii" do
      "foo".byte_index_to_char_index(0).should eq(0)
      "foo".byte_index_to_char_index(1).should eq(1)
      "foo".byte_index_to_char_index(2).should eq(2)
      "foo".byte_index_to_char_index(3).should eq(3)
      "foo".byte_index_to_char_index(4).should be_nil
    end

    it "with utf-8" do
      "これ".byte_index_to_char_index(0).should eq(0)
      "これ".byte_index_to_char_index(3).should eq(1)
      "これ".byte_index_to_char_index(6).should eq(2)
      "これ".byte_index_to_char_index(7).should be_nil
      "これ".byte_index_to_char_index(1).should be_nil
    end
  end

  it "raises if string capacity is negative" do
    expect_raises(ArgumentError, "Negative capacity") do
      String.new(-1) { |buf| {0, 0} }
    end
  end

  it "raises if capacity too big on new with UInt32::MAX" do
    expect_raises(ArgumentError, "Capacity too big") do
      String.new(UInt32::MAX) { {0, 0} }
    end
  end

  it "raises if capacity too big on new with UInt32::MAX - String::HEADER_SIZE - 1" do
    expect_raises(ArgumentError, "Capacity too big") do
      String.new(UInt32::MAX - String::HEADER_SIZE) { {0, 0} }
    end
  end

  it "raises if capacity too big on new with UInt64::MAX" do
    expect_raises(ArgumentError, "Capacity too big") do
      String.new(UInt64::MAX) { {0, 0} }
    end
  end

  describe "compare" do
    it "compares case-sensitive" do
      "fo".compare("foo").should eq(-1)
      "foo".compare("fo").should eq(1)
      "foo".compare("foo").should eq(0)
      "foo".compare("fox").should eq(-1)
      "fox".compare("foo").should eq(1)
      "foo".compare("Foo").should eq(1)
      "hällo".compare("Hällo").should eq(1)
      "".compare("").should eq(0)
    end

    it "compares case-insensitive" do
      "foo".compare("FO", case_insensitive: true).should eq(1)
      "FOO".compare("fo", case_insensitive: true).should eq(1)
      "fo".compare("FOO", case_insensitive: true).should eq(-1)
      "FOX".compare("foo", case_insensitive: true).should eq(1)
      "foo".compare("FOX", case_insensitive: true).should eq(-1)
      "foo".compare("FOO", case_insensitive: true).should eq(0)
      "hELLo".compare("HellO", case_insensitive: true).should eq(0)
      "fo\u{0}".compare("FO", case_insensitive: true).should eq(1)
      "fo".compare("FO\u{0}", case_insensitive: true).should eq(-1)
      "\u{0}".compare("\u{0}", case_insensitive: true).should eq(0)
      "z".compare("hello", case_insensitive: true).should eq(1)
      "h".compare("zzz", case_insensitive: true).should eq(-1)
      "ä".compare("äA", case_insensitive: true).should eq(-1)
      "äÄ".compare("äÄ", case_insensitive: true).should eq(0)
      "heIIo".compare("heııo", case_insensitive: true, options: Unicode::CaseOptions::Turkic).should eq(0)
      "".compare("abc", case_insensitive: true).should eq(-1)
      "abc".compare("", case_insensitive: true).should eq(1)
      "abcA".compare("abca", case_insensitive: true).should eq(0)
    end

    it "treats invalid code units as replacement char in an otherwise ascii string" do
      "\xC0".compare("\xE0", case_insensitive: true).should eq(0)
      "\xE0".compare("\xC0", case_insensitive: true).should eq(0)
      "\xC0".compare("a", case_insensitive: true).should eq(1)
      "a".compare("\xC0", case_insensitive: true).should eq(-1)
    end
  end

  it "builds with write_byte" do
    string = String.build do |io|
      255_u8.times do |byte|
        io.write_byte(byte)
      end
    end
    255.times do |i|
      string.byte_at(i).should eq(i)
    end
  end

  it "raises if String.build negative capacity" do
    expect_raises(ArgumentError, "Negative capacity") do
      String.build(-1) { }
    end
  end

  it "raises if String.build capacity too big" do
    expect_raises(ArgumentError, "Capacity too big") do
      String.build(UInt32::MAX) { }
    end
  end

  {% unless flag?(:without_iconv) %}
    describe "encode" do
      it "encodes" do
        bytes = "Hello".encode("UCS-2LE")
        bytes.to_a.should eq([72, 0, 101, 0, 108, 0, 108, 0, 111, 0])
      end

      {% unless flag?(:musl) || flag?(:freebsd) %}
        it "flushes the shift state (#11992)" do
          "\u{00CA}".encode("BIG5-HKSCS").should eq(Bytes[0x88, 0x66])
          "\u{00CA}\u{0304}".encode("BIG5-HKSCS").should eq(Bytes[0x88, 0x62])
        end
      {% end %}

      # FreeBSD iconv encoder expects ISO/IEC 10646 compatibility code points,
      # see https://www.ccli.gov.hk/doc/e_hkscs_2008.pdf for details.
      {% if flag?(:freebsd) %}
        it "flushes the shift state (#11992)" do
          "\u{F329}".encode("BIG5-HKSCS").should eq(Bytes[0x88, 0x66])
          "\u{F325}".encode("BIG5-HKSCS").should eq(Bytes[0x88, 0x62])
        end
      {% end %}

      it "raises if wrong encoding" do
        expect_raises ArgumentError, "Invalid encoding: FOO" do
          "Hello".encode("FOO")
        end
      end

      it "raises if wrong encoding with skip" do
        expect_raises ArgumentError, "Invalid encoding: FOO" do
          "Hello".encode("FOO", invalid: :skip)
        end
      end

      it "raises if illegal byte sequence" do
        expect_raises ArgumentError, "Invalid multibyte sequence" do
          "\xff".encode("EUC-JP")
        end
      end

      it "doesn't raise on invalid byte sequence" do
        "好\xff是".encode("EUC-JP", invalid: :skip).to_a.should eq([185, 165, 192, 167])
      end

      it "raises if incomplete byte sequence" do
        expect_raises ArgumentError, "Incomplete multibyte sequence" do
          "好".byte_slice(0, 1).encode("EUC-JP")
        end
      end

      it "doesn't raise if incomplete byte sequence" do
        ("好".byte_slice(0, 1) + "是").encode("EUC-JP", invalid: :skip).to_a.should eq([192, 167])
      end

      it "decodes" do
        bytes = "Hello".encode("UTF-16LE")
        String.new(bytes, "UTF-16LE").should eq("Hello")
      end

      {% unless flag?(:freebsd) %}
        it "decodes with shift state" do
          String.new(Bytes[0x88, 0x66], "BIG5-HKSCS").should eq("\u{00CA}")
          String.new(Bytes[0x88, 0x62], "BIG5-HKSCS").should eq("\u{00CA}\u{0304}")
        end
      {% end %}

      # FreeBSD iconv decoder returns ISO/IEC 10646-1:2000 code points,
      # see https://www.ccli.gov.hk/doc/e_hkscs_2008.pdf for details.
      {% if flag?(:freebsd) %}
        it "decodes with shift state" do
          String.new(Bytes[0x88, 0x66], "BIG5-HKSCS").should eq("\u{00CA}")
          String.new(Bytes[0x88, 0x62], "BIG5-HKSCS").should eq("\u{F325}")
        end
      {% end %}

      it "decodes with skip" do
        bytes = Bytes[186, 195, 255, 202, 199]
        String.new(bytes, "EUC-JP", invalid: :skip).should eq("挫頁")
      end
    end
  {% end %}

  it "inserts" do
    "bar".insert(0, "foo").should eq("foobar")
    "bar".insert(1, "foo").should eq("bfooar")
    "bar".insert(2, "foo").should eq("bafoor")
    "bar".insert(3, "foo").should eq("barfoo")

    "bar".insert(-1, "foo").should eq("barfoo")
    "bar".insert(-2, "foo").should eq("bafoor")

    "ともだち".insert(0, "ねこ").should eq("ねこともだち")
    "ともだち".insert(1, "ねこ").should eq("とねこもだち")
    "ともだち".insert(2, "ねこ").should eq("ともねこだち")
    "ともだち".insert(4, "ねこ").should eq("ともだちねこ")

    "ともだち".insert(0, 'ね').should eq("ねともだち")
    "ともだち".insert(1, 'ね').should eq("とねもだち")
    "ともだち".insert(2, 'ね').should eq("ともねだち")
    "ともだち".insert(4, 'ね').should eq("ともだちね")

    "ともだち".insert(-1, 'ね').should eq("ともだちね")
    "ともだち".insert(-2, 'ね').should eq("ともだねち")

    expect_raises(IndexError) { "bar".insert(4, "foo") }
    expect_raises(IndexError) { "bar".insert(-5, "foo") }
    expect_raises(IndexError) { "bar".insert(4, 'f') }
    expect_raises(IndexError) { "bar".insert(-5, 'f') }

    "barbar".insert(0, "foo").size.should eq(9)
    "ともだち".insert(0, "ねこ").size.should eq(6)

    "foo".insert(0, 'a').ascii_only?.should be_true
    "foo".insert(0, 'あ').ascii_only?.should be_false
    "".insert(0, 'a').ascii_only?.should be_true
    "".insert(0, 'あ').ascii_only?.should be_false
  end

  it "hexbytes" do
    expect_raises(ArgumentError) { "abc".hexbytes }
    expect_raises(ArgumentError) { "abc ".hexbytes }
    "abcd".hexbytes.should eq(Bytes[171, 205])
  end

  it "hexbytes?" do
    "abc".hexbytes?.should be_nil
    "abc ".hexbytes?.should be_nil
    "abcd".hexbytes?.should eq(Bytes[171, 205])
  end

  it "dups" do
    string = "foo"
    dup = string.dup
    string.should be(dup)
  end

  it "clones" do
    string = "foo"
    clone = string.clone
    string.should be(clone)
  end

  {% unless flag?(:wasm32) %}
    it "allocates buffer of correct size when UInt8 is given to new (#3332)" do
      String.new(255_u8) do |buffer|
        LibGC.size(buffer).should be >= 255
        {255, 0}
      end
    end
  {% end %}

  it "raises on String.new if returned bytesize is greater than capacity" do
    expect_raises ArgumentError, "Bytesize out of capacity bounds" do
      String.new(123) do |buffer|
        {124, 0}
      end
    end
  end

  describe "invalid UTF-8 byte sequence" do
    it "gets size" do
      string = String.new(Bytes[255, 0, 0, 0, 65])
      string.size.should eq(5)
    end

    it "gets size (2)" do
      string = String.new(Bytes[104, 101, 108, 108, 111, 32, 255, 32, 255, 32, 119, 111, 114, 108, 100, 33])
      string.size.should eq(16)
    end

    it "gets chars" do
      string = String.new(Bytes[255, 0, 0, 0, 65])
      string.chars.should eq([Char::REPLACEMENT, 0.chr, 0.chr, 0.chr, 65.chr])
    end

    it "gets chars (2)" do
      string = String.new(Bytes[255, 0])
      string.chars.should eq([Char::REPLACEMENT, 0.chr])
    end

    it "valid_encoding?" do
      "hello".valid_encoding?.should be_true
      "hello\u{80}\u{7FF}\u{800}\u{FFFF}\u{10000}\u{10FFFF}".valid_encoding?.should be_true

      # non-starters
      String.new(Bytes[0x80]).valid_encoding?.should be_false
      String.new(Bytes[0x8F]).valid_encoding?.should be_false
      String.new(Bytes[0x90]).valid_encoding?.should be_false
      String.new(Bytes[0x9F]).valid_encoding?.should be_false
      String.new(Bytes[0xA0]).valid_encoding?.should be_false
      String.new(Bytes[0xAF]).valid_encoding?.should be_false

      # incomplete, 2-byte
      String.new(Bytes[0xC2]).valid_encoding?.should be_false
      String.new(Bytes[0xC2, 0x00]).valid_encoding?.should be_false
      String.new(Bytes[0xC2, 0xC2]).valid_encoding?.should be_false

      # overlong, 2-byte
      String.new(Bytes[0xC0, 0x80]).valid_encoding?.should be_false
      String.new(Bytes[0xC1, 0xBF]).valid_encoding?.should be_false
      String.new(Bytes[0xC2, 0x80]).valid_encoding?.should be_true

      # incomplete, 3-byte
      String.new(Bytes[0xE1]).valid_encoding?.should be_false
      String.new(Bytes[0xE1, 0x00]).valid_encoding?.should be_false
      String.new(Bytes[0xE1, 0xC2]).valid_encoding?.should be_false
      String.new(Bytes[0xE1, 0x80]).valid_encoding?.should be_false
      String.new(Bytes[0xE1, 0x80, 0x00]).valid_encoding?.should be_false
      String.new(Bytes[0xE1, 0x80, 0xC2]).valid_encoding?.should be_false

      # overlong, 3-byte
      String.new(Bytes[0xE0, 0x80, 0x80]).valid_encoding?.should be_false
      String.new(Bytes[0xE0, 0x9F, 0xBF]).valid_encoding?.should be_false
      String.new(Bytes[0xE0, 0xA0, 0x80]).valid_encoding?.should be_true

      # surrogate pairs
      String.new(Bytes[0xED, 0x9F, 0xBF]).valid_encoding?.should be_true
      String.new(Bytes[0xED, 0xA0, 0x80]).valid_encoding?.should be_false
      String.new(Bytes[0xED, 0xBF, 0xBF]).valid_encoding?.should be_false
      String.new(Bytes[0xEE, 0x80, 0x80]).valid_encoding?.should be_true

      # incomplete, 4-byte
      String.new(Bytes[0xF1]).valid_encoding?.should be_false
      String.new(Bytes[0xF1, 0x00]).valid_encoding?.should be_false
      String.new(Bytes[0xF1, 0xC2]).valid_encoding?.should be_false
      String.new(Bytes[0xF1, 0x80]).valid_encoding?.should be_false
      String.new(Bytes[0xF1, 0x80, 0x00]).valid_encoding?.should be_false
      String.new(Bytes[0xF1, 0x80, 0xC2]).valid_encoding?.should be_false
      String.new(Bytes[0xF1, 0x80, 0x80]).valid_encoding?.should be_false
      String.new(Bytes[0xF1, 0x80, 0x80, 0x00]).valid_encoding?.should be_false
      String.new(Bytes[0xF1, 0x80, 0x80, 0xC2]).valid_encoding?.should be_false

      # overlong, 4-byte
      String.new(Bytes[0xF0, 0x80, 0x80, 0x80]).valid_encoding?.should be_false
      String.new(Bytes[0xF0, 0x8F, 0xBF, 0xBF]).valid_encoding?.should be_false
      String.new(Bytes[0xF0, 0x90, 0x80, 0x80]).valid_encoding?.should be_true

      # upper boundary, 4-byte
      String.new(Bytes[0xF4, 0x8F, 0xBF, 0xBF]).valid_encoding?.should be_true
      String.new(Bytes[0xF4, 0x90, 0x80, 0x80]).valid_encoding?.should be_false
      String.new(Bytes[0xF5]).valid_encoding?.should be_false
      String.new(Bytes[0xF8]).valid_encoding?.should be_false
      String.new(Bytes[0xFF]).valid_encoding?.should be_false
    end

    it "scrubs" do
      string = String.new(Bytes[255, 129, 97, 255, 97])
      string.scrub.bytes.should eq([239, 191, 189, 239, 191, 189, 97, 239, 191, 189, 97])

      string.scrub("?").should eq("??a?a")

      "hello".scrub.should eq("hello")
    end
  end

  describe "interpolation" do
    it "of a single string" do
      string = "hello"
      interpolated = String.interpolation(string)
      interpolated.should be(string)
    end

    it "of a single non-string" do
      String.interpolation(123).should eq("123")
    end

    it "of string and char" do
      String.interpolation("hello", '!').should eq("hello!")
    end

    it "of char and string" do
      String.interpolation('!', "hello").should eq("!hello")
    end

    it "of multiple strings" do
      String.interpolation("a", "bcd", "ef").should eq("abcdef")
    end

    it "of multiple possibly non-strings" do
      String.interpolation("a", 123, "b", 456, "cde").should eq("a123b456cde")
    end
  end

  describe "delete_at" do
    describe "char" do
      it { "abcde".delete_at(0).should eq("bcde") }
      it { "abcde".delete_at(1).should eq("acde") }
      it { "abcde".delete_at(2).should eq("abde") }
      it { "abcde".delete_at(4).should eq("abcd") }
      it { "abcde".delete_at(-2).should eq("abce") }
      it { expect_raises(IndexError) { "abcde".delete_at(5) } }
      it { expect_raises(IndexError) { "abcde".delete_at(-6) } }

      it { "二ノ国".delete_at(0).should eq("ノ国") }
      it { "二ノ国".delete_at(1).should eq("二国") }
      it { "二ノ国".delete_at(2).should eq("二ノ") }
      it { "二ノ国".delete_at(-2).should eq("二国") }
      it { expect_raises(IndexError) { "二ノ国".delete_at(3) } }
      it { expect_raises(IndexError) { "二ノ国".delete_at(-4) } }
    end

    describe "start, count" do
      it { "abcdefg".delete_at(0, 2).should eq("cdefg") }
      it { "abcdefg".delete_at(1, 2).should eq("adefg") }
      it { "abcdefg".delete_at(3, 10).should eq("abc") }
      it { "abcdefg".delete_at(-3, 2).should eq("abcdg") }
      it { "abcdefg".delete_at(7, 10).should eq("abcdefg") }
      it { expect_raises(IndexError) { "abcdefg".delete_at(8, 1) } }
      it { expect_raises(IndexError) { "abcdefg".delete_at(-8, 1) } }

      it "raises on negative count" do
        expect_raises(ArgumentError, "Negative count: -1") {
          "abcdefg".delete_at(1, -1)
        }
      end

      it { "セキロ：シャドウズ ダイ トゥワイス".delete_at(4, 6).should eq("セキロ：ダイ トゥワイス") }
      it { "セキロ：シャドウズ ダイ トゥワイス".delete_at(0, 4).should eq("シャドウズ ダイ トゥワイス") }
      it { "セキロ：シャドウズ ダイ トゥワイス".delete_at(3, 20).should eq("セキロ") }
      it { "セキロ：シャドウズ ダイ トゥワイス".delete_at(-14, 6).should eq("セキロ：ダイ トゥワイス") }
      it { "セキロ：シャドウズ ダイ トゥワイス".delete_at(18, 3).should eq("セキロ：シャドウズ ダイ トゥワイス") }
      it { expect_raises(IndexError) { "セキロ：シャドウズ ダイ トゥワイス".delete_at(19, 1) } }
      it { expect_raises(IndexError) { "セキロ：シャドウズ ダイ トゥワイス".delete_at(-19, 1) } }

      it "raises on negative count" do
        expect_raises(ArgumentError, "Negative count: -1") {
          "セキロ：シャドウズ ダイ トゥワイス".delete_at(1, -1)
        }
      end
    end

    describe "range" do
      it { "abcdefg".delete_at(0..1).should eq("cdefg") }
      it { "abcdefg".delete_at(0...2).should eq("cdefg") }
      it { "abcdefg".delete_at(1..3).should eq("aefg") }
      it { "abcdefg".delete_at(3..10).should eq("abc") }
      it { "abcdefg".delete_at(-3..-2).should eq("abcdg") }
      it { "abcdefg".delete_at(3..).should eq("abc") }
      it { "abcdefg".delete_at(..-3).should eq("fg") }
      it { expect_raises(IndexError) { "abcdefg".delete_at(8..1) } }
      it { expect_raises(IndexError) { "abcdefg".delete_at(-8..1) } }

      it { "セキロ：シャドウズ ダイ トゥワイス".delete_at(4...10).should eq("セキロ：ダイ トゥワイス") }
      it { expect_raises(IndexError) { "セキロ：シャドウズ ダイ トゥワイス".delete_at(19..1) } }
      it { expect_raises(IndexError) { "セキロ：シャドウズ ダイ トゥワイス".delete_at(-19..1) } }
    end
  end
end

class String
  describe String do
    it ".char_bytesize_at" do
      String.char_bytesize_at(Bytes[0x00, 0].to_unsafe).should eq 1
      String.char_bytesize_at(Bytes[0x7F, 0].to_unsafe).should eq 1
      String.char_bytesize_at(Bytes[0x80, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xBF, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xC2, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xC3, 0].to_unsafe).should eq 1 # malformed

      String.char_bytesize_at(Bytes[0xC2, 0x7F, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xC2, 0x80, 0].to_unsafe).should eq 2
      String.char_bytesize_at(Bytes[0xDF, 0xBF, 0].to_unsafe).should eq 2
      String.char_bytesize_at(Bytes[0xDF, 0xC0, 0].to_unsafe).should eq 1 # malformed

      String.char_bytesize_at(Bytes[0xE0, 0xA0, 0x7F, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xE0, 0x9F, 0x8F, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xE0, 0xA0, 0x80, 0].to_unsafe).should eq 3
      String.char_bytesize_at(Bytes[0xED, 0x9F, 0xBF, 0].to_unsafe).should eq 3
      String.char_bytesize_at(Bytes[0xED, 0x9F, 0xC0, 0].to_unsafe).should eq 1 # surrogate
      String.char_bytesize_at(Bytes[0xED, 0xBF, 0xBF, 0].to_unsafe).should eq 1 # surrogate
      String.char_bytesize_at(Bytes[0xEE, 0x80, 0x80, 0].to_unsafe).should eq 3
      String.char_bytesize_at(Bytes[0xEF, 0xBF, 0xBD, 0].to_unsafe).should eq 3
      String.char_bytesize_at(Bytes[0xEF, 0xBF, 0xBF, 0].to_unsafe).should eq 3
      String.char_bytesize_at(Bytes[0xEF, 0xBF, 0xC0, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xEF, 0xC0, 0xBF, 0].to_unsafe).should eq 1 # malformed

      String.char_bytesize_at(Bytes[0xF0, 0x90, 0x80, 0x7F, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xF0, 0x90, 0x7F, 0x80, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xF0, 0x8F, 0x80, 0x80, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xF0, 0x90, 0x80, 0x80, 0].to_unsafe).should eq 4
      String.char_bytesize_at(Bytes[0xF0, 0x9F, 0xBF, 0xBF, 0].to_unsafe).should eq 4
      String.char_bytesize_at(Bytes[0xF3, 0x90, 0x80, 0x80, 0].to_unsafe).should eq 4
      String.char_bytesize_at(Bytes[0xF4, 0x8F, 0xBD, 0xBF, 0].to_unsafe).should eq 4
      String.char_bytesize_at(Bytes[0xF4, 0x8F, 0xBF, 0xBF, 0].to_unsafe).should eq 4
      String.char_bytesize_at(Bytes[0xF4, 0x8F, 0xBF, 0xC0, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xF4, 0x8F, 0xC0, 0xBF, 0].to_unsafe).should eq 1 # malformed
      String.char_bytesize_at(Bytes[0xF4, 0x90, 0xBF, 0xBF, 0].to_unsafe).should eq 1 # malformed

      String.char_bytesize_at(Bytes[0xF5, 0].to_unsafe).should eq 1 # out of codepoint range
      String.char_bytesize_at(Bytes[0xFF, 0].to_unsafe).should eq 1 # out of codepoint range
    end
  end
end
