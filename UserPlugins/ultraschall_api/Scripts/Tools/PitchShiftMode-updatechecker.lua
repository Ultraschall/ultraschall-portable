dofile(reaper.GetResourcePath().."/UserPlugins/ultraschall_api.lua")

String=[[
0 - Soundtouch(Default)
1 - Soundtouch(High Quality)
2 - Soundtouch(Fast)
131072 - Simple Windowed(fast) (50ms window, 25ms fade)
131073 - Simple Windowed(fast) (50ms window, 16ms fade)
131074 - Simple Windowed(fast) (50ms window, 10ms fade)
131075 - Simple Windowed(fast) (50ms window, 7ms fade)
131076 - Simple Windowed(fast) (75ms window, 37ms fade)
131077 - Simple Windowed(fast) (75ms window, 25ms fade)
131078 - Simple Windowed(fast) (75ms window, 15ms fade)
131079 - Simple Windowed(fast) (75ms window, 10ms fade)
131080 - Simple Windowed(fast) (100ms window, 50ms fade)
131081 - Simple Windowed(fast) (100ms window, 33ms fade)
131082 - Simple Windowed(fast) (100ms window, 20ms fade)
131083 - Simple Windowed(fast) (100ms window, 14ms fade)
131084 - Simple Windowed(fast) (150ms window, 75ms fade)
131085 - Simple Windowed(fast) (150ms window, 50ms fade)
131086 - Simple Windowed(fast) (150ms window, 30ms fade)
131087 - Simple Windowed(fast) (150ms window, 21ms fade)
131088 - Simple Windowed(fast) (225ms window, 112ms fade)
131089 - Simple Windowed(fast) (225ms window, 75ms fade)
131090 - Simple Windowed(fast) (225ms window, 45ms fade)
131091 - Simple Windowed(fast) (225ms window, 32ms fade)
131092 - Simple Windowed(fast) (300ms window, 150ms fade)
131093 - Simple Windowed(fast) (300ms window, 100ms fade)
131094 - Simple Windowed(fast) (300ms window, 60ms fade)
131095 - Simple Windowed(fast) (300ms window, 42ms fade)
131096 - Simple Windowed(fast) (40ms window, 20ms fade)
131097 - Simple Windowed(fast) (40ms window, 13ms fade)
131098 - Simple Windowed(fast) (40ms window, 8ms fade)
131099 - Simple Windowed(fast) (40ms window, 5ms fade)
131100 - Simple Windowed(fast) (30ms window, 15ms fade)
131101 - Simple Windowed(fast) (30ms window, 10ms fade)
131102 - Simple Windowed(fast) (30ms window, 6s fade)
131103 - Simple Windowed(fast) (30ms window, 4ms fade)
131104 - Simple Windowed(fast) (20ms window, 10ms fade)
131105 - Simple Windowed(fast) (20ms window, 6ms fade)
131106 - Simple Windowed(fast) (20ms window, 4ms fade)
131107 - Simple Windowed(fast) (20ms window, 2ms fade)
131108 - Simple Windowed(fast) (10ms window, 5ms fade)
131109 - Simple Windowed(fast) (10ms window, 3ms fade)
131110 - Simple Windowed(fast) (10ms window, 2ms fade)
131111 - Simple Windowed(fast) (10ms window, 1ms fade)
131112 - Simple Windowed(fast) (5ms window, 2ms fade)
131113 - Simple Windowed(fast) (5ms window, 1ms fade)
131114 - Simple Windowed(fast) (5ms window, 1ms fade)
131115 - Simple Windowed(fast) (5ms window, 1ms fade)
131116 - Simple Windowed(fast) (3ms window, 1ms fade)
131117 - Simple Windowed(fast) (3ms window, 1ms fade)
131118 - Simple Windowed(fast) (3ms window, 1ms fade)
131119 - Simple Windowed(fast) (3ms window, 1ms fade)
393216 - elastique 2.28 Pro Normal
393217 - elastique 2.28 Pro Preserve Formants(Lowest Pitches)
393218 - elastique 2.28 Pro Preserve Formants(Lower Pitches)
393219 - elastique 2.28 Pro Preserve Formants(Low Pitches)
393220 - elastique 2.28 Pro Preserve Formants(Most Pitches)
393221 - elastique 2.28 Pro Preserve Formants(High Pitches)
393222 - elastique 2.28 Pro Preserve Formants(Higher Pitches)
393223 - elastique 2.28 Pro Preserve Formants(Highest Pitches)
393224 - elastique 2.28 Pro Mid/Side
393225 - elastique 2.28 Pro Mid/Side, Preserve Formants(Lowest Pitches)
393226 - elastique 2.28 Pro Mid/Side, Preserve Formants(Lower Pitches)
393227 - elastique 2.28 Pro Mid/Side, Preserve Formants(Low Pitches)
393228 - elastique 2.28 Pro Mid/Side, Preserve Formants(Most Pitches)
393229 - elastique 2.28 Pro Mid/Side, Preserve Formants(High Pitches)
393230 - elastique 2.28 Pro Mid/Side, Preserve Formants(Higher Pitches)
393231 - elastique 2.28 Pro Mid/Side, Preserve Formants(Highest Pitches)
393232 - elastique 2.28 Pro Synchronized: Normal
393233 - elastique 2.28 Pro Synchronized: Preserve Formants(Lowest Pitches)
393234 - elastique 2.28 Pro Synchronized: Preserve Formants(Lower Pitches)
393235 - elastique 2.28 Pro Synchronized: Preserve Formants(Low Pitches)
393236 - elastique 2.28 Pro Synchronized: Preserve Formants(Most Pitches)
393237 - elastique 2.28 Pro Synchronized: Preserve Formants(High Pitches)
393238 - elastique 2.28 Pro Synchronized: Preserve Formants(Higher Pitches)
393239 - elastique 2.28 Pro Synchronized: Preserve Formants(Highest Pitches)
393240 - elastique 2.28 Pro Synchronized: Mid/Side 
393241 - elastique 2.28 Pro Synchronized: Mid/Side, Preserve Formants(Lowest Pitches)
393242 - elastique 2.28 Pro Synchronized: Mid/Side, Preserve Formants(Lower Pitches) 
393243 - elastique 2.28 Pro Synchronized: Mid/Side, Preserve Formants(Low Pitches)
393244 - elastique 2.28 Pro Synchronized: Mid/Side, Preserve Formants(Most Pitches)
393245 - elastique 2.28 Pro Synchronized: Mid/Side, Preserve Formants(High Pitches)
393246 - elastique 2.28 Pro Synchronized: Mid/Side, Preserve Formants(Higher Pitches)
393247 - elastique 2.28 Pro Synchronized: Mid/Side, Preserve Formants(Highest Pitches)
458752 - elastique 2.28 Efficient Normal
458753 - elastique 2.28 Efficient Mid/Side
458754 - elastique 2.28 Efficient Synchronized: Normal
458755 - elastique 2.28 Efficient Synchronized: Mid/Side
524288 - elastique 2.28 Soloist Monophonic
524289 - elastique 2.28 Soloist Monophonic [Mid/Side]
524290 - elastique 2.28 Soloist Speech
524291 - elastique 2.28 Soloist Speech [Mid/Side]
589824 - elastique 3.2.3 Pro Normal
589825 - elastique 3.2.3 Pro Preserve Formants(Lowest Pitches)
589826 - elastique 3.2.3 Pro Preserve Formants(Lower Pitches)
589827 - elastique 3.2.3 Pro Preserve Formants(Low Pitches)
589828 - elastique 3.2.3 Pro Preserve Formants(Most Pitches)
589829 - elastique 3.2.3 Pro Preserve Formants(High Pitches)
589830 - elastique 3.2.3 Pro Preserve Formants(Higher Pitches)
589831 - elastique 3.2.3 Pro Preserve Formants(Highest Pitches)
589832 - elastique 3.2.3 Pro Mid/Side
589833 - elastique 3.2.3 Pro Mid/Side, Preserve Formants(Lowest Pitches)
589834 - elastique 3.2.3 Pro Mid/Side, Preserve Formants(Lower Pitches)
589835 - elastique 3.2.3 Pro Mid/Side, Preserve Formants(Low Pitches)
589836 - elastique 3.2.3 Pro Mid/Side, Preserve Formants(Most Pitches)
589837 - elastique 3.2.3 Pro Mid/Side, Preserve Formants(High Pitches)
589838 - elastique 3.2.3 Pro Mid/Side, Preserve Formants(Higher Pitches)
589839 - elastique 3.2.3 Pro Mid/Side, Preserve Formants(Highest Pitches)
589840 - elastique 3.2.3 Pro Synchronized: Normal
589841 - elastique 3.2.3 Pro Synchronized: Preserve Formants(Lowest Pitches)
589842 - elastique 3.2.3 Pro Synchronized: Preserve Formants(Lower Pitches)
589843 - elastique 3.2.3 Pro Synchronized: Preserve Formants(Low Pitches)
589844 - elastique 3.2.3 Pro Synchronized: Preserve Formants(Most Pitches)
589845 - elastique 3.2.3 Pro Synchronized: Preserve Formants(High Pitches)
589846 - elastique 3.2.3 Pro Synchronized: Preserve Formants(Higher Pitches)
589847 - elastique 3.2.3 Pro Synchronized: Preserve Formants(Highest Pitches)
589848 - elastique 3.2.3 Pro Synchronized: Mid/Side 
589849 - elastique 3.2.3 Pro Synchronized: Mid/Side, Preserve Formants(Lowest Pitches)
589850 - elastique 3.2.3 Pro Synchronized: Mid/Side, Preserve Formants(Lower Pitches) 
589851 - elastique 3.2.3 Pro Synchronized: Mid/Side, Preserve Formants(Low Pitches)
589852 - elastique 3.2.3 Pro Synchronized: Mid/Side, Preserve Formants(Most Pitches)
589853 - elastique 3.2.3 Pro Synchronized: Mid/Side, Preserve Formants(High Pitches)
589853 - elastique 3.2.3 Pro Synchronized: Mid/Side, Preserve Formants(Higher Pitches)
589855 - elastique 3.2.3 Pro Synchronized: Mid/Side, Preserve Formants(Highest Pitches)
655360 - elastique 3.2.3 Efficient Normal
655361 - elastique 3.2.3 Efficient Mid/Side
655362 - elastique 3.2.3 Efficient Synchronized: Normal
655363 - elastique 3.2.3 Efficient Synchronized: Mid/Side
720896 - elastique 3.2.3 Soloist (Monophonic)
720897 - elastique 3.2.3 Soloist (Monophonic Mid Side)
720898 - elastique 3.2.3 Soloist (Speech)
720898 - elastique 3.2.3 Soloist (Monophonic Mid Side)
851968 - nothing
851969 - Preserve Formants
851970 - Mid/Side
851971 - Preserve Formants (Mid Side)
851972 - Independent Phase
851973 - Preserve Formants, Independent Phase
851974 - Mid/Side, Independent Phase
851975 - Preserve Formants, Mid/Side, Independent Phase
851984 - nothing
851985 - Preserve Formants
851986 - Mid/Side
851987 - Preserve Formants (Mid Side)
851988 - Independent Phase
851989 - Preserve Formants, Independent Phase
851990 - Mid/Side, Independent Phase
851991 - Preserve Formants, Mid/Side, Independent Phase
852000 - nothing
852001 - Preserve Formants
852002 - Mid/Side
852003 - Preserve Formants (Mid Side)
852004 - Independent Phase
852005 - Preserve Formants, Independent Phase
852006 - Mid/Side, Independent Phase
852007 - Preserve Formants, Mid/Side, Independent Phase
852016 - nothing
852017 - Preserve Formants
852018 - Mid/Side
852019 - Preserve Formants (Mid Side)
852020 - Independent Phase
852021 - Preserve Formants, Independent Phase
852022 - Mid/Side, Independent Phase
852023 - Preserve Formants, Mid/Side, Independent Phase
852032 - nothing
852033 - Preserve Formants
852034 - Mid/Side
852035 - Preserve Formants (Mid Side)
852036 - Independent Phase
852037 - Preserve Formants, Independent Phase
852038 - Mid/Side, Independent Phase
852039 - Preserve Formants, Mid/Side, Independent Phase
852048 - nothing
852049 - Preserve Formants
852050 - Mid/Side
852051 - Preserve Formants (Mid Side)
852052 - Independent Phase
852053 - Preserve Formants, Independent Phase
852054 - Mid/Side, Independent Phase
852055 - Preserve Formants, Mid/Side, Independent Phase
852064 - nothing
852065 - Preserve Formants
852066 - Mid/Side
852067 - Preserve Formants (Mid Side)
852068 - Independent Phase
852069 - Preserve Formants, Independent Phase
852070 - Mid/Side, Independent Phase
852071 - Preserve Formants, Mid/Side, Independent Phase
852080 - nothing
852081 - Preserve Formants
852082 - Mid/Side
852083 - Preserve Formants (Mid Side)
852084 - Independent Phase
852085 - Preserve Formants, Independent Phase
852086 - Mid/Side, Independent Phase
852087 - Preserve Formants, Mid/Side, Independent Phase
852096 - nothing
852097 - Preserve Formants
852098 - Mid/Side
852099 - Preserve Formants (Mid Side)
852100 - Independent Phase
852101 - Preserve Formants, Independent Phase
852102 - Mid/Side, Independent Phase
852103 - Preserve Formants, Mid/Side, Independent Phase
852112 - nothing
852113 - Preserve Formants
852114 - Mid/Side
852115 - Preserve Formants (Mid Side)
852116 - Independent Phase
852117 - Preserve Formants, Independent Phase
852118 - Mid/Side, Independent Phase
852119 - Preserve Formants, Mid/Side, Independent Phase
852128 - nothing
852129 - Preserve Formants
852130 - Mid/Side
852131 - Preserve Formants (Mid Side)
852132 - Independent Phase
852133 - Preserve Formants, Independent Phase
852134 - Mid/Side, Independent Phase
852135 - Preserve Formants, Mid/Side, Independent Phase
852144 - nothing
852145 - Preserve Formants
852146 - Mid/Side
852147 - Preserve Formants (Mid Side)
852148 - Independent Phase
852149 - Preserve Formants, Independent Phase
852150 - Mid/Side, Independent Phase
852151 - Preserve Formants, Mid/Side, Independent Phase
852160 - nothing
852161 - Preserve Formants
852162 - Mid/Side
852163 - Preserve Formants (Mid Side)
852164 - Independent Phase
852165 - Preserve Formants, Independent Phase
852166 - Mid/Side, Independent Phase
852167 - Preserve Formants, Mid/Side, Independent Phase
852176 - nothing
852177 - Preserve Formants
852178 - Mid/Side
852179 - Preserve Formants (Mid Side)
852180 - Independent Phase
852181 - Preserve Formants, Independent Phase
852182 - Mid/Side, Independent Phase
852183 - Preserve Formants, Mid/Side, Independent Phase
852192 - nothing
852193 - Preserve Formants
852194 - Mid/Side
852195 - Preserve Formants (Mid Side)
852196 - Independent Phase
852197 - Preserve Formants, Independent Phase
852198 - Mid/Side, Independent Phase
852199 - Preserve Formants, Mid/Side, Independent Phase
852208 - nothing
852209 - Preserve Formants
852210 - Mid/Side
852211 - Preserve Formants (Mid Side)
852212 - Independent Phase
852213 - Preserve Formants, Independent Phase
852214 - Mid/Side, Independent Phase
852215 - Preserve Formants, Mid/Side, Independent Phase
852224 - nothing
852225 - Preserve Formants
852226 - Mid/Side
852227 - Preserve Formants (Mid Side)
852228 - Independent Phase
852229 - Preserve Formants, Independent Phase
852230 - Mid/Side, Independent Phase
852231 - Preserve Formants, Mid/Side, Independent Phase
852240 - nothing
852241 - Preserve Formants
852242 - Mid/Side
852243 - Preserve Formants (Mid Side)
852244 - Independent Phase
852245 - Preserve Formants, Independent Phase
852246 - Mid/Side, Independent Phase
852247 - Preserve Formants, Mid/Side, Independent Phase
852256 - nothing
852257 - Preserve Formants
852258 - Mid/Side
852259 - Preserve Formants (Mid Side)
852260 - Independent Phase
852261 - Preserve Formants, Independent Phase
852262 - Mid/Side, Independent Phase
852263 - Preserve Formants, Mid/Side, Independent Phase
852272 - nothing
852273 - Preserve Formants
852274 - Mid/Side
852275 - Preserve Formants (Mid Side)
852276 - Independent Phase
852277 - Preserve Formants, Independent Phase
852278 - Mid/Side, Independent Phase
852279 - Preserve Formants, Mid/Side, Independent Phase
852288 - nothing
852289 - Preserve Formants
852290 - Mid/Side
852291 - Preserve Formants (Mid Side)
852292 - Independent Phase
852293 - Preserve Formants, Independent Phase
852294 - Mid/Side, Independent Phase
852295 - Preserve Formants, Mid/Side, Independent Phase
852304 - nothing
852305 - Preserve Formants
852306 - Mid/Side
852307 - Preserve Formants (Mid Side)
852308 - Independent Phase
852309 - Preserve Formants, Independent Phase
852310 - Mid/Side, Independent Phase
852311 - Preserve Formants, Mid/Side, Independent Phase
852320 - nothing
852321 - Preserve Formants
852322 - Mid/Side
852323 - Preserve Formants (Mid Side)
852324 - Independent Phase
852325 - Preserve Formants, Independent Phase
852326 - Mid/Side, Independent Phase
852327 - Preserve Formants, Mid/Side, Independent Phase
852336 - nothing
852337 - Preserve Formants
852338 - Mid/Side
852339 - Preserve Formants (Mid Side)
852340 - Independent Phase
852341 - Preserve Formants, Independent Phase
852342 - Mid/Side, Independent Phase
852343 - Preserve Formants, Mid/Side, Independent Phase
852352 - nothing
852353 - Preserve Formants
852354 - Mid/Side
852355 - Preserve Formants (Mid Side)
852356 - Independent Phase
852357 - Preserve Formants, Independent Phase
852358 - Mid/Side, Independent Phase
852359 - Preserve Formants, Mid/Side, Independent Phase
852368 - nothing
852369 - Preserve Formants
852370 - Mid/Side
852371 - Preserve Formants (Mid Side)
852372 - Independent Phase
852373 - Preserve Formants, Independent Phase
852374 - Mid/Side, Independent Phase
852375 - Preserve Formants, Mid/Side, Independent Phase
852384 - nothing
852385 - Preserve Formants
852386 - Mid/Side
852387 - Preserve Formants (Mid Side)
852388 - Independent Phase
852389 - Preserve Formants, Independent Phase
852390 - Mid/Side, Independent Phase
852391 - Preserve Formants, Mid/Side, Independent Phase
852400 - nothing
852401 - Preserve Formants
852402 - Mid/Side
852403 - Preserve Formants (Mid Side)
852404 - Independent Phase
852405 - Preserve Formants, Independent Phase
852406 - Mid/Side, Independent Phase
852407 - Preserve Formants, Mid/Side, Independent Phase
852416 - nothing
852417 - Preserve Formants
852418 - Mid/Side
852419 - Preserve Formants (Mid Side)
852420 - Independent Phase
852421 - Preserve Formants, Independent Phase
852422 - Mid/Side, Independent Phase
852423 - Preserve Formants, Mid/Side, Independent Phase
852432 - nothing
852433 - Preserve Formants
852434 - Mid/Side
852435 - Preserve Formants (Mid Side)
852436 - Independent Phase
852437 - Preserve Formants, Independent Phase
852438 - Mid/Side, Independent Phase
852439 - Preserve Formants, Mid/Side, Independent Phase
852448 - nothing
852449 - Preserve Formants
852450 - Mid/Side
852451 - Preserve Formants (Mid Side)
852452 - Independent Phase
852453 - Preserve Formants, Independent Phase
852454 - Mid/Side, Independent Phase
852455 - Preserve Formants, Mid/Side, Independent Phase
852464 - nothing
852465 - Preserve Formants
852466 - Mid/Side
852467 - Preserve Formants (Mid Side)
852468 - Independent Phase
852469 - Preserve Formants, Independent Phase
852470 - Mid/Side, Independent Phase
852471 - Preserve Formants, Mid/Side, Independent Phase
852480 - nothing
852481 - Preserve Formants
852482 - Mid/Side
852483 - Preserve Formants (Mid Side)
852484 - Independent Phase
852485 - Preserve Formants, Independent Phase
852486 - Mid/Side, Independent Phase
852487 - Preserve Formants, Mid/Side, Independent Phase
852496 - nothing
852497 - Preserve Formants
852498 - Mid/Side
852499 - Preserve Formants (Mid Side)
852500 - Independent Phase
852501 - Preserve Formants, Independent Phase
852502 - Mid/Side, Independent Phase
852503 - Preserve Formants, Mid/Side, Independent Phase
852512 - nothing
852513 - Preserve Formants
852514 - Mid/Side
852515 - Preserve Formants (Mid Side)
852516 - Independent Phase
852517 - Preserve Formants, Independent Phase
852518 - Mid/Side, Independent Phase
852519 - Preserve Formants, Mid/Side, Independent Phase
852528 - nothing
852529 - Preserve Formants
852530 - Mid/Side
852531 - Preserve Formants (Mid Side)
852532 - Independent Phase
852533 - Preserve Formants, Independent Phase
852534 - Mid/Side, Independent Phase
852535 - Preserve Formants, Mid/Side, Independent Phase
852544 - nothing
852545 - Preserve Formants
852546 - Mid/Side
852547 - Preserve Formants (Mid Side)
852548 - Independent Phase
852549 - Preserve Formants, Independent Phase
852550 - Mid/Side, Independent Phase
852551 - Preserve Formants, Mid/Side, Independent Phase
852560 - nothing
852561 - Preserve Formants
852562 - Mid/Side
852563 - Preserve Formants (Mid Side)
852564 - Independent Phase
852565 - Preserve Formants, Independent Phase
852566 - Mid/Side, Independent Phase
852567 - Preserve Formants, Mid/Side, Independent Phase
852576 - nothing
852577 - Preserve Formants
852578 - Mid/Side
852579 - Preserve Formants (Mid Side)
852580 - Independent Phase
852581 - Preserve Formants, Independent Phase
852582 - Mid/Side, Independent Phase
852583 - Preserve Formants, Mid/Side, Independent Phase
852592 - nothing
852593 - Preserve Formants
852594 - Mid/Side
852595 - Preserve Formants (Mid Side)
852596 - Independent Phase
852597 - Preserve Formants, Independent Phase
852598 - Mid/Side, Independent Phase
852599 - Preserve Formants, Mid/Side, Independent Phase
852608 - nothing
852609 - Preserve Formants
852610 - Mid/Side
852611 - Preserve Formants (Mid Side)
852612 - Independent Phase
852613 - Preserve Formants, Independent Phase
852614 - Mid/Side, Independent Phase
852615 - Preserve Formants, Mid/Side, Independent Phase
852624 - nothing
852625 - Preserve Formants
852626 - Mid/Side
852627 - Preserve Formants (Mid Side)
852628 - Independent Phase
852629 - Preserve Formants, Independent Phase
852630 - Mid/Side, Independent Phase
852631 - Preserve Formants, Mid/Side, Independent Phase
852640 - nothing
852641 - Preserve Formants
852642 - Mid/Side
852643 - Preserve Formants (Mid Side)
852644 - Independent Phase
852645 - Preserve Formants, Independent Phase
852646 - Mid/Side, Independent Phase
852647 - Preserve Formants, Mid/Side, Independent Phase
852656 - nothing
852657 - Preserve Formants
852658 - Mid/Side
852659 - Preserve Formants (Mid Side)
852660 - Independent Phase
852661 - Preserve Formants, Independent Phase
852662 - Mid/Side, Independent Phase
852663 - Preserve Formants, Mid/Side, Independent Phase
852672 - nothing
852673 - Preserve Formants
852674 - Mid/Side
852675 - Preserve Formants (Mid Side)
852676 - Independent Phase
852677 - Preserve Formants, Independent Phase
852678 - Mid/Side, Independent Phase
852679 - Preserve Formants, Mid/Side, Independent Phase
852688 - nothing
852689 - Preserve Formants
852690 - Mid/Side
852691 - Preserve Formants (Mid Side)
852692 - Independent Phase
852693 - Preserve Formants, Independent Phase
852694 - Mid/Side, Independent Phase
852695 - Preserve Formants, Mid/Side, Independent Phase
852704 - nothing
852705 - Preserve Formants
852706 - Mid/Side
852707 - Preserve Formants (Mid Side)
852708 - Independent Phase
852709 - Preserve Formants, Independent Phase
852710 - Mid/Side, Independent Phase
852711 - Preserve Formants, Mid/Side, Independent Phase
852720 - nothing
852721 - Preserve Formants
852722 - Mid/Side
852723 - Preserve Formants (Mid Side)
852724 - Independent Phase
852725 - Preserve Formants, Independent Phase
852726 - Mid/Side, Independent Phase
852727 - Preserve Formants, Mid/Side, Independent Phase
852736 - nothing
852737 - Preserve Formants
852738 - Mid/Side
852739 - Preserve Formants (Mid Side)
852740 - Independent Phase
852741 - Preserve Formants, Independent Phase
852742 - Mid/Side, Independent Phase
852743 - Preserve Formants, Mid/Side, Independent Phase
852752 - nothing
852753 - Preserve Formants
852754 - Mid/Side
852755 - Preserve Formants (Mid Side)
852756 - Independent Phase
852757 - Preserve Formants, Independent Phase
852758 - Mid/Side, Independent Phase
852759 - Preserve Formants, Mid/Side, Independent Phase
852768 - nothing
852769 - Preserve Formants
852770 - Mid/Side
852771 - Preserve Formants (Mid Side)
852772 - Independent Phase
852773 - Preserve Formants, Independent Phase
852774 - Mid/Side, Independent Phase
852775 - Preserve Formants, Mid/Side, Independent Phase
852784 - nothing
852785 - Preserve Formants
852786 - Mid/Side
852787 - Preserve Formants (Mid Side)
852788 - Independent Phase
852789 - Preserve Formants, Independent Phase
852790 - Mid/Side, Independent Phase
852791 - Preserve Formants, Mid/Side, Independent Phase
852800 - nothing
852801 - Preserve Formants
852802 - Mid/Side
852803 - Preserve Formants (Mid Side)
852804 - Independent Phase
852805 - Preserve Formants, Independent Phase
852806 - Mid/Side, Independent Phase
852807 - Preserve Formants, Mid/Side, Independent Phase
852816 - nothing
852817 - Preserve Formants
852818 - Mid/Side
852819 - Preserve Formants (Mid Side)
852820 - Independent Phase
852821 - Preserve Formants, Independent Phase
852822 - Mid/Side, Independent Phase
852823 - Preserve Formants, Mid/Side, Independent Phase
852832 - nothing
852833 - Preserve Formants
852834 - Mid/Side
852835 - Preserve Formants (Mid Side)
852836 - Independent Phase
852837 - Preserve Formants, Independent Phase
852838 - Mid/Side, Independent Phase
852839 - Preserve Formants, Mid/Side, Independent Phase
852848 - nothing
852849 - Preserve Formants
852850 - Mid/Side
852851 - Preserve Formants (Mid Side)
852852 - Independent Phase
852853 - Preserve Formants, Independent Phase
852854 - Mid/Side, Independent Phase
852855 - Preserve Formants, Mid/Side, Independent Phase
852864 - nothing
852865 - Preserve Formants
852866 - Mid/Side
852867 - Preserve Formants (Mid Side)
852868 - Independent Phase
852869 - Preserve Formants, Independent Phase
852870 - Mid/Side, Independent Phase
852871 - Preserve Formants, Mid/Side, Independent Phase
852880 - nothing
852881 - Preserve Formants
852882 - Mid/Side
852883 - Preserve Formants (Mid Side)
852884 - Independent Phase
852885 - Preserve Formants, Independent Phase
852886 - Mid/Side, Independent Phase
852887 - Preserve Formants, Mid/Side, Independent Phase
852896 - nothing
852897 - Preserve Formants
852898 - Mid/Side
852899 - Preserve Formants (Mid Side)
852900 - Independent Phase
852901 - Preserve Formants, Independent Phase
852902 - Mid/Side, Independent Phase
852903 - Preserve Formants, Mid/Side, Independent Phase
852912 - nothing
852913 - Preserve Formants
852914 - Mid/Side
852915 - Preserve Formants (Mid Side)
852916 - Independent Phase
852917 - Preserve Formants, Independent Phase
852918 - Mid/Side, Independent Phase
852919 - Preserve Formants, Mid/Side, Independent Phase
852928 - nothing
852929 - Preserve Formants
852930 - Mid/Side
852931 - Preserve Formants (Mid Side)
852932 - Independent Phase
852933 - Preserve Formants, Independent Phase
852934 - Mid/Side, Independent Phase
852935 - Preserve Formants, Mid/Side, Independent Phase
852944 - nothing
852945 - Preserve Formants
852946 - Mid/Side
852947 - Preserve Formants (Mid Side)
852948 - Independent Phase
852949 - Preserve Formants, Independent Phase
852950 - Mid/Side, Independent Phase
852951 - Preserve Formants, Mid/Side, Independent Phase
852960 - nothing
852961 - Preserve Formants
852962 - Mid/Side
852963 - Preserve Formants (Mid Side)
852964 - Independent Phase
852965 - Preserve Formants, Independent Phase
852966 - Mid/Side, Independent Phase
852967 - Preserve Formants, Mid/Side, Independent Phase
852976 - nothing
852977 - Preserve Formants
852978 - Mid/Side
852979 - Preserve Formants (Mid Side)
852980 - Independent Phase
852981 - Preserve Formants, Independent Phase
852982 - Mid/Side, Independent Phase
852983 - Preserve Formants, Mid/Side, Independent Phase
852992 - nothing
852993 - Preserve Formants
852994 - Mid/Side
852995 - Preserve Formants (Mid Side)
852996 - Independent Phase
852997 - Preserve Formants, Independent Phase
852998 - Mid/Side, Independent Phase
852999 - Preserve Formants, Mid/Side, Independent Phase
853008 - nothing
853009 - Preserve Formants
853010 - Mid/Side
853011 - Preserve Formants (Mid Side)
853012 - Independent Phase
853013 - Preserve Formants, Independent Phase
853014 - Mid/Side, Independent Phase
853015 - Preserve Formants, Mid/Side, Independent Phase
853024 - nothing
853025 - Preserve Formants
853026 - Mid/Side
853027 - Preserve Formants (Mid Side)
853028 - Independent Phase
853029 - Preserve Formants, Independent Phase
853030 - Mid/Side, Independent Phase
853031 - Preserve Formants, Mid/Side, Independent Phase
853040 - nothing
853041 - Preserve Formants
853042 - Mid/Side
853043 - Preserve Formants (Mid Side)
853044 - Independent Phase
853045 - Preserve Formants, Independent Phase
853046 - Mid/Side, Independent Phase
853047 - Preserve Formants, Mid/Side, Independent Phase
853056 - nothing
853057 - Preserve Formants
853058 - Mid/Side
853059 - Preserve Formants (Mid Side)
853060 - Independent Phase
853061 - Preserve Formants, Independent Phase
853062 - Mid/Side, Independent Phase
853063 - Preserve Formants, Mid/Side, Independent Phase
853072 - nothing
853073 - Preserve Formants
853074 - Mid/Side
853075 - Preserve Formants (Mid Side)
853076 - Independent Phase
853077 - Preserve Formants, Independent Phase
853078 - Mid/Side, Independent Phase
853079 - Preserve Formants, Mid/Side, Independent Phase
853088 - nothing
853089 - Preserve Formants
853090 - Mid/Side
853091 - Preserve Formants (Mid Side)
853092 - Independent Phase
853093 - Preserve Formants, Independent Phase
853094 - Mid/Side, Independent Phase
853095 - Preserve Formants, Mid/Side, Independent Phase
853104 - nothing
853105 - Preserve Formants
853106 - Mid/Side
853107 - Preserve Formants (Mid Side)
853108 - Independent Phase
853109 - Preserve Formants, Independent Phase
853110 - Mid/Side, Independent Phase
853111 - Preserve Formants, Mid/Side, Independent Phase
853120 - nothing
853121 - Preserve Formants
853122 - Mid/Side
853123 - Preserve Formants (Mid Side)
853124 - Independent Phase
853125 - Preserve Formants, Independent Phase
853126 - Mid/Side, Independent Phase
853127 - Preserve Formants, Mid/Side, Independent Phase
853136 - nothing
853137 - Preserve Formants
853138 - Mid/Side
853139 - Preserve Formants (Mid Side)
853140 - Independent Phase
853141 - Preserve Formants, Independent Phase
853142 - Mid/Side, Independent Phase
853143 - Preserve Formants, Mid/Side, Independent Phase
853152 - nothing
853153 - Preserve Formants
853154 - Mid/Side
853155 - Preserve Formants (Mid Side)
853156 - Independent Phase
853157 - Preserve Formants, Independent Phase
853158 - Mid/Side, Independent Phase
853159 - Preserve Formants, Mid/Side, Independent Phase
853168 - nothing
853169 - Preserve Formants
853170 - Mid/Side
853171 - Preserve Formants (Mid Side)
853172 - Independent Phase
853173 - Preserve Formants, Independent Phase
853174 - Mid/Side, Independent Phase
853175 - Preserve Formants, Mid/Side, Independent Phase
853184 - nothing
853185 - Preserve Formants
853186 - Mid/Side
853187 - Preserve Formants (Mid Side)
853188 - Independent Phase
853189 - Preserve Formants, Independent Phase
853190 - Mid/Side, Independent Phase
853191 - Preserve Formants, Mid/Side, Independent Phase
853200 - nothing
853201 - Preserve Formants
853202 - Mid/Side
853203 - Preserve Formants (Mid Side)
853204 - Independent Phase
853205 - Preserve Formants, Independent Phase
853206 - Mid/Side, Independent Phase
853207 - Preserve Formants, Mid/Side, Independent Phase
853216 - nothing
853217 - Preserve Formants
853218 - Mid/Side
853219 - Preserve Formants (Mid Side)
853220 - Independent Phase
853221 - Preserve Formants, Independent Phase
853222 - Mid/Side, Independent Phase
853223 - Preserve Formants, Mid/Side, Independent Phase
853232 - nothing
853233 - Preserve Formants
853234 - Mid/Side
853235 - Preserve Formants (Mid Side)
853236 - Independent Phase
853237 - Preserve Formants, Independent Phase
853238 - Mid/Side, Independent Phase
853239 - Preserve Formants, Mid/Side, Independent Phase
853248 - nothing
853249 - Preserve Formants
853250 - Mid/Side
853251 - Preserve Formants (Mid Side)
853252 - Independent Phase
853253 - Preserve Formants, Independent Phase
853254 - Mid/Side, Independent Phase
853255 - Preserve Formants, Mid/Side, Independent Phase 
]]


count, split_string = ultraschall.SplitStringAtLineFeedToArray(String)

String=""
for i=0, 10000 do
  for a=0, 10000 do
    retval, str = reaper.EnumPitchShiftModes(i)
    if str~=nil then
      str2=reaper.EnumPitchShiftSubModes(i, a) 
      if str2~=nil then
        combi=ultraschall.CombineBytesToInteger(0, a, 0, i)
        String=String..combi..","..i..","..a.." - "..str..","..str2.."\n"
--        print_alt(i, a, str, "P"..tostring(str2).."P")
--        reaper.CF_SetClipboard(str..","..str2)
      end
    end
  end
end
reaper.CF_SetClipboard(String)

print(ultraschall.ConvertIntegerToBits(131072))
