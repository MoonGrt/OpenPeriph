`timescale 1ns / 1ps

module syncbase #(
    parameter kResetTo = 0
) (
    input  areset,
    input  inclk,
    input  iin,
    input  outclk,
    output oout

);

    // define wire
    wire oout;

    // define reg
    reg  iin_q = 0;

    //*****************************************************
    //**                    main code
    //*****************************************************

    always @(posedge inclk) begin
        if (areset) iin_q <= kResetTo;
        else iin_q <= iin;
    end

    // Crossing clock boundary here
    syncasync u_syncasync (
        .areset(areset),
        .ain   (iin_q),
        .outclk(outclk),
        .oout  (oout)
    );

endmodule
