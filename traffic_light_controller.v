module traffic_light_controller(
    input clk, reset,
    input N, S, E, W,
    output reg Rn, Yn, Gn, Re, Ye, Ge, Rs, Ys, Gs, Rw, Yw, Gw
);
    // State definitions
    localparam S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100,
               S5 = 3'b101, S6 = 3'b110, S7 = 3'b111;

    // Timing parameters (adjust these values based on your system clock)
    localparam GREEN_TIME = 4'd10;  // Time for green light in clock cycles
    localparam YELLOW_TIME = 4'd3;  // Time for yellow light in clock cycles

    // State register and next state logic
    reg [2:0] state_reg, next_state;
    reg [3:0] timer_n, timer_e, timer_s, timer_w;  // Timers for each direction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= S0;
            timer_n <= 0;
            timer_e <= 0;
            timer_s <= 0;
            timer_w <= 0;
        end else begin
            state_reg <= next_state;

            // Update timers based on the state
            if (state_reg == S0) begin
                if (timer_n < GREEN_TIME) timer_n <= timer_n + 1;
                else if (timer_n < GREEN_TIME + YELLOW_TIME) timer_n <= timer_n + 1;
            end
            if (state_reg == S2) begin
                if (timer_e < GREEN_TIME) timer_e <= timer_e + 1;
                else if (timer_e < GREEN_TIME + YELLOW_TIME) timer_e <= timer_e + 1;
            end
            if (state_reg == S4) begin
                if (timer_s < GREEN_TIME) timer_s <= timer_s + 1;
                else if (timer_s < GREEN_TIME + YELLOW_TIME) timer_s <= timer_s + 1;
            end
            if (state_reg == S6) begin
                if (timer_w < GREEN_TIME) timer_w <= timer_w + 1;
                else if (timer_w < GREEN_TIME + YELLOW_TIME) timer_w <= timer_w + 1;
            end
        end
    end

    // State transitions
    always @(*) begin
        next_state = state_reg;
        case (state_reg)
            S0: begin
                // North Green
                if (timer_n == GREEN_TIME) next_state = S1;  // Go to Yellow after Green
                else if (N) next_state = S0;  // Stay in Green if traffic
                else if (E) next_state = S2; // Check East traffic
                else if (S) next_state = S4; // Check South traffic
                else if (W) next_state = S6; // Check West traffic
            end
            S1: begin
                // North Yellow
                if (timer_n == YELLOW_TIME) next_state = S2;  // Go to East Green after Yellow
                else if (N) next_state = S1;  // Stay in Yellow if traffic
                else if (E) next_state = S2;
                else if (S) next_state = S4;
                else if (W) next_state = S6;
            end
            S2: begin
                // East Green
                if (timer_e == GREEN_TIME) next_state = S3;  // Go to Yellow after Green
                else if (E) next_state = S2;  // Stay in Green if traffic
                else if (S) next_state = S4;
                else if (W) next_state = S6;
                else if (N) next_state = S0;
            end
            S3: begin
                // East Yellow
                if (timer_e == YELLOW_TIME) next_state = S4;  // Go to South Green after Yellow
                else if (E) next_state = S3;  // Stay in Yellow if traffic
                else if (S) next_state = S4;
                else if (W) next_state = S6;
                else if (N) next_state = S0;
            end
            S4: begin
                // South Green
                if (timer_s == GREEN_TIME) next_state = S5;  // Go to Yellow after Green
                else if (S) next_state = S4;  // Stay in Green if traffic
                else if (W) next_state = S6;
                else if (N) next_state = S0;
                else if (E) next_state = S2;
            end
            S5: begin
                // South Yellow
                if (timer_s == YELLOW_TIME) next_state = S6;  // Go to West Green after Yellow
                else if (S) next_state = S5;
                else if (W) next_state = S6;
                else if (N) next_state = S0;
                else if (E) next_state = S2;
            end
            S6: begin
                // West Green
                if (timer_w == GREEN_TIME) next_state = S7;  // Go to Yellow after Green
                else if (W) next_state = S6;  // Stay in Green if traffic
                else if (N) next_state = S0;
                else if (E) next_state = S2;
                else if (S) next_state = S4;
            end
            S7: begin
                // West Yellow
                if (timer_w == YELLOW_TIME) next_state = S0;  // Go back to North Green after Yellow
                else if (W) next_state = S7;  // Stay in Yellow if traffic
                else if (N) next_state = S0;
                else if (E) next_state = S2;
                else if (S) next_state = S4;
            end
            default: next_state = S0;  // Default to North Green state
        endcase
    end

    // Control signals for each direction
    always @(*) begin
        // Default: all red
        Rn = 1'b1; Re = 1'b1; Rs = 1'b1; Rw = 1'b1;
        Yn = 1'b0; Ye = 1'b0; Ys = 1'b0; Yw = 1'b0;
        Gn = 1'b0; Ge = 1'b0; Gs = 1'b0; Gw = 1'b0;

        case (state_reg)
            S0: begin
                Gn = 1'b1;  // North Green
                if (N) Rn = 1'b0;  // Turn off red for North if green is on
            end
            S1: begin
                Yn = 1'b1;  // North Yellow
            end
            S2: begin
                Ge = 1'b1;  // East Green
                if (E) Re = 1'b0;  // Turn off red for East if green is on
            end
            S3: begin
                Ye = 1'b1;  // East Yellow
            end
            S4: begin
                Gs = 1'b1;  // South Green
                if (S) Rs = 1'b0;  // Turn off red for South if green is on
            end
            S5: begin
                Ys = 1'b1;  // South Yellow
            end
            S6: begin
                Gw = 1'b1;  // West Green
                if (W) Rw = 1'b0;  // Turn off red for West if green is on
            end
            S7: begin
                Yw = 1'b1;  // West Yellow
            end
            default: begin
                Rn = 1'b1; Re = 1'b1; Rs = 1'b1; Rw = 1'b1;
                Yn = 1'b0; Ye = 1'b0; Ys = 1'b0; Yw = 1'b0;
                Gn = 1'b0; Ge = 1'b0; Gs = 1'b0; Gw = 1'b0;
            end
        endcase
    end
endmodule
