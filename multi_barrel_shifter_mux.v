`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/05/2023 12:44:20 AM
// Design Name: 
// Module Name: multi_barrel_shifter_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

parameter N = 3;

module multi_barrel_shifter_mux
(
    input logic[2**N-1:0] a,
    input logic [N - 1:0] amt,
    input logic lr, // 0 rotate right, 1 rotate left
    output logic [2**N-1:0] y
    );

    logic [2**N-1:0] yL;
    logic [2**N-1:0] yR;
    
    param_left_shifter bsL(.a(a), .amt(amt), .y(yL));
    param_right_shifter bsR(.a(a), .amt(amt), .y(yR));

    assign y = (lr == 1) ? yL:yR;   
    //assign y = (lr) ? yR[N**2-1]:yL[0];

    
endmodule

// RIGHT SHIFTER
module param_right_shifter
    (
    input logic [2**N-1:0] a,
    input logic [N-1:0] amt,
    output logic [2**N-1:0] y
    );

logic [2**N-1:0] S[N-1];

//stage 0
assign S[0] = amt[0] ? {a[0], a[2**N-1:1]} : a;

// Middle stages
generate
    genvar i;
    for (i = 1; i < N-1; i=i+1)
        assign S[i] = amt[i] ? {S[i-1][2**i-1:0], S[i-1][2**N-1:2**i]}: S[i-1];
endgenerate

//final stage
assign y = amt[N-1] ? {S[N-2][2**(N-1)-1:0], S[N-2][2**N-1:2**(N-1)]}:S[N-2];

endmodule


// LEFT SHIFTER
module param_left_shifter
    (
    input logic [(2**N)-1:0] a,
    input logic [N-1:0] amt,
    output logic [(2**N)-1:0] y
    );

logic [2**N-1:0] S[N-1];

//stage 0
assign S[0] = amt[0] ? {a[0], a[2**N-1:1]} : a;

// Middle stages
generate
    genvar i;
    for (i = 1; i < N-1; i=i+1)
        assign S[i] = amt[i] ? {S[i-1][2**N-1-(2**i):0] , S[i-1][2**N-1:2**N-2**i]}: S[i-1];
                    
endgenerate
            
           
           assign y = amt[N-1] ? {S[N-2][2**(N-1)-1:0], S[N-2][2**N-1:2**(N-1)]}:S[N-2];

endmodule
