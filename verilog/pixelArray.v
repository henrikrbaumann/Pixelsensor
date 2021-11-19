// ====================================================================
// Make an array out of the data output from the pixelsensor
// ===================================================================

module PIXEL_ARRAY(
                    input logic                  clk,        
                    input logic                  vbn1,        
                    input logic                  ramp,
                    input logic                  reset,
                    input logic                  erase,
                    input logic                  expose,
                    input logic                  read,       
                    input logic                  row_pointer, 
                    output reg [7:0]             out_data     

   );

    wire [7:0] sensor_in    [0:1][0:1];
    reg [7:0] row_shift_reg [1:0];
    integer i;
    integer k;
    integer c_column = 0;
    parameter integer n_columns = 2;
    //#parameter dv_pixel = 0.5;

    // Making a 2x2 pixel array
    PIXEL_SENSOR/* #(.dv_pixel(0))    */ ps00(.VBN1(vbn1), .RAMP(ramp), .RESET(reset), .ERASE(erase), .EXPOSE(expose), .READ(read), .test(0), .DATA(sensor_in[0][0]));
    PIXEL_SENSOR/* #(.dv_pixel(0.25)) */ ps01(.VBN1(vbn1), .RAMP(ramp), .RESET(reset), .ERASE(erase), .EXPOSE(expose), .READ(read), .test(1), .DATA(sensor_in[0][1]));
    PIXEL_SENSOR/* #(.dv_pixel(0.5))  */ ps10(.VBN1(vbn1), .RAMP(ramp), .RESET(reset), .ERASE(erase), .EXPOSE(expose), .READ(read), .test(2), .DATA(sensor_in[1][0]));
    PIXEL_SENSOR/* #(.dv_pixel(0.75)) */ ps11(.VBN1(vbn1), .RAMP(ramp), .RESET(reset), .ERASE(erase), .EXPOSE(expose), .READ(read), .test(3), .DATA(sensor_in[1][1]));
   

    // Whenever rowpointer changes, load row sensor data into reg
    // i is the number of columns, and row_pointer points to current row
    always @(row_pointer) begin
        for (i=0; i<2; i++) begin
            row_shift_reg[i] = sensor_in[row_pointer][i];
            c_column <= 0;
        end        
    end

    // Output a 8 bit pixel on each clk
    always_ff @(posedge clk) begin
        if (~reset) begin
            for (k = 0; k < n_columns; k++) begin
                row_shift_reg[k] <= 0;
                out_data <= 8'bZ;
            end
        end
        else begin
            // Output all pixels in register, then sett output to high impedance
            if (read) begin        
                if (c_column >= n_columns) begin
                    out_data <= 8'bZ;
                    c_column++;
                end
                else begin
                    out_data = row_shift_reg[c_column];
                    c_column++;
                end
            end
        end
    end
endmodule