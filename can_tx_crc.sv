module can_tx_crc (
    input        clk,
    input        rst_n,
    input        start,
    input [10:0] id,        // Standard CAN ID
    input  [7:0] data,      // 8-bit data field
    output reg   tx,
    output reg   busy,
    output reg [14:0] crc_out // Final CRC output
);

    typedef enum logic [3:0] {
        IDLE,
        START_BIT,
        SEND_ID,
        CONTROL,
        SEND_DATA,
        SEND_CRC,
        CRC_DELIM,
        ACK_SLOT,
        END_FRAME,
        DONE
    } state_t;

    state_t state, next_state;

    reg [7:0] bit_cnt;
    reg [31:0] shift_reg;
    reg [14:0] crc_reg;       // CRC calculation register
    reg [3:0]  crc_cnt;

    // CAN CRC-15 polynomial: x^15 + x^14 + x^10 + x^8 + x^7 + x^4 + x^3 + 1
    function [14:0] next_crc;
        input [14:0] crc;
        input        din;
        reg          feedback;
        begin
            feedback = crc[14] ^ din;
            next_crc = {crc[13:0], 1'b0} ^ (feedback ? 15'h4599 : 15'h0000);
        end
    endfunction

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:       if (start) next_state = START_BIT;
            START_BIT:  next_state = SEND_ID;
            SEND_ID:    if (bit_cnt == 0) next_state = CONTROL;
            CONTROL:    next_state = SEND_DATA;
            SEND_DATA:  if (bit_cnt == 0) next_state = SEND_CRC;
            SEND_CRC:   if (crc_cnt == 0) next_state = CRC_DELIM;
            CRC_DELIM:  next_state = ACK_SLOT;
            ACK_SLOT:   next_state = END_FRAME;
            END_FRAME:  next_state = DONE;
            DONE:       next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            tx        <= 1'b1;
            busy      <= 1'b0;
            bit_cnt   <= 0;
            crc_cnt   <= 0;
            crc_reg   <= 15'h0000;
            crc_out   <= 15'h0000;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    tx      <= 1'b1;
                    busy    <= 1'b0;
                    if (start) begin
                        shift_reg <= {id, 4'b1000, data}; // ID + DLC (8) + data
                        bit_cnt   <= 11 + 4 + 8 - 1;
                        crc_reg   <= 15'h0000;
                        crc_cnt   <= 15;
                        busy      <= 1'b1;
                    end
                end

                START_BIT: begin
                    tx <= 1'b0; // Dominant start bit
                end

                SEND_ID,
                CONTROL,
                SEND_DATA: begin
                    tx <= shift_reg[bit_cnt];
                    $display("tx=%b,shift[%d]=%b",tx,bit_cnt,shift_reg[bit_cnt]);
                    crc_reg <= next_crc(crc_reg, shift_reg[bit_cnt]);
                    $display("*after_Crc**crc_reg=%b,shift[%d]=%b",crc_reg,bit_cnt,shift_reg[bit_cnt],$time);

                    if (bit_cnt != 0)
                        bit_cnt <= bit_cnt - 1;
                end

                SEND_CRC: begin
                    if (crc_cnt == 15)
                        crc_out <= crc_reg;
                    tx <= crc_reg[crc_cnt - 1];
                    if (crc_cnt != 0)
                        crc_cnt <= crc_cnt - 1;
                end

                CRC_DELIM: begin
                    tx <= 1'b1;
                end

                ACK_SLOT: begin
                    tx <= 1'b1;
                end

                END_FRAME: begin
                    tx <= 1'b1;
                end

                DONE: begin
                    tx   <= 1'b1;
                    busy <= 1'b0;
                end
            endcase
        end
    end

endmodule
