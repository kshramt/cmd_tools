#!/opt/local/bin/ruby
# -*- coding: utf-8 -*-
# 欲しい機能：入力と終了（コメントを付加出来るようにする．）
# システムとして，入力に1ファイルで，下の部分に付加していく．
# 終了したものを1ファイル作る．コメントファイルも，1つ作る．
# __index__00000001
# 終わったやつは，頭に^をつけてやると，
# 内容をlessで表示する機能: td
# 内容をcatで表示する機能: td -a
# 終わった内容をlessで表示する機能: td -f
# 終わった内容をcatで表示する機能: td -fa
# 終了した内容を選択して，コメントを付けて消去する機能: td -d
# grepしてlessしたものの番号を選択できるようにしようかな．
# エイリアスをすれば良いのだから，オプションで出来るようにする．

require 'date'
require 'yaml'
include Math
TDdIR = '/Users/seismo04/.td.d/'
TDfILE = TDdIR + 'td.dat'
FINISHfILE = TDdIR + 'finish.dat'
COMMENTfILE = TDdIR + 'comment.dat'
INDEXfILE = TDdIR + 'index.dat'
INDEXpREFIX = '__index__'
MAXdIGIT = 6

# ずっと付けているアプリケーションにするのか，たまにアクセスするツールにするのかで，かなり変わってくる．
# 両方可能にすれば良いのかもしれない．
# 使い心地は，アプリケーションの方が良いだろう．しかし，軽く使う感じだと，テンポラリモードの方が良いだろう．
# 問題は，データの扱い方にある．
# アプリケーションモードと，テンポラリモード
# 変更したら，アプリケーションモードでは再読み込みする感じかな．

argvSize = ARGV.size

if argvSize == 0                 # 終わってないやつをlessで表示
  system("cat #{TDfILE} | grep -vEf #{FINISHfILE} | cat -n | less")
else
  case ARGV[0]
  when('-a')                     # 終わってないやつを全て表示
    system("cat #{TDfILE} | grep -vEf #{FINISHfILE} | cat -n")
  when('-f')                     # 終わったやつをlessで表示
    system("cat #{TDfILE} | grep -Ef #{FINISHfILE} | cat -n | less")
  when('-fa')                    # 終わったやつを全て表示
    system("cat #{TDfILE} | grep -Ef #{FINISHfILE} | cat -n")
  when('-d')                     # 終わったやつを終了にする
    loop{                          # 毎回，消す候補をループする
      td = %x(cat #{TDfILE} | grep -E '#{ARGV[1]}').split("\n")
      for _i in 0..td.size - 1
        line = td[_i].split
        puts "#{line[1]} _ #{_i} _ #{line[2..line.size].join(' ')}"

        # 
        #
        # 深いループから抜ける方法がよくわからない．途中で抜けるまで繰り返すループの書き方がわからない．
        #
        #
      end
     loop{
        delete = $stdin.gets.chomp
        if delete =~ /%d+/
          # 消す処理だ
        elsif delete =~ /(quit|exit|q)/
          #          外側のループから抜けたいんだけど．
        else
          puts "#{delete} is not number nor q, quit, exit"
        end
      }
      td[delete]                # こいつのインデックスを，finishに登録して，可能ならばコメントを受け取るんだ．
      # 本当は，クラスにでもした方が良いのかもしれないけれど，とりあえずまだ，使い方を知らないので，このままでやろうかな．
    }
    
  else                           # ここで，入力する
    CURRENTtIME = DateTime.now.strftime("%y%m%d%H%M%S")
    index = %x(cat #{INDEXfILE}).to_i + 1
    index = '0'*(6 - log10(index).to_i.ceil) + index.to_s # かなり，綺麗じゃない書き方なんだけど，とりあえず，仕方ない．
    system("echo #{INDEXpREFIX + index} #{CURRENTtIME} #{ARGV.join(' ')} >> #{TDfILE}") # 本当は，openした方が良いんだろうけど，仕方が無いね．面倒だし．必要になったら帰る．
    system("echo #{index} > #{INDEXfILE}")
  end
end
