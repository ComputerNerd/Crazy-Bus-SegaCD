rem convert bg_f_06.jpg -adaptive-resize 320x224! out1.png
rem convert out1.png -dither FloydSteinberg -remap MDColor_fixed.png out2.png
rem convert -size "320x224" -depth 8 out2.png out.rgb
rem scolorq out.rgb 320 224 16 out_16.rgb
rem convert -size "320x224" -depth 8 out_16.rgb -dither None -remap MDColor_fixed.png PNG8:bg_f_06.png
sixpack.exe -image -opt -t -target smd bg_i_05.png







pause