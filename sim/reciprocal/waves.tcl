lappend system "i_clk"
lappend system "i_rst_p"

set num_added [ gtkwave::addSignalsFromList $system ]

gtkwave::/Edit/Insert_Comment "---- t0 ----"

lappend t0 "top_tb.DUT.t_0_dat"
lappend t0 "top_tb.DUT.t_0_req"
lappend t0 "top_tb.DUT.t_0_ack"

set num_added [ gtkwave::addSignalsFromList $t0 ]


gtkwave::/Edit/Insert_Comment "---- i0 ----"

lappend i0 "top_tb.DUT.i_13_dat"
lappend i0 "top_tb.DUT.i_13_req"
lappend i0 "top_tb.DUT.i_13_ack"

set num_added [ gtkwave::addSignalsFromList $i0 ]

gtkwave::setZoomFactor -4
