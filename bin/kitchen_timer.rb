#!/opt/local/bin/ruby1.9
# -*- coding: utf-8 -*-
sleep sec = ARGV[0].to_i
require 'tk'
puts "\a"*5
root = TkRoot.new
root.width = 900
root.height = 900
root.bg = "#ff0000"
Tk.mainloop
