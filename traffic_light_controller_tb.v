module traffic_light_controller_tb;

    // Inputs
    reg clk;
    reg reset;
    reg N, S, E, W;

    // Outputs
    wire Rn, Yn, Gn;
    wire Re, Ye, Ge;
    wire Rs, Ys, Gs;
    wire Rw, Yw, Gw;

    // Instantiate the Unit Under Test (UUT)
    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .N(N), .S(S), .E(E), .W(W),
        .Rn(Rn), .Yn(Yn), .Gn(Gn),
        .Re(Re), .Ye(Ye), .Ge(Ge),
        .Rs(Rs), .Ys(Ys), .Gs(Gs),
        .Rw(Rw), .Yw(Yw), .Gw(Gw)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period (100 MHz)

    // Test sequence
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        N = 0; S = 0; E = 0; W = 0;

        // Release reset
        #10 reset = 0;

        // Test case 1: Traffic only in North
        #10 N = 1; S = 0; E = 0; W = 0;
        #120 N = 0; // Wait long enough for the full cycle to complete (adjusted)

        // Test case 2: Traffic only in East
        #10 N = 0; E = 1; S = 0; W = 0;
        #120 E = 0; // Wait long enough for the full cycle to complete

        // Test case 3: Traffic only in South
        #10 N = 0; E = 0; S = 1; W = 0;
        #120 S = 0; // Wait long enough for the full cycle to complete

        // Test case 4: Traffic only in West
        #10 N = 0; E = 0; S = 0; W = 1;
        #120 W = 0; // Wait long enough for the full cycle to complete

        // End simulation
        #50 $stop;
    end

    // Monitor outputs
    initial begin
        $monitor($time, " Reset=%b | N=%b, E=%b, S=%b, W=%b | Rn=%b Yn=%b Gn=%b | Re=%b Ye=%b Ge=%b | Rs=%b Ys=%b Gs=%b | Rw=%b Yw=%b Gw=%b",
                 reset, N, E, S, W, Rn, Yn, Gn, Re, Ye, Ge, Rs, Ys, Gs, Rw, Yw, Gw);
    end

endmodule
