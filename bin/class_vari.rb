# -*- coding: utf-8 -*-
require 'pp'
class Vari
  EXTENSION2lANGUAGE = { ".rb" => "ruby", ".f90" => "fortran", ".f" => "fortran" }
  INTRINSICoFfORTRAN = %w(
 abs aimg aint anint ceiling cmplx
 conjg dble dim dprod floor int max min mod modulo nint real sign
 acos asin atan atan2 cos cosh exp log log10 sin sinh sqrt tan
 tanh achar adjustl adjustr char iachar ichar index len_trim lge lgt lle
 llt repeat scan trim verify len kind selected_int_kind selected_real_kind
 logical digit epsilon huge maxexponent minexponent precision radix range
 tiny bit_size btest iand ibclr ibits ibset ieor ior ishft ishftc not
 transfer exponent fraction nearest rrspacing  scale set_exponent spacing
 dot_product matmul all any count maxval minval product sum allocated
 lbound shape size ubound merge pack spread unpack reshape cshift eoshift
 transpose maxloc minloc associated date_and_time mvbits random_number
 random_seed system_clock allocate allocatable integer character do end call
 use write then unit read open only exit if file else function format endif
 goto data program stop complex dimension return subroutine intent interface
 module implicit float present private public procedure optional close contains
 in out deallocate status system print continue parameter advance inout
 ABS AIMG AINT ANINT
 CEILING CMPLX CONJG DBLE DIM DPROD FLOOR INT MAX MIN MOD MODULO NINT REAL
 SIGN ACOS ASIN ATAN ATAN2 COS COSH EXP LOG LOG10 SIN SINH SQRT TAN
 TANH ACHAR ADJUSTL ADJUSTR CHAR IACHAR ICHAR INDEX LEN_TRIM LGE LGT LLE
 LLT REPEAT SCAN TRIM VERIFY LEN KIND SELECTED_INT_KIND SELECTED_REAL_KIND
 LOGICAL DIGIT EPSILON HUGE MAXEXPONENT MINEXPONENT PRECISION RADIX RANGE
 TINY BIT_SIZE BTEST IAND IBCLR IBITS IBSET IEOR IOR ISHFT ISHFTC NOT
 TRANSFER EXPONENT FRACTION NEAREST RRSPACING  SCALE SET_EXPONENT SPACING
 DOT_PRODUCT MATMUL ALL ANY COUNT MAXVAL MINVAL PRODUCT SUM ALLOCATED
 LBOUND SHAPE SIZE UBOUND MERGE PACK SPREAD UNPACK RESHAPE CSHIFT EOSHIFT
 TRANSPOSE MAXLOC MINLOC ASSOCIATED DATE_AND_TIME MVBITS RANDOM_NUMBER
 RANDOM_SEED SYSTEM_CLOCK ALLOCATE ALLOCATABLE INTEGER CHARACTER DO END CALL
 USE WRITE THEN UNIT READ OPEN ONLY EXIT IF FILE ELSE FUNCTION FORMAT ENDIF
 GOTO DATA PROGRAM STOP COMPLEX DIMENSION RETURN SUBROUTINE INTENT INTERFACE
 MODULE IMPLICIT FLOAT PRESENT PRIVATE PUBLIC PROCEDURE OPTIONAL CLOSE CONTAINS
 IN OUT DEALLOCATE STATUS SYSTEM PRINT CONTINUE PARAMETER ADVANCE INOUT
 )
  INTRINSICoF = { "fortran" => INTRINSICoFfORTRAN }
  OPERATORoF = { "fortran" => /[^A-Za-z0-9_]+/ }
  COMMENToF = { "fortran" => "!" }
  NUMBERoF = { "fortran" => /[^A-Za-z_]\d+\.?\d*(d|D|e|E)?\d*/}
  QUOTEeTCoF = { "fortran" => /(implicit none|".*?"|'.*?'|\.[A-Za-z]+\.)/ } # implicit none，ダブルクオート，シングルクオート，「.le.」とか
  DECLAREoFfORTRAN = %w(real integer logical type interface subroutine function program module use only call)
  DECLAREoF = { "fortran" => DECLAREoFfORTRAN}
 # # #
 # # # 定数が巨大すぎる気がする．分けるのかな，こういうときって．
 # # #
  attr_reader :fileName, :vari, :language 
  def initialize(fileName)
    # @fileName, @vari, @language，@defedがある．
    @fileName = fileName
    begin
      io = open(@fileName, "r")
      @vari = []
      @defed = []
    rescue
      puts "#{@fileName}は存在しません．別のファイルを試してください．"
    else
      # 言語が知られている場合
      if @language = EXTENSION2lANGUAGE[File.extname(@fileName)]
        while line = io.gets
          # とりあえず，ソースコードで区切る荒っぽい（とり漏らしのある）やり方．
          # そのうち，関数毎に結果を出すようにする．
          # 1列目がコメントなら無視する
          if line[0].chr != COMMENToF[@language]
            if commentLocation = line.index(COMMENToF[@language]) # コメント記号以下を切り捨て
              lLine = line.size
              line.slice!(commentLocation-1..lLine-1)
            end
            line.gsub!(QUOTEeTCoF[@language], " ") # 文字などを消去する
            line.gsub!(NUMBERoF[@language], " ")   # 数字とかを消す
            # 英数文字と下線以外で分割する
            @vari << line.split(OPERATORoF[@language])
            # 効率悪いけど，ここから，別の機能を実装する気分で書く
            line.split!(OPERATORoF[@language])
            # これで，もう十分に綺麗
            # ここで，real, integer, logical, call, subrotuine, interface, functionの
            # 隣にあるやつを見つける．で，そいつらを，定義されてるやつに付け加える．
            
          end
        end
        @vari.flatten!
        @vari.uniq!
        @vari.compact!
        @vari.reject!{ |i| i == ""} # 出てくると気持ち悪いから消しとく
        @vari.sort!
      else                        # 知らない言語だった場合
        puts "まだ，#{@language}には対応してません．"
        puts "必要なのは，コメント記号，変数名に使われる記号，内部関数と予約変数の名前です．"
      end
    ensure
      io.close
    end
  end
  def printTTY                  # tele-type端末のこと
    if @vari.empty?
      puts "原因はよくわからないけど，@variが空っぽらしい"
    else
      tmpVari = @vari - INTRINSICoF[@language]
      puts "#{@fileName}の中にはサブルーチンも含めて"
      puts "\t #{tmpVari.size}"
      puts "個の変数がありました"
      iVariMax = tmpVari.size-1
      for iVari in 0..tmpVari.size-2
        print("\t", tmpVari[iVari])
        print("\n") if (iVari+1)%10 == 0
      end
      print("\t#{tmpVari[iVariMax]}\n")
    end
  end
end
class RealVari
  @name[]
end
class IntVari
  @name[]
end
class LogiVari
  @name[]
end
class CharVari
  @name[]
end
class StrcVari
  @name
  @instName[]
end
class IntrFunc

end
class IntrSubr

end
class ExtrFunc

end
class ExtrSubr

end
class GenerName

end
class SpecName

end
class ModName

end
class MethName

end














