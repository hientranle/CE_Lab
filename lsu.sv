module lsu (
  input  logic        i_clk,
  input  logic        i_rstn,
  input  logic        i_lsu_wren,

  input  logic [2:0]  i_funct3,

  input  logic [31:0] i_lsu_addr,
  input  logic [31:0] i_st_data,

  output logic [31:0] o_ld_data,

//Periipherals
  input  logic [31:0] i_io_sw,
  output logic [31:0] o_io_ledr,
  output logic [31:0] o_io_ledg,
  output logic [31:0] o_io_hex0,
  output logic [31:0] o_io_hex1,
  output logic [31:0] o_io_hex2,
  output logic [31:0] o_io_hex3,
  output logic [31:0] o_io_hex4,
  output logic [31:0] o_io_hex5,
  output logic [31:0] o_io_hex6,
  output logic [31:0] o_io_hex7,
  output logic [31:0] o_io_lcd
);
//Local param
// Base addresses
localparam DATA_BASE_ADDR = 32'h0000_2000;
localparam DATA_LAST_ADDR = 32'h0000_20FF; 
localparam LEDR_BASE_ADDR = 32'h0000_7000;
localparam LEDG_BASE_ADDR = 32'h0000_7010;
localparam SEG7_BASE_ADDR = 32'h0000_7020;
localparam LCD_BASE_ADDR  = 32'h0000_7030;
localparam SW_BASE_ADDR   = 32'h0000_7800;
localparam BTN_BASE_ADDR  = 32'h0000_7810;
//Data handler for Load instruction
logic [3:0]  byte_sign;
logic [3:0]  st_strb;;
logic [31:0] ld_data;
logic [31:0] st_data;
logic [31:0] byte_mask;
logic [31:0] ledr_reg;
logic [31:0] ledg_reg;
logic [31:0] seg7_0to3_reg;
logic [31:0] seg7_4to7_reg;
logic [31:0] lcd_reg;
logic        is_data_addr;
logic        is_ledr_addr;
logic        is_ledg_addr;
logic        is_seg7_addr;
logic        is_lcd_addr;
logic        is_sw_addr;
logic        is_btn_addr;
//
//funct3[2] = 1'b1 is unsigned load
always_comb begin
  byte_sign[0] = (i_funct3[2])? 1'b0 : ld_data[7];
  byte_sign[1] = (i_funct3[2])? 1'b0 : ld_data[15];
  byte_sign[2] = (i_funct3[2])? 1'b0 : ld_data[23];
  byte_sign[3] = (i_funct3[2])? 1'b0 : ld_data[31];
