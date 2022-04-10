module ctr (
    clock,
    control,
    initial_value,
    INIT
);
  input clock, control, initial_value, INIT;

  // #### Important Signals #### 
  bit INIT;
  bit [1:0] control;
  reg clock;

  // #### Main Counter Variable ####
  bit [3:0] counter = 0;
  bit [3:0] initial_value;  // initial value for counter


  // #### Winner and loser signals & variables ####
  bit LOSER = 1'b0, WINNER = 1'b0, GAMEOVER = 1'b0;
  bit [3:0] winner_counter = 4'b0, loser_counter = 4'b0;
  bit [1:0] WHO = 2'b00;
  bit signal_holder = 1'b0;
  // NOTE --> signal_holder ensures that WINNER or LOSER are high for only one cycle


  // #### Initial Actions ####
  initial begin
    if (INIT) begin
      counter = initial_value;
    end else begin
      counter = 0;
    end
    $display("Counter Initially: %0d", counter);



    // $display(INIT);
    // $display(initial_value);
    // $display(control);


  end



  // #### Periodic Actions ####
  always @(posedge clock) begin

    // Performing count
    if (!GAMEOVER) begin
      case (control)
        // Counting Up
        2'b00: counter += 1;
        2'b01: counter += 2;

        // Counting Down
        2'b10: counter -= 1;
        2'b11: counter -= 2;
      endcase

    end
    $display("Counter: %0d", counter);

    
    // if it's GAMEOVER, then we reset all counters and start over 
    if (GAMEOVER) begin
      counter = 0;
      winner_counter = 0;
      loser_counter = 0;
      signal_holder = 1'b0;
      WINNER = 1'b0;
      LOSER = 1'b0;
      GAMEOVER = 1'b0;

      $display("All Reset. Starting Over...!");
    end




    // Handling WINNER & LOSER signals
    if (signal_holder) begin
      // then we ensured that WINNER or LOSER have completed one cycle
      // Shutting down these signals
      signal_holder = 1'b0;
      WINNER = 1'b0;
      LOSER = 1'b0;

      $display("Signal Released!");
    end else begin
      // Here, we check if counter is Zeros or Ones and take action
      if (counter == 4'b0000) begin
        LOSER = 1'b1;
        loser_counter += 1'b1;
        signal_holder = 1'b1;

        $display("loser_counter: %0d", loser_counter);
      end else if (counter == 4'b1111) begin
        WINNER = 1'b1;
        winner_counter += 1'b1;
        signal_holder = 1'b1;

        $display("winner_counter: %0d", winner_counter);
      end
    end

    // GAMEOVER STATE
    if (loser_counter == 4'b1111) begin
      GAMEOVER = 1'b1;
      WHO = 2'b01;

      $display("-------------------");
      $display("GAMEOVER LOSER");
      $display(WHO);
      $display("-------------------");

    end else if (winner_counter == 4'b1111) begin
      GAMEOVER = 1'b1;
      WHO = 2'b10;

      $display("-------------------");
      $display("GAMEOVER WINNER");
      $display(WHO);
      $display("-------------------");

    end







  end


endmodule
