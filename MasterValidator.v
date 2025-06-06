module MasterValidator #(
    parameter [7:0] MASTER_PASS = 8'hA5
)(
    input  [7:0] entered_pass,
    output       unlocked
);
    assign unlocked = (entered_pass == MASTER_PASS);
endmodule