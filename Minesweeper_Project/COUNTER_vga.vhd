----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2026 09:11:24
-- Design Name: 
-- Module Name: COUNTER_vga - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity COUNTER_vga is
Port (  clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        pixel_bit   : in STD_LOGIC;
        mouse_xpos  : in STD_LOGIC_VECTOR(11 downto 0);
        mouse_ypos  : in STD_LOGIC_VECTOR(11 downto 0);
        
        r, g, b     : out STD_LOGIC_VECTOR (3 downto 0);
        vs, hs      : out STD_LOGIC;
        current_cell_x : out integer range 0 to 7;
        current_cell_y : out integer range 0 to 7;
        current_pixel_x : out integer range 0 to 7;
        current_pixel_y : out integer range 0 to 7;
        game_over : in STD_LOGIC;
        game_won  : in STD_LOGIC);
end COUNTER_vga;

architecture Behavioral of COUNTER_vga is

-- Constante Timing VGA
    constant hd : integer := 640; -- visible horizontal area
    constant hfp : integer := 16;
    constant hsp : integer := 96; 
    constant hbp : integer := 48;
    constant totalh : integer := 800;

    constant vd : integer := 480; -- visible vertical area
    constant vfp : integer := 10;
    constant vsp : integer := 2; 
    constant vbp : integer := 33;
    constant totalv : integer := 525;
    
    -- Board placement on screen
    -- 8 cells * 32 pixels = 256x256 board
    -- Starting at (192,112) centers it nicely on a 640x480 screen
    constant board_x0  : integer := 192;
    constant board_y0  : integer := 112;
    constant cell_size : integer := 32;

    --board output constants
    constant board_size       : integer := 8 * cell_size;
    constant border_thickness : integer := 6;
    
    constant outer_x0 : integer := board_x0 - border_thickness;
    constant outer_y0 : integer := board_y0 - border_thickness;
    constant outer_x1 : integer := board_x0 + board_size + border_thickness;
    constant outer_y1 : integer := board_y0 + board_size + border_thickness;
    
    -- Semnale pozitie si ceas
    signal hpos : integer range 0 to totalh - 1 := 0; -- current horizontal pixel counter
    signal vpos : integer range 0 to totalv - 1 := 0; -- current vertical pixel counter
    
    signal clk_25MHz : std_logic := '0';  -- pixel clock for VGA
    signal clk_count : integer range 0 to 1 := 0;


    signal inside_board : STD_LOGIC; -- '1' when current pixel is inside the 8x8 board
    signal visible_area : STD_LOGIC; -- '1' when current pixel is inside visible 640x480 area

    signal cell_x_i  : integer range 0 to 7 := 0;
    signal cell_y_i  : integer range 0 to 7 := 0;
    signal pixel_x_i : integer range 0 to 7 := 0;
    signal pixel_y_i : integer range 0 to 7 := 0;
    
component MouseDisplay is
port (
   pixel_clk: in std_logic;
   xpos     : in std_logic_vector(11 downto 0);
   ypos     : in std_logic_vector(11 downto 0);

   hcount   : in std_logic_vector(11 downto 0);
   vcount   : in std_logic_vector(11 downto 0);
   --blank    : in std_logic; -- if VGA blank is used

   --red_in   : in std_logic_vector(3 downto 0); -- if VGA signal pass-through is used
   --green_in : in std_logic_vector(3 downto 0);
   --blue_in  : in std_logic_vector(3 downto 0);
   
   enable_mouse_display_out : out std_logic;

   red_out  : out std_logic_vector(3 downto 0);
   green_out: out std_logic_vector(3 downto 0);
   blue_out : out std_logic_vector(3 downto 0)
);
end component MouseDisplay;
    --mouse signals
    signal base_r, base_g, base_b : STD_LOGIC_VECTOR(3 downto 0);
    signal mouse_r, mouse_g, mouse_b : STD_LOGIC_VECTOR(3 downto 0);
    signal mouse_enable : STD_LOGIC;
    signal hcount_s : STD_LOGIC_VECTOR(11 downto 0);
    signal vcount_s : STD_LOGIC_VECTOR(11 downto 0);
begin


-- Convert the VGA pixel counters from integer to std_logic_vector
hcount_s <= conv_std_logic_vector(hpos, 12);
vcount_s <= conv_std_logic_vector(vpos, 12);

