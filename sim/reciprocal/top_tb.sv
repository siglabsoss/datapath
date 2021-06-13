module top_tb (
        input wire          i_clk,
        input wire          i_rst_p,
        input wire [31:0]   i_seed,
        input wire          rand_valid,
        input wire          rand_ready
        );

    
        localparam DEPTH_0 = 16000;

        logic [15-1:0]              mem0 [DEPTH_0-1:0]; // depth and width are controlled by template
        logic [$clog2(DEPTH_0) : 0]     read_addr0;
        logic                               mem0_valid; // can be generated using $rand()

        logic [31:0] random_valid0;

        logic [15-1:0]                t0_data;
        logic                                 t0_valid;
        logic                                 t0_ready;
    

    
        logic [DEPTH_0 - 1 : 0]               data_out_counter0;
        logic [7:0] idle_counter0;
        logic [16-1:0]                i0_data;
        logic                                 i0_valid;
        logic                                 i0_ready;
        integer f0;

        logic [31:0] random_ready0;
    

        initial begin
        
                $readmemh ("t_0_dat.mif", mem0);
        
        
                f0 = $fopen("i_13_dat.mif","w");
        
        end

        always_ff @(posedge i_clk) begin
        
            i0_ready <= (rand_ready) ? random_ready0[0] : 1;
            if (i0_ready && i0_valid) begin
                $fwrite(f0,"%h\n",i0_data);
            end
        
        end

        logic [31:0] counter1;

/* verilator lint_off WIDTH */
    assign t0_data = mem0[read_addr0];
    assign t0_valid = mem0_valid && (read_addr0 != DEPTH_0) && (!i_rst_p);

    logic flag0;
    always_ff @(posedge i_clk) begin
        if (i_rst_p) begin
            random_valid0 <= 0;
            read_addr0 <= {$clog2(DEPTH_0){1'b0}};
            mem0_valid <= 0;
            flag0 <= 1;
        end else begin
            random_valid0 <= counter1 % (2 * 0 + 45);
            mem0_valid <= (rand_valid && t0_ready) ? random_valid0[0] : 1;
            if (mem0_valid && t0_ready) begin
                read_addr0 <= read_addr0 + 1;
                flag0 <= 0;
            end

            if ((flag0 == 0) && (read_addr0 == DEPTH_0)) begin
                read_addr0 <= read_addr0;
            end


        end

    end
/* verilator lint_on WIDTH */



    always_ff @(posedge i_clk) begin
        random_ready0 = counter1 % (5 * 32);
    end


    // count the number of outputs
    always_ff @(posedge i_clk) begin
        if (i_rst_p) begin
            data_out_counter0 <= 0;
            idle_counter0 <= 0;
        end else begin
            idle_counter0 <= idle_counter0 + 1;
            if (i0_ready && i0_valid) begin
                data_out_counter0 <= data_out_counter0+ 1;
                idle_counter0 <= 0;
            end

            if ((data_out_counter0 == DEPTH_0) || (idle_counter0 == 100))begin
//                $finish;
            end
        end
    end



        reciprocal DUT (
            .t_0_dat (t0_data),
            .t_0_ack (t0_ready), // ready
            .t_0_req (t0_valid),
            .i_13_dat (i0_data),
            .i_13_ack (i0_ready), // ready
            .i_13_req (i0_valid),
            .clk  (i_clk),
            .reset_n  (!i_rst_p));


    typedef enum {
        ST_IDLE,         // switch from here
        PAT1_WORK        // pattern generation using a lfsr
    } genfsm_states_t;

    genfsm_states_t curr_state;
    genfsm_states_t next_state;


    // lfsr of 6 bits
    logic [5:0] lfsr_pattern;

    always_ff @(posedge i_clk) begin

        if (i_rst_p) begin
            curr_state <= ST_IDLE;
            next_state <= ST_IDLE;
            counter1 <= {32{1'b0}};

            lfsr_pattern <= {1'b1,{5{1'b0}}}; // initializing lfsr by 100000


        end else begin

            // curr_state <= ST_IDLE;

            // /* defaults */
            counter1 <= {32{1'b0}};


            // next_state
            curr_state <= next_state;

            case (curr_state)

                ST_IDLE: begin
                    next_state <= PAT1_WORK;
                    counter1 <= i_seed;
                end

                PAT1_WORK: begin
                    /*
                     * 20 bit lfsr -> x^20 + x^3 + 1 -> only 20bit output will be there. rest 12 bits won't toggle at all.
                     * 30 bit lfsr -> x^30 + x^16 + x^15 +1
                     * I am designing using a 32 bit adder and 6 bit lfsr so that all the bits toggle eventually. -> x^6 + x + 1
                     */

                    lfsr_pattern <= {lfsr_pattern[4:0],lfsr_pattern[5]}; //circular shift
                    lfsr_pattern[1] <= lfsr_pattern[0] ^ lfsr_pattern[5];
                    /* verilator lint_off WIDTH */
                    counter1 <= counter1 + lfsr_pattern;
                    /* verilator lint_on WIDTH */


                end
            endcase

        end // if i_reset
    end // always_ff i_clock


endmodule
