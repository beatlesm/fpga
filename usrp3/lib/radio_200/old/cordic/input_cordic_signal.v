`define K 
module input_cordic_signal(radio_clk, start, reset, angle_in, get_tx);
    input radio_clk;
    input start;
    input reset;
    output [31:0] get_tx;

    output [31:0] sin_out;
    output [31:0] cos_out;

    wire [31:0] sin_out = sin; 
    wire [31:0] cos_out = cos; 

    reg [4:0] count_next;
    reg state_next;

    always @(posedge radio_clk) begin
        if (reset) begin
            cos <= 0;
            sin <= 0;
            angle <= 0;
            count <= 0;
            state <= 0;
        and else begin
            cos <= cos_next;
            sin <= sin_next;
            angle <= angle_next;
            count <= count_next;
            state <= state_next;
        end
    end

    always @* begin
        cos_next = cos;
        sin_next = sin;
        angle_next = angle;
        count_next = count;
        state_next = state;

        if (state) begin
            cos_next = cos + (direction_negative ? sin_shft : -sin_shft);
            sin_next = sin + (direction_negative ? -cos_shft : cos_shft);
            angle_next = angle + (direction_negative ? beta : -beta);
            count_next = count + 1;

            if (count == 31) begin
                state_next = 0;
            end
        end

        else begin
            if (start) begin
                cos_next = `K;
                sin_next = 0;
                angle_next = angle_in;
                count_next = 0;
                state_next = 1;
            end
        end
    end

    wire [31:0] cos_signbits = {32{cos[31]}};
    wire [31:0] sin_signbits = {32{sin[31]}};
    wire [31:0] cos_shft = {cos_signbits, cos} >> count;
    wire [31:0] sin_shft = {sin_signbits, sin} >> count;

    wire direction_negative = angle[31]; // Using sign bit of angle



    always @(posedge radio_clk) begin
        phase_acc1 = phase_acc1 + 1342177280;
        phase_acc2 = phase_acc2 + 1879048192;
        tx_out[10:0] = sine[phase_acc1[31:21]] + sine[phase_acc2[31:21]];
        tx_out[31:11] = 21'b000000000000000000000;
    end
   assign get_tx = tx_out;


// SINE LOOKUP TABLE
    reg [9:0] sine [0:31];
    initial
        begin
                atan[0] = 32'b01100100100001111110110101010001;
                atan[1] = 32'b00111011010110001100111000001010;
                atan[2] = 32'b00011111010110110111010111111001;
                atan[3] = 32'b00001111111010101101110101001101;
                atan[4] = 32'b00000111111111010101011011101101;
                atan[5] = 32'b00000011111111111010101010110111;
                atan[6] = 32'b00000001111111111111010101010101;
                atan[7] = 32'b00000000111111111111111010101010;
                atan[8] = 32'b00000000011111111111111111010101;
                atan[9] = 32'b00000000001111111111111111111010;
                atan[10] = 32'b00000000000111111111111111111111;
                atan[11] = 32'b00000000000011111111111111111111;
                atan[12] = 32'b00000000000001111111111111111111;
                atan[13] = 32'b00000000000000111111111111111111;
                atan[14] = 32'b00000000000000011111111111111111;
                atan[15] = 32'b00000000000000001111111111111111;
                atan[16] = 32'b00000000000000000111111111111111;
                atan[17] = 32'b00000000000000000011111111111111;
                atan[18] = 32'b00000000000000000001111111111111;
                atan[19] = 32'b00000000000000000000111111111111;
                atan[20] = 32'b00000000000000000000011111111111;
                atan[21] = 32'b00000000000000000000001111111111;
                atan[22] = 32'b00000000000000000000000111111111;
                atan[23] = 32'b00000000000000000000000011111111;
                atan[24] = 32'b00000000000000000000000001111111;
                atan[25] = 32'b00000000000000000000000000111111;
                atan[26] = 32'b00000000000000000000000000011111;
                atan[27] = 32'b00000000000000000000000000010000;
                atan[28] = 32'b00000000000000000000000000001000;
                atan[29] = 32'b00000000000000000000000000000100;
                atan[30] = 32'b00000000000000000000000000000010;
                atan[31] = 32'b00000000000000000000000000000001;
        end