end
//Determine which store command 
always_comb begin
  case(i_funct3[1:0])
    //byte
    2'b00: begin
      if (i_lsu_addr[1:0] == 2'b00) begin
        st_data = {24'b0, i_st_data[7:0]};
        st_strb = 4'h1;
      end
      else if (i_lsu_addr[1:0] == 2'b01) begin
        st_data = {16'b0, i_st_data[7:0], 8'b0};
        st_strb = 4'h2;
      end
      else if (i_lsu_addr[1:0] == 2'b10) begin
        st_data = {8'b0, i_st_data[7:0], 16'b0};
        st_strb = 4'h4;
      end
      else if (i_lsu_addr[1:0] == 2'b11) begin
        st_data = {i_st_data[7:0], 24'b0};
        st_strb = 4'h8;
      end
    end

    //half word
    2'b01: begin
      if (i_lsu_addr[1] == 1'b1) begin
        st_data = {i_st_data[15:0],16'h0};
        st_strb = 4'h3;
      end
      else begin
        st_data = {16'b0, i_st_data[15:0]};
        st_strb = 4'hC;
      end    
    end

    //word
    2'b10: begin
        st_data = i_st_data[15:0];
        st_strb = 4'hF;
    end

    default: begin
      st_data = '0;
      st_strb = '0;
    end
  endcase
end
//Determine which load command
always_comb begin
  case(i_funct3[1:0])
    //byte
    2'b00: begin
      if (i_lsu_addr[1:0] == 2'b00) begin
        o_ld_data = {{24{byte_sign[0]}},ld_data[7:0]};
      end
      else if (i_lsu_addr[1:0] == 2'b01) begin
        o_ld_data = {{24{byte_sign[1]}},ld_data[15:8]};
      end
      else if (i_lsu_addr[1:0] == 2'b10) begin
        o_ld_data = {{24{byte_sign[2]}},ld_data[23:16]};
      end
      else if (i_lsu_addr[1:0] == 2'b11) begin
        o_ld_data = {{24{byte_sign[3]}},ld_data[31:24]};
      end
    end

    //half word
    2'b01: begin
      if (i_lsu_addr[1] == 1'b1) begin
        o_ld_data = {{16{byte_sign[3]}},ld_data[31:16]};
      end
      else begin
        o_ld_data = {{16{byte_sign[1]}},ld_data[15:0]};
      end    
    end

    //word
    2'b10: begin
      o_ld_data = ld_data;
    end

    default: begin
      o_ld_data = '0;
    end
  endcase
end
always_comb begin
  byte_mask    = {{8{st_strb[3]}}, {8{st_strb[2]}}, {8{st_strb[1]}}, {8{st_strb[0]}}};
  is_data_addr = (i_lsu_addr[15:13] == DATA_BASE_ADDR[15:13]) && (~|i_lsu_addr[31:16]);
  is_ledr_addr = (i_lsu_addr[15:2]  == LEDR_BASE_ADDR[15:2])  && (~|i_lsu_addr[31:16]);
  is_ledg_addr = (i_lsu_addr[15:2]  == LEDG_BASE_ADDR[15:2])  && (~|i_lsu_addr[31:16]);
  is_seg7_addr = (i_lsu_addr[15:3]  == SEG7_BASE_ADDR[15:3])  && (~|i_lsu_addr[31:16]);
  is_lcd_addr  = (i_lsu_addr[15:2]  == LCD_BASE_ADDR[15:2])   && (~|i_lsu_addr[31:16]);
  is_sw_addr   = (i_lsu_addr[15:2]  == SW_BASE_ADDR[15:2])    && (~|i_lsu_addr[31:16]);
  is_btn_addr  = (i_lsu_addr[15:2]  == BTN_BASE_ADDR[15:2])   && (~|i_lsu_addr[31:16]);
end
//internal ram, replace SDRAM later
//Write logic to RAM
localparam TOTAL_BYTES = DATA_LAST_ADDR-DATA_BASE_ADDR+1;
localparam RAM_DEPTH   = TOTAL_BYTES/4;
localparam ADDR_WIDTH  = $clog2(TOTAL_BYTES);
localparam BYTE_WIDTH  = 8;
localparam BYTES       = 4;
logic [BYTES-1:0][BYTE_WIDTH-1:0] [0:RAM_DEPTH-1] ram;
always_ff @(posedge i_clk or negedge i_rstn) begin 
  if (!i_rstn) begin
    ram <= '0;
  end
  else begin
    if (i_lsu_wren && is_data_addr) begin
      for (int i=0;i<BYTES;i=i+1) begin
        if(st_strb[i]) begin
          ram[i_lsu_addr[ADDR_WIDTH-1:2]][i] <= st_data[BYTE_WIDTH*i+:BYTE_WIDTH];
        end
      end
    end
  end 
end
//Peripherals control
//Write to peripherals (led, lcd, hex)
always_ff @ (posedge i_clk or negedge i_rstn) begin
  if (!i_rstn) begin
    ledr_reg      <= '0;  
    ledg_reg      <= '0;  
    seg7_0to3_reg <= '0;  
    seg7_4to7_reg <= '0;  
    lcd_reg       <= '0;  
  end
  else begin
    if (i_lsu_wren) begin
      if      (is_ledr_addr) ledr_reg <= (ledr_reg & ~byte_mask) | (st_data & byte_mask);
      else if (is_ledg_addr) ledg_reg <= (ledg_reg & ~byte_mask) | (st_data & byte_mask);
      else if (is_lcd_addr)  lcd_reg  <= (lcd_reg & ~byte_mask)  | (st_data & byte_mask);
      else if (is_seg7_addr) begin
        if (i_lsu_addr[2]) begin
          seg7_4to7_reg <= (seg7_4to7_reg & ~byte_mask) | (i_st_data & byte_mask);
        end
        else begin
          seg7_0to3_reg <= (seg7_0to3_reg & ~byte_mask) | (i_st_data & byte_mask);
        end
      end
      else begin
        ledr_reg      <= ledr_reg;  
        ledg_reg      <= ledg_reg;  
        seg7_0to3_reg <= seg7_0to3_reg;  
        seg7_4to7_reg <= seg7_4to7_reg;  
        lcd_reg       <= lcd_reg;  
      end
    end
    else begin
      ledr_reg      <= ledr_reg;  
      ledg_reg      <= ledg_reg;  
      seg7_0to3_reg <= seg7_0to3_reg;  
      seg7_4to7_reg <= seg7_4to7_reg;  
      lcd_reg       <= lcd_reg;  
    end
  end
end
//Read from peripherals 
always_comb begin
  if (!i_lsu_wren && is_ledr_addr) begin
    ld_data  = ledr_reg;
  end
  else if (!i_lsu_wren && is_ledg_addr) begin
    ld_data  = ledg_reg;
  end
  else if (!i_lsu_wren && is_seg7_addr) begin
    if (i_lsu_addr[2]) begin
      ld_data = seg7_4to7_reg;
     end
    else begin
      ld_data = seg7_0to3_reg;
    end
  end
  else if (!i_lsu_wren && is_lcd_addr) begin
    ld_data = lcd_reg;
  end
  else if (!i_lsu_wren && is_sw_addr) begin
    ld_data = i_io_sw;
  end
  else if (!i_lsu_wren && is_data_addr) begin
    ld_data  = ram[i_lsu_addr[ADDR_WIDTH-1:2]];
  end
end
//Peripherals output
always_comb begin
  //LED
  o_io_ledr = ledr_reg;
  o_io_ledg = ledg_reg;
  //HEX 
  o_io_hex7 = seg7_4to7_reg[8*3+:7];
  o_io_hex6 = seg7_4to7_reg[8*2+:7];
  o_io_hex5 = seg7_4to7_reg[8*1+:7];
  o_io_hex4 = seg7_4to7_reg[8*0+:7];
  o_io_hex3 = seg7_0to3_reg[8*3+:7];
  o_io_hex2 = seg7_0to3_reg[8*2+:7];
  o_io_hex1 = seg7_0to3_reg[8*1+:7];
  o_io_hex0 = seg7_0to3_reg[8*0+:7];
  //lcd
  o_io_lcd  = lcd_reg;
end
endmodule