MOUSE_DISPLAY_label: MouseDisplay port map (pixel_clk => clk_25Mhz, xpos => mouse_xpos, ypos => mouse_ypos, hcount => hcount_s, vcount => vcount_s,
                                            enable_mouse_display_out => mouse_enable, red_out => mouse_r, green_out => mouse_g, blue_out => mouse_b);

    -- Clock divider : 100MHz -> 25MHz
    process(clk, rst)
    begin
        if rst = '1' then
            clk_count <= 0;
            clk_25MHz <= '0';
        elsif rising_edge(clk) then
            if clk_count = 1 then
                clk_count <= 0;
                clk_25MHz <= not clk_25MHz;
            else
                clk_count <= clk_count + 1;
            end if;
        end if;
    end process;

    -- Horizontal and vertical counters
    -- Scan the full VGA continuously
    process (clk_25MHz, rst)
    begin
        if rst = '1' then 
            hpos <= 0;
            vpos <= 0;
            
        elsif rising_edge(clk_25MHz) then
            if hpos = totalh - 1 then
                hpos <= 0;
                
                if vpos = totalv - 1 then
                    vpos <= 0;
                else 
                    vpos <= vpos + 1;
                end if;
            else
                hpos <= hpos + 1;
            end if;
        end if;
    end process;

    -- VGA sync generation
    -- Active low sync pulses
    hs <= '0' when (hpos >= hd + hfp) and (hpos < hd + hfp + hsp) else '1';
    vs <= '0' when (vpos >= vd + vfp) and (vpos < vd + vfp + vsp) else '1';

    -- Visible area flag
    -- True only inside the 640x480 display region

    visible_area <= '1' when (hpos < hd and vpos < vd) else '0';
    
    -- Check if current pixel is inside the Minesweeper board
    inside_board <= '1' when
        (hpos >= board_x0 and hpos < board_x0 + 8 * cell_size and
         vpos >= board_y0 and vpos < board_y0 + 8 * cell_size)
        else '0';
    
    -- Compute current board cell coordinates
    -- Each cell is 32x32 pixels
    cell_x_i <= (hpos - board_x0) / cell_size when inside_board = '1' else 0;
    cell_y_i <= (vpos - board_y0) / cell_size when inside_board = '1' else 0;

    -- Compute current pixel coordinates inside the 8x8 sprite
    -- Since one cell is 32x32 and the sprite is 8x8,
    -- each sprite pixel is scaled by 4x4 screen pixels
    pixel_x_i <= ((hpos - board_x0) mod cell_size) / 4 when inside_board = '1' else 0;
    pixel_y_i <= ((vpos - board_y0) mod cell_size) / 4 when inside_board = '1' else 0;
    
    -- Send coordinates outside the module
    -- These coordinates are used by RAM / ROM logic
    current_cell_x <= cell_y_i;
    current_cell_y <= cell_x_i;
    current_pixel_x <= pixel_y_i;
    current_pixel_y <= pixel_x_i;

    -- Color generation with grid lines + pixel_bit
    process(visible_area, inside_board, pixel_bit, hpos, vpos, game_over, game_won)
    begin
        if visible_area = '0' then
        base_r <= "0000";
        base_g <= "0000";
        base_b <= "0000";

    -- Outer border around the whole board
    elsif (hpos >= outer_x0 and hpos < outer_x1 and
           vpos >= outer_y0 and vpos < outer_y1) and
          not (hpos >= board_x0 and hpos < board_x0 + board_size and
               vpos >= board_y0 and vpos < board_y0 + board_size) then

        if game_over = '1' then
            base_r <= "1111"; -- red border
            base_g <= "0000";
            base_b <= "0000";

        elsif game_won = '1' then
            base_r <= "0000"; -- green border
            base_g <= "1111";
            base_b <= "0000";

        else
            base_r <= "0110"; -- gray border while playing
            base_g <= "0110";
            base_b <= "0110";
        end if;

    elsif inside_board = '0' then
        base_r <= "0000";
        base_g <= "0000";
        base_b <= "0000";

    else
        -- black grid lines between cells
        if (((hpos - board_x0) mod cell_size) < 2) or
           (((vpos - board_y0) mod cell_size) < 2) then

            base_r <= "0000";
            base_g <= "0000";
            base_b <= "0000";

        else
            if pixel_bit = '1' then
                base_r <= "0000"; -- black sprite pixel
                base_g <= "0000";
                base_b <= "0000";
            else
                base_r <= "1000"; -- gray cell background
                base_g <= "1000";
                base_b <= "1000";
            end if;
        end if;
    end if;
    end process;
r <= mouse_r when mouse_enable = '1' else base_r;
g <= mouse_g when mouse_enable = '1' else base_g;
b <= mouse_b when mouse_enable = '1' else base_b;
end Behavioral;
