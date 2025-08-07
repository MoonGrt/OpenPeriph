`timescale 1ns / 1ps

module syncasync (
    input areset,
    input ain,
    input outclk,

    output oout
);

    // define wire
    wire       oout;

    // define reg
    reg  [1:0] osyncstages = 0;

    //*****************************************************
    //**                    main code
    //*****************************************************

    // define assign
    assign oout = osyncstages[1];


    always @(posedge outclk) begin
        if (areset) osyncstages <= 2'b11;
        else osyncstages <= {osyncstages[0], ain};
    end

endmodule